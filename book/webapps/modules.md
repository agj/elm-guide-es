# Módulos

Elm nos permite usar **módulos** para que nuestro código crezca sin problemas. En su nivel más básico, los módulos nos permiten separar nuestro código en múltiples archivos.

## Definición de módulos

Los módulos en Elm funcionan mejor cuando los definimos en torno a un tipo central. Por ejemplo, el módulo `List` contiene código exclusivamente relacionado con el tipo `List`. Ahora, digamos que queremos crear un módulo en torno a un tipo `Post` para un blog. Podemos hacer algo como esto:

```elm
module Post exposing (Post, decoder, encode, estimatedReadTime)

import Json.Decode as D
import Json.Encode as E



-- POST


type alias Post =
    { title : String
    , author : String
    , content : String
    }



-- READ TIME


estimatedReadTime : Post -> Float
estimatedReadTime post =
    toFloat (wordCount post) / 220


wordCount : Post -> Int
wordCount post =
    List.length (String.words post.content)



-- JSON


encode : Post -> E.Value
encode post =
    E.object
        [ ( "title", E.string post.title )
        , ( "author", E.string post.author )
        , ( "content", E.string post.content )
        ]


decoder : D.Decoder Post
decoder =
    D.map3 Post
        (D.field "title" D.string)
        (D.field "author" D.string)
        (D.field "content" D.string)
```

La única sintaxis nueva es la primera línea, que dice `module Post exposing (Post, decoder, encode, estimatedReadTime)`. Significa que el módulo tiene el nombre `Post`, y que sólo ciertos valores específicos están visibles desde fuera del módulo. La función `wordCount` no está en esta lista, y por lo tanto está sólo disponible _dentro_ del módulo `Post`. Esconder funciones de esta manera es, de hecho, una de las técnicas más importantes en Elm.

> **Nota:** Si te olvidas de añadir una declaración de módulo, Elm va a usar esta:
>
> ```elm
> module Main exposing (..)
> ```
>
> Esto hace que sea más fácil para principiantes que sólo necesitan un archivo. Así, no necesitan preocuparse del sistema de módulos en su primer día.

## Cuando un módulo crece

A medida que se va haciendo más compleja nuestra aplicación, trendremos que ir añadiendo más cosas a cada módulo. Es normal que un módulo Elm tenga entre 400 y 1000 líneas, como explico en mi charla [“The Life of a File”](https://youtu.be/XpDsk374LDE) (en inglés). Pero cuando tenemos múltiples módulos, ¿cómo decidimos _dónde_ añadir código nuevo?

Yo trato de seguir las siguientes estrategias cuando el código en cuestión es:

- **Único** — Si es lógica usada en un sólo lugar, creamos funciones auxiliares y las ubicamos lo más cerca posible a donde se usan. Tal vez ponemos un comentario tipo encabezado, algo como `-- PREVISUALIZACIÓN DEL ARTÍCULO`, para agrupar y especificar el uso del código que le sigue.
- **Similar** — Tal vez queremos mostrar previsualizaciones de `Post` en la página principal y también en las páginas de autor. En la página principal queremos enfatizar lo interesante del contenido, así que necesitamos poner un extracto largo de éste. Pero en la página de un autor queremos exhibir variedad, así que le ponemos más énfasis a los títulos. Estos casos son _similares_, no iguales, así que volvemos a la estrategia de código **único**: escribimos la lógica por separado.
- **Lo mismo** — En algún momento tendremos bastante código **único**. No hay nada de malo en eso. Pero tal vez notaremos que algunas definiciones contienen lógica que es _exactamente_ igual. Separémosla a una función auxiliar. Si la función sólo se usa dentro del mismo módulo, no hace falta hacer nada más. Simplemente agreguemos un encabezado nuevo, como `-- TIEMPO DE LECTURA`, si hace falta.

Estas estrategias sirven para crear funciones auxiliares dentro del mismo archivo. Es más útil crear un nuevo módulo sólo cuando ya tenemos un montón de estas funciones en torno a un mismo tipo personalizado. Por ejemplo, podemos empezar creando un módulo `Page.Author`, y esperamos a crear el módulo `Post` hasta que sus funciones auxiliares comiencen a acumularse. En ese momento, crear el nuevo módulo debiera hacer que el código se sienta más fácil de navegar y de entender. Si no es así, entonces volvamos a la forma cuando era más claro. En lo que se refiere a módulos, más no significa mejor. Tomemos el camino que permita que nuestro código sea simple y claro.

En resumen, asumamos por defecto que el código **similar** es **único**. Lo es, habitualmente, en interfaces de usuario. Si vemos lógica que es **la misma** en distintas definiciones, creemos funciones auxiliares con comentarios como encabezados. Cuando tengamos varias funciones auxiliares para un tipo específico, _consideremos_ crear un nuevo módulo. Si el nuevo módulo hace que el código sea más claro, ¡bien! Si no, deshagamos los cambios. Tener más archivos no es inherentemente más simple o claro.

> **Nota:** Una de las formas más comunes de complicarse con los módulos es cuando algo que solía ser **lo mismo** se vuelve **similar** en algún momento. Muy común, sobre todo en interfaces de usuario. Mucha gente termina construyendo funciones “frankenstein” para manejar todos los distintos casos, añadiéndole argumentos o simplemente complejizando sus argumentos. El mejor camino es aceptar que ahora tenemos dos situaciones **únicas**, y copiar el código en ambos lugares. Ajustémoslo hasta que quede justo como lo necesitamos. Después, fijémonos en si parte de la lógica es **la misma**. Si es así, separémosla en funciones auxiliares. **Las funciones largas van a quedar separadas en múltiples funciones más pequeñas, en vez de crecer y volverse más y más complejas.**

## Ubicando y usando los módulos

Lo convencional es poner todo el código Elm en el directorio `src/`. Este es el lugar definido por defecto en [`elm.json`](https://github.com/elm/compiler/blob/0.19.1/docs/elm.json/application.md), de hecho. Dado esto, nuestro módulo `Post` tendría que vivir en un archivo llamado `src/Post.elm`. Ahora podremos importar el módulo con una declaración `import`, y usar los valores que expone. Hay cuatro maneras distintas de hacerlo:

<!-- prettier-ignore-start -->
```elm
import Post
-- Post.Post, Post.estimatedReadTime, Post.encode, Post.decoder

import Post as P
-- P.Post, P.estimatedReadTime, P.encode, P.decoder

import Post exposing (Post, estimatedReadTime)
-- Post, estimatedReadTime
-- Post.Post, Post.estimatedReadTime, Post.encode, Post.decoder

import Post as P exposing (Post, estimatedReadTime)
-- Post, estimatedReadTime
-- P.Post, P.estimatedReadTime, P.encode, P.decoder
```
<!-- prettier-ignore-end -->

Recomiendo usar `exposing` infrecuentemente. Idealmente, en ninguno o sólo uno de los `import`s. De otra manera, puede empezar a volverse difícil entender de dónde salieron las cosas. “A ver, ¿de dónde era que venía `filterPostBy`? ¿Qué argumentos acepta?”. Mientras más usemos `exposing`, más difícil se hace entender el código. Yo tiendo a usarlo para `import Html exposing (..)`, pero para nada más. Para todo lo demás, recomiendo usar `import` solo, y tal vez usar `as` si tenemos un módulo con un nombre particularmente largo.

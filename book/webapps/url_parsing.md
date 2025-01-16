# Interpretación de URLs

En una aplicación real nos interesa mostrar distinto contenido para distintas URLs:

- `/search`
- `/search?q=seiza`
- `/settings`

¿Cómo lo logramos? Usando el paquete [`elm/url`](https://package.elm-lang.org/packages/elm/url/latest/) para interpretar strings como estructuras de datos Elm. Este paquete se entiende mejor al mirar ejemplos, así que entremos directamente a ello.

## Ejemplo 1

Digamos que tenemos un sitio web sobre arte donde las siguientes direcciones deben ser válidas:

- `/topic/architecture`
- `/topic/painting`
- `/topic/sculpture`
- `/blog/42`
- `/blog/123`
- `/blog/451`
- `/user/tom`
- `/user/sue`
- `/user/sue/comment/11`
- `/user/sue/comment/51`

Tenemos páginas de temas específicos, artículos del blog, información de usuarios y una forma de ver comentarios escritos por usuarios específicos. Vamos a usar el módulo [`Url.Parser`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser) para escribir un interpretador de URLs como el siguiente:

```elm
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)


type Route
    = Topic String
    | Blog Int
    | User String
    | Comment String Int


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Topic (s "topic" </> string)
        , map Blog (s "blog" </> int)
        , map User (s "user" </> string)
        , map Comment (s "user" </> string </> s "comment" </> int)
        ]



-- /topic/pottery        ==>  Just (Topic "pottery")
-- /topic/collage        ==>  Just (Topic "collage")
-- /topic/               ==>  Nothing
-- /blog/42              ==>  Just (Blog 42)
-- /blog/123             ==>  Just (Blog 123)
-- /blog/mosaic          ==>  Nothing
-- /user/tom/            ==>  Just (User "tom")
-- /user/sue/            ==>  Just (User "sue")
-- /user/bob/comment/42  ==>  Just (Comment "bob" 42)
-- /user/sam/comment/35  ==>  Just (Comment "sam" 35)
-- /user/sam/comment/    ==>  Nothing
-- /user/                ==>  Nothing
```

El módulo `Url.Parser` permite interpretar URLs válidas como datos Elm en forma muy concisa.

## Ejemplo 2

Ahora imaginemos que tenemos un blog personal donde direcciones como las siguientes son válidas:

- `/blog/12/the-history-of-chairs`
- `/blog/13/the-endless-september`
- `/blog/14/whale-facts`
- `/blog/`
- `/blog?q=whales`
- `/blog?q=seiza`

En este caso tenemos artículos y una página principal que lleva opcionalmente un parámetro `q` de consulta. Tenemos que añadir el módulo [`Url.Parser.Query`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser-Query) para escribir nuestro interpretador:

```elm
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, s, string)
import Url.Parser.Query as Query


type Route
    = BlogPost Int String
    | BlogQuery (Maybe String)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map BlogPost (s "blog" </> int </> string)
        , map BlogQuery (s "blog" <?> Query.string "q")
        ]



-- /blog/14/whale-facts  ==>  Just (BlogPost 14 "whale-facts")
-- /blog/14              ==>  Nothing
-- /blog/whale-facts     ==>  Nothing
-- /blog/                ==>  Just (BlogQuery Nothing)
-- /blog                 ==>  Just (BlogQuery Nothing)
-- /blog?q=chabudai      ==>  Just (BlogQuery (Just "chabudai"))
-- /blog/?q=whales       ==>  Just (BlogQuery (Just "whales"))
-- /blog/?query=whales   ==>  Just (BlogQuery Nothing)
```

Los operadores `</>` y `<?>` nos permiten escribir intepretadores que se ven como las URLs que queremos interpretar. Y el uso de `Url.Parser.Query` nos permitió manejar parámetros como `?q=seiza`.

## Ejemplo 3

Ahora lo que tenemos es un sitio web de documentación donde veremos direcciones como estas:

- `/Basics`
- `/Maybe`
- `/List`
- `/List#map`
- `/List#filter`
- `/List#foldl`

Podemos usar el interpretador [`fragment`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser#fragment) de `Url.Parser` para interpretar direcciones, así:

```elm
type alias Docs =
    ( String, Maybe String )


docsParser : Parser (Docs -> a) a
docsParser =
    map Tuple.pair (string </> fragment identity)



-- /Basics     ==>  Just ("Basics", Nothing)
-- /Maybe      ==>  Just ("Maybe", Nothing)
-- /List       ==>  Just ("List", Nothing)
-- /List#map   ==>  Just ("List", Just "map")
-- /List#      ==>  Just ("List", Just "")
-- /List/map   ==>  Nothing
-- /           ==>  Nothing
```

Y así ya podemos interpretar “fragmentos” de URL también.

## Síntesis

Ya vimos varios interpretadores, así que ahora nos toca ver cómo se conjugan en un programa `Browser.application`. En vez de sólo guardar la URL como lo hicimos en el ejemplo anterior, veamos si podemos interpretar la URL y convertirla en datos útiles para mostrar.

```elm
TODO
```

Lo nuevo más importante es:

1. Nuestra función `update` interpreta la URL cuando recibe un mensaje `UrlChanged`.
2. Nuestra función `view` muestra distinto contenido para direcciones distintas.

No es nada muy complicado, ¿no?

Pero ¿qué pasa si tengo 10, o 20, o 100 distintas páginas? ¿Tiene todo que ir dentro de esta función `view`? Seguro que no puede ir todo en el mismo archivo. ¿En cuántos archivos se separa? ¿Cómo debe ser la estructura de directorios? Bueno, eso mismo es lo que vamos a discutir en el próximo capítulo.

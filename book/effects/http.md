# HTTP

Muy frecuentemente vamos a tener que recuperar información desde algún otro lugar de internet.

Por ejemplo, imaginemos que queremos cargar el texto completo de _La opinión pública_ por Walter Lippmann. Este libro publicado en 1922 entrega una perspectiva histórica sobre la proliferación de los medios masivos y su incidencia en la democracia. Para lo que vamos a ver a continuación, usaremos el paquete [`elm/http`][http] para descargar este libro en nuestro programa.

Apreta el botón azul “Editar” para abrir este programa en el editor online. Seguramente vas a ver una pantalla que dice “Loading...” antes de que aparezca el libro completo. **Apreta ahora el botón.**

[http]: https://package.elm-lang.org/packages/elm/http/latest

<div class="edit-link"><a href="https://elm-lang.org/examples/book">Editar</a></div>

```elm
import Browser
import Html exposing (Html, pre, text)
import Http



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )



-- UPDATE


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            text "I was unable to load your book."

        Loading ->
            text "Loading..."

        Success fullText ->
            pre [] [ text fullText ]
```

Partes de este código te pareceran similares a ejemplos anteriores de la Arquitectura Elm. Aún tenemos un `Model` como modelo de nuestra aplicación. Aún tenemos la función `update` que reacciona ante mensajes. Aún tenemos una función `view` que muestra todo en pantalla.

Las partes nuevas extienden el patrón básico que ya hemos visto, con algunos cambios en `init` y en `update`, y la adición de la función `subscription`.

## `init`

La función `init` describe cómo inicializar nuestro programa:

```elm
init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )
```

Como siempre, tenemos que producir el `Model` inicial, pero ahora también estamos produciendo un **comando** de lo que necesitamos que ocurra inmediatamente. Ese comando eventualmente producirá un valor `Msg`, que luego será suplido a la función `update`.

Nuestro sitio web del libro comienza con el estado `Loading`, y queremos hacer un GET del texto completo. Cuando hagamos la solicitud GET usando [`Http.get`][get] vamos a especificar la `url` de los datos que queremos recuperar, y también necesitamos especificar lo que anticipamos que sean esos datos en `expect`. En nuestro caso, la `url` apunta a ciertos datos en el sitio web de Elm, y anticipamos que el dato sea un gran `String` que podremos mostrar en pantalla.

Pero la línea `Http.expectString GotText` dice algo más que el hecho de que esperamos un `String`. También está diciendo que cuando obtengamos la respuesta, ésta debiera convertirse en un mensaje `GotText`.

```elm
type Msg
    = GotText (Result Http.Error String)



-- GotText (Ok "The Project Gutenberg EBook of ...")
-- GotText (Err Http.NetworkError)
-- GotText (Err (Http.BadStatus 404))
```

Fíjate en que estamos usando el tipo `Result` que vimos un par de secciones atrás. Esto nos permite considerar en nuestra función `update`todos los posibles errores. Y hablando de funciones `update`…

[get]: https://package.elm-lang.org/packages/elm/http/latest/Http#get

> **Nota:** Si te preguntas por qué `init` es una función (y por qué ignoramos su argumento), vamos a hablar de eso en el capítulo siguiente sobre interoperabilidad con JavaScript. (Un pequeño avance: el argumento nos permite recuperar información desde JS al inicializar).

## `update`

Nuestra función `update` también retorna un poco más de información:

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )
```

Si te fijas en la firma, verás que no sólo retornamos un modelo actualizado, sino que _además_ producimos un **comando** de lo que queremos que Elm haga por nosotros.

Después, en la implementación, estamos haciendo búsqueda de patrones como es normal. Cuando llega un mensaje `GotText`, inspeccionamos el `Result` proveniente de nuestra solicitud HTTP, y actualizamos el modelo según si fue exitoso o no. La parte nueva es que también suplimos un comando.

En el caso de que recuperáramos el texto exitosamente, decimos `Cmd.none` para indicar que no hay más que hacer. Ya tenemos el contenido del libro.

Y si por otro lado hubiera ocurrido un error, también decimos `Cmd.none` y simplemente nos rendimos. El texto del libro no se cargó. Si quisiéramos evolucionarlo un poco, podríamos hacer búsqueda de patrones sobre el [`Http.Error`][Error] y reintentar la solicitud si ésta expiró por tiempo.

El punto es que sea como sea que actualicemos el modelo, también tenemos la libertad de emitir nuevos comandos. ¡Necesito más datos! ¡Necesito un número al azar! Etc.

[Error]: https://package.elm-lang.org/packages/elm/http/latest/Http#Error

## `subscription`

Otro aspecto nuevo de este programa es la función `subscription`. Nos permite revisar el `Model` y decidir si queremos suscribirnos a cierta información. En nuestro ejemplo, decimos `Sub.none` para indicar que no necesitamos suscribirnos a nada, pero pronto veremos un ejemplo de un reloj donde nos interesa suscribirnos al tiempo actual.

## Resumen

Cuando creamos programas con `Browser.element`, configuramos un sistema como este:

![](diagrams/element.svg)

Tenemos la abilidad de emitir **comandos** desde `init` y `update`. Esto nos permite hacer cosas como mandar solicitudes HTTP cuando queramos. También podemos **suscribirnos** a información interesante. (Pronto veremos un ejemplo que usa suscripciones).

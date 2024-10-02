# Flags

Las “flags” son una forma de pasarle valores a Elm al inicializar.

Algunos usos comunes incluye pasarle llaves de API, variables de entorno y datos de usuario. Esto puede ser útil si generaste el HTML dinámicamente. También nos pueden ayudar a cargar información en caché, como en [este ejemplo de `localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage).

## Flags en HTML

El HTML es prácticamente igual a como lo vimos antes, pero con un argumento `flags` adicional que le pasamos a la función `Elm.Main.init()`.

```html
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <script src="main.js"></script>
  </head>

  <body>
    <div id="myapp"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById("myapp"),
        flags: Date.now(),
      });
    </script>
  </body>
</html>
```

En este ejemplo le pasamos el tiempo actual en milisegundos, pero cualquier valor JS que pueda ser convertido en JSON puede ser usado como flag.

> **Nota:** Estos datos adicionales se llaman “flags” porque es el término que se usa para referirse a las opciones suministradas a un programa de línea de comandos. Cuando llamas `elm make src/Main.elm` también le puedes pasar algunas “flags” como `--optimize` o `--output=main.js` para cambiar lo que hará. En este caso es lo mismo.

## Flags en Elm

Para recibir las flags en el lado de Elm tendrás que modificar un poco la función `init`:

```elm
module Main exposing (..)

import Browser
import Html exposing (Html, text)



-- MAIN


main : Program Int Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { currentTime : Int }


init : Int -> ( Model, Cmd Msg )
init currentTime =
    ( { currentTime = currentTime }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text (String.fromInt model.currentTime)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
```

Lo único importante aquí es que la función `init` dice que recibe un argumento `Int`. Esta es la manera en que Elm puede acceder inmediatamente a las flags que le pases desde JavaScript. Después de eso puedes poner los datos en el modelo o ejecutar algún comando, lo que sea que necesites hacer.

Te recomiendo que revises [este ejemplo que usa `localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage) para ver un caso más interesante que usa flags.

## Verificando las flags

Pero, ¿qué pasa si `init` dice que recibe una flag `Int`, y alguien trata de inicializar con `Elm.Main.init({ flags: "ja, ¿qué vas a hacer?" })`?

Elm revisa esos casos, asegurando que las flags son exactamente lo que esperas. Sin este chequeo, le podrías pasar cualquier cosa, y terminarías viendo errores en tiempo de ejecución en Elm.

Hay muchos tipos que pueden usarse en flags:

- `Bool`
- `Int`
- `Float`
- `String`
- `Maybe`
- `List`
- `Array`
- tuples
- records
- [`Json.Decode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#Value)

Mucha gente usa `Json.Decode.Value` porque les da un control más preciso. Pueden escribir un decodificador para lidiar con cualquier situación específica usando código Elm, y recuperándose sin problemas si llegan datos extraños.

Los otros tipos que Elm soporta son un rezago de antes de que tuviéramos una forma de escribir decodificadores JSON. Si decides usarlos, hay ciertos detalles a tener en cuenta. Los siguientes ejemplos muestran el tipo deseado de la flag, y sus subpuntos ilustran la manera en que se interpretarían distintos valores JS:

- `init : Int -> ...`

  - `0` => `0`
  - `7` => `7`
  - `3.14` => error
  - `6.12` => error

- `init : Maybe Int -> ...`

  - `null` => `Nothing`
  - `42` => `Just 42`
  - `"hi"` => error

- `init : { x : Float, y : Float } -> ...`

  - `{ x: 3, y: 4, z: 50 }` => `{ x = 3, y = 4 }`
  - `{ x: 3, name: "Tom" }` => error
  - `{ x: 360, y: "why?" }` => error

- `init : (String, Int) -> ...`
  - `["Tom", 42]` => `("Tom", 42)`
  - `["Sue", 33]` => `("Sue", 33)`
  - `["Bob", "4"]` => error
  - `["Joe", 9, 9]` => error

Nótese que si la conversión no sale bien, **vas a obtener un error de JS**. Estamos tomando la política de “fallar rápido”. En vez de permitir que el error permee tu código Elm, lo reportamos lo antes posible. Esta es otra razón por la que hay gente a la que le gusta usar `Json.Decode.Value` en sus flags. En vez de obtener un error de JS, el valor extraño pasa por un decodificador, garantizando que puedas implementar un comportamiento de contingencia.

# Flags

Las “flags” son una forma de pasarle valores a nuestro programa Elm al inicializarlo.

Algunos usos comunes incluyen pasarle credenciales de una API, variables de entorno o datos de usuario. Puede ser bastante útil si generamos el HTML en forma dinámica. También nos pueden ayudar a cargar información en caché, como en [este ejemplo de `localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage).

<!-- TODO: 👆 Agregar este ejemplo al repositorio y traducirlo. -->

## Flags en HTML

El siguiente HTML es prácticamente igual a como lo vimos en la página anterior, pero con un argumento `flags` adicional que le pasamos a la función `Elm.Main.init()`.

```html
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <script src="main.js"></script>
  </head>

  <body>
    <div id="mi-app"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById("mi-app"),
        flags: Date.now(),
      });
    </script>
  </body>
</html>
```

En este ejemplo le pasamos la hora actual en milisegundos, pero cualquier valor JS que pueda ser convertido a JSON puede ser usado como flag.

> **Nota:** Estos datos adicionales se llaman “flags” porque es el término que se usa para referirse a las opciones suministradas a un programa de línea de comandos. Cuando llamamos `elm make src/Main.elm` también le podemos pasar algunas “flags” como `--optimize` o `--output=main.js` para cambiar lo que hará. En este caso es algo muy similar.

## Flags en Elm

Para recibir las flags en el lado de Elm tendremos que modificar un poco la función `init`:

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

Lo único importante aquí es que la función `init` dice que recibe un argumento `Int`. Esta es la manera en que nuestro código Elm puede acceder directamente a las flags que le pasemos desde JavaScript. Después de eso podemos poner esos datos en el modelo o ejecutar algún comando con ellos, lo que sea que necesitemos hacer.

Te recomiendo que revises [este ejemplo que usa `localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage) para ver un caso más interesante usando flags.

<!-- TODO: 👆 Agregar este ejemplo al repositorio y traducirlo. -->

## Verificando las flags

Pero, ¿qué pasa si `init` dice que recibe una flag `Int`, y alguien trata de hacer la inicialización de esta manera?: `Elm.Main.init({ flags: "Ja, ¿qué vas a hacer?" })`

Elm revisa esos casos, asegurando que las flags son exactamente lo que esperas. Sin este chequeo, le podrías pasar cualquier cosa, y terminarías viendo errores en tiempo de ejecución en Elm.

Hay muchos tipos que pueden usarse en flags:

- `Bool`
- `Int`
- `Float`
- `String`
- `Maybe`
- `List`
- `Array`
- tuplas
- registros
- [`Json.Decode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#Value)

Mucha gente prefiere usar `Json.Decode.Value` porque les otorga un control más preciso. Podemos escribir un decodificador para lidiar con cualquier situación específica usando código Elm, y si se reciben datos inesperados, podemos recuperarnos sin problemas.

Los otros tipos que Elm soporta son un rezago de la época antes de que existieran los decodificadores JSON. Si decides usar estos otros tipos, hay ciertos detalles a tener en cuenta. Los siguientes ejemplos muestran el tipo deseado de la flag, y en forma anidada se ilustra cómo se interpretan distintos valores JS:

- `init : Int -> ...`

  - `0` → `0`
  - `7` → `7`
  - `3.14` → error
  - `6.12` → error

- `init : Maybe Int -> ...`

  - `null` → `Nothing`
  - `42` → `Just 42`
  - `"hi"` → error

- `init : { x : Float, y : Float } -> ...`

  - `{ x: 3, y: 4, z: 50 }` → `{ x = 3, y = 4 }`
  - `{ x: 3, name: "Tom" }` → error
  - `{ x: 360, y: "why?" }` → error

- `init : (String, Int) -> ...`
  - `["Tom", 42]` → `("Tom", 42)`
  - `["Sue", 33]` → `("Sue", 33)`
  - `["Bob", "4"]` → error
  - `["Joe", 9, 9]` → error

Nótese que si la conversión no sale bien, **vas a obtener un error de JS**. Estamos adoptando la política de “fallar rápido”: En vez de permitir que el valor problemático permee nuestro código Elm, lo reportamos lo antes posible. Esta es otra razón por la que hay gente a la que le gusta usar `Json.Decode.Value` en sus flags: En vez de obtener un error de JS, el valor incorrecto pasa por un decodificador, garantizando que podamos implementar un comportamiento de contingencia.

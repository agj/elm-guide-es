# Puertos

Los puertos permiten la comunicación entre Elm y JavaScript.

Son más frecuentemente usados con [`WebSockets`](https://github.com/elm-community/js-integration-examples/tree/master/websockets) y con [`localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage). Enfoquémonos en el ejemplo de `WebSockets`.

<!-- TODO: 👆 Agregar estos ejemplos al repositorio y traducirlos. -->

## Puertos en JavaScript

Aquí tenemos prácticamente el mismo HTML que hemos usado en las últimas dos páginas, pero con un poco de JavaScript añadido. Creamos una conexión con `wss://echo.websocket.org` que repite lo que sea que le envíes. Puedes comprobar viendo [este ejemplo](https://ellie-app.com/8yYgw7y7sM2a1) que nos permite crear el esqueleto de un chat:

<!-- TODO: 👆 Traducir el ejemplo en el Ellie, y actualizar el link y el código abajo. -->

```html
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Elm + Websockets</title>
    <script type="text/javascript" src="elm.js"></script>
  </head>

  <body>
    <div id="myapp"></div>
  </body>

  <script type="text/javascript">
    // Start the Elm application.
    var app = Elm.Main.init({
      node: document.getElementById("myapp"),
    });

    // Create your WebSocket.
    var socket = new WebSocket("wss://echo.websocket.org");

    // When a command goes to the `sendMessage` port, we pass the message
    // along to the WebSocket.
    app.ports.sendMessage.subscribe(function (message) {
      socket.send(message);
    });

    // When a message comes into our WebSocket, we pass the message along
    // to the `messageReceiver` port.
    socket.addEventListener("message", function (event) {
      app.ports.messageReceiver.send(event.data);
    });

    // If you want to use a JavaScript library to manage your WebSocket
    // connection, replace the code in JS with the alternate implementation.
  </script>
</html>
```

Llamamos `Elm.Main.init()` igual que en otros ejemplos de interoperabilidad, pero esta vez sí usamos el objeto `app` que devuelve. Nos suscribimos al puerto `sendMessage` y estamos enviando datos al puerto `messageReceiver`.

Estos tienen una correspondencia en el lado Elm.

## Puertos en Elm

Revisa las líneas en que usamos la palabra clave `port` en el archivo Elm correspondiente. Así es como definimos los puertos que acabamos de ver en el lado JavaScript.

```elm
port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- PORTS


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { draft : String
    , messages : List String
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { draft = "", messages = [] }
    , Cmd.none
    )



-- UPDATE


type Msg
    = DraftChanged String
    | Send
    | Recv String



-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DraftChanged draft ->
            ( { model | draft = draft }
            , Cmd.none
            )

        Send ->
            ( { model | draft = "" }
            , sendMessage model.draft
            )

        Recv message ->
            ( { model | messages = model.messages ++ [ message ] }
            , Cmd.none
            )



-- SUBSCRIPTIONS
--
-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver Recv



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Echo Chat" ]
        , ul []
            (List.map (\msg -> li [] [ text msg ]) model.messages)
        , input
            [ type_ "text"
            , placeholder "Draft"
            , onInput DraftChanged
            , on "keydown" (ifIsEnter Send)
            , value model.draft
            ]
            []
        , button [ onClick Send ] [ text "Send" ]
        ]



-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg

                else
                    D.fail "some other key"
            )
```

Fíjate en que la primera línea dice `port module` en vez de sólo `module`. Esto es lo que hace posible definir puertos dentro del módulo. El compilador te va a dar ayuda si acaso te equivocas en esto, así que espero que no llegue a ser un problema muy grande.

Bueno, pero ¿qué significan las declaraciones `port` para `sendMessage` y `messageReceiver`?

## Mensajes de salida (`Cmd`)

La declaración de `sendMessage` nos permite enviar mensajes de salida desde Elm.

```elm
port sendMessage : String -> Cmd msg
```

Aquí declaramos que queremos enviar valores `String`, pero podríamos poner cualquiera de los otros tipos que funcionan con flags. Hablamos sobre esos tipos en la página anterior, y puedes revisar este [ejemplo que usa `localStorage`](https://ellie-app.com/8yYddD6HRYJa1) para ver cómo enviamos un valor [`Json.Encode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode#Value) hacia JavaScript.

<!-- TODO: 👆 Traducir este ejemplo en el Ellie. -->

Ahora podemos usar `sendMessage` igual que cualquier función. Si tu función `update` genera un comando `sendMessage "hello"`, lo vas a recibir en el lado de JavaScript:

```javascript
app.ports.sendMessage.subscribe(function (message) {
  socket.send(message);
});
```

Este código JavaScript está suscrito a todos los mensajes de salida. Puedes llamar suscribir múltiples funciones con `subscribe`, y después desuscribirlas por referencia usando `unsubscribe`, pero en general sugerimos mantener esto estático.

También recomendamos enviar mensajes más completos en vez de crear muchos puertos individuales. Tal vez eso significaría tener un tipo personalizado en Elm que representa todo lo que necesites decirle a JS, y después usar [`Json.Encode`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode) para enviarlo a una única suscripción de JS. Mucha gente cree que esto contribuye a tener una mejor separación de intereses. El código Elm es claramente dueño de cierto estado, y el lado JS es claramente dueño de cierto otro estado.

## Mensajes de entrada (`Sub`)

La declaración de `messageReceiver` nos permite escuchar mensajes que entran a Elm.

```elm
port messageReceiver : (String -> msg) -> Sub msg
```

Aquí decimos que vamos a recibir valores `String`, pero nuevamente, podemos escuchar cualquier tipo que sea compatible con flags o con puertos de salida. Simplemente cambia el tipo `String` por el de uno de los tipos que puede cruzar la frontera.

Podemos usar `messageReceiver` igual que otras funciones. En nuestro caso, llamamos `messageReceiver Recv` cuando definimos nuestras suscripciones, porque queremos escuchar cualquier mensaje de entrada desde JavaScript. Esto nos permitirá recibir mensajes como `Recv "¿cómo estás?"` en nuestra función `update`.

En el lado JavaScript, podemos enviar cosas a un puerto cuando queramos:

```javascript
socket.addEventListener("message", function (event) {
  app.ports.messageReceiver.send(event.data);
});
```

En este caso lo estamos haciendo cuando recibimos un mensaje vía un websocket, pero podrías enviarlo en cualquier otro momento también. Tal vez hay otra fuente más desde la cual recibimos mensajes. No hay problema, Elm no necesita saber los detalles. Sólo mándale el string por el puerto que corresponda.

## Notas

**Los puertos están diseñados para crear fronteras.** Definitivamente no intentes crear un puerto por cada función JS que necesites. Tal vez te gusta mucho Elm y quieras hacer todo en Elm sin importar el costo, pero los puertos no están diseñados para eso. En vez de esto, enfócate en preguntas como “¿quién es el dueño de este estado?”, y usa uno o dos puertos para enviar mensajes de ida y vuelta. Si estás en un escenario complejo, puedes incluso simular valores `Msg` enviando objetos JS como `{ tag: "active-users-changed", list: ... }`, donde tienes una etiqueta para cada variante de la información que necesites transmitir.

Aquí tienes algunas reglas generales y problemas frecuentes:

- **Es recomendado enviar `Json.Encode.Value` en tus puertos.** Igual que con flags, hay ciertos tipos básicos que pueden transmitirse vía puertos. Esto viene del tiempo antes de que existieran decodificadores de JSON, y puedes leer más al respecto [aquí](/interop/flags.html#verifying-flags).

- **Todas las declaraciones `port` deben aparecer en un `port module`.** Probablemente lo mejor es organizar tus puertos en un sólo `port module` para que sea más fácil visualizar la interfaz, toda en un sólo lugar.

- **Los puertos son para aplicaciones.** Los `port module` están disponibles para aplicaciones, pero no para paquetes. Esto asegura que los autores de una aplicación tengan la flexibilidad que necesitan, pero el ecosistema de paquetes está escrito en Elm al cien porciento. Creemos que esto creará un ecosistema y una comunidad más fuertes a la larga, y nos referimos a los sacrificios involucrados más en detalle en la sección siguiente sobre los [límites](/interop/limits.html) de la interoperabilidad Elm/JS.

- **Los puertos pueden ser eliminados como código muerto.** Elm tiene un agresivo sistema de [eliminación de código muerto](/interop/limits.html), y borrará puertos que no son usados dentro de Elm, ya que el compilador no tiene idea de lo que ocurre en el lado JavaScript. Por lo tanto, intenta cablear tus puertos en el lado Elm antes que nada.

Espero que esta información te ayude a encontrar maneras de incluir Elm junto a tu JavaScript preexistente. No es tan excitante como hacer una reescritura completa en Elm, pero históricamente hemos visto que es una estrategia mucho más efectiva.

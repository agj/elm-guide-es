# Puertos

Los puertos permiten la comunicación entre Elm y JavaScript.

Son más frecuentemente usados con [`WebSockets`](https://github.com/elm-community/js-integration-examples/tree/master/websockets) y con [`localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage). Enfoquémonos en el caso de `WebSockets`.

<!-- TODO: 👆 Agregar estos ejemplos al repositorio y traducirlos. -->

## Puertos en JavaScript

Aquí tenemos prácticamente el mismo HTML que hemos usado en las últimas dos páginas, pero con un poco de JavaScript añadido. Creamos una conexión con `wss://echo.websocket.org`, que responde con lo que sea que le enviemos. Puedes comprobarlo viendo [este ejemplo](https://ellie-app.com/xWNj3FJ5tWQa1) que es como el “esqueleto” de un chat:

```html
<!doctype html>

<html>
  <head>
    <meta charset="UTF-8" />
    <title>Elm + websockets</title>
    <script type="text/javascript" src="elm.js"></script>
  </head>

  <body>
    <div id="myapp"></div>
  </body>

  <script type="text/javascript">
    // Inicializa la aplicación Elm.
    var app = Elm.Main.init({
      node: document.getElementById("myapp"),
    });

    // Crea el websocket.
    var socket = new WebSocket("wss://echo.websocket.org");

    // Cuando algo llega al puerto `enviarMensaje`, lo redirigimos
    // al websocket.
    app.ports.enviarMensaje.subscribe(function (mensaje) {
      socket.send(mensaje);
    });

    // Cuando algo llega por el websocket, lo redirigimos al puerto
    // `mensajeEntrante`.
    socket.addEventListener("message", function (evento) {
      app.ports.mensajeEntrante.send(evento.data);
    });

    // Puedes reemplazar este código de arriba con una implementación
    // que use tu librería preferida de manejo de websockets.
  </script>
</html>
```

Llamamos `Elm.Main.init()`, igual que en otros ejemplos de interoperabilidad, pero esta vez sí usamos el objeto `app` que devuelve. Nos suscribimos al puerto `sendMessage`, y enviamos datos al puerto `messageReceiver`.

Estos tienen una correspondencia en el lado Elm.

## Puertos en Elm

Revisa las líneas en que usamos la palabra clave `port` en el archivo Elm correspondiente. Así es como definimos en Elm los puertos que acabamos de ver en el lado JavaScript.

```elm
port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- PUERTOS


port enviarMensaje : String -> Cmd msg


port mensajeEntrante : (String -> msg) -> Sub msg



-- MODELO


type alias Model =
    { borrador : String
    , mensajes : List String
    }


init : () -> ( Model, Cmd Msg )
init flags =
    ( { borrador = "", mensajes = [] }
    , Cmd.none
    )



-- ACTUALIZACIÓN


type Msg
    = BorradorCambiado String
    | EnviarSolicitado
    | MensajeRecibido String



-- Usamos el puerto `enviarMensaje` cuando el usuario apreta
-- la tecla “enter” o el botón “Enviar”. Revisa `index.html`
-- para ver el código JS donde esto se redirige a un WebSocket.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BorradorCambiado borrador ->
            ( { model | borrador = borrador }
            , Cmd.none
            )

        EnviarSolicitado ->
            ( { model | borrador = "" }
            , enviarMensaje model.borrador
            )

        MensajeRecibido mensaje ->
            ( { model | mensajes = model.mensajes ++ [ mensaje ] }
            , Cmd.none
            )



-- SUSCRIPCIONES
--
-- Nos suscribimos al puerto `mensajeEntrante` para escuchar
-- los mensajes de entrada desde JS. Revisa el archivo
-- `index.html` para ver cómo se conecta esto con un websocket.


subscriptions : Model -> Sub Msg
subscriptions _ =
    mensajeEntrante MensajeRecibido



-- VISTA


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Mensajería eco" ]
        , ul []
            (List.map (\msg -> li [] [ text msg ]) model.mensajes)
        , input
            [ type_ "text"
            , placeholder "Borrador"
            , onInput BorradorCambiado
            , on "keydown" (siEsEnter EnviarSolicitado)
            , value model.borrador
            ]
            []
        , button [ onClick EnviarSolicitado ] [ text "Enviar" ]
        ]



-- DETECTAR ENTER


siEsEnter : msg -> D.Decoder msg
siEsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg

                else
                    D.fail "otra tecla"
            )
```

Fíjate en que la primera línea dice `port module` en vez de sólo `module`. Esto es lo que hace posible definir puertos dentro del módulo. El compilador te va a dar ayuda si acaso te equivocas en esto, así que espero que no llegue a ser inconveniente.

Bueno, pero ¿qué significan las declaraciones `port` para definir `sendMessage` y `messageReceiver`?

## Mensajes de salida (`Cmd`)

La declaración de `sendMessage` nos permite enviar mensajes de salida desde Elm.

```elm
port sendMessage : String -> Cmd msg
```

Aquí declaramos que queremos enviar valores `String`, pero podríamos poner cualquiera de los otros tipos que funcionan con flags. Hablamos sobre esos tipos en la página anterior. También puedes revisar este [ejemplo que usa `localStorage`](https://ellie-app.com/8yYddD6HRYJa1) para ver cómo enviamos un valor [`Json.Encode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode#Value) hacia JavaScript.

<!-- TODO: 👆 Traducir este ejemplo en el Ellie. -->

Ahora podemos usar `sendMessage` igual que cualquier función. Si tu función `update` genera un comando `sendMessage "hello"`, lo vas a recibir en el lado de JavaScript:

```javascript
app.ports.sendMessage.subscribe(function (message) {
  socket.send(message);
});
```

Este código JavaScript está suscrito a todos los mensajes de salida. Es posible suscribir múltiples funciones usando `subscribe`, y después desuscribirlas por referencia usando `unsubscribe`, pero en general sugerimos mantener esto estático.

También recomendamos enviar mensajes más completos en vez de crear muchos puertos individuales. Tal vez eso significaría tener un tipo personalizado en Elm que representa todo lo que necesitemos decirle a JS, y después usar [`Json.Encode`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode) para enviarlo a una única suscripción de JS. Mucha gente opina que esto contribuye a tener una mejor separación de intereses. El código Elm es claramente dueño de cierto estado, y el lado JS es claramente dueño de cierto otro estado.

## Mensajes de entrada (`Sub`)

La declaración de `messageReceiver` nos permite escuchar mensajes que entran al lado Elm.

```elm
port messageReceiver : (String -> msg) -> Sub msg
```

Aquí decimos que vamos a recibir valores `String`, pero nuevamente, podemos escuchar cualquier tipo que sea compatible con flags o con puertos de salida. Simplemente cambia el tipo `String` por otro de los tipos que pueden cruzar la frontera.

Podemos usar `messageReceiver` igual que otras funciones. En nuestro caso, llamamos `messageReceiver Recv` cuando definimos nuestras suscripciones, porque queremos escuchar cualquier mensaje de entrada desde JavaScript. Esto nos permitirá recibir mensajes como `Recv "¿cómo estás?"` en nuestra función `update`.

En el lado JavaScript podemos enviar cosas a un puerto en cualquier momento:

```javascript
socket.addEventListener("message", function (event) {
  app.ports.messageReceiver.send(event.data);
});
```

En este caso lo hacemos al recibir un mensaje vía websocket, pero podríamos enviarlo en cualquier otro momento también. Tal vez hay otra fuente más desde la cual recibimos mensajes, y no hay problema, porque Elm no necesita saber los detalles: sólo mándale el string por el puerto que corresponda.

## Notas

**Los puertos están diseñados para crear fronteras.** Definitivamente no busques crear un puerto para cada función JS que necesites invocar. Tal vez te gusta mucho Elm y quieras hacer todo en Elm sin importar el costo, pero los puertos no están diseñados para eso. Mejor enfócate en preguntas como “¿quién es el dueño de este estado?”, y usa uno o dos puertos para enviar mensajes de ida y vuelta. Si estás en un escenario complejo, puedes incluso simular valores `Msg` enviando objetos JS como `{ tag: "active-users-changed", list: ... }`, donde tienes una etiqueta para cada variante de la información que necesites transmitir.

Aquí tienes algunas sugerencias y soluciones a problemas frecuentes:

- **Es recomendado enviar `Json.Encode.Value` en tus puertos.** Igual que con flags, hay ciertos tipos básicos que pueden transmitirse vía puertos. Esto viene del tiempo antes de que existieran los decodificadores de JSON, y puedes leer más al respecto [aquí](/interop/flags.html#verifying-flags).

- **Todas las declaraciones `port` deben aparecer en un `port module`.** Probablemente lo mejor es organizar tus puertos en un sólo `port module` para que sea más fácil visualizar la interfaz, toda en un sólo lugar.

- **Los puertos son para aplicaciones.** Los `port module` están disponibles para aplicaciones, pero no para paquetes. Esto asegura que los autores de una aplicación tengan la flexibilidad que necesitan, pero el ecosistema de paquetes está escrito en Elm al cien porciento. Creemos que esto creará un ecosistema y una comunidad más fuertes a la larga, y nos referimos a los sacrificios involucrados más en detalle en la sección siguiente sobre los [límites](/interop/limits.html) de la interoperabilidad Elm/JS.

- **Los puertos pueden ser eliminados como código muerto.** Elm tiene un agresivo sistema de [eliminación de código muerto](/interop/limits.html), y borrará puertos que no son usados dentro de Elm, ya que el compilador no tiene idea de lo que ocurre en el lado JavaScript. Por lo tanto, asegúrate de cablear tus puertos en el lado Elm antes que nada.

Espero que esta información te ayude a encontrar maneras de incorporar Elm junto a tu JavaScript preexistente. Tal vez no es tan motivante como reescribir un proyecto completo en Elm, pero históricamente hemos visto que es una estrategia mucho más efectiva.

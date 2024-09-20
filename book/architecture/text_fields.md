# Campos de texto

Vamos a crear una simple aplicación que escribe al revés lo que pongas en un campo de texto.

Ahora abre este programa en el editor online. Revisa el tip que aparece cuando pones el cursor sobre la palabra `type`. **¡Apreta el botón azul!**

<div class="edit-link"><a href="https://elm-lang.org/examples/text-fields">Editar</a></div>

```elm
import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { content : String
    }


init : Model
init =
    { content = "" }



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        ]
```

Este código es una ligera variación del ejemplo anterior. Primero configuras un modelo. Defines unos mensajes. Dices cómo actualizar con `update`. Defines la vista en `view`. La diferencia es sólo el cómo rellenamos este esqueleto. Vamos parte por parte.

## Modelo

Siempre empiezo tratando de imaginar cómo tiene que ser mi `Model`. Sabemos que tenemos que llevar cuenta de lo que el usuario haya escrito en el campo de texto. Necesitamos esa información para saber cómo mostrar el texto al revés. Así que probamos con esto:

```elm
type alias Model =
    { content : String
    }
```

Esta vez decidí representar el modelo como un registro. El registro guarda la información ingresada por el usuario en el campo `content`.

> **Nota:** Tal vez te surja la duda de por qué usar un registro cuando sólo tiene un campo. ¿No podríamos usar `String` directamente? Claro que sí. Pero si empezamos con un registro, se hace más fácil después añadir más campos a medida que nuestra aplicación se hace más complicada. Cuando llegue el momento en que necesitemos _dos_ campos de texto, vamos a tener que hacer mucho menos trabajo.

## Vista

Ya tenemos un modelo, así que normalmente lo siguiente que hago es crear la función `view`:

```elm
view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        ]
```

Creamos un `<div>` con dos hijos. El hijo que más nos interesa es el nodo `<input>`, que tiene tres atributos:

- `placeholder` es el texto que se muestra cuando no hay contenido
- `value` es el contenido actual de este `<input>`
- `onInput` envía mensajes cuando el usuario escribe algo en este nodo `<input>`

Si escribes “bard” vas a producir cuatro mensajes:

1. `Change "b"`
2. `Change "ba"`
3. `Change "bar"`
4. `Change "bard"`

Estos serán ingresados a nuestra función `update`.

## Actualización

Solo hay un tipo de mensaje en este programa, así que nuestro `update` sólo tiene que tomar en cuenta un caso:

```elm
type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }
```

Cuando recibimos un mensaje de que hubo un cambio en nuestro `<input>`, actualizamos el campo `content` del modelo. Así que si escribes “bard”, los mensajes resultantes producirían estos modelos:

1. `{ content = "b" }`
2. `{ content = "ba" }`
3. `{ content = "bar" }`
4. `{ content = "bard" }`

Necesitamos llevar cuenta de esta información en el modelo en forma explícita.Si no, no tendríamos cómo mostrar el texto al revés en nuestra función `view`.

> **Ejercicio:** Abre el ejemplo en el editor online [aquí](https://elm-lang.org/examples/text-fields), y muestra el largo del campo `content` en tu función `view`. Usa la función [`String.length`](https://package.elm-lang.org/packages/elm/core/latest/String#length).
>
> **Nota:** Si quieres más información sobre exactamente cómo funcionan los valores `Change` en este programa, revisa las secciones posteriores sobre [tipos personalizados](/types/custom_types.html) y [búsqueda de patrones](/types/pattern_matching.html).

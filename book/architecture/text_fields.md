# Campos de texto

Vamos a crear una simple aplicación que escribe al revés lo que ingreses en un campo de texto.

Abre este programa en el editor online, y fíjate en el tip que aparece cuando pones el cursor sobre la palabra `type`. **¡Apreta el botón azul!**

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

Este código es una ligera variación del ejemplo anterior. Configuramos un modelo, definimos unos mensajes, decimos cómo actualizar el modelo con `update`, y definimos la vista en `view`. La diferencia está sólo en cómo completamos este esqueleto. Veamos parte por parte.

## Modelo

Yo siempre comienzo tratando de imaginar cómo tiene que ser mi `Model`. De partida sabemos que necesitamos llevar cuenta de lo que el usuario haya escrito en el campo de texto, porque necesitamos esa información para saber cómo mostrar el texto al revés. Así que probamos con esto:

```elm
type alias Model =
    { content : String
    }
```

Esta vez decidí representar el modelo como un registro. El registro alberga el texto ingresado por el usuario en el campo `content`.

> **Nota:** Tal vez te surja la duda de por qué usar un registro con un sólo campo. ¿No podríamos usar `String` directamente? Claro que sí. Pero si empezamos con un registro, se hace más fácil después añadir más campos a medida que nuestra aplicación se haga más compleja. Cuando llegue el momento en que necesitemos _dos_ campos de texto, tendremos que hacer mucho menos trabajo.

## Vista

Ya teniendo el modelo, lo que normalmente hago después es crear la función `view`:

```elm
view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        ]
```

Creamos un `<div>` con dos hijos. El hijo que más nos interesa es el nodo `<input>`, que tiene tres atributos:

- `placeholder` es el texto que se muestra cuando no hay contenido.
- `value` es el contenido actual de este `<input>`.
- `onInput` produce mensajes cuando el usuario escribe algo en este nodo `<input>`.

Si escribes “sala” vas a producir cuatro mensajes:

1. `Change "s"`
2. `Change "sa"`
3. `Change "sal"`
4. `Change "sala"`

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

Cuando recibimos un mensaje indicando que hubo un cambio en nuestro `<input>`, actualizamos el campo `content` del modelo. Así que si escribimos “sala”, los mensajes resultantes producirían estos modelos:

1. `{ content = "s" }`
2. `{ content = "sa" }`
3. `{ content = "sal" }`
4. `{ content = "sala" }`

Necesitamos llevar cuenta de esta información en el modelo en forma explícita. Si no, no tendríamos cómo mostrar el texto al revés en nuestra función `view`.

> **Ejercicio:** Abre el ejemplo en el editor online [aquí](https://elm-lang.org/examples/text-fields), y pon la cantidad de caracteres que tiene el campo `content` en tu función `view`. Usa la función [`String.length`](https://package.elm-lang.org/packages/elm/core/latest/String#length) para lograrlo.
>
> **Nota:** Si quieres más información sobre exactamente cómo funcionan los valores `Change` en este programa, revisa las secciones posteriores sobre [tipos personalizados](/types/custom_types.html) y [búsqueda de patrones](/types/pattern_matching.html).

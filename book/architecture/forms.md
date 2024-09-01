# Formularios

Vamos a crear un pequeño formulario. Tiene un campo para tu nombre, otro para tu clave, y otro para verificar la clave. También vamos a hacer un poco de validación para asegurarnos de que ambas claves son iguales.

Abajo tienes el programa completo. Puedes abrirlo en el editor online. Trata de escribir algo mal para ver mensajes de error. Por ejemplo, cambia el nombre de un campo, como `password`, o de una función, como `placeholder`. **¡Apreta el botón azul!**

<div class="edit-link"><a href="https://elm-lang.org/examples/forms">Editar</a></div>

```elm
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    if model.password == model.passwordAgain then
        div [ style "color" "green" ] [ text "OK" ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]
```

Es bastante similar a nuestro [ejemplo de campos de texto](text_fields.md), pero con más campos.

# Modelo

Yo siempre empiezo pensando en el `Modelo`. Sabemos que vamos a necesitar tres campos de texto, así que partamos con eso.

```elm
type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }
```

Normalmente empiezo con un modelo mínimo, tal vez con un sólo campo. Después intento escribir las funciones `view` y `update`. En ese proceso suelo sentir la necesidad de guardar más cosas en `Model`. Si usamos esta estrategia de construir el modelo gradualmente, podemos tener un programa funcional en cada etapa de su desarrollo. No tendrá todas las funcionalidades desde un principio, pero llegaremos ahí de a poco.

## Actualización

Hay veces en que tenemos una idea basante completa de cómo se vería el código de actualización. Sabemos que necesitamos cambiar los tres campos, así que necesitamos mensajes para cada caso.

```elm
type Msg
    = Name String
    | Password String
    | PasswordAgain String
```

Esto significa que `update` necesita una rama para cada variante:

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }
```

Cada rama usa la sintaxis de actualización de registros para transformar el campo correspondiente del modelo. Esto se parece a lo que hicimos en el ejemplo anterior, pero con más casos.

En `view` vamos a tener que hacer un poco más de trabajo.

## Vista

Esta función `view` usa **funciones de ayuda** para organizar mejor la cosas:

```elm
view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]
```

En ejemplos anteriores usábamos `input` y `div` directamente. ¿Por qué aquí no?

Lo bueno del HTML en Elm es que `input` y `div` son sólo funciones comunes y corrientes. Reciben (1) una lista de atributos, y (2) una lista de nodos hijo. **Ya que son sólo funciones, tenemos el poder completo de Elm para construir nuestras vistas.** Podemos refactorizar código repetitivo y ponerlo en funciones de ayuda de nuestra propia creación. Y eso es justamente lo que estamos haciendo aquí.

La función `view` hace tres llamadas a `viewInput`:

```elm
viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []
```

Esto significa que si escribimos `viewInput "text" "Name" "Bill" Name` en Elm, se convertiría en un valor HTML como `<input type="text" placeholder="Name" value="Bill">` cuando se despliegue en pantalla.

El cuarto hijo es más interesante. Es una llamada a `viewValidation`:

```elm
viewValidation : Model -> Html msg
viewValidation model =
    if model.password == model.passwordAgain then
        div [ style "color" "green" ] [ text "OK" ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]
```

Esta función primero compara las dos claves. Si son iguales, retorna un texto en verde y un mensaje de afirmación. Si no son iguales, retorna un texto en rojo y un mensaje de ayuda.

Estas funciones de ayuda ya empiezan a mostrar el beneficio de que nuestra librería de HTML sea sólo código Elm. Podríamos haber puesto todo este código dentro de `view`, pero crear funciones de ayuda es completamente normal en Elm, incluyendo en el código de la vista. “Parece que está un poco difícil de entender. Probemos extrayéndolo a una función de ayuda”.

> **Ejercicios:** [Revisa este ejemplo](https://elm-lang.org/examples/forms) en el editor online. Intenta añadir las siguientes funcionalidades a la función `viewValidation`:
>
> - Confirma que la clave es más larga que 8 caracteres.
> - Asegura que la clave tiene letras mayúsculas, minúsculas y dígitos numéricos.
>
> Usa las funciones del módulo [`String`](https://package.elm-lang.org/packages/elm/core/latest/String) para completar estos ejercicios.
>
> **Advertencia:** Necestamos aprender mucho más antes de poder enviar una solicitud HTTP. Sigue leyendo en orden hasta llegar a la sección sobre HTTP antes de intentarlo por tu cuenta. Te va a resultar mucho más fácil siguiendo la guía.
>
> **Nota:** Parece que los intentos de hacer librerías genéricas de validación no han dado muchos frutos. Creo que el problema es que los chequeos son más comúnmente resueltos con funciones normales. Éstas reciben argumentos y retornan un `Bool` o un `Maybe`. O sea, ¿para qué usar una librería para revisar que dos textos son iguales? De lo que hemos aprendido, el código más simple surge al escribir la lógica para tu caso particular, sin extras añadidos. Así que siempre intenta hacer esto antes de decidir que necesitas una solución más compleja.

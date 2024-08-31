# Botones

Nuestro primer ejemplo es un contador que puede incrementarse o decrementarse.

Abajo está el programa completo. Si apretas el botón “Edit” puedes jugar con el código interactivamente en el editor online. Prueba cambiar el texto de uno de los botones. **¡Apreta el botón azul!**

<div class="edit-link"><a href="https://elm-lang.org/examples/buttons">Edit</a></div>

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
```

Ahora que ya has jugado un poco con el código, seguramente tienes algunas preguntas. ¿Qué hace el valor `main`? ¿Cómo calzan todas estas partes? Discutámoslo parte por parte.

> **Nota:** El código usa [anotaciones de tipo](/types/reading_types.html), [tipos alias](/types/type_aliases.html), y [tipos personalizados](/types/custom_types.html). El punto de esta sección es que agarres una idea de la Arquitectura Elm, por lo que no vamos a entrar en esos temas hasta después. Te sugiero que no te adelantes, aunque te compliquen un poco estos aspectos.

## Main

El valor `main` tiene un significado especial en Elm. Describe lo que se muestra en pantalla. En este caso, vamos a inicializar nuestra aplicación con el valor `init`, la función `view` va a mostrar todo en pantalla, y la entrada de usuario va a ser ingresada a la función `update`. `main` es como la descripción global de nuestro programa.

## Modelo

El modelado de datos es extremadamente importante en Elm. El punto del **modelo** es capturar todos los detalles de tu aplicación en forma de datos.

Para hacer un contador, necesitamos tener un número que aumentará o bajará. Eso significa que en esta ocasión el modelo es muy pequeño:

```elm
type alias Model =
    Int
```

Sólo necesitamos un valor `Int` para llevar la cuenta. Podemos también verlo en nuestro valor inicial:

```elm
init : Model
init =
    0
```

El valor inicial es cero, y éste subirá o bajará según la gente aprete los botones.

## Vista

Tenemos un modelo, pero ¿cómo lo mostramos en pantalla? Ese es el rol de la función `view`:

```elm
view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
```

Esta función recibe el `Model` como un argumento, y retorna HTML. Estamos diciendo que queremos un botón de decremento, la cuenta actual, y un botón de incremento.

Nótese que tenemos una suscripción al evento `onClick` para cada botón. Estamos diciendo: **cuando alguien haga clic, genera un mensaje**. Dado esto, el botón “+” está generando un mensaje `Increment`. ¿Qué es eso y a dónde va a parar? Bueno, terminará en la función `update`.

## Actualización

La función `update` describe cómo nuestro `Model` cambiará en el tiempo.

Definimos dos mensajes que puede recibir:

```elm
type Msg
    = Increment
    | Decrement
```

Después, la función `update` simplemente describe qué se debe hacer cuando se recibe uno de estos mensajes.

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1
```

Si recibe un mensaje `Increment`, incrementamos el modelo. Si recibe un mensaje `Decrement`, decrementamos el modelo.

Cada vez que recibimos un mensaje, se le suplirá a la función `update` para generar un nuevo modelo. Después llamamos a `view` para saber cómo mostrar este modelo en pantalla. Y así sucesivamente. Las interacciones del usuario generan un mensaje, actualizamos el modelo con `update`, lo mostramos en pantalla con `view`. Etc.

## Resumen

Ahora que hemos visto todas las partes de un programa Elm, tal vez sea más fácil entender cómo se relacionan con el diagrama que vimos antes:

![Diagrama de la Arquitectura Elm](buttons.svg)

Elm empieza visualizando el valor inicial en pantalla. Después, entras en este loop:

1. Esperar interacción del usuario.
2. Mandar un mensaje a `update`.
3. Producir un nuevo `Model`.
4. Llamar a `view` para obtener un nuevo HTML.
5. Mostrar el nuevo HTML en pantalla.
6. Y se repite.

Esta es la esencia de la Arquitectura Elm. Todos los ejemplos que veamos a partir de aquí serán sólo leves variaciones de este patrón fundamental.

> **Ejercicio:** Añade un botón que reinicie el contador en cero:
>
> 1. Añade una variante `Reset` en el tipo `Msg`.
> 2. Añade una rama `Reset` en la función `update`.
> 3. Añade un botón en la función `view`.
>
> Puedes editar el ejemplo en el editor online [aquí](https://elm-lang.org/examples/buttons).
>
> Si te va bien con eso, intenta añadir otro botón que incremente en intervalos de a 10.

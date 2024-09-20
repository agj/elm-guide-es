# Valores aleatorios

Hasta ahora sólo hemos visto comandos que realizan solicitudes HTTP, pero también existen otros comandos, como aquellos que general valores aleatorios. Vamos a crear una aplicación que tira un dado y produce un valor entre 1 y 6.

Apreta el botón azul “Editar” para ver este ejemplo en acción. Genera algunos números aleatorios y revisa el código para tratar de interpretar cómo funciona. **Apreta el botón azul.**

<div class="edit-link"><a href="https://elm-lang.org/examples/numbers">Editar</a></div>

```elm
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6)
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
```

Lo nuevo aquí es el comando generado en la función `update`:

```elm
Random.generate NewFace (Random.int 1 6)
```

Generar valores aleatorios funciona un poco distinto en comparación con otros lenguajes como JavaScript, Python, Java, etc. Veamos cómo funciona en Elm.

## Generadores de valores aleatorios

Usamos el paquete [`elm/random`][readme] para esto. En particular, el módulo [`Random`][random].

[readme]: https://package.elm-lang.org/packages/elm/random/latest
[random]: https://package.elm-lang.org/packages/elm/random/latest/Random

La idea fundametal es que tenemos un generador `Generator` que describe _cómo_ vamos a generar el valor aleatorio. Por ejemplo:

```elm
import Random


probability : Random.Generator Float
probability =
    Random.float 0 1


roll : Random.Generator Int
roll =
    Random.int 1 6


usuallyTrue : Random.Generator Bool
usuallyTrue =
    Random.weighted ( 80, True ) [ ( 20, False ) ]
```

Aquí tenemos tres generadores de valores aleatorios. El generador `roll` dice que producirá un `Int`, y más específicamente, uno entre `1` y `6`, inclusivos. Similarmente, el generador `usuallyTrue` dice que producirá un `Bool`, y más específicamente, que éste será `True` el 80% de las veces.

El punto es que no estamos aún generando los valores. Estamos sólo describiendo _cómo_ generarlos. Después podemos usar [`Random.generate`][gen] para convertirlo en un comando:

```elm
generate : (a -> msg) -> Generator a -> Cmd msg
```

Cuando el comando se ejecuta, el `Generator` produce un valor, y éste se convierte en un mensaje para la función `update`. En nuestro ejemplo, el `Generator` produce un valor entre 1 y 6, y después se convierte en un mensaje como `NewFace 1` o `NewFace 4`. Eso es todo lo que necesitamos para poder lanzar el dado, pero los generadores pueden hacer mucho más.

[gen]: https://package.elm-lang.org/packages/elm/random/latest/Random#generate

## Combinando generadores

Teniendo generadores simples como `probability` o `usuallyTrue`, podemos empezar a conjugarlos usando funciones como [`map3`](https://package.elm-lang.org/packages/elm/random/latest/Random#map3). Imagina que quisiéramos hacer una máquina tragamonedas. Podríamos tener un generador como este:

```elm
import Random


type Symbol
    = Cherry
    | Seven
    | Bar
    | Grapes


symbol : Random.Generator Symbol
symbol =
    Random.uniform Cherry [ Seven, Bar, Grapes ]


type alias Spin =
    { one : Symbol
    , two : Symbol
    , three : Symbol
    }


spin : Random.Generator Spin
spin =
    Random.map3 Spin symbol symbol symbol
```

Primero creamos `Symbol` para describir los símbolos que aparecen en la máquina tragamonedas. Después creamos un generador que otorga la misma probabilidad a cada símbolo.

Después usamos `map3` para combinarlos en un nuevo generador `spin`. Lo que hace es generar tres símbolos y después unirlos en un valor `Spin`.

El punto es que a partir de estas piezas básicas podemos crear un `Generator` que describe comportamientos bastante complejos. Y desde nuestra aplicación, sólo necesitamos decir algo como `Random.generate NewSpin spin` para obtener el siguiente valor aleatorio.

> **Ejercicios:** Estas son algunas ideas para hacer más interesante el código que vimos en esta página.
>
> - En vez de mostrar un número, muestra la cara del dado como imagen.
> - En vez de mostrar una imagen de un dado, usa [`elm/svg`][svg] para dibujarla por tu cuenta.
> - Crea un dado “tramposo” usando [`Random.weighted`][weighted].
> - Añade un segundo dado y haz que se tiren ambos al mismo tiempo.
> - Haz que el dado gire aleatoriamente antes de caer sobre su valor final.

[svg]: https://package.elm-lang.org/packages/elm/svg/latest/
[weighted]: https://package.elm-lang.org/packages/elm/random/latest/Random#weighted

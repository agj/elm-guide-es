# Navegación

Ya vimos cómo servir una página, pero imaginemos que estamos creando un sitio web como `package.elm-lang.org`, que tiene varias páginas como [la búsqueda](https://package.elm-lang.org/), [el readme](https://package.elm-lang.org/packages/elm/core/latest/) de cada paquete y [la documentación](https://package.elm-lang.org/packages/elm/core/latest/Maybe), todas las cuales funcionan distinto. ¿Cómo podemos hacer eso?

## Múltiples páginas

La forma más simple sería servir múltiples archivos HTML. Si vas a la página principal, cargas un nuevo HTML. Si vas a la documentación de `elm/core`, cargas otro HTML. Si vas a la documentación de `elm/json`, cargas otro HTML.

Hasta Elm 0.19, eso era lo que este sitio web hacía. Funciona, y es simple. Pero tiene sus debilidades:

1. **Páginas en blanco.** La página se pone blanca cada vez que cargas nuevo HTML. ¿Podemos lograr una mejor transición?
2. **Solicitudes redundantes.** Cada paquete tiene un sólo archivo `docs.json`, pero éste tiene que cargar cada vez que visitas la página de un módulo, como [`String`](https://package.elm-lang.org/packages/elm/core/latest/String) o [`Maybe`](https://package.elm-lang.org/packages/elm/core/latest/Maybe). ¿Podemos compartir datos entre páginas?
3. **Código redundante.** La página principal y la documentación comparten muchas funciones, como `Html.text` y `Html.div`. ¿Podemos hacer que el mismo código sea compartido entre páginas?

Podemos mejorar los tres casos anteriores. La idea es sólo cargar el HTML una vez, y después manejar por nuestra cuenta los cambios de URL.

## Página única

En vez de crear nuestro programa usando `Browser.element` o `Browser.document`, podemos crear una aplicación con [`Browser.application`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#application) para evitar cargar más HTML cuando cambia la URL.

```elm
application :
    { init : flags -> Url -> Key -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    , onUrlRequest : UrlRequest -> msg
    , onUrlChange : Url -> msg
    }
    -> Program flags model msg
```

Extiende la funcionalidad de `Browser.document` en tres situaciones importantes.

**Cuando la aplicación inicia**, la función `init` recibe la [`Url`][u] actual de la barra de navegación. Esto te permite mostrar distintas cosas dependiendo de la `Url`.

**Cuando alguien apreta un link**, como `<a href="/home">Inicio</a>`, es interceptado por [`UrlRequest`][ur]. Entonces en vez de cargar nuevo HTML y todo lo que eso conlleva, `onUrlRequest` crea un mensaje para tu función `update` donde puedes decidir qué quieres hacer. Puedes guardar la posición de desplazamiento en la página, persistir datos, cambiar la URL manualmente, etc.

**Cuando la URL cambia**, la nueva `Url` es enviada a `onUrlChange`. El mensaje resultante llegará a `update`, donde puedes decidir cómo mostrar la nueva página.

En vez de cargar nuevo HTML, estas tres adiciones te dan control completo de los cambios de URL. Veámoslo en acción

[u]: https://package.elm-lang.org/packages/elm/url/latest/Url#Url
[ur]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#UrlRequest
[bn]: https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation
[bnp]: https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#pushUrl
[bnl]: https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#load

## Ejemplo

Partamos con el más básico programa que usa `Browser.application`. Sólo guarda la URL actual en el modelo. Revisa el código y observa que lo nuevo e interesante ocurre casi todo dentro de la función `update`. Nos adentraremos en esos detalles más abajo.

```elm
import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ text "The current URL is: "
        , b [] [ text (Url.toString model.url) ]
        , ul []
            [ viewLink "/home"
            , viewLink "/profile"
            , viewLink "/reviews/the-century-of-the-self"
            , viewLink "/reviews/public-opinion"
            , viewLink "/reviews/shah-of-shahs"
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
```

La función `update` puede manejar mensajes `LinkClicked` y `UrlChanged`. Hay harto nuevo en la rama que corresponde a `LinkClicked`, así que revisemos eso primero.

## `UrlRequest`

Cuando alguien hace clic en un link como `<a href="/home">/home</a>`, esto produce un valor `UrlRequest`:

```elm
type UrlRequest
    = Internal Url.Url
    | External String
```

La variante `Internal` es para un link que tiene el mismo dominio actual. O sea que si estás dentro de `https://example.com`, todos estos son links `Internal`: `settings#privacy`, `/home`, `https://example.com/home`, `//example.com/home`.

La variante `External` es para links que apuntan a un dominio distinto. Links como `https://elm-lang.org/examples`, `https://static.example.com`, y `http://example.com/home` todos apuntan a dominios distintos. Nótese que al cambiar el protocolo de `https` a `http`, ya se considera un dominio diferente.

Cualquiera sea el link que se aprete, nuestro programa generará un mensaje `LinkClicked` y lo enviará a la función `update`. Y es ahí donde veremos el código más interesante para esta ocasión.

### `LinkClicked`

La mayor parte de la lógica en `update` es decidir qué hacer con estos valores `UrlRequest`:

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )
```

Las funciones más interesantes son `Nav.load` y `Nav.pushUrl`. Ambas provienen del módulo [`Browser.Navigation`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation), que nos ayuda a cambiar la URL en diversas maneras. Estamos usando las dos funciones más comunes del módulo:

- [`load`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#load) carga un nuevo HTML. Es equivalente a escribir la URL en la barra de dirección y apretar enter. Sin importar lo que que tenga el modelo, éste se descartará y una nueva página será cargada desde cero.
- [`pushUrl`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#pushUrl) cambia la URL, pero no carga nuevo HTML. En vez, se gatilla un mensaje `UrlChanged` que podemos manejar manualmente. También añade una entrada en la historia de navegación para permitir que los botones “atrás” y “adelante” del navegador funcionen normalmente.

Si examinamos la función `update` nuevamente, ya podremos entender un poco mejor cómo funciona todo en conjunto. Cuando el usuario apreta un link `https://elm-lang.org`, recibimos un mensaje `External` y usamos `load` para cargar nuevo HTML desde esos servidores. Pero cuando el usuario apreta un link `/home`, recibimos un mensaje `Internal` y usamos `pushUrl` para cambiar la URL _sin_ cargar nuevo HTML.

> **Nota 1:** Tanto los links `Internal` como `External` producen comandos inmediatamente en este ejemplo, pero eso no es necesario. Si alguien apreta un link `External`, tal vez quieres primero guardar contenido ingresado en un campo de texto, o tal vez quieres usar [`getViewport`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#getViewport) para guardar la posición de desplazamiento vertical, en caso de que el usuario navegue de vuelta usando el botón “atrás”. Todo esto es posible ya que no es más que la misma función `update` que conocemos, y puedes retrasar la navegación efectivamente todo lo que quieras.
>
> **Nota 2:** Si quieres restaurar “lo que se ve” al momento de navegar una vez que el usuario aprete el botón “atrás”, la posición de desplazamiento no es información perfecta. Si el usuario ajusta el tamaño de la ventana, o gira su dispositivo y lo pone apaisado, puede que la posición sea bastante incorrecta. Por eso, es mejor guardar justamente “lo que se ve”. Tal vez eso signifique usar [`getViewportOf`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#getViewportOf) para determinar exactamente qué hay en pantalla en ese momento. Los detalles dependen de cómo funciona tu aplicación, así que no puedo darte consejos más específicos.

## `UrlChanged`

Hay más de una manera de que se generen mensajes `UrlChanged`. Acabamos de ver que `pushUrl` los produce, pero apretar los botones “atrás” y “adelante” es otra manera. Y como mencioné en las notas más arriba, cuando obtienes un mensaje `LinkClicked` no hace falta emitir el comando `pushUrl` inmediatamente.

Lo bueno de tener un mensaje `UrlChanged` específico es que no importa cómo ni cuándo cambió la URL. Todo lo que necesitas saber es que cambió.

En nuestro ejemplo solamente estamos guardando la URL, pero en una aplicación web real necesitarías analizar la URL para determinar el contenido a mostrar. En la próxima página vamos a hablar de esto.

> **Nota:** No expliqué nada sobre [`Nav.Key`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#Key), para enfocarme en los conceptos más importantes. Pero para los interesados, aquí está la explicación.
>
> Un valor `Key` es una “llave de navegación”; es necesaria para crear comandos que cambian la URL, como `pushUrl`. Sólo tienes acceso a un valor `Key` cuando creas un programa usando `Browser.application`, garantizando que tu programa tiene lo necesario para detectar estos cambios de URL. Si los valores `Key` estuvieran disponibles para otros tipos de programa, un programador despistado podría toparse con [molestos bugs][bugs] y aprender ciertas técnicas a tropezones.
>
> Por eso es que tenemos una línea en nuestro `Modelo` dedicada a almacenar la `Key`. Es un bajo precio a pagar para que todos eviten una muy sutil categoría de problemas.

[bugs]: https://github.com/elm/browser/blob/1.0.0/notes/navigation-in-elements.md

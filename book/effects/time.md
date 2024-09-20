# Tiempo

Ahora vamos a crear un reloj digital. (La versión análoga viene como un ejercicio al final).

Hasta ahora nos hemos enfocado en los comandos. Con los ejemplos de HTTP y aleatoriedad, comandamos a Elm que haga cierto trabajo inmediatamente, pero eso no tiene sentido para un reloj. _Siempre_ queremos saber cuál es el tiempo actual. Y para eso sirven las **suscripciones**.

Empieza apretando el botón azul “Editar” y revisa el código en el editor online.

<div class="edit-link"><a href="https://elm-lang.org/examples/time">Editar</a></div>

```elm
import Browser
import Html exposing (..)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
```

Todo lo nuevo aquí proviene del paquete [`elm/time`][time]. Vamos parte por parte.

[time]: https://package.elm-lang.org/packages/elm/time/latest/

## `Time.Posix` y `Time.Zone`

Para trabajar correctamente con el tiempo al programar, necesitamos tres conceptos distintos:

- **Tiempo humano** — Esto es lo que ves en los relojes (8 am) o en los calendarios (3 de mayo). Bien, pero, si tengo una llamada a las 8 am en Boston, ¿a qué hora sería para mi amigo en Vancouver? Si es a las 8 am en Tokio, ¿sería siquiera el mismo día en Nueva York? (¡No!). Ya que las [zonas horarias][tz] están basadas en fronteras políticas en flujo constante, y dado el uso inconsistente del [horario de verano][dst], básicamente nunca debiera almacenarse en tu `Model` o en tu base de datos. Es sólo para ser mostrado.

- **Tiempo POSIX** — Con el tiempo POSIX, no importa dónde vivas o qué fecha en el año sea. Es simplemente el número de segundos transcurridos desde un punto arbitrario en el tiempo (en 1970). Vayas donde vayas en la Tierra, el tiempo POSIX es siempre el mismo.

- **Zonas horarias** — Una “zona horaria” es un montón de datos que te permiten convertir el tiempo POSIX en tiempo humano. Esto _no_ es sólo `UTC-7` o `UTC+3`. Las zonas horarias son mucho más complicadas que sólo un ajuste numérico. Cada vez que [Florida cambia permanentemente a tiempo DST][florida] o que [Samoa cambia de UTC-11 a UTC+13][samoa], un pobre individuo hace una anotación en la [base de datos de zonas horarias de IANA][iana]. Esa base de datos es cargada en cada computador, y combinando el tiempo POSIX y todos los casos borde incluídos en la base de datos, podemos calcular el tiempo humano.

Para mostrarle a una persona el tiempo, siempre necesitamos tener un `Time.Posix` y un `Time.Zone`. Eso es todo. Recuerda que todo eso del “tiempo humano” es algo de lo que la función `view` se debe preocupar, y nunca el modelo. De hecho, puedes observarlo en nuestra vista:

```elm
view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
```

La función [`Time.toHour`][toHour] recibe un `Time.Zone` y un `Time.Posix`, y nos devuelve un `Int` entre `0` y `23` indicando qué hora es en _tu_ zona horaria.

Hay mucha más información relacionada con el manejo del tiempo en el README de [`elm/time`][time]. Dale una leída antes de hacer otras cosas que usen tiempo, especialmente si necesitas trabajar con planificación de horarios, calendarios, etc.

[tz]: https://es.wikipedia.org/wiki/Huso_horario
[dst]: https://es.wikipedia.org/wiki/Horario_de_verano
[iana]: https://es.wikipedia.org/wiki/TZ_Database
[samoa]: https://en.wikipedia.org/wiki/Time_in_Samoa
[florida]: https://www.npr.org/sections/thetwo-way/2018/03/08/591925587/
[toHour]: https://package.elm-lang.org/packages/elm/time/latest/Time#toHour

## `subscriptions`

Bueno, pero ¿cómo obtenemos un valor `Time.Posix`? La respuesta es, con una **suscripción**.

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick
```

Usamos la función [`Time.every`][every]:

[every]: https://package.elm-lang.org/packages/elm/time/latest/Time#every

```elm
every : Float -> (Time.Posix -> msg) -> Sub msg
```

Ésta recibe dos argumentos:

1. Un intervalo de tiempo en milisegundos. Pusimos `1000`, lo que significa una vez por segundo. Pero también podríamos decir `60 * 1000` para una vez por minuto, o `5 * 60 * 1000` para cada cinco minutos.
2. Una función que convierte el tiempo actual en un `Msg`. Es decir que cada segundo, el tiempo actual se convertirá en un mensaje `Tick <time>` que recibirá la función `update`.

Ese es el patrón básico de cualquier suscripción. Le pasas un poco de configuración, y luego describes cómo producir un valor `Msg`. No es tan difícil, ¿o sí?

## `Task.perform`

Obtener `Time.Zone` es un poco más complicado. Nuestro programa crea un **comando** con:

```elm
Task.perform AdjustTimeZone Time.here
```

Leer la documentación de [`Task`][task] es la mejor manera de entender esa línea de código. La documentación está escrita (lamentablemente en inglés) para explicar los conceptos nuevos, y creo que sería desviarse demasiado de lo importante si repitiéramos todo eso aquí. El punto es que comandamos al sistema de ejcución que nos entregue un `Time.Zone` que corresponde al lugar en donde se está ejecutando el código.

<!-- TODO: Añadir explicación breve de Task, para no depender de la documentación en inglés. -->

[utc]: https://package.elm-lang.org/packages/elm/time/latest/Time#utc
[task]: https://package.elm-lang.org/packages/elm/core/latest/Task

> **Ejercicios:**
>
> - Agrega un botón que pause el reloj, apagando la suscripción de `Time.every`.
> - Embellece el reloj digital. Le podrías añadir atributos [`style`][style].
> - Usa [`elm/svg`][svg] para crear un reloj análogo con una manecilla roja para los segundos.

[style]: https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#style
[svg]: https://package.elm-lang.org/packages/elm/svg/latest/

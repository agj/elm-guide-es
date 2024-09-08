# Maybe

A medida que uses Elm te toparás con el tipo [`Maybe`][Maybe] muy frecuentemente. Está definido así:

```elm
type Maybe a
    = Just a
    | Nothing



-- Just 3.14 : Maybe Float
-- Just "hi" : Maybe String
-- Just True : Maybe Bool
-- Nothing   : Maybe a
```

Es un tipo con dos variantes. O bien tienes nada (`Nothing`), o tienes un valor (`Just`). La variable de tipo te permite tener `Maybe Float` o tal vez `Maybe String`, dependiendo del valor específico.

Este tipo es útil en dos situaciones principalmente: funciones parciales y campos opcionales.

[Maybe]: https://package.elm-lang.org/packages/elm-lang/core/latest/Maybe#Maybe

## Funciones parciales

A veces necesitamos una función que da una respuesta a ciertos argumentos, pero no a otros. Muchos se encuentran con este tipo usando [`String.toFloat`][toFloat], al tratar de convertir texto introducido por el usuario a un número. Veamos cómo se usa:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
  {
    "input": "String.toFloat",
    "value": "\u001b[36m<function>\u001b[0m",
    "type_": "String -> Maybe Float"
  },
  {
    "input": "String.toFloat \"3.1415\"",
    "value": "\u001b[96mJust\u001b[0m \u001b[95m3.1415\u001b[0m",
    "type_": "Maybe Float"
  },
  {
    "input": "String.toFloat \"abc\"",
    "value": "\u001b[96mNothing\u001b[0m",
    "type_": "Maybe Float"
  }
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Prueba llamar `String.toFloat` con un otros textos y observa lo que te devuelve ⬆️

No cualquier texto tiene sentido como un número, por lo que esta función modela esa situación en forma explícita. ¿Puede un `String` ser convertido a un `Float`? ¡Tal vez (“maybe”)! Así podemos después usar búsqueda de patrones sobre el valor resultante y continuar según sea apropiado.

> **Ejercicio:** Escribí un pequeño programa que convierte grados Celcius a Fahrenheit, [aquí](https://ellie-app.com/bJSMQz9tydqa1). Intenta refactorizar el código `view` de distintas maneras. ¿Le puedes poner un borde rojo al campo de texto cuando el valor es inválido? ¿Puedes añadir más conversiones, como Fahrenheit a Celcius, o pulgadas a metros?

[toFloat]: https://package.elm-lang.org/packages/elm-lang/core/latest/String#toFloat

## Campos opcionales

Otro lugar donde aparecen valores `Maybe` es en registros con campos opcionales.

Por ejemplo, digamos que administramos una red social. O sea, conectar gente, amistades, etc. Nuestro objetivo lo puso mejor el noticiero-parodia The Onion en 2011: [“recolecta toda la información posible para la CIA”](https://youtu.be/juQcZO_WnsI). Y si queremos _toda_ la información de los usuarios, tenemos que persuadirlos de a poquito. Hay que poner funcionalidades que los impulse a ir compartiendo más y más información mientras más usan nuestra red.

Empecemos con un modelo simple del usuario. Deben tener un nombre, pero vamos a dejar la edad como opcional.

```elm
type alias User =
    { name : String
    , age : Maybe Int
    }
```

Ahora imaginemos que Sue creó una cuenta, pero decide no compartir su fecha de nacimiento.

```elm
sue : User
sue =
    { name = "Sue", age = Nothing }
```

Los amigos de Sue no le pueden desear un feliz cumpleaños. ¿Que acaso son amigos realmente? Tom, después, crea una cuenta y _sí_ comparte su edad:

```elm
tom : User
tom =
    { name = "Tom", age = Just 24 }
```

Genial, seguro que para su cumpleaños va a recibir muchas felicidades. Pero más importantemente, Tom es parte de un valioso grupo etario. Los anunciantes van a estar contentos.

Muy bien, ya tenemos algunos usuarios, pero ¿cómo les vendemos alcohol sin romper la ley? Seguro se enojan con nosotros si les tratamos de vender a jóvenes menores de 21, así que hagamos el chequeo:

```elm
canBuyAlcohol : User -> Bool
canBuyAlcohol user =
    case user.age of
        Nothing ->
            False

        Just age ->
            age >= 21
```

Fíjate en que el tipo `Maybe` nos obliga a hacer búsqueda de patrones sobre la edad del usuario. Es, en realidad, imposible escribir código donde nos olvidemos de que un usuario podría no tener una edad. Elm se cerciora de esto. Ahora podemos venderle alcohol a nuestros usuarios sabiendo que no estamos haciéndolo a menores de edad sin querer, sino sólo a los mayores. Éxito.

## Evitando el sobreuso

Este tipo `Maybe` es muy útil, pero hay límites. Los principiantes tienen una particular tendencia a entusiasmarse con `Maybe` y ponerse a usarlo en todas partes, incluso cuando un tipo personalizado sería más apropiado.

Por ejemplo, imaginemos que tenemos una aplicación de ejercicio donde competimos con nuestros amigos. Partimos con una lista con sólo los nombres de nuestros amigos, pero podemos cargar más información sobre ellos después. Podría tentarte modelarlo de esta manera:

```elm
type alias Friend =
    { name : String
    , age : Maybe Int
    , height : Maybe Float
    , weight : Maybe Float
    }
```

Toda la información está ahí, pero no estás realmente modelando la forma en que funciona esta aplicación. Sería mucho más preciso modelarlo así:

```elm
type Friend
    = Less String
    | More String Info


type alias Info =
    { age : Int
    , height : Float
    , weight : Float
    }
```

Este nuevo modelo captura mucho mejor la realidad de la aplicación. Sólo tenemos dos posibles situaciones: O sólo tienes el nombre, o tienes el nombre y un montón de información extra. En el código de nuestra vista sólo necesitamos pensar en si acaso vamos a mostrar una vista `Less` o `More` del amigo. No hace falta responder preguntas como “¿Qué pasa si tengo `age` pero no tengo `weight`?”. Simplemente no es algo posible con nuestro tipo más preciso.

El punto es que si te hallas usando `Maybe` en todas partes, vale la pena revisar tus definiciones `type` y `type alias` y preguntarte si puedes acaso usar una representación más exacta. Esto comunmente conllevará refactorizaciones que simplifican tu código de actualización y de vista.

> ## Paréntesis: Relación a referencias nulas (`null`)
>
> El inventor de las referencias `null`, Tony Hoare, dijo lo siguiente:
>
> > Lo llamo mi “error de los mil millones”. Hablo de la invención de la referencia nula en 1965. En ese entonces estaba diseñando el primer sistema exhaustivo de tipos para referencias en un lenguaje orientado a objetos (ALGOL W). Mi objetivo era asegurarme de que el uso de cualquier referencia sea absolutamente seguro, con chequeos realizados en forma automática por el compilador. Pero no pude resistir la tentación de añadir referencias nulas, sólo porque eran tan fáciles de implementar. Esto conllevó a un sinfín de errores, vulnerabilidades y caídas de sistema, los que probablemente han causado miles de millones de dólares en sufrimiento y daños durante estos cuarenta años.
>
> Es un diseño que hace que un error sea **implícito**. En cualquier momento que creas que tienes un `String`, podrías en realidad tener `null`. ¿Tenemos que revisarlo? ¿El código que te pasó el valor hizo el chequeo? Tal vez no haya problema; tal vez haga que se caiga tu servidor. Supongo que nos enteraremos después.
>
> Elm evita estos problemas al simplemente no tener referencias `null`. En cambio, tenemos tipos personalizados como `Maybe` para que los errores sean **explícitos**. Así no nos topamos con sorpresas. Un `String` siempre será un `String`, y cuando veas `Maybe String`, el compilador te asegura que ambas variantes están siendo consideradas en el código. Así obtenemos la misma flexibilidad, pero ninguno de los bugs.

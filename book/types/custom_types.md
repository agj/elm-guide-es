> **Nota:** Los tipos personalizados solían llamarse “tipos de unión” en Elm. En otras partes puede que los hayas oído llamar como [“tipos de datos algebraicos”](https://es.wikipedia.org/wiki/Tipo_de_dato_algebraico), también.

# Tipos personalizados

Hasta ahora hemos visto muchos tipos, como `Bool`, `Int` y `String`. Pero ¿cómo definimos nuestro propio tipo?

Imaginemos que queremos crear un chat. Cada usuario necesita un nombre, pero tal vez algunos usuarios no tienen cuenta permanente, solamente escriben un nombre cada vez que entran.

Podemos describir esta situación definiendo un tipo `UserStatus` que lista todas las posibles variaciones:

```elm
type UserStatus
    = Regular
    | Visitor
```

El tipo `UserStatus` tiene dos **variantes**. Una persona puede ser `Regular` o `Visitor`. Así que representamos un usuario usando un registro así:

```elm
type UserStatus
    = Regular
    | Visitor


type alias User =
    { status : UserStatus
    , name : String
    }


thomas =
    { status = Regular, name = "Thomas" }


kate95 =
    { status = Visitor, name = "kate95" }
```

Ahora podemos llevar cuenta de si un usuario es `Regular`, o sea que tiene cuenta, o es `Visitor`, es decir visitante temporal. No está tan mal, pero podemos simplificarlo aún más.

En vez de crear un tipo personalizado y un alias de tipo, podemos representar todo esto con un sólo tipo personalizado. Las variantes `Regular` y `Visitor` pueden llevar información asociada. En nuestro caso, la información es un valor `String`:

```elm
type User
    = Regular String
    | Visitor String


thomas =
    Regular "Thomas"


kate95 =
    Visitor "kate95"
```

La información se asocia directamente a la variante, y ya no hay necesidad de definir un registro.

Otro beneficio de esta manera de hacerlo es que cada variante puede tener distinta información asociada. Por ejemplo, los usuarios `Regular` podrían informar su edad al registrarse. No hay una buena manera de capturar eso con registros, pero cuando defines tu propio tipo personalizado, ya no es problema. Añadamos un poco de información a la variante `Regular` en un ejemplo interactivo:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
  {
    "add-type": "User",
    "input": "type User\n  = Regular String Int\n  | Visitor String\n"
  },
  {
    "input": "Regular",
    "value": "\u001b[36m<function>\u001b[0m",
    "type_": "String -> Int -> User"
  },
  {
    "input": "Visitor",
    "value": "\u001b[36m<function>\u001b[0m",
    "type_": "String -> User"
  },
  {
    "input": "Regular \"Thomas\" 44",
    "value": "\u001b[96mRegular\u001b[0m \u001b[93m\"Thomas\"\u001b[0m \u001b[95m44\u001b[0m",
    "type_": "User"
  },
  {
    "input": "Visitor \"kate95\"",
    "value": "\u001b[96mVisitor\u001b[0m \u001b[93m\"kate95\"\u001b[0m",
    "type_": "User"
  }
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Define un usuario `Regular` con nombre y edad ⬆️

Sólo añadimos una edad, pero cada variante en un tipo puede diverger mucho más. Por ejemplo, podríamos querer añadir información de ubicación a los usuarios `Regular`, para ofrecer chats regionales; basta con agregar esa información a su variante. O tal vez queremos tener usuarios anónimos también, y para eso podemos añadir una variante `Anonymous`.

```elm
type User
    = Regular String Int Location
    | Visitor String
    | Anonymous
```

¡Así de fácil! Veamos más ejemplos.

## Mensajes

En la sección de arquitectura, vimos algunos ejemplos de definir un tipo `Msg`. Esta clase de tipo es extremadamente común en Elm. En nuestro chat, tal vez necesitemos un tipo `Msg` como este:

```elm
type Msg
    = PressedEnter
    | ChangedDraft String
    | ReceivedMessage { user : User, message : String }
    | ClickedExit
```

Tenemos cuatro variantes. Algunas variantes no llevan información asociada, otras llevan bastante. Fíjate en que `ReceivedMessage` lleva un registro asociado. Es totalmente normal. Cualquier tipo puede ser parte de esa información asociada. Esto te permite describir interacciones en tu aplicación en forma muy precisa.

## Modelado

Los tipos personalizados se vuelven muy poderosos cuando empiezas a modelar situaciones en forma precisa. Por ejemplo, si estás esperando que se carguen ciertos datos, puedes querer un modelo con un tipo personalizado así:

```elm
type Profile
    = Failure
    | Loading
    | Success { name : String, description : String }
```

Empiezas en el estado `Loading`, y luego haces la transición a `Failure` o `Success` según lo que ocurra. Esto permite que sea muy fácil escribir una función `view` que siempre muestre algo sensato mientras se cargan los datos.

¡Ya aprendimos a crear tipos personalizados! En la próxima sección vamos a ver cómo usarlos.

> **Nota:** **Los tipos personalizados son la funcionalidad más importante de Elm.** Tienen muchísima profundidad, especialmente cuando entres en el hábito de modelar situaciones en forma bien precisa. Traté de comunicar esta profundidad en los apéndices [“Tipos como conjuntos”](/appendix/types_as_sets.html) y [“Tipos como bits”](/appendix/types_as_bits.html). Ojalá los encuentres útiles.

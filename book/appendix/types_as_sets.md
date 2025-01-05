# Tipos como conjuntos

Hemos visto tipos primitivos como `Bool` y `String`. Hemos creado nuestros propios tipos personalizados así:

```elm
type Color
    = Red
    | Yellow
    | Green
```

Una de las técnicas más importantes programando Elm is hacer que **los valores posibles en el código** calcen exactamente con **los valores válidos en la realidad**. Así no hay posibilidad de tener datos inválidos, y es la razón por la que siempre incentivo a centrarse en tipos personalizados y estructuras de datos.

En búsqueda de este objetivo, he encontrado útil comprender la relación entre tipos y conjuntos. Puede parecer rebuscado, pero es algo que realmente ayuda a desarrollar una intuición.

## Conjuntos

Podemos pensar en los tipos como un conjunto de valores.

- `Bool` es el conjunto `{ True, False }`
- `Color` es el conjunto `{ Red, Yellow, Green }`
- `Int` es el conjunto `{ ... -2, -1, 0, 1, 2 ... }`
- `Float` es el conjunto `{ ... 0.9, 0.99, 0.999 ... 1.0 ... }`
- `String` es el conjunto `{ "", "a", "aa", "aaa" ... "hello" ... }`

Es decir que cuando decimos `x : Bool`, es como decir que `x` está en el conjunto `{ True, False }`.

## Cardinalidad

Cosas interesantes ocurren cuando empezamos a considerar cuántos valores existen en estos conjuntos. Por ejemplo, el conjunto `Bool`, correspondiente a `{ True, False }`, contiene dos valores. Los matemáticos dirían que `Bool` tiene una [cardinalidad](https://es.wikipedia.org/wiki/Cardinalidad) de 2. Es decir que conceptualmente:

- cardinalidad(`Bool`) = 2
- cardinalidad(`Color`) = 3
- cardinalidad(`Int`) = ∞
- cardinalidad(`Float`) = ∞
- cardinalidad(`String`) = ∞

Se pone más interesante cuando empezamos a pensar en tipos como `( Bool, Bool )`, que combinan distintos conjuntos.

> **Nota:** La cardinalidad de `Int` y `Float` es en realidad menos que infinita. Los computadores necesitan almacenar los números en un número fijo de bits (como se describe [aquí](/appendix/types_as_bits.html)), así que en realidad es más cercano a ser cardinalidad(`Int32`) = 2^32 y cardinalidad(`Float32`) = 2^32. El punto es simplemente que es un número grandísimo.

## Multiplicación (tuplas y registros)

Cuando combinamos tipos usando tuplas, las cardinalidades se multiplican:

- cardinalidad(`( Bool, Bool )`) = cardinalidad(`Bool`) × cardinalidad(`Bool`) = 2 × 2 = 4
- cardinalidad(`( Bool, Color )`) = cardinalidad(`Bool`) × cardinalidad(`Color`) = 2 × 3 = 6

Si quieres confirmar esto, prueba hacer una lista de todos los posibles valores que tendrían `( Bool, Bool )` y `( Bool, Color )`. ¿Calzan los números con los que predijimos? ¿Qué tal el caso `( Color, Color )`?

Pero, ¿qué pasa cuando usamos conjuntos infinitos, como `Int` y `String`?

- cardinalidad(`( Bool, String )`) = 2 × ∞
- cardinalidad(`( Int, Int )`) = ∞ × ∞

A mí personalmente me gusta mucho la idea de que tenemos dos infinidades. ¿No bastaba con una? Y después, infinitas infinidades. ¿No se nos van a acabar en algún punto?

> **Nota:** Hasta ahora hemos usado tuplas, pero los registros funcionan de la misma exacta manera:
>
> - cardinalidad(`( Bool, Bool )`) = cardinalidad(`{ x : Bool, y : Bool }`)
> - cardinalidad(`( Bool, Color )`) = cardinalidad(`{ active : Bool, color : Color }`)
>
> Y si definimos `type Point = Point Float Float`, entonces cardinalidad(`Point`) es equivalente a cardinalidad(`( Float, Float )`). ¡Todo es multiplicación!

## Adición (tipos personalizados)

Al calcular la cardinalidad de un tipo personalizado, sumamos la cardinalidad de cada una de sus variantes. Empecemos viendo unos tipos `Maybe` y `Result`.

- cardinalidad(`Result Bool Color`) = cardinalidad(`Bool`) + cardinalidad(`Color`) = 2 + 3 = 5
- cardinalidad(`Maybe Bool`) = 1 + cardinalidad(`Bool`) = 1 + 2 = 3
- cardinalidad(`Maybe Int`) = 1 + cardinalidad(`Int`) = 1 + ∞

Para persuadirnos de que esto es así, prueba listar todos los posibles valores que existen en los conjuntos `Maybe Bool` y `Result Bool Color`. ¿Coincide con los números que obtuvimos?

Aquí tienes otros ejemplos:

```elm
type Height
    = Inches Int
    | Meters Float



-- cardinalidad(Height)
-- = cardinalidad(Int) + cardinalidad(Float)
-- = ∞ + ∞


type Location
    = Nowhere
    | Somewhere Float Float



-- cardinalidad(Location)
-- = 1 + cardinalidad(( Float, Float ))
-- idad + cardinalidad(Float) × cardinalidad(Float)
-- = 1 + ∞ × ∞
```

Si vemos los tipos personalizados de esta forma, podemos saber cuándo dos tipos son equivalentes. Por ejemplo, `Location` es equivalente a `Maybe ( Float, Float )`. Una vez que nos damos cuenta de esto, ¿cuál es mejor usar? Prefiero usar `Location` por dos razones:

1. El código se autodocumenta mejor. No hace falta pensar si `Just ( 1.6, 1.8 )` es una ubicación o un par de altitudes.
2. El módulo `Maybe` puede exponer funciones que no hacen sentido para nuestros datos particulares. Por ejemplo, combinar dos `Location` probablemente no funciona de la misma manera que `Maybe.map2`. ¿La existencia de un `Nowhere` implica que todo es `Nowhere`? Suena extraño.

En otras palabras, escribimos unas cuantas líneas que son _similares_ a otro código preexistente, pero la distinción nos da un nivel de claridad y control que es extremadamente valioso para equipos y bases de código grandes.

## ¿De qué me sirve esto?

Pensar en “tipos como conjuntos” nos ayuda a explicar una clase importante de bugs: **datos inválidos**. Por ejemplo, si queremos representar el color de un semáforo, los valores válidos son { rojo, amarillo, verde }; pero ¿cómo lo representamos en código? Estas son tres maneras:

- `type alias Color = String` — Podemos decidir que `"red"`, `"yellow"` y `"green"` son los tres strings que usaremos, y que todos los demás son _datos inválidos_. Pero ¿qué pasa cuando aparecen datos inválidos? Tal vez alguien escribe mal y pone `"rad"`, o alguien decide escribirlo como `"RED"`. ¿Tendrían todas las funciones que revisar que estos argumentos estén bien? ¿Tendríamos que tener tests para asegurar que los resultados de este tipo son válidos? El problema fundamental es que cardinalidad(`Color`) = ∞, es decir que hay (∞ - 3) valores inválidos. Necesitamos hacer un montón de chequeos para asegurarnos de que nunca aparezcan.

- `type alias Color = { red : Bool, yellow : Bool, green : Bool }` — La idea aquí es que “rojo” se representaría como `Color True False False`. Pero ¿qué pasa con `Color True True True`? ¿Qué significa que sean todos los colores a la vez? Esto es un _dato inválido_. Tal como en el caso de `String`, terminamos necesitando añadir chequeos y tests en nuestro código para asegurar que no tenemos errores. En este caso, cardinalidad(`Color`) = 2 × 2 × 2 = 8, así que sólo hay 5 valores inválidos. Definitivamente hay menos formas de equivocarse, pero aún necesitamos algunos chequeos y tests.

- `type Color = Red | Yellow | Green` — En este caso, los datos inválidos son imposibles. cardinalidad(`Color`) = 1 + 1 + 1 = 3, que corresponde exactamente al conjunto de tres valores de la vida real. No hay necesidad de revisar datos inválidos de color en nuestro código, o escribir tests. Simplemente no existen.

El punto es que **descartar la posibilidad de tener datos inválidos hace que tu código sea más corto, más simple y más confiable.** Asegurándonos de que el conjunto de valores _posibles_ en el código coincida precisamente con el conjunto de valores _válidos_ en la realidad, muchos problemas desaparecen. Es una herramienta que corta muy preciso.

A medida que cambia nuestro programa, el conjunto de valores posibles en el código puede diverger del conjunto de valores válidos en la realidad. **Recomiendo revisar periódicamente los tipos para volver a hacer que coincidan.** Es como notar que el cuchillo está desafilado, y pasarlo por el afilador. Es un tipo de mantenimiento elemental al programar Elm.

**Cuando empezamos a pensar de esta manera, terminamos necesitando menos tests, y aún así teniendo código más confiable.** Usamos menos dependencias, pero terminamos las tareas más rápido. Es parecido al hecho de que alguien muy hábil con el cuchillo no compraría un [aparato “pica-fácil”](https://duckduckgo.com/?q=slapchop&iax=images&ia=images). Siempre existen casos de uso para licuadoras y tal, pero seguramente son muchos menos de lo que piensas. Nadie hace publicidades sobre cómo ser autónomos e independiente sin sufrir grandes inconvenientes. No hay mercado para eso.

> ## Paréntesis sobre el diseño de lenguajes
>
> Pensar en tipos como conjuntos también ayuda a explicar por qué un lenguaje se siente “fácil” o “restrictivo” o “propenso a errores” para cierta gente. Por ejemplo:
>
> - **Java** — Existen valores primitivos como `Bool` y `String`. A partir de éstos podemos crear clases con un grupo definido de campos de distintos tipos. Se parece a los registros de Elm, permitiendo multiplicar cardinalidades. Pero es muy difícil lograr la adición. Se puede lograr usando subtipado, pero es un proceso bastante elaborado. Entonces, mientras `Result Bool Color` es algo fácilmente lograble en Elm, es bastante complicado en Java. Yo creo que la gente que opina que Java es “restrictivo” es porque diseñar un tipo con cardinalidad 5 es bastante difícil, al punto de que puede no valer la pena.
> - **JavaScript** — También tiene valores primitivos como `Bool` y `String`. A partir de éstos podemos crear objetos con un grupo dinámico de campos, permitiéndonos multiplicar cardinalidades. Es mucho más simple y liviano que crear clases. Pero igual que en el caso de Java, la adición no es muy fácil. Por ejemplo, puedes simular un `Maybe Int` con objetos como `{ tag: "just", value: 42 }` y `{ tag: "nothing" }`, pero esto sigue siendo multiplicación de cardinalidades. Se hace difícil obtener el conjunto exacto de valores válidos en la realidad. Por eso creo que hay gente que cree que JavaScript es “fácil”, porque diseñar un tipo con cardinalidad (∞ × ∞ × ∞) es extremadamente fácil, y puede cubrir casi cualquier caso de uso, pero otra gente lo encuentra “propenso a errores” porque diseñar un tipo con cardinalidad 5 no es verdaderamente posible, dejando mucho espacio para datos inválidos.
>
> Curiosamente, algunos lenguajes imperativos tienen tipos personalizados. Rust es un gran ejemplo. Los llaman [“enums”](https://book.rustlang-es.org/ch06-01-defining-an-enum), colgándose de la intuición que tienen muchos programadores que han usado C o Java. En Rust, la adición de cardinalidades es igual de fácil que en Elm, y trae los mismos beneficios.
>
> Creo que el punto aquí es que la “adición” de tipos está extraordinariamente subvalorada en general, y que pensar en “tipos como conjuntos” ayuda a clarificar por qué ciertos diseños de lenguaje producen ciertas frustraciones.

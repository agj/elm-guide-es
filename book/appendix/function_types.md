# Tipos de función

Leyendo la documentación de paquetes como [`elm/core`][core] y [`elm/html`][html] te habrás fijado en que aparecen funciones con muchas flechas. Por ejemplo:

```elm
String.repeat : Int -> String -> String
String.join : String -> List String -> String
```

¿Por qué las flechas? ¿Cuál es la idea?

[core]: https://package.elm-lang.org/packages/elm/core/latest/
[html]: https://package.elm-lang.org/packages/elm/html/latest/

## Paréntesis escondidos

Se vuelve más claro si visualizamos los paréntesis. Por ejemplo, también es válido escribir el tipo de `String.repeat` así:

```elm
String.repeat : Int -> (String -> String)
```

Es una función que recibe un valor `Int` y produce _otra_ función. Veámoslo en la práctica:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "String.repeat",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "Int -> String -> String"
	},
	{
		"input": "String.repeat 4",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String"
	},
	{
		"input": "String.repeat 4 \"ha\"",
		"value": "\u001b[93m\"hahahaha\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "String.join",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> List String -> String"
	},
	{
		"input": "String.join \"|\"",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "List String -> String"
	},
	{
		"input": "String.join \"|\" [ \"red\", \"yellow\", \"green\" ]",
		"value": "\u001b[93m\"red|yellow|green\"\u001b[0m",
		"type_": "String"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Es decir que, conceptualmente, **todas las funciones aceptan un sólo argumento.** Pueden retornar otra función que acepta otro argumento, y así sucesivamente. Eventualmente dejará de retornar funciones.

_Podríamos_ siempre escribir los paréntesis para indicar que es esto lo que ocurre, pero empieza a volverse bastante redundante si tenemos muchos argumentos. Es la misma lógica que cuando escribimos `4 * 2 + 5 * 3` en vez de `(4 * 2) + (5 * 3)`. Esto implica que hay una regla más que aprender de antemano, pero es algo tan común que vale la pena.

Bien hasta aquí, pero ¿y esta funcionalidad de qué nos sirve? ¿Por qué no hacer que sea `(Int, String) -> String`, y pasar todos los argumentos simultáneamente?

## Aplicación parcial

`List.map` es una función de uso muy frecuentemente en programas Elm:

```elm
List.map : (a -> b) -> List a -> List b
```

Recibe dos argumentos: una función y una lista. La función suplida es usada para transformar todos los ítems en la lista. Unos ejemplos:

- `List.map String.reverse [ "part", "are" ] == [ "trap", "era" ]`
- `List.map String.length [ "part", "are" ] == [ 4, 3 ]`

¿Recuerdas que la expresión `String.repeat 4` resulta en el tipo `String -> String` al ejecutarse por sí sola? Bueno, eso significa que podemos hacer esto:

- `List.map (String.repeat 2) [ "ha", "choo" ] == [ "haha", "choochoo" ]`

La expresión `(String.repeat 2)` es una función `String -> String`, o sea que podemos usarla directamente. Ni siquiera necesitamos escribir `(\str -> String.repeat 2 str)`.

Elm también usa la convención de que **los datos siempre vienen al final** a través de todo su ecosistema. Esto significa que las funciones están diseñadas para hacer que esta técnica sea posible, y efectivamente es una manera muy común de escribir código Elm.

Es importante recordar que **es fácil caer en su sobreutilización.** La aplicación parcial es a menudo conveniente y muy legible, pero yo encuentro que es mejor usarla en moderación. Por eso, recomiendo separar el código en funciones auxiliares apenas se pongan _un poquito_ complicadas las cosas. Así, le podemos poner un nombre explicativo a la función, los argumentos también llevan nombre, y además queda fácil de testear. En nuestro ejemplo, significaría crear esto:

```elm
-- List.map reduplicate [ "ha", "choo" ]


reduplicate : String -> String
reduplicate string =
    String.repeat 2 string
```

Este es un caso muy simple, pero (1) queda más claro que el foco es el fenómeno lingüístico de la [reduplicación](https://es.wikipedia.org/wiki/Reduplicaci%C3%B3n_%28ling%C3%BC%C3%ADstica%29), y (2) sería bastante fácil añadir nueva lógica a `reduplicate` a medida que evolucione nuestro programa. Tal vez querramos llegar a soportar la llamada [reduplicación “shm”](https://academia-lab.com/enciclopedia/reduplicacion-shm/) también, por decir algo.

En otras palabras, **si nuestro uso de aplicación parcial se hace muy largo, creemos una función auxiliar.** Y si ocupa múltiples líneas, _definitivamente_ debiera ser convertida en una función auxiliar. Mi consejo aplica (ejem) para las funciones anónimas también.

> **Nota:** Si terminamos creando “demasiadas” funciones después de seguir este consejo, recomiendo la antigua técnica de usar comentarios del tipo `-- REDUPLICACIÓN` justo delante de las cinco o diez funciones que corresponden a este grupo. Ya lo he demostrado con mis comentarios `-- UPDATE` y `-- VIEW` en ejemplos anteriores, pero es una técnica general que uso a través de todo mi código. Y si te preocupa que tus archivos se vuelvan muy largos, te recomiendo ver mi charla [“The life of a file”](https://youtu.be/XpDsk374LDE) (en inglés).

## Tuberías

Elm también tiene un [operador “tubo” `|>`][pipe] (“pipe”, también coloquialmente llamado “pizza”) cuyo funcionamiento requiere el uso de aplicación parcial. Por ejemplo, si tenemos una función `sanitize` que convierte un texto ingresado por el usuario en un número entero:

```elm
-- ANTES


sanitize : String -> Maybe Int
sanitize input =
    String.toInt (String.trim input)
```

Podemos reescribirla para que quede así:

```elm
-- DESPUÉS


sanitize : String -> Maybe Int
sanitize input =
    input
        |> String.trim
        |> String.toInt
```

Esta es una “tubería” (¿pizzería?) por la que pasamos un argumento `input`, que primero pasa por `String.trim`, y cuya salida se convierte en el argumento suplido a `String.toInt`.

Esto es interesante porque nos permite hacer que el código se lea de izquierda a derecha, lo que mucha gente encuentra cómodo, pero **las tuberías pueden ser sobreutilizadas.** Si llegamos a tener tres o cuatro pasos, el código puede quedar más claro si lo separamos en una función auxiliar, ya que la transformación adquiere un nombre, los argumentos también, y además le podemos escribir su tipo. La función quedaría autodocumentada, por lo que tanto nuestros colegas como nosotros mismos en el futuro podremos apreciar la claridad que aporta. Testear esta lógica también se hace más fácil.

> **Nota:** Yo, personalmente, prefiero cómo queda en el “antes” del ejemplo, pero tal vez es porque aprendí programación funcional en lenguajes que no permiten tuberías.

[pipe]: https://package.elm-lang.org/packages/elm/core/latest/Basics#|>

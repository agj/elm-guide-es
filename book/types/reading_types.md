# Leyendo tipos

En la sección [_Fundamentos del lenguaje_](/core_language.html) revisamos varios ejemplos interactivos para desarrollar una intuición general del lenguaje. Ahora vamos a volver a hacer lo mismo, pero con una nueva pregunta en mente: ¿Qué **tipo** de valor es este?

## Valores primitivos y listas

Ingresemos algunas expresiones simples y veamos qué pasa:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "\"hello\"",
		"value": "\u001b[93m\"hello\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "not True",
		"value": "\u001b[96mFalse\u001b[0m",
		"type_": "Bool"
	},
	{
		"input": "round 3.1415",
		"value": "\u001b[95m3\u001b[0m",
		"type_": "Int"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Haz clic sobre esta caja negra ⬆️ y verás un cursor parpadeando. Escribe `3.1415` y apreta “enter”. Debería aparecer `3.1415` seguido del tipo `Float`.

Okay, pero ¿qué es esto, exactamente? Cada fila muestra un valor junto con el **tipo** que le corresponde al valor. Puedes leer estos ejemplos de esta forma:

- El valor `"hello"` es un `String`.
- El valor `False` es un `Bool`.
- El valor `3` es un `Int`.
- El valor `3.1415` es un `Float`.

Elm reconoce el tipo de cualquier valor que ingresemos. Veamos qué pasa con listas:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "[ \"Alice\", \"Bob\" ]",
		"value": "[\u001b[93m\"Alice\"\u001b[0m,\u001b[93m\"Bob\"\u001b[0m]",
		"type_": "List String"
	},
	{
		"input": "[ 1.0, 8.6, 42.1 ]",
		"value": "[\u001b[95m1.0\u001b[0m,\u001b[95m8.6\u001b[0m,\u001b[95m42.1\u001b[0m]",
		"type_": "List Float"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Puedes leer estos tipos de esta forma:

1. Tenemos una `List` rellena con valores `String`.
2. Tenemos una `List` rellena con valores `Float`.

El **tipo** es una descripción general del valor particular que estamos viendo.

## Funciones

Veamos el tipo de algunas funciones:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "String.length",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> Int"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Ingresa `round` o `sqrt` para ver otros tipos de funciones ⬆️

La función `String.length` tiene el tipo `String -> Int`. Esto significa que _tiene que_ recibir un argumento `String`, y que definitivamente retornará un valor `Int`. Probemos pasarle un argumento:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "String.length \"Supercalifragilisticexpialidocious\"",
		"value": "\u001b[95m34\u001b[0m",
		"type_": "Int"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Le pasamos un argumento `String` a una función `String -> Int`. Esto resulta en un `Int`.

¿Y qué ocurre si le pasamos algo que no es `String`? Prueba escribir `String.length [1, 2, 3]` o `String.length True` y ve lo que ocurre ⬆️

Vas a darte cuenta de que una función `String -> Int` _debe sí o sí_ recibir un argumento `String`.

<!-- prettier-ignore-start -->
> **Nota:** Las funciones que reciben múltiples argumentos se escriben con varias flechas. Por ejemplo, esta es una función que recibe dos argumentos:
>
> {% replWithTypes %}
[
	{
		"input": "String.repeat",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "Int -> String -> String"
	}
]
{% endreplWithTypes %}
>
> Si le pasas dos argumentos, así: `String.repeat 3 "ha"`, el resultado será `"hahaha"`. Puedes considerar `->` como una forma rara de separar los argumentos, pero [la razón de por qué se escribe así la explico aquí](/appendix/function_types.md). ¡Es bastante interesante!
<!-- prettier-ignore-end -->

## Anotaciones de tipo

Hasta ahora hemos permitido que Elm infiera el tipado, pero también podemos **anotar tipos** en la línea justo arriba de una definición. Es decir, podemos escribir algo así:

<!-- prettier-ignore-start -->
```elm
half : Float -> Float
half n =
    n / 2

-- half 256 == 128
-- half "3" -- error!


hypotenuse : Float -> Float -> Float
hypotenuse a b =
    sqrt (a ^ 2 + b ^ 2)

-- hypotenuse 3 4  == 5
-- hypotenuse 5 12 == 13


checkPower : Int -> String
checkPower powerLevel =
    if powerLevel > 9000 then
        "It's over 9000!!!"

    else
        "Meh"

-- checkPower 9001 == "It's over 9000!!!"
-- checkPower True -- error!
```
<!-- prettier-ignore-end -->

No es necesario anotar tipos, pero definitivamente lo recomiendo. Estos son algunos beneficios:

1. **Calidad de los mensajes de error** — Cuando anotamos un tipo, le estamos diciendo al compilador nuestra _intención_. La implementación puede que tenga errores, y después de comparar el código con nuestra anotación, el compilador nos dará un mensaje del tipo: “Dijiste que el argumento `powerLevel` era `Int`, pero está siendo usado como `String`”.
2. **Documentación** — Cuando pase un tiempo sin que trabajemos sobre el mismo código, o cuando un colega lo haga por primera vez, va a ser muy útil ver exactamente lo que recibe y devuelve una función sin tener que leer la implementación en detalle.

Pero la gente igual puede cometer errores al anotar tipos, así que ¿qué pasa si la anotación no coincide con la implementación? Pues, el compilador determina todos los tipos por su cuenta y confirma que tu anotación coincide con la respuesta real. En otras palabras, el compilador siempre verificará que todas las anotaciones que escribas estén correctas. Así tendrás mejores mensajes de error _y además_ tu documentación se mantendrá siempre al día.

## Variables de tipo

A medida que revises más código Elm, te irás dando cuenta de que existen anotaciones de tipo con letras en minúscula. Un ejemplo común es el de la función `List.length`:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "List.length",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "List a -> Int"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Fíjate en esa `a` minúscula en el tipo. Esto se llama una **variable de tipo**. Su significado puede cambiar según cómo se use [`List.length`][length]:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "List.length [1,1,2,3,5,8]",
		"value": "\u001b[95m6\u001b[0m",
		"type_": "Int"
	},
	{
		"input": "List.length [ \"a\", \"b\", \"c\" ]",
		"value": "\u001b[95m3\u001b[0m",
		"type_": "Int"
	},
	{
		"input": "List.length [ True, False ]",
		"value": "\u001b[95m2\u001b[0m",
		"type_": "Int"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Como sólo queremos el largo de la lista, no nos importa qué lleva dentro. La variable de tipo `a` significa que ahí puede ir cualquier tipo. Veamos otro ejemplo común:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "List.reverse",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "List a -> List a"
	},
	{
		"input": "List.reverse [ \"a\", \"b\", \"c\" ]",
		"value": "[\u001b[93m\"c\"\u001b[0m,\u001b[93m\"b\"\u001b[0m,\u001b[93m\"a\"\u001b[0m]",
		"type_": "List String"
	},
	{
		"input": "List.reverse [ True, False ]",
		"value": "[\u001b[96mFalse\u001b[0m,\u001b[96mTrue\u001b[0m]",
		"type_": "List Bool"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Otra vez, la variable de tipo `a` puede cambiar según cómo usemos [`List.reverse`][reverse]. Pero en este caso, tenemos una `a` tanto en el argumento como en el tipo de retorno. Esto significa que si le pasas una `List Int`, deberás recibir una `List Int` también. Una vez que se decide lo que es esa `a`, seguirá siendo lo mismo después.

> **Nota:** Las variables de tipo deben empezar con una letra minúscula, pero pueden ser palabras completas. Podemos escribir el tipo de `List.length` como `List value -> Int` y podríamos escribir el tipo de `List.reverse` como `List element -> List element`. Funciona siempre y cuando comiencen con una letra minúscula. Las variables de tipo `a` y `b` son usadas por convención en muchos lugares, pero algunas anotaciones quedan mejor con nombres más específicos.

[length]: https://package.elm-lang.org/packages/elm/core/latest/List#length
[reverse]: https://package.elm-lang.org/packages/elm/core/latest/List#reverse

## Variables limitadas de tipo

Hay una variedad especial de variable de tipo en Elm que llamamos variables **limitadas** de tipo. El ejemplo más común es el tipo `number`. La función [`negate`](https://package.elm-lang.org/packages/elm/core/latest/Basics#negate) la usa:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"input": "negate",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "number -> number"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Prueba escribir expresiones como `negate 3.1415` o `negate (round 3.1415)` o `negate "hi"` ⬆️

Normalmente, las variables de tipo pueden rellenarse con cualquier cosa, pero `number` sólo puede rellenarse con valores `Int` y `Float`. O sea, _limita_ las posibilidades.

Esta es la lista completa de variables limitadas de tipo:

- `number` permite `Int` y `Float`
- `appendable` permite `String` y `List a`
- `comparable` permite `Int`, `Float`, `Char`, `String` y listas o tuplas de valores `comparable`
- `compappend` permite `String` y `List comparable`

Estas variables limitadas de tipo existen para que ciertos operadores como `(+)` y `(<)` puedan ser un poco más flexibles.

Ya cubrimos bastante bien los tipos de valores y funciones, pero ¿cómo se ve esto cuando empezamos a necesitar estructuras más complejas de datos?

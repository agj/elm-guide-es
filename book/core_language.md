
# Lo esencial del lenguaje

Intentemos primero construir una intuición sobre cómo funciona Elm.

El objetivo es familiarizarnos con **valores** y **funciones**, y tomar confianza para cuando nos enfrentemos a ejemplos más largos de código.


## Valores

La unidad más básica en Elm se llama un **valor**. Todos estos son valores: `42`, `True`, `"¡Hola!"`.

Veamos primero los números.

{% repl %}
[
	{
		"input": "1 + 1",
		"value": "\u001b[95m2\u001b[0m",
		"type_": "number"
	}
]
{% endrepl %}

Todos los ejemplos en esta página son interactivos. Si apretas sobre esta caja negra ⬆️ vas a ver que el cursor de texto va a empezar a pestañear. Escribe `2 + 2` y apreta ENTER. Deberías ver que aparece `4` como resultado. Recuerda que puedes interactuar de la misma forma con todos los demás ejemplos en este documento.

Prueba escribir algo como `30 * 60 * 1000` o `2 ^ 4`. Verás que funciona igual que una calculadora.

Está bien hacer aritmética, pero es algo sorprendentemente poco común en la mayoría de programas que uno escribe. Es mucho más frecuente manipular textos, lo que en informática se llama técnicamente **string**. Algo así:

{% repl %}
[
	{
		"input": "\"hello\"",
		"value": "\u001b[93m\"hello\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "\"butter\" ++ \"fly\"",
		"value": "\u001b[93m\"butterfly\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Prueba unir varios strings con el operador `(++)` ⬆️

Estos valores primitivos se vuelven más interesantes a medida que escribamos funciones para transformarlos.

> **Nota:** Puedes leer más sobre distintos operadores, como [`(+)`](op-plus), [`(/)`](op-div) y [`(++)`](op-concat) en la documentación del módulo [`Basics`](core-basics). Lamentablemente, esta documentación está en inglés, pero está escrita en un lenguaje muy poco técnico, y aunque sea con traducción automática, creo que vale la pena darle una leída una vez que te parezca apropiado.

[op-plus]: https://package.elm-lang.org/packages/elm/core/latest/Basics#+
[op-div]: https://package.elm-lang.org/packages/elm/core/latest/Basics#/
[op-concat]: https://package.elm-lang.org/packages/elm/core/latest/Basics#++
[core-basics]: https://package.elm-lang.org/packages/elm/core/latest/Basics

## Funciones

Una **función** es una forma de transformar valores. Éstas toman algunos valores, y producen un nuevo valor.

Por ejemplo, esta es una función `greet` que recibe un nombre y dice “hola”:

{% repl %}
[
	{
		"add-decl": "greet",
		"input": "greet name =\n  \"Hello \" ++ name ++ \"!\"\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String"
	},
	{
		"input": "greet \"Alice\"",
		"value": "\u001b[93m\"Hello Alice!\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "greet \"Bob\"",
		"value": "\u001b[93m\"Hello Bob!\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Trata saludar a alguna otra persona, como a `"Stokely"` o a `"Kwame"` ⬆️

Los valores que le pasas a la función se suelen llamar **argumentos**, así que podríamos decir que `greet` es una función que recibe un argumento.

Bien, ahora que terminamos las formalidades, ¿qué te parece si probamos una función `madlib` que recibe _dos_ argumentos?

{% repl %}
[
	{
		"add-decl": "madlib",
		"input": "madlib animal adjective =\n  \"The ostentatious \" ++ animal ++ \" wears \" ++ adjective ++ \" shorts.\"\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String -> String"
	},
	{
		"input": "madlib \"cat\" \"ergonomic\"",
		"value": "\u001b[93m\"The ostentatious cat wears ergonomic shorts.\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "madlib (\"butter\" ++ \"fly\") \"metallic\"",
		"value": "\u001b[93m\"The ostentatious butterfly wears metallic shorts.\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Intenta darle dos argumentos a la función `madlib` ⬆️

Observa que usamos paréntesis para agrupar `"butter" ++ "fly"` en el segundo ejemplo. Cada argumento necesita ser un valor primitivo, como `"gato"`, y si no, necesitas usar paréntesis.

> **Nota:** Si estás habituado a lenguajes como JavaScript, te puede sorprender que las funciones se ven distintas:
>
>     madlib "cat" "ergonomic"                  -- Elm
>     madlib("cat", "ergonomic")                // JavaScript
>
>     madlib ("butter" ++ "fly") "metallic"      -- Elm
>     madlib("butter" + "fly", "metallic")       // JavaScript
>
> Te puede parecer raro al principio, pero para este estilo necesitamos usar menos paréntesis y comas. Cuando te acostumbres vas a ver que el lenguaje se siente más simple y limpio.


## Expresiones `if`

Cuando necesitas comportamiento condicional en Elm, puedes usar una expresión `if`.

Creemos una nueva función `greet` que es adecuadamente respetuosa con el expresidente Abraham Lincoln.

{% repl %}
[
	{
		"add-decl": "greet",
		"input": "greet name =\n  if name == \"Abraham Lincoln\" then\n    \"Greetings Mr. President!\"\n  else\n    \"Hey!\"\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String"
	},
	{
		"input": "greet \"Tom\"",
		"value": "\u001b[93m\"Hey!\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "greet \"Abraham Lincoln\"",
		"value": "\u001b[93m\"Greetings Mr. President!\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Probablemente hay más casos que podríamos cubrir, pero por ahora, con esto basta.


## Listas

Las listas son unas de las estructuras de datos más comunes en Elm. Sirven para albergar una secuencia de cosas relacionadas, similar a los “arrays” en JavaScript.

Una lista puede contener muchos valores. Dichos valores deben tener todos el mismo tipo. Aquí tienes algunos ejemplos que usan funciones del módulo [`List`][list]:

[list]: https://package.elm-lang.org/packages/elm/core/latest/List

{% repl %}
[
	{
		"add-decl": "names",
		"input": "names =\n  [ \"Alice\", \"Bob\", \"Chuck\" ]\n",
		"value": "[\u001b[93m\"Alice\"\u001b[0m,\u001b[93m\"Bob\"\u001b[0m,\u001b[93m\"Chuck\"\u001b[0m]",
		"type_": "List String"
	},
	{
		"input": "List.isEmpty names",
		"value": "\u001b[96mFalse\u001b[0m",
		"type_": "Bool"
	},
	{
		"input": "List.length names",
		"value": "\u001b[95m3\u001b[0m",
		"type_": "String"
	},
	{
		"input": "List.reverse names",
		"value": "[\u001b[93m\"Chuck\"\u001b[0m,\u001b[93m\"Bob\"\u001b[0m,\u001b[93m\"Alice\"\u001b[0m]",
		"type_": "List String"
	},
	{
		"add-decl": "numbers",
		"input": "numbers =\n  [4,3,2,1]\n",
		"value": "[\u001b[95m4\u001b[0m,\u001b[95m3\u001b[0m,\u001b[95m2\u001b[0m,\u001b[95m1\u001b[0m]",
		"type_": "List number"
	},
	{
		"input": "List.sort numbers",
		"value": "[\u001b[95m1\u001b[0m,\u001b[95m2\u001b[0m,\u001b[95m3\u001b[0m,\u001b[95m4\u001b[0m]",
		"type_": "List number"
	},
	{
		"add-decl": "increment",
		"input": "increment n =\n  n + 1\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "number -> number"
	},
	{
		"input": "List.map increment numbers",
		"value": "[\u001b[95m5\u001b[0m,\u001b[95m4\u001b[0m,\u001b[95m3\u001b[0m,\u001b[95m2\u001b[0m]",
		"type_": "List number"
	}
]
{% endrepl %}

Prueba construir tu propia lista, y usa funciones como `List.length` ⬆️

¡Recuerda que todos los elementos de la lista deben siempre tener el mismo tipo!


## Tuplas

Las tuplas son otra estructura de datos muy útil. Una tupla puede contener dos o tres valores, y cada valor puede tener cualquier tipo. Un uso común es para devolver más de un valor desde una función. La siguiente función recibe un nombre y devuelve un mensaje al usuario:

{% repl %}
[
	{
		"add-decl": "isGoodName",
		"input": "isGoodName name =\n  if String.length name <= 20 then\n    (True, \"name accepted!\")\n  else\n    (False, \"name was too long; please limit it to 20 characters\")\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> ( Bool, String )"
	},
	{
		"input": "isGoodName \"Tom\"",
		"value": "(\u001b[96mTrue\u001b[0m, \u001b[93m\"name accepted!\"\u001b[0m)",
		"type_": "( Bool, String )"
	}
]
{% endrepl %}

Es una estructura muy útil, pero cuando las cosas se ponen más complicadas, es mejor usar registros en vez de tuplas.


## Registros

Un **registro** puede contener muchos valores, y cada valor lleva un nombre asociado.

Este es un registro que representa al economista inglés John A. Hobson:

{% repl %}
[
	{
		"add-decl": "john",
		"input": "john =\n  { first = \"John\"\n  , last = \"Hobson\"\n  , age = 81\n  }\n",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "john.last",
		"value": "\u001b[93m\"Hobson\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Definimos un registro con tres **campos** que contienen información sobre John, específicamente su nombre y edad.

Prueba recuperar otros campos del registro, como `john.age` ⬆️

También puedes recuperar campos de un registro usando funciones de acceso:

{% repl %}
[
	{
		"add-decl": "john",
		"input": "john = { first = \"John\", last = \"Hobson\", age = 81 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": ".last john",
		"value": "\u001b[93m\"Hobson\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "List.map .last [john,john,john]",
		"value": "[\u001b[93m\"Hobson\"\u001b[0m,\u001b[93m\"Hobson\"\u001b[0m,\u001b[93m\"Hobson\"\u001b[0m]",
		"type_": "List String"
	}
]
{% endrepl %}

También es útil **actualizar** valores en un registro:

{% repl %}
[
	{
		"add-decl": "john",
		"input": "john = { first = \"John\", last = \"Hobson\", age = 81 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "{ john | last = \"Adams\" }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Adams\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "{ john | age = 22 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m22\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	}
]
{% endrepl %}

Si intentamos leer en voz alta las expresiones de arriba, diríamos algo como “Quiero una versión de John cuyo apellido es Adams”, o “cuya edad es 22”.

Nótese que al actualizar los campos de `john`, estamos creando un registro completamente nuevo. El registro original no ha sido sobreescrito. Elm permite hacer esto en forma eficiente, compartiendo todo lo que pueda entre ambos. Si actualizas uno en diez campos, el nuevo registro va a compartir los otros nueve.

Dicho esto, una función que actualiza la edad quedaría así:

{% repl %}
[
	{
		"add-decl": "celebrateBirthday",
		"input": "celebrateBirthday person =\n  { person | age = person.age + 1 }\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "{ a | age : number } -> { a | age : number }"
	},
	{
		"add-decl": "john",
		"input": "john = { first = \"John\", last = \"Hobson\", age = 81 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "celebrateBirthday john",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m82\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	}
]
{% endrepl %}

Actualizar campos en registros es algo muy común, así que vamos a ver muchos más ejemplos en la próxima sección.

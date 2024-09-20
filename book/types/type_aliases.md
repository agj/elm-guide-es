# Alias de tipo

Las anotaciones de tipo pueden quedar un poco extensas. Esto se vuelve particularmente problemático si tienes registros con muchos campos. Esa es la razón por la que existen los alias de tipo. Un **alias de tipo** es un nombre corto para un tipo. Por ejemplo, puedes creas un alias `User` de esta forma:

```elm
type alias User =
    { name : String
    , age : Int
    }
```

En vez de escribir el registro entero cada vez, puedes simplemente poner `User`. Esto nos permite escribir anotaciones de tipo mucho más fáciles de leer:

```elm
-- WITH ALIAS


isOldEnoughToVote : User -> Bool
isOldEnoughToVote user =
    user.age >= 18



-- WITHOUT ALIAS


isOldEnoughToVote : { name : String, age : Int } -> Bool
isOldEnoughToVote user =
    user.age >= 18
```

Estas dos definiciones son equivalentes, pero la que lleva el alias de tipo es más corta y fácil de leer. Todo lo que hicimos fue crear un **alias** para un tipo más grande.

## Modelos

Es súper común usar alias de tipo al diseñar el modelo. Cuando aprendimos sobre la Arquitectura Elm, usamos este modelo:

```
type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }
```

El principal beneficio de usar un alias de tipo es para cuando escribamos las anotaciones para las funciones `update` y `view`. Es mucho más sensato escribir `Msg -> Model -> Model` que la versión larga. Además tiene el beneficio de que podemos añadir campos a nuestro modelo sin necesitar cambiar anotaciones de tipo.

## Constructores de registro

Cuando creas un alias de tipo para un registro específicamente, también se genera un **constructor de registro**. Así que si definimos un alias de tipo `User`, podemos crear registros de esta forma:

<!-- prettier-ignore-start -->
{% replWithTypes %}
[
	{
		"add-type": "User",
		"input": "type alias User = { name : String, age : Int }"
	},
	{
		"input": "User",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> Int -> User"
	},
	{
		"input": "User \"Sue\" 58",
		"value": "{ \u001b[37mname\u001b[0m = \u001b[93m\"Sue\"\u001b[0m, \u001b[37mage\u001b[0m = \u001b[95m58\u001b[0m }",
		"type_": "User"
	},
	{
		"input": "User \"Tom\" 31",
		"value": "{ \u001b[37mname\u001b[0m = \u001b[93m\"Tom\"\u001b[0m, \u001b[37mage\u001b[0m = \u001b[95m31\u001b[0m }",
		"type_": "User"
	}
]
{% endreplWithTypes %}
<!-- prettier-ignore-end -->

Prueba crear un usuario o un alias de tipo nuevo ⬆️

Fíjate en que el orden de los argumentos que recibe el constructor es el mismo que el orden de los campos en el alias de tipo.

Y repito, **esto sólo vale para registros**. Cuando crees alias de tipo para otros tipos no se generará un constructor.

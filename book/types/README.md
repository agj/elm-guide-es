# Tipos

Uno de los más grandes beneficios de usar Elm es que **en la práctica, tus usuarios nunca se toparán con excepciones de ejecución**. Esto ocurre porque el compilador de Elm puede rápidamente analizar el código y entender cómo fluye cada valor a través del programa. Si encuentra usos inválidos de estos valores, el compilador nos avisa con un mensaje de error fácil de entender. Esto se llama _inferencia de tipos_. El compilador resuelve los _tipos_ de los valores que fluyen a través de todas las funciones del programa.

## Un ejemplo de inferencia de tipos

Este código define una función `toFullName` que extrae el nombre completo de una persona como `String`:

```elm
toFullName person =
    person.firstName ++ " " ++ person.lastName


fullName =
    toFullName { fistName = "Hermann", lastName = "Hesse" }
```

Tal como en JavaScript o Python, sólo necesitamos escribir el código, sin anotar tipos. Pero **¿notaste el error?**

Si escribiéramos lo mismo en JavaScript, el resultado sería `"undefined Hesse"`. ¡Ni siquiera sería un error! Con un poco de suerte, uno de tus usuarios te avisaría cuando lo vea durante el uso. Por otro lado, el compilador de Elm revisa tu código y te da esta retroalimentación:

```
-- TYPE MISMATCH ---------------------------------------------------------------

The 1st argument to `toFullName` is not what I expect:

6|       toFullName { fistName = "Hermann", lastName = "Hesse" }
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This argument is a record of type:

    { fistName : String, lastName : String }

But `toFullName` needs the 1st argument to be:

    { a | firstName : String, lastName : String }

Hint: Seems like a record field typo. Maybe firstName should be fistName?

Hint: Can more type annotations be added? Type annotations always help me give
more specific messages, and I think they could help a lot in this case!
```

Traducido, dice: “El primer argumento a `toFullName` no es lo que esperaba: (…) Este argumento es un registro de tipo: (…) Pero `toFullName` necesita que el primer argumento sea: (…)”

Se dio cuenta de que `toFullName` está recibiendo el _tipo_ de argumento incorrecto. Los tips abajo en _Hint_ también muestran que escribiste “fist” en vez de “first”.

Es muy útil tener esta ayuda para identificar errores simples como este, pero es invaluable cuando tienes cientos de archivos de código y varios contribuyentes haciendo cambios. No importa cuán grande y compleja se vuelva la aplicación, el compilador de Elm revisa que _todo_ calce correctamente, sólo en base al análisis de tu código.

Mientras mejor entiendas los tipos, más sentirás que el compilador es como un asistente amigo. Dicho esto, continuemos para aprender más sobre los tipos.

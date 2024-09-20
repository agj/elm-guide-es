# Tipos

Uno de los más grandes beneficios de usar Elm es que **tus usuarios virtualmente no verán errores en tiempo de ejecución**. Esto ocurre porque el compilador de Elm puede analizar tu código muy rápidamente y saber cómo fluyen los valores a través de tu programa. Si existen formas de usar valors de manera inválida, el compilador te avisa con un mensaje de error amistoso. Esto se llama _inferencia de tipos_. El compilador resuelve los _tipos_ de los valores que fluyen a través de todas tus funciones.

## Un ejemplo de inferencia de tipos

Este código define una función `toFullName` que extrae el nombre completo de una persona como `String`:

```elm
toFullName person =
    person.firstName ++ " " ++ person.lastName


fullName =
    toFullName { fistName = "Hermann", lastName = "Hesse" }
```

Tal como en JavaScript o Python, sólo necesitamos escribir el código, sin anotaciones. Pero, ¿notaste el error?

En JavaScript, código equivalente a este respondería con `"undefined Hesse"`. ¡Ni siquiera sería un error! Con un poco de suerte, uno de tus usuarios te avisaría cuando lo vea durante el uso. Por otro lado, el compilador de Elm revisa tu código y te da esta retroalimentación:

```
-- TYPE MISMATCH ---------------------------------------------------------------

The argument to function `toFullName` is causing a mismatch.

6│   toFullName { fistName = "Hermann", lastName = "Hesse" }
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Function `toFullName` is expecting the argument to be:

    { …, firstName : … }

But it is:

    { …, fistName : … }

Hint: I compared the record fields and found some potential typos.

    firstName <-> fistName
```

“El argumento a la función `toFullName` no calza. La función `toFullName` espera que el argumento sea: (…) Pero es: (…)”

Se dio cuenta de que `toFullName` está recibiendo el _tipo_ de argumento incorrecto. La ayuda en _Hint_ también muestra que escribiste “fist” en vez de “first”.

Es muy útil tener esta ayuda para identificar errores simples como este, pero es invaluable cuando tienes cientos de archivos de código y varios contribuyentes haciendo cambios. No importa cuán grande y compleja se vuelva la aplicación, el compilador de Elm revisa que _todo_ calce correctamente sólo en base a tu código.

Mientras mejor entiendas los tipos, más sentirás que el compilador es como un asistente amigo. ¡Aprendamos más, entonces!

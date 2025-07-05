# Result

El tipo `Maybe` puede ayudar con funciones simples que pueden fallar, pero no te dirá _por qué_ falló. Imagina si cada vez que haya algo incorrecto en nuestro código, el compilador sólo nos respondiera: `Nothing`. Buena suerte encontrando la causa del error.

Ese es el caso de uso del tipo [`Result`][Result]. Está definido así:

```elm
type Result error value
    = Ok value
    | Err error
```

El punto de este tipo es dar información adicional cuando algo sale mal. Es muy útil para reportar problemas y recuperarse de errores.

[Result]: https://package.elm-lang.org/packages/elm-lang/core/latest/Result#Result

## Reportando errores

Tal vez tenemos un sitio web donde la gente ingresa su edad. Podríamos confirmar que la edad ingresada es un número sensato con una función como esta:

```elm
isReasonableAge : String -> Result String Int
isReasonableAge input =
    case String.toInt input of
        Nothing ->
            Err "Eso no es un número."

        Just age ->
            if age < 0 then
                Err "Vuelve después de que nazcas."

            else if age > 135 then
                Err "¿Eres una tortuga o algo así?"

            else
                Ok age



-- isReasonableAge "abc" == Err ...
-- isReasonableAge "-13" == Err ...
-- isReasonableAge "24"  == Ok 24
-- isReasonableAge "150" == Err ...
```

No sólo podemos revisar la edad, sino que además podemos mostrar mensajes distintos según detalles de lo que ingresaron. Este tipo de retroalimentación es mucho mejor que responder con `Nothing`.

## Recuperación de errores

El tipo `Result` también te puede ayudar a recuperarte después de un error. Una situación donde encontrarás esto es al hacer solicitudes HTTP. Digamos que queremos mostrar el texto completo de _Anna Karenina_ de León Tolstói. Nuestra solicitud retorna un valor `Result Error String` para capturar el hecho de que la solicitud puede ser exitosa y contener el texto completo, o tal vez falle en una de varias maneras:

```elm
type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int
    | BadBody String



-- Ok "All happy ..." : Result Error String
-- Err Timeout        : Result Error String
-- Err NetworkError   : Result Error String
```

Teniendo esta información podemos mostrar mejores mensajes de error, como lo mencionamos antes, pero además podríamos probar una rutina de recuperación. Si vemos un error `Timeout`, podría servir esperar un poco y reintentar la solicitud. Pero si vemos un valor `BadStatus 404` ya sabemos que no tiene caso reintentar.

El próximo capítulo muestra cómo hacer solicitudes HTTP, así que nos volveremos a encontrar con los tipos `Result` y `Error` muy pronto.

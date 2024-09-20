# Manejo de errores

Una de las garantías que ofrece Elm es que no vas a ver virtualmente ningún error en tiempo de ejecución. Esto en parte es porque **Elm trata los errores como datos**. En vez de caerse, modelamos la posibilidad de un fallo en forma explícita usando tipos personalizados. Por ejemplo, digamos que quieres convertir un texto introducido por el usuario en una edad. Puedes crear un tipo personalizado como este:

```elm
type MaybeAge
  = Age Int
  | InvalidInput

toAge : String -> MaybeAge
toAge userInput =
  ...

-- toAge "24" == Age 24
-- toAge "99" == Age 99
-- toAge "ZZ" == InvalidInput
```

No importa cuál sea el dato de entrada para la función `toAge`, siempre va a producir un valor. Cuando el argumento sea válido, generará valores como `Age 24` o `Age 99`, mientras que un argumento inválido generará un valor `InvalidInput`. Después podemos usar búsqueda de patrones para asegurarnos de que nuestro código tome en cuenta ambas posibilidades. ¡Y el programa no se va a caer!

Este patrón lo vas a ver repetido siempre. Por ejemplo, si quisieras transformar texto ingresado por un usuario en un artículo `Post` a compartir con otros usuarios. Pero, ¿qué pasa si el usuario no ingresó un título? ¿O si el artículo no tiene contenido? Podemos modelar estos problemas en forma explícita:

```elm
type MaybePost
  = Post { title : String, content : String }
  | NoTitle
  | NoContent

toPost : String -> String -> MaybePost
toPost title content =
  ...

-- toPost "hi" "sup?" == Post { title = "hi", content = "sup?" }
-- toPost ""   ""     == NoTitle
-- toPost "hi" ""     == NoContent
```

En vez de sólo decir que los argumentos son inválidos, hemos descrito cada una de las formas en que estos datos podrían causar problemas. Si tuviéramos una función `viewPreview : MaybePost -> Html msg` que nos permite previsualizar articulos válidos, podremos mostrar un mensaje de error específico cuando encontremos algo mal.

Esas situaciones son súper frecuentes. Es muy útil crear un tipo personalizado que se ajuste a tu situación específica, pero en los casos más simples puedes optar por una solución prehecha. Durante el resto de este capítulo vamos a explorar los tipos `Maybe` y `Result`, y veremos cómo nos ayudan a tratar errores como datos.

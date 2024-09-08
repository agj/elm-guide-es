# Búsqueda de patrones

En la página anterior vimos cómo crear [tipos personalizados](/types/custom_types.html) con la palabra clave `type`. Nuestro ejemplo principal era un usuario en un chat:

```elm
type User
    = Regular String Int
    | Visitor String
```

Usuarios `Regular` llevan nombre y edad, mientras que los `Visitor` sólo llevan nombre. Ya tenemos nuestro tipo personalizado, pero ¿cómo se usa?

## `case`

Digamos que queremos una función `toName` que decide qué nombre mostrar para un `User`. Para eso usamos una expresión `case`:

```elm
toName : User -> String
toName user =
    case user of
        Regular name age ->
            name

        Visitor name ->
            name



-- toName (Regular "Thomas" 44) == "Thomas"
-- toName (Visitor "kate95")    == "kate95"
```

La expresión `case` nos permite bifurcar el código en base a la variante que recibamos. Sea “Thomas” o “Kate”, siempre sabremos cómo mostrar su nombre.

Y si intentamos pasarle argumentos inválidos, como `toName (Visitar "kate95")` o `toName Anonymous`, el compilador nos va a avisar inmediatamente. Esto significa que muchos errores simples pueden ser corregidos en segundos, en vez de aparecerle a los usuarios y terminar costando mucho más tiempo al fin y al cabo.

## Comodines

La función `toName` que definimos funciona sin problemas, pero nota que `age` no se usa en esta implementación. Cuando parte de los datos no se usan, es común usar un “comodín” en vez de darle un nombre:

```elm
toName : User -> String
toName user =
    case user of
        Regular name _ ->
            name

        Visitor name ->
            name
```

El uso de `_` indica que sabemos que hay un dato ahí, pero hemos decidido ignorarlo explícitamente.

# `Html.Lazy`

Para mostrar cosas en pantalla usamos el paquete [`elm/html`](https://package.elm-lang.org/packages/elm/html/latest/). Y para entender cómo optimizar su uso, primero tenemos que saber cómo funciona tras bambalinas.

## ¿Qué es el DOM?

Cuando creamos un archivo HTML, escribimos algo como esto:

```html
<div>
  <p>Chair alternatives include:</p>
  <ul>
    <li>seiza</li>
    <li>chabudai</li>
  </ul>
</div>
```

Esto genera una estructura DOM así:

![](diagrams/dom.svg)

Cada caja negra representa un pesado objeto DOM, con cientos de atributos. Y cuando uno de ellos cambia, puede gatillar repintado y reajuste del contenido en la página, y tardar un tiempo considerable.

## ¿Qué es un DOM virtual?

Si estamos creando un archivo Elm, podemos usar `elm/html` para escribir algo así:

```elm
viewChairAlts : List String -> Html msg
viewChairAlts chairAlts =
    div []
        [ p [] [ text "Chair alternatives include:" ]
        , ul [] (List.map viewAlt chairAlts)
        ]


viewAlt : String -> Html msg
viewAlt chairAlt =
    li [] [ text chairAlt ]
```

Lo que `viewChairAlts ["seiza", "chabudai"]` está haciendo es producir una estructura de “DOM virtual” por detrás:

![](diagrams/vdom.svg)

Las cajas blancas representan objetos JavaScript livianos. Sólo contienen los atributos que especificamos. Su creación nunca causa repintado o reajustes en la página. El punto es que, en comparación con nodos del DOM, estos son mucho más livianos de manejar.

## Pintado

Si sólo estamos manipulando nodos virtuales en Elm, ¿cómo se convierte esto al DOM que vemos en pantalla? Al inicializar, los programas Elm hacen esto:

- Llaman a `init` para obtener el valor `Model` inicial.
- Llaman a `view` para obtener los nodos virtuales iniciales.

Teniendo estos nodos virtuales, construímos una réplica exacta en el DOM real:

![](diagrams/render.svg)

Y después ¿qué pasa cuando algo cambia? Reconstruir el DOM completo de cero en cada fotograma no es una opción muy óptima. Entonces, ¿qué hacemos?

## Comparación de cambios

Teniendo ya el DOM inicial, empezamos a trabajar usando nodos virtuales principalmente. Cuando el valor `Model` cambia, volvemos a correr `view`. Después, comparamos los nodos virtuales resultantes para determinar cuáles son los cambios mínimos que es necesario realizar en el DOM real.

Imagina que el `Model` tiene una nueva alternativa de silla, y queremos añadir un nuevo nodo `li` para ésta. Por detrás, Elm compara los nodos virtuales **actuales** contra los **nuevos** para detectar cambios:

![](diagrams/diff.svg)

El algoritmo toma nota de que un tercer nodo `li` fue añadido, el que está marcado en verde. Ahora Elm sabe exactamente cómo modificar el DOM real para hacer que coincidan. Sólo falta agregar el nuevo `li`:

![](diagrams/patch.svg)

Este proceso de comparación hace posible minimizar la manipulación del DOM. Si no hay diferencias, entonces no hace falta tocar el DOM en absoluto. Este proceso minimiza el repintado y reajuste de contenido en página que de otro modo tendría que ocurrir.

Dicho esto, ¿podemos reducir aún más el trabajo necesario?

## Módulo `Html.Lazy`

El módulo [`Html.Lazy`](https://package.elm-lang.org/packages/elm/html/latest/Html-Lazy/) nos permite incluso ahorrarnos la construcción de los nodos virtuales. La pieza central es la función `lazy`:

```elm
lazy : (a -> Html msg) -> a -> Html msg
```

Volviendo al ejemplo de las sillas, hicimos una llamada a `viewChairAlts ["seiza", "chabudai"]`, pero bien podemos hacer algo como `lazy viewChairAlts ["seiza", "chabudai"]`. La versión que usa `lazy` almacena un sólo nodo “perezoso”, así:

![](diagrams/lazy.svg)

Este nodo guarda una referencia a la función y a sus argumentos. Elm podrá generar la estructura completa usando esta información si hace falta, pero el punto es que no siempre hará falta.

Uno de los superpoderes de Elm es la garantía de que _dados los mismos argumentos, el resultado es siempre el mismo._ Tomando esto en cuenta, cuando comparamos dos nodos “perezosos” preguntamos: ¿es la función la misma? ¿Son los argumentos los mismos? Si son todos los mismos, sabemos con seguridad que los nodos virtuales producidos serán también idénticos. **Podemos ahorrarnos el trabajo de volver a generar los nodos virtuales.** De otro modo, si algo en la ecuación cambia, simplemente generamos los nodos y procedemos a hacer la comparación habitual contra el DOM.

> **Nota:** ¿Cuándo son dos valores “lo mismo”? Para optimizar el rendimiento, la implementación compara usando el operador `===` de JavaScript:
>
> - Se comparan por igualdad estructural los valores `Int`, `Float`, `String`, `Char`, y `Bool`.
> - Se comparan por igualdad de referencia los registros, listas, tipos personalizados, diccionarios, etc.
>
> La igualdad estructural significa que `4` es lo mismo que `4` sin importar cómo se produjeron esos valores. La igualdad de referencia significa que el puntero en memoria debe ser el mismo. Usar igualdad de referencia es de complejidad O(1), o sea muy óptimo, aún si la estructura de datos tuviera miles o millones de entradas. Esta decisión fue hecha principalmente para asegurarnos de que usar `lazy` nunca ralentice el código sin querer. Todos los chequeos que se realizan son súper livianos.

## Uso

El lugar ideal para poner nodos `lazy` es cerca de la raíz de tu aplicación. Muchas aplicaciones tienen regiones visuales diferenciadas, como una cabecera, barras laterales, resultados de búsqueda, etc. Y cuando un usuario interactúa con una de éstas, normalmente no influye en las demás. Así se demarcan líneas donde se hace natural usar `lazy`.

Por ejemplo, en [mi implementación de TodoMVC](https://github.com/evancz/elm-todomvc/), `view` se define así:

```elm
view : Model -> Html Msg
view model =
    div
        [ class "todomvc-wrapper"
        , style "visibility" "hidden"
        ]
        [ section
            [ class "todoapp" ]
            [ lazy viewInput model.field
            , lazy2 viewEntries model.visibility model.entries
            , lazy2 viewControls model.visibility model.entries
            ]
        , infoFooter
        ]
```

Fíjate en que el ingreso de texto (`viewInput`), los ítems en la lista (`viewEntries`) y los controles (`viewControls`) todos forman nodos “perezosos” separados. Así podemos tipear en el campo de texto sin tener que generar nodos virtuales para la lista o los controles, porque no tendrán cambios. Por lo tanto, el primer consejo es **trata de usar nodos `lazy` en la raíz de tu aplicación.**

También puede resultar útil usar `lazy` en listas con muchos ítems. El uso de la aplicación TodoMVC implica ir añadiendo ítems a una lista de pendientes. Eventualmente podríamos tener cientos de ítems, pero cada uno cambiará muy infrecuentemente. Los ítems de esta lista son grandes candidatos para hacerlos “perezosos”. Al cambiar `viewEntry entry` a `lazy viewEntry entry` podemos ahorrarnos un montón de infructuoso trajín en memoria. Dicho esto, el segundo consejo es **trata de usar nodos `lazy` en estructuras repetitivas donde cada ítem cambia con poca frecuencia.**

## En resumen

Manipular el DOM es mucho más costoso que cualquier otra operación que pueda ocurrir en una interfaz de usuario normal. Basado en mis comparativas de rendimiento, no importa lo mucho que optimicemos nuestras estructuras de datos, al final lo único que importa es qué tan bien usemos `lazy`.

En la próxima página vamos a aprender una técnica que nos permitirá usar `lazy` aún más.

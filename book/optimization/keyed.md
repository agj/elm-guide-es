# `Html.Keyed`

En la página anterior aprendimos cómo funciona el DOM virtual y cómo podemos usar `Html.Lazy` para evitar computar de más. Ahora vamos a conocer [`Html.Keyed`](https://package.elm-lang.org/packages/elm/html/latest/Html-Keyed/) para ahorrarnos aún más cómputo.

Esta optimización es particularmente útil para interfaces con listas de datos que requieren **añadir**, **quitar** y **reordenar** ítems.

## El problema

Digamos que tenemos una lista de todos los presidentes de los Estados Unidos. Tal vez se pueden ordenar por nombre, [por educación](https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_education), [por patrimonio neto](https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_net_worth) o [por lugar de nacimiento](https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_home_state).

Cuando el algoritmo de comparación de nodos (descrito en la página anterior) se topa con una larga lista de ítems, simplemente la revisa de a pares:

- Compara el actual elemento 1 contra el nuevo elemento 1.
- Compara el actual elemento 2 contra el nuevo elemento 2.
- …

Pero si cambiamos el orden de los ítems, ¡todos van a resultar diferentes! Entonces terminamos causando mucho trabajo en el DOM cuando lo único que hacía falta era intercambiar algunos nodos de lugar.

El problema también ocurre al insertar y quitar ítems. Si quitamos el primero de una lista de cien, todo quedará desplazado por una posición, y por lo tanto se verá distinto para el algoritmo. Terminamos haciendo 99 comparaciones y una eliminación al final. No es muy óptimo.

## La solución

La manera de arreglar este problema es con [`Html.Keyed.node`](https://package.elm-lang.org/packages/elm/html/latest/Html-Keyed#node), que permite asignarle una “llave” a cada ítem para distinguirlo fácilmente de todos los demás.

En nuestro ejemplo de los presidentes, podríamos escribir código así:

```elm
import Html exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)

viewPresidents : List President -> Html msg
viewPresidents presidents =
  Keyed.node "ul" [] (List.map viewKeyedPresident presidents)

viewKeyedPresident : President -> (String, Html msg)
viewKeyedPresident president =
  ( president.name, lazy viewPresident president )

viewPresident : President -> Html msg
viewPresident president =
  li [] [ ... ]
```

Cada nodo hijo tiene una llave asociada (un `String` con el nombre del presidente). En vez de hacer una comparación de a pares, comparamos en base a igualdad de llaves.

Ahora el algoritmo del DOM virtual es capaz de reconocer si una lista fue reordenada. Primero busca cada nodo de presidente por su llave, y compara el actual con el nuevo. Como usamos `lazy` para cada ítem, ni siquiera necesitará generar los nodos virtuales. Después determina cómo reordenar los nodos del DOM para mostrar las cosas en el orden que queremos. En suma, la versión con llaves acaba haciendo mucho menos trabajo.

Este ejemplo de reordenamiento ayuda para entender cómo funciona, pero no es el caso más común que necesita esta optimización. **Los nodos con llave son fundamentalmente necesarios cuando añadimos o quitamos ítems.** Si quitamos el primero de una lista con cien elementos, al usar nodos con llave permitimos que el DOM virtual entienda la situación inmediatamente. Y al final sólo necesitamos hacer una eliminación, y no 99 comparaciones.

## En resumen

Manipular el DOM es extraordinariamente lento en comparación con cualquier otro tipo de cómputo que una aplicación normal típicamente hace. **Cuanto tengas problemas de rendimiento, siempre parte aplicando `Html.Lazy` y `Html.Keyed`.** Recomiendo en lo posible verificar las optimizaciones usando perfilamiento. Las herramientas de desarrollo de algunos navegadores proveen una vista en forma de línea de tiempo de tu programa, [así](https://developer.chrome.com/docs/devtools/performance?hl=es-419). Te da un resumen de cuánto tiempo se gasta en descarga, ejecución de código, pintado, etc. Si observas que sólo el 10% del tiempo se gasta en ejecución de código, podrías hacer que tu código Elm ande el doble de rápido y aún así no notarías la diferencia. Mientras que usar nodos `Lazy` y `Keyed` nos permite darle un gran mordisco a ese otro 90%, al manipular menos el DOM.

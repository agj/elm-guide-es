# Comandos y suscripciones

Hemos visto cómo manejar interacciones de mouse y teclado usando la Arquitectura Elm, pero ¿qué tal si queremos comunicarnos con un servidor? ¿O generar un número al azar?

Para responder estas preguntas, nos va a servir saber más sobre cómo funciona la Arquitectura Elm detrás de bambalinas. Vamos a ver por qué las cosas funcionan un poco diferente en comparación con otros lenguajes como JavaScript, Python, etc.

## `sandbox`

No me he referido directamente al hecho, pero hasta ahora todos nuestros programas han sido creados con [`Browser.sandbox`][sandbox]. Le suplimos un `Model` inicial, y describimos cómo actualizarlo (`update`) y cómo visualizarlo (`view`).

Puedes considerar que lo que `Browser.sandbox` hace es configurar un sistema así:

![](diagrams/sandbox.svg)

Tenemos la ventaja de vivir dentro del mundo de Elm, escribiendo funciones y transformando datos. Éste se vincula con el **sistema de ejecución** de Elm. El sistema de ejecución decide cómo dibujar el `Html` eficientemente. ¿Hubo algún cambio? ¿Cuál es la más mínima modificación que necesitamos hacerle al DOM? También escucha cuando alguien hace clic en un botón o escribe en un campo de texto. Convierte estas acciones en mensajes `Msg`, y los provee a nuestro código Elm.

Al separar limpiamente toda modificación al DOM, se vuelve posible hacer optimizaciones muy contundentes. Es gran parte de por qué Elm es [una de las opciones más rápidas disponibles][benchmark].

[sandbox]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox
[benchmark]: https://elm-lang.org/blog/blazing-fast-html-round-two

## `element`

En los próximos ejemplos vamos a usar [`Browser.element`][element] para crear programas. Éste introduce los conceptos **comando** y **suscripción**, que nos permiten interactuar con el mundo exterior.

Puedes considerar que `Browser.element` configura un sistema así:

![](diagrams/element.svg)

Además de producir valores `Html`, nuestros programas también enviarán valores `Cmd` y `Sub` al sistema de ejecución. En este mundo, nuestros programas pueden dar **comandos** al sistema de ejecución para que realice una solicitud HTTP, o que genere un número al azar. También pueden **suscribirse** al tiempo actual.

Creo que los comandos y las suscripciones hacen más sentido cuando ves ejemplos, así que hagamos justamente eso.

[element]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#element

> **Nota 1:** Algunos lectores podrán preocuparse del tamaño de los archivos producidos. “¿Sistema de ejecución? Suena pesado”. Pero en verdad, ¡no lo es! De hecho, Elm exporta [archivos extremadamente pequeños](https://elm-lang.org/blog/small-assets-without-the-headache) si los comparamos con otras alternativas populares.
>
> **Nota 2:** Vamos a usar paquetes de [`package.elm-lang.org`](https://package.elm-lang.org) en los siguientes ejemplos. Ya hemos usado un par:
>
> - [`elm/core`](https://package.elm-lang.org/packages/elm/core/latest/)
> - [`elm/html`](https://package.elm-lang.org/packages/elm/html/latest/)
>
> Pero ahora vamos a hacer uso de algunos más complejos:
>
> - [`elm/http`](https://package.elm-lang.org/packages/elm/http/latest/)
> - [`elm/json`](https://package.elm-lang.org/packages/elm/json/latest/)
> - [`elm/random`](https://package.elm-lang.org/packages/elm/random/latest/)
> - [`elm/time`](https://package.elm-lang.org/packages/elm/time/latest/)
>
> Hay muchísimos otros paquetes en `package.elm-lang.org`. Cuando empieces a desarrollar tus propios programas en tu entorno local, seguramente vas a ejecutar algunos comandos como estos en tu terminal:
>
> ```bash
> elm init
> elm install elm/http
> elm install elm/random
> ```
>
> Eso configurará un archivo `elm.json` con las dependencias `elm/http` y `elm/random`.
>
> En cada uno de los siguientes ejemplos voy a nombrar los paquetes en uso, así que espero que te aporte un poco de contexto sobre cómo funciona todo esto.

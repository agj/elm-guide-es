# Arquitectura Elm

La Arquitectura Elm es un patrón para arquitecturar programas interactivos, tales como aplicaciones web y videojuegos.

Esta arquitectura parece emerger naturalmente en Elm. Más que ser un invento de alguien en particular, los primeros usuarios de Elm redescubrían constantemente los mismos patrones básicos en su código. Era un poco misterioso ver a tanta gente dar con código bien arquitecturado sin haber planificado con antelación.

La Arquitectura Elm es fácil de usar en Elm, pero es útil en cualquier proyecto de front-end. De hecho, hay proyectos, como Redux, que han sido inspirados por la Arquitectura Elm, así que es posible que ya te hayas topado con derivados de este patrón. El punto es que, aunque en tu trabajo no puedas Elm aún, vas igual a poder sacar provecho de usar Elm e internalizar este patrón.

## El patrón fundamental

Los programas escritos en Elm siempre se ven más o menos así:

![Diagrama de la Arquitectura Elm](buttons.svg)

Un programa en Elm produce HTML para mostrar en pantalla, y el computador envía de vuelta mensajes de cosas que ocurren. “Apretaron un botón”, etc.

¿Y qué ocurre dentro del programa Elm? Se divide en estas tres partes:

- **Modelo** — el estado de tu aplicación.
- **Vista** — una forma de convertir el estado en HTML.
- **Actualización** — una forma de actualizar tu estado basado en mensajes.

Estos tres conceptos son el núcleo de la **Arquitectura Elm**.

Los siguientes ejemplos te demostrarán cómo usar este patrón para interpretar entrada del usuario, como botones y campos de texto. Vamos a hacer concreto todo lo que te acabo de decir.

## Hagámoslo juntos

Todos los ejemplos están disponibles en el editor online:

[![editor online](try.png)](https://elm-lang.org/try)

Este editor muestra tips en la esquina superior izquierda:

<video id="hints-video" width="360" height="180" autoplay loop style="margin: 0.55em 0 1em 2em;" onclick="var v = document.getElementById('hints-video'); v.paused ? (v.play(), v.style.opacity = 1) : (v.pause(), v.style.opacity = 0.5)">
  <source src="hints.mp4" type="video/mp4">
</video>

¡No te olvides de probar los tips si te topas con algo confuso!

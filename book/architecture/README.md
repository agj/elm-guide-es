# Arquitectura Elm

La Arquitectura Elm es un patrón para construir programas interactivos, tales como aplicaciones web y videojuegos.

Esta arquitectura parece emerger naturalmente en Elm. Más que ser un invento de alguien en particular, los primeros usuarios de Elm redescubrían constantemente los mismos patrones básicos en su código. Fue curioso ver a tanta gente dar con este tipo de código bien arquitecturado sin planificación previa.

Elm, por supuesto, hace muy fácil usar la Arquitectura Elm, pero más allá del lenguaje, es una arquitectura que resulta muy ergonómica para cualquier proyecto de front-end. De hecho, hay proyectos, como Redux, que han sido inspirados por esta arquitectura, así que es posible que ya te hayas topado con derivados de este patrón. El punto es que, aún si en tu trabajo no puedes usar Elm aún, igual puedes sacar provecho de usar Elm e internalizar la arquitectura que te voy a presentar.

## El patrón en su esencia

Los programas escritos en Elm siempre se ven más o menos así:

![Diagrama de la Arquitectura Elm](buttons.svg)

Un programa en Elm produce HTML para mostrar en pantalla, y el computador envía de vuelta mensajes (`Msg`) de cosas que ocurren. “Un botón fue apretado”, etc.

¿Y cómo se organiza internamente el programa? Lo dividimos en estas tres partes:

- **Modelo**: El estado de nuestra aplicación.
- **Vista**: Una forma de convertir el modelo en HTML.
- **Actualización**: Cómo se actualiza el modelo en base a mensajes.

Estos tres conceptos son el núcleo de la **Arquitectura Elm**.

Los siguientes ejemplos te demostrarán cómo usar este patrón para interpretar acciones del usuario, como el presionar botones e ingreso en campos de texto. Vamos a hacer concreto todo lo que te acabo de decir.

## Hagámoslo juntos

Todos los ejemplos están disponibles en el editor online:

[![editor online](try.png)](https://elm-lang.org/try)

Este editor muestra tips en la esquina superior izquierda (dice “Hint”):

<video id="hints-video" width="360" height="180" autoplay loop style="margin: 0.55em 0 1em 2em;" onclick="var v = document.getElementById('hints-video'); v.paused ? (v.play(), v.style.opacity = 1) : (v.pause(), v.style.opacity = 0.5)">
  <source src="hints.mp4" type="video/mp4">
</video>

¡No te olvides de probar los tips si te topas con algo confuso!

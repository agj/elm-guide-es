# Interoperabilidad con JavaScript

Hasta este punto hemos visto la **Arquitectura Elm, tipos, comandos, suscripciones,** y hasta instalamos Elm localmente.

Pero ¿y si necesitamos integrar con JavaScript? Tal vez hay alguna API del navegador que aún no tiene su equivalente en código Elm. O tal vez queremos incrustar una pequeña herramienta hecha en Javascript en medio de tu aplicación Elm. Etc. En este capítulo vamos a revisar las tres formas con las que podemos interoperar con JavaScript.

- [Flags](/interop/flags.html)
- [Puertos](/interop/ports.html)
- [Elementos personalizados](/interop/custom_elements.html)

Pero antes de entrar en materia, aprendamos a compilar nuestros programas Elm a JavaScript.

> **Nota:** Si estás evaluando el usar Elm en tu trabajo, te sugiero que te asegures de que estos tres mecanismos sean capaces de cubrir todas tus necesidades. Puedes ver [estos ejemplos](https://github.com/elm-community/js-integration-examples/) como un resumen breve de este capítulo. [Pregunta aquí](https://elm-lang.org/community) si hay algo que te haga dudar, y si decides que aún no es el momento, ojalá vuelvas a darte una vuelta y revisar el estado de Elm más adelante.

<!-- TODO: 👆 Agregar este ejemplo al repositorio y traducirlo. -->

## Compilar a JavaScript

Correr el comando `elm make` genera archivos HTML por defecto. Es decir, algo así:

```bash
elm make src/Main.elm
```

Esto producirá un archivo `index.html` que podemos abrir directamente para interactuar con nuestro programa. Pero si necesitamos interoperabilidad con JavaScript, vamos a necesitar generar un archivo JavaScript, así:

```bash
elm make src/Main.elm --output=main.js
```

Este comando produce un archivo JavaScript que expone una función `Elm.Main.init()`. Teniendo este archivo `main.js` podemos escribir nuestro propio archivo HTML que haga lo que necesitamos.

## Incrustar en HTML

Este es el HTML mínimo necesario para que `main.js` funcione en un navegador:

```html
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <script src="main.js"></script>
  </head>

  <body>
    <div id="mi-app"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById("mi-app"),
      });
    </script>
  </body>
</html>
```

Revisemos las líneas más importantes aquí:

- `<head>` — Tenemos una línea que carga nuestro archivo compilado `main.js`. _Esto es necesario._ Haciendo esto obtendremos una función `Elm.Main.init()` en JavaScript si compilamos un módulo llamado `Main`; o una función `Elm.Home.init()` si nuestro módulo se llama `Home`, etc.

- `<body>` — Hay dos cosas que tenemos que hacer aquí. Primero, creamos un `<div>` del que Elm tomará control. Tal vez es sólo una parte dentro de una aplicación más grande, y no habría problema. Segundo, tenemos un nodo `<script>` para inicializar nuestro programa Elm. Aquí llamamos la función `Elm.Main.init()` para inicializar el programa, pasándole el nodo HTML (`node`) que controlará.

Con esto hemos aprendido a incrustar programas Elm dentro de un documento HTML, así que podemos empezar a explorar las tres opciones de interoperabilidad: flags, puertos, y elementos personalizados.

> **Nota:** Este es un archivo HTML común y corriente, lo que significa que podemos ponerle cualquier cosa que necesitemos. Mucha gente carga más archivos JS y CSS en `<head>`. Eso significa que es válido escribir CSS a mano, o generarlo con alguna herramienta. Podemos añadir algo como `<link rel="stylesheet" href="lo-que-sea.css">` en `<head>`, y ya tendremos sus estilos cargados en la página. También hay buenas opciones para manejar el CSS _dentro_ de Elm, pero ese es un tema para otra ocasión.

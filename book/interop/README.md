# Interoperabilidad con JavaScript

Hasta este punto hemos visto la **Arquitectura Elm**, **tipos**, **comandos**, **suscripciones**, y hasta instalamos Elm localmente.

Pero ¿y si necesitamos integrar con JavaScript? Tal vez hay alguna API del navegador que aún no tiene un equivalente en un paquete de Elm. O tal vez quieres incrustar un _widget_ de Javascript en tu app Elm. Etc. En este capítulo vamos a revisar las tres formas con las que podemos interoperar con JavaScript.

- [Flags](/interop/flags.html)
- [Ports](/interop/ports.html)
- [Custom Elements](/interop/custom_elements.html)

Antes de entrar en materia, aprendamos a compilar nuestros programas Elm a JavaScript.

> **Nota:** Si estás evaluando el usar Elm en tu trabajo, te sugiero que te asegures de que estos tres mecanismos sean capaces de cubrir todas tus necesidades. Puedes ver [estos ejemplos](https://github.com/elm-community/js-integration-examples/) como un resumen breve de este capítulo. [Pregunta aquí](https://elm-lang.org/community) si hay algo que te haga dudar, y si decides que aún no es el momento, ojalá vuelvas a darte una vuelta a revisar Elm en el futuro.

<!-- TODO: 👆 Agregar este ejemplo al repositorio y traducirlo. -->

## Compilar a JavaScript

Si corres `elm make` producirás archivos HTML por defecto. Es decir que si pones:

```bash
elm make src/Main.elm
```

Esto producirá un archivo `index.html` que puedes abrir directamente para interactuar con tu programa. Pero si necesitas interoperabilidad con JavaScript, vas a necesitar producir archivos JavaScript.

```bash
elm make src/Main.elm --output=main.js
```

Este comando produce un archivo JavaScript que expone una función `Elm.Main.init()`. Teniendo este archivo `main.js`, puedes escribir tu propio archivo HTML que haga lo que necesites.

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
    <div id="myapp"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById("myapp"),
      });
    </script>
  </body>
</html>
```

Revisemos las líneas más importantes aquí:

- `<head>` - Tenemos una línea que carga nuestro archivo compilado `main.js`. ¡Esto es necesario! Si compilas un módulo llamado `Main`, vas a obtener una función `Elm.Main.init()` disponible en JavaScript. Si compilas un módulo llamado `Home`, vas a obtener una función `Elm.Home.init()` en JavaScript. Etc.

- `<body>` - Hay dos cosas que tenemos que hacer aquí. Primero, creamos un `<div>` del que Elm tomará cargo. Tal vez es sólo una parte dentro de una aplicación más grande, y no habría problema. Segundo, tenemos un `<script>` para inicializar nuestro programa Elm. Aquí llamamos la función `Elm.Main.init()` para inicializar el programa, pasándole el nodo HTML (`node`) del que se hará cargo.

Ya aprendimos a incrustar programas Elm dentro de un documento HTML, así que podemos empezar a explorar las tres opciones de interoperabilidad: flags, puertos, y elementos personalizados.

> **Nota:** Este es un archivo HTML normal, lo que signiffica que puedes ponerle cualquier cosa que necesites. Mucha gente carga más archivos JS y CSS en `<head>`. Eso significa que es válido escribir tu CSS a mano, o generarlo con alguna herramienta. Puedes añadir algo como `<link rel="stylesheet" href="whatever-you-want.css">` en tu `<head>`, y ya tendrás acceso. También hay buenas opciones para manejar tu CSS _dentro_ de Elm, pero ese es un tema para otra ocasión.

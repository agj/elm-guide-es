# Aplicaciones web

Hasta este punto hemos creado programas Elm con `Browser.element`, que nos permite apoderarnos de un único nodo en una aplicación más grande. Esto funciona bien para introducir Elm en tu trabajo (como explico [aquí](https://elm-lang.org/blog/how-to-use-elm-at-work)), pero ¿qué pasa después de eso? ¿Cómo podemos usar Elm más extensivamente?

En este capítulo aprenderemos a crear una “aplicación web” con varias páginas distintas que funcionan en forma integrada, pero primero partamos controlando una sola página.

## Controla el documento

El primer paso es cambiar a comenzar nuestros programas usando [`Browser.document`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#document):

```elm
document :
    { init : flags -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }
    -> Program flags model msg
```

Los argumentos son casi exáctamente los mismos que `Browser.element`, excepto por la función `view`. En vez de retornar un valor `Html`, retornas un valor [`Document`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#Document) como este:

```elm
type alias Document msg =
    { title : String
    , body : List (Html msg)
    }
```

Esto te da control sobre los elementos `<title>` y `<body>` del documento. Tal vez tu programa descarga datos, y eso te ayuda a determinar un título más específico. Ahora ya tienes la posibilidad de cambiarlo desde tu función `view`.

## Sirve la página

El compilador produce HTML por defecto, así que puedes compilar tu código así:

```bash
elm make src/Main.elm
```

La salida será un archivo `index.html` que puedes servir igual que cualquier otro archivo HTML. Esto funciona, pero ganas más flexibilidad al (1) compilar Elm a JavaScript, y (2) crear tu propio archivo HTML. Para tomar esa ruta, compila de esta forma:

```bash
elm make src/Main.elm --output=main.js
```

Esto producirá un archivo `main.js` que puedes cargar desde tu HTML personalizado así:

```html
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <link rel="stylesheet" href="whatever-you-want.css" />
    <script src="main.js"></script>
  </head>
  <body>
    <script>
      var app = Elm.Main.init();
    </script>
  </body>
</html>
```

Este HTML es bastante simple. Cargas lo que necesitas en `<head>`, e inicializas tu programa Elm en `<body>`. El programa Elm se encargará del resto y renderizará todo.

De cualquier manera, ya tienes HTML que pasarle a un navegador. Puedes servir el HTML vía servicios gratuitos como [GitHub Pages](https://pages.github.com/) o [Netlify](https://www.netlify.com/), o tal vez puedes configurar tu propio servidor como un VPS con un servicio como [Digital Ocean](https://m.do.co/c/c47faa1916d2). Haz lo que mejor te acomode; sólo necesitas una forma de servir tu HTML en un navegador.

> **Nota 1:** Si estás usando CSS personalizado, ayuda que manejes el HTML por tu cuenta. Mucha gente usa proyectos como [`rtfeldman/elm-css`](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/) para gestionar sus estilos desde Elm mismo, pero tal vez estás trabajando dentro de un equipo que ya tiene mucho CSS prdefinido. Tal vez el equipo usa algún preprocesador de CSS. No hay problema, sólo tienes que vincular al archivo CSS final desde `<head>` en tu archivo HTML.
>
> **Nota 2:** El link a Digital Ocean que puse arriba es un link promocional. Si te suscribes desde ahí al servicio, nos ayudas con USD $25 de crédito contra el costo de alojamiento de `elm-lang.org` y `package.elm-lang.org`.

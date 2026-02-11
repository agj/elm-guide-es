# Aplicaciones web

Hasta este punto hemos creado programas en Elm con `Browser.element`, que nos permite apoderarnos de un único nodo en una aplicación más grande. Esto es una buena manera de empezar a probar Elm en tu trabajo (como explico [aquí](https://elm-lang.org/blog/how-to-use-elm-at-work)), pero ¿qué pasa después de eso? ¿Cómo podemos usar Elm más extensivamente?

En este capítulo aprenderemos a crear una “aplicación web” con varias páginas distintas que funcionan en forma integrada, pero primero partamos controlando una sola página.

## Controla el documento

El primer paso es cambiar el código para que use [`Browser.document`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#document):

```elm
document :
    { init : flags -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    }
    -> Program flags model msg
```

Los argumentos son casi exactamente los mismos que `Browser.element`, excepto por la función `view`. En vez de retornar un valor `Html`, retornamos un valor [`Document`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#Document) como este:

```elm
type alias Document msg =
    { title : String
    , body : List (Html msg)
    }
```

Esto nos da control sobre los elementos `<title>` y `<body>` del documento. Tal vez nuestro programa descarga datos de internet, y queremos usar esos datos para determinar el título de la página. Usando `Browser.document` ya tenemos la posibilidad de cambiar el título desde la función `view`.

## Publicando la página

El compilador produce HTML por defecto, así que podemos compilar el código así:

```bash
elm make src/Main.elm
```

Esto creará un archivo `index.html` que podemos publicar en la web igual que cualquier otro archivo HTML. Esto funciona, pero ganamos más flexibilidad al (1) compilar Elm a JavaScript, y (2) creando un archivo HTML por cuenta propia. Para tomar esa ruta, necesitamos compilar de esta forma:

```bash
elm make src/Main.elm --output=main.js
```

Esto producirá un archivo `main.js` que podemos cargar desde nuestro HTML personalizado así:

```html
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <link rel="stylesheet" href="tu-archivo.css" />
    <script src="main.js"></script>
  </head>
  <body>
    <script>
      var app = Elm.Main.init();
    </script>
  </body>
</html>
```

Este HTML es bastante simple. Cargamos lo necesario en `<head>`, e inicializamos el programa Elm en `<body>`. El programa se encargará del resto y pintará nuestra vista.

Sea lo que sea que hagamos, ya tendremos HTML que podemos pasarle a un navegador. Podemos publicar el HTML vía servicios gratuitos como [GitHub Pages](https://pages.github.com/) o [Netlify](https://www.netlify.com/), o tal vez podemos configurar un servidor propio, como un VPS (servidor privado virtual) a través de un servicio como [Digital Ocean](https://m.do.co/c/c47faa1916d2). Haz lo que mejor te acomode; sólo necesitas una forma de proveer tu HTML en la web para que se pueda acceder desde un navegador.

> **Nota 1:** Si usas CSS personalizado, es ideal que gestiones el HTML por tu cuenta. Muchos usan proyectos como [`rtfeldman/elm-css`](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/) para gestionar los estilos dentro de Elm mismo, pero tal vez trabajas dentro de un equipo que ya tiene mucho CSS predefinido, o tal vez el equipo usa algún preprocesador de CSS. No hay problema, sólo tienes que vincular el archivo CSS dentro de `<head>` en tu archivo HTML.
>
> **Nota 2:** El link a Digital Ocean que puse arriba es un link promocional. Si te suscribes desde ahí al servicio, nos ayudas con USD $25 de crédito contra el costo de alojamiento de `elm-lang.org` y `package.elm-lang.org`.

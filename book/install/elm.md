# Instala Elm

La página anterior explicó cómo instalar un editor de código para Elm, así que el próximo paso es obtener el archivo ejecutable de nombre `elm`. Aquí tienes los links de **instalación**:

- **Mac** - [installer](https://github.com/elm/compiler/releases/download/0.19.1/installer-for-mac.pkg)
- **Linux** - <a href="https://github.com/elm/compiler/blob/master/installers/linux/README.md" target="_blank">instructions</a>
- **Windows** - [installer](https://github.com/elm/compiler/releases/download/0.19.1/installer-for-windows.exe)

Después de que completes la instalación, abre el terminal en tu computador. Puede que se llame `cmd.exe` o `Command Prompt` en Windows.

![terminal](images/terminal.png)

Primero navega a tu escritorio en el terminal:

```bash
# Mac y Linux
cd ~/Desktop

# Windows (pero cambia <username> por tu nombre de usuario)
cd C:\Users\<usuario>\Desktop
```

El paso siguiente es familiarizarte con el comando `elm`. Personalmente, me costó mucho aprender comandos del terminal, así que hice un gran esfuerzo para que el comando `elm` sea fácil de usar. Vamos a ver cómo se usa en algunas situaciones diferentes.

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm init</span>

Puedes empezar un proyecto Elm corriendo:

```bash
elm init
```

Corre este comando para crear un archivo `elm.json` y un directorio `src/`.

- [`elm.json`](https://github.com/elm/compiler/blob/master/docs/elm.json/application.md) describe tu proyecto.
- `src/` contiene todos tus archivos Elm.

Ahora crea un archivo `src/Main.elm` en tu editor, y copia el código del [ejemplo de los botones](https://elm-lang.org/examples/buttons).

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm reactor</span>

`elm reactor` te ayuda a crear proyectos Elm sin lidiar demasiado con el terminal. Corre este comando en el directorio raíz de tu proyecto:

```bash
elm reactor
```

Esto inicializa un servidor en [`http://localhost:8000`](http://localhost:8000). Desde ahí puedes navegar a cualquier archivo Elm para ver cómo se ejecuta. Corre `elm reactor`, sigue el link de localhost, y busca tu archivo `src/Main.elm` en tu navegador.

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm make</span>

Puedes compilar tu código Elm a HTML o JavaScript con comandos como este:

```bash
# Crea un archivo index.html que puedes abrir en tu navegador.
elm make src/Main.elm

# Crea un archivo JS optimizado para vincular desde un documento HTML personalizado.
elm make src/Main.elm --optimize --output=elm.js
```

Corre estos comandos con tu archivo `src/Main.elm`.

Esta es la forma más general de compilar código Elm. Es extremadamente útil una vez que tu proyecto se haya vuelto demasiado avanzado para `elm reactor`.

Este comando produce los mismos mensajes que has visto en el editor online y con `elm reactor`. Hemos puesto años de trabajo en ellos, pero por favor reporta [aquí](https://github.com/elm/error-message-catalog/issues) cualquier mensaje confuso o poco útil. Estoy seguro de que aún podemos mejorarlos.

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm install</span>

Los paquetes de Elm los encuentras todos en [`package.elm-lang.org`](https://package.elm-lang.org/).

Supongamos que después de buscar, decides que necesitas [`elm/http`][http] y [`elm/json`][json] para hacer solicitudes HTTP. Puedes configurarlos en tu proyecto con estos comandos:

```bash
elm install elm/http
elm install elm/json
```

Esto añade esas dependencias a tu archivo `elm.json`, dejando los paquetes disponibles dentro de tu proyecto. Esto te permitirá poner `import Http` y usar funciones como `Http.get` en tus programas.

[http]: https://package.elm-lang.org/packages/elm/http/latest
[json]: https://package.elm-lang.org/packages/elm/json/latest

## Tips

**Primero**, no te canses tratando de memorizar todo lo de arriba.

Cuando te haga falta, puedes correr `elm --help` para tener una vista general de lo que `elm` te permite hacer.

También puedes correr comandos como `elm make --help` y `elm repl --help` para obtener ayuda sobre comandos específicos. Es muy útil si quieres revisar detalles sobre lo que hace cada uno y las opciones que reciben.

**Segundo**, no te preocupes si te toma un poco de tiempo acostumbrarte a usar el terminal.

Yo llevo más de una década usándolo, y todavía no recuerdo cómo comprimir archivos, encontrar todos los archivos Elm en un directorio, etc. ¡Todavía tengo que buscar ayuda para hacer muchas cosas!

---

Ahora que ya tenemos nuestro editor configurado y `elm` disponible en el terminal, ¡volvamos a aprender Elm!

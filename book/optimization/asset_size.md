# Minificación

Lo único más lento que modificar el DOM es comunicarse con un servidor, especialmente para gente navegando en su teléfono celular o con conexión lenta a internet. Podrías optimizar tu código con `Html.Lazy` y `Html.Keyed` todo lo que quieras, pero tu aplicación se seguiría sintiendo lenta si carga lento.

Una gran manera de mejorar esto es enviando menos bits. Por ejemplo, si podemos convertir un archivo de 122 kb a uno de 9 kb, va a cargar más rápido. Este tipo de resultados se pueden lograr con las siguientes técnicas:

- **Compilación.** El compilador de Elm puede realizar optimizaciones como eliminación de código muerto y renombramiento de campos en registros. Es decir, puede quitar código sin uso y hacer que nombres como `userStatus` sean más cortos dentro del código generado.
- **Minificación.** En el mundo de JavaScript hay herramientas llamadas “minificadores”, que realizan varias transformaciones. Acortan variables, mueven código de funciones directo al lugar en donde son llamadas, convierten `if`s en ternarios `?:`, y transforman `'\u0041'` en `'A'`. Cualquier cosa que reduzca un poquito el peso.
- **Compresión.** Una vez que el código haya quedado tan pequeño como es posible, puedes usar un algoritmo de compresión como gzip para apachurrarlo aún más. Funciona particularmente bien contra palabras clave como `function` y `return`, que no se pueden quitar del código mismo.

Elm facilita hacer todo esto en tu proyecto. No hace falta un sistema complicado de compilación. Basta con dos comandos de terminal.

## Instrucciones

El primer paso es compilar usando la opción `--optimize`. Esto abrevia nombres de campos en registros, entre otras cosas.

El segundo paso es minificar el código JavaScript. Yo uso un minificador que se llama `uglifyjs`, pero puedes usar otro si prefieres. Lo interesante de `uglifyjs` son las muchas opciones que incluye. Estas opciones permiten muchas optimizaciones que son poco confiables en código JS normal, pero gracias al diseño de Elm, son totalmente seguras de realizar para nuestro caso.

Si juntamos estos dos, podemos optimizar `src/Main.elm` usando dos comandos de terminal:

```bash
elm make src/Main.elm --optimize --output=elm.js
uglifyjs elm.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output elm.min.js
```

Con esto vas a tener un archivo `elm.js` y su versión más pequeña, `elm.min.js`.

> **Nota 1:** Llamamos `uglifyjs` dos veces aquí. Primero usamos `--compress`, y la segunda vez usamos `--mangle`. ¡Esto es necesario! De otra manera `uglifyjs` ignorará la opción `pure_funcs`.
>
> **Nota 2:** Si el comando `uglifyjs` no está disponible en tu terminal, puedes correr el comando `npm install uglify-js --global` para instalarlo. Si tampoco tienes `npm`, puedes obtenerlo junto con [Node.js](https://nodejs.org/).

## Scripts

Como es difícil recordar todas esas opciones de `uglifyjs`, tal vez es más fácil escribir un script para esto.

Podemos escribir un script Bash que genera los archivos `elm.js` y `elm.min.js`. En Mac y Linux podemos definir `optimize.sh` así:

```bash
#!/usr/bin/env bash

set -e

js="elm.js"
min="elm.min.js"

elm make --optimize --output=$js "$@"

uglifyjs $js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $min

echo "Tamaño compilado: $(wc $js -c) bytes  ($js)"
echo "Tamaño minificado:$(wc $min -c) bytes  ($min)"
echo "Tamaño comprimido:$(gzip $min -c | wc -c) bytes"
```

Y ahora, si corro `./optimize.sh src/Main.elm` sobre mi código [TodoMVC](https://github.com/evancz/elm-todomvc) voy a ver este resultado en mi terminal:

```
Tamaño compilado:   122297 bytes  (elm.js)
Tamaño minificado:  24123 bytes  (elm.min.js)
Tamaño comprimido:  9148 bytes
```

Buen resultado, ¿no? Ahora sólo necesitamos transferir aproximadamente 9 kb a nuestros usuarios.

Los comandos importantes son `elm` y `uglifyjs`, que funcionan en cualquier plataforma, así que no sería muy difícil hacer un script parecido para Windows.

## Consejos

Recomiendo escribir código usando `Browser.application` y compilarlo en un sólo archivo JavaScript, como hemos visto aquí. En la primera visita el archivo será descargado, y quedará guardado en caché. Elm genera archivos bien pequeños en comparación con otras alternativas populares, [como puedes ver aquí](https://elm-lang.org/blog/small-assets-without-the-headache), así que esta estrategia te puede servir bastante bien.

> **Nota:** En teoría, es posible reducir aún más los tamaños de archivos generados por Elm. Actualmente no es posible, pero si estás trabajando en un proyecto de 50 mil líneas de Elm o más, nos gustaría conocer tu situación como parte de un estudio de usuarios. [Más detalles aquí (en inglés).](https://gist.github.com/evancz/fc6ff4995395a1643155593a182e2de7)

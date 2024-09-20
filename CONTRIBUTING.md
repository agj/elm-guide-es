# Cómo aportar

¡Gracias por querer aportar! Esta es una pequeña guía para ayudarte en este proceso.

## Dudas y correcciones pequeñas

Puedes ir directo a la pestaña “issues” del proyecto en Github y crear un caso para contarnos el problema o preguntar lo que quieras.

Si quieres tomar el asunto en tus propias manos, puedes enviarnos un PR con tu corrección. Clona el repositorio, y seguramente no necesitarás nada más que un editor de texto para hacer las ediciones necesarias en los archivos Markdown.

## Para aportes más grandes

Tal vez quieres ayudar a traducir páginas que faltan, o quieres ayudar en el funcionamiento del REPL, cosas así. Primero…

### Configura tu entorno

Parte por bifurcar el repositorio en Github y clonando antes de seguir.

El proyecto usa [Nix][nix] para simplificar la configuración de tu entorno local. Nix es un gestor de paquetes que no ensucia tu entorno global, y habilita las herramientas necesarias para previsualizar el libro en tu navegador y darle formato a los archivos. Recomiendo que uses [Determinate Nix Installer][nix-installer] para instalar Nix. Si ya tenías Nix instalado, entonces asegúrate de [tener “flakes” activos][flakes].

Una segunda dependencia útil pero no requerida es [direnv][direnv]. Te permite que cuando entres vía terminal al directorio de este repositorio se levante automáticamente a un shell que contiene todo lo necesario para correr el proyecto.

Si no tienes direnv, no hay problema. Estando dentro del directorio, escribe este comando para lograr el mismo efecto:

```sh
nix develop -c $SHELL
```

Ahora ya tendrás todo configurado. Las tareas ejecutables están gestionadas con el comando `just`. Corriendo ese comando sin argumentos verás una lista de tareas disponibles. Y si por ejemplo corres `just preview`, podrás cargar una previsualización del libro en tu navegador.

[nix]: https://nixos.org/
[nix-installer]: https://github.com/DeterminateSystems/nix-installer
[flakes]: https://nixos.wiki/wiki/Flakes
[direnv]: https://direnv.net/

## Traduciendo

El objetivo central de esta traducción es **contribuir a diseminar el uso de Elm y sus ideas en la comunidad hispanohablante de programadores**, particularmente de Hispanoamérica. Por supuesto, más allá de este grupo principal, todos son bienvenidos a hacer uso de esta traducción.

Los siguientes son otros ideales y directrices para este proyecto.

La idea es conservar el tono original del texto en inglés, que intenta ser **cercano y amistoso**, jamás críptico o rebuscado. Tratamos al lector de “tú” y no de “usted”.

Dicho esto, la traducción está pensada para ser leída por gente de toda Hispanoamérica. Preferimos **no usar localismos** que sean difíciles de entender por gente de otras partes. Por lo mismo, evitamos usar mucho coloquialismo, ya que éstos son regionales por naturaleza.

Queremos que cualquier persona se sienta incluída cuando lea nuestra traducción, por lo que preferimos usar **lenguaje neutro al género**. La [“Guía para el uso de un lenguaje inclusivo al género”][onu-genero] de la ONU puede servir para obtener ideas sobre cómo cumplir ese objetivo.

La disciplina de la informática es demasiado anglocéntrica. Gran parte de la terminología tiene origen en palabras cotidianas del inglés, pero al usarlas tal cual en español se vuelven jerga confusa. A través de esta traducción queremos también acercar a hablantes de español a la disciplina en general, por lo que preferimos **evitar el uso de anglicismos** cuando exista una buena alternativa en español.

[onu-genero]: https://authoring.prod.unwomen.org/sites/default/files/Headquarters/Attachments/Sections/Library/Gender-inclusive%20language/Guidelines-on-gender-inclusive-language-es.pdf

### Referencias útiles

- [Traducción del libro Pro Git](https://github.com/progit/progit2-es)
- [Traducción del libro The Rust Programming Language](https://github.com/RustLangES/rust-book-es)

## Cosas que faltan

- Traducción de varias páginas faltantes.
- Revisión de traducción, pulido, regularización del lenguaje.
- Adición de detalles importantes que no existen en la versión original.
  - Explicación de `Task` en `effects/time.md`.
  - Instalación de extensión de Sublime Text.
- Reemplazo de links externos en inglés a equivalentes en español.
- Corrección del REPL para que funcione.
- Traducción de comentarios en código de ejemplo.
- Traducción de contenido en código de ejemplo, donde mejor haga sentido.
- Versión propia del editor online, que contenga los ejemplos traducidos.

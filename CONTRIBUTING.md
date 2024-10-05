# Cómo aportar

¡Gracias por tu interés! Esta es una pequeña guía para ayudarte en este proceso.

## Dudas y correcciones pequeñas

Puedes ir directo a la pestaña [“Issues”][issues] del proyecto en Github y crear un caso para contarnos el problema o preguntar lo que quieras.

Si quieres tomar el asunto en tus propias manos, puedes enviarnos un PR (“pull request”, solicitud de cambios) con tu corrección. El texto del libro está todo escrito en [archivos Markdown dentro del directorio `book/`][book-dir]. Si no tienes experiencia con Github o haciendo PRs, [aquí tienes una guía que explica la forma más fácil de hacerlo][pr-facil]. Eso sí, toma en cuenta que tenemos chequeos automáticos para asegurar que los archivos queden con formato convencional, por lo que puede que te aparezcan errores.

[issues]: https://github.com/agj/elm-guide-es/issues
[book-dir]: https://github.com/agj/elm-guide-es/tree/master/book
[pr-facil]: https://www.freecodecamp.org/espanol/news/como-crear-tu-primer-pull-request-en-github/

## Para aportes más grandes

Tal vez quieres ayudar a traducir páginas que faltan, o quieres ayudar en el funcionamiento del REPL, cosas así. Revisa más abajo la lista de cosas pendientes.

Asumo que ya tienes experiencia usando editores de texto, el terminal y Github, y que sabes crear PRs.

### Configura tu entorno

El proyecto usa [Nix][nix] para simplificar la configuración del entorno de desarrollo. Nix es un gestor de paquetes que no ensucia tu entorno global, y habilita todas las herramientas necesarias para previsualizar el libro en tu navegador y darle formato a los archivos. Recomiendo que uses [Determinate Nix Installer][nix-installer] para instalar Nix. Si ya tenías Nix instalado, entonces asegúrate de [tener “flakes” activos][flakes].

Una segunda dependencia útil pero no requerida es [direnv][direnv]. Permite que cuando entres vía terminal al directorio de este repositorio se levante automáticamente un shell Nix que contiene todo lo necesario para correr el proyecto.

Si no tienes direnv, no hay problema. Estando dentro del directorio, escribe este comando para lograr el mismo efecto:

```sh
nix develop -c $SHELL
```

Después de un rato en que se descargan las dependencias, ya tendrás todo configurado.

Las tareas ejecutables están gestionadas con el comando `just`. Corriendo ese comando sin argumentos verás una lista de tareas disponibles. Y si por ejemplo corres `just preview`, podrás cargar una previsualización del libro en tu navegador que se actualiza cada vez que hagas cambios en los archivos.

[nix]: https://nixos.org/
[nix-installer]: https://github.com/DeterminateSystems/nix-installer
[flakes]: https://nixos.wiki/wiki/Flakes
[direnv]: https://direnv.net/

## Traduciendo

El objetivo central de esta traducción es **contribuir a diseminar el uso de Elm y sus ideas en la comunidad hispanohablante de programadores**, particularmente de Hispanoamérica. Por supuesto, más allá de este grupo principal, todos son bienvenidos a hacer uso de esta traducción.

Los siguientes son otros ideales y directrices para este proyecto.

La idea es conservar el tono original del texto en inglés, que intenta ser **cercano y amistoso**, jamás críptico o rebuscado. Tratamos al lector de “tú” y no de “usted”.

Dicho esto, la traducción está pensada para ser leída por gente de toda Hispanoamérica. Preferimos **no usar localismos** que sean difíciles de entender por gente de otras partes. Por lo mismo, evitamos usar mucho coloquialismo, ya que éstos son regionales por naturaleza.

Queremos que cualquier persona se sienta incluída cuando lea nuestra traducción, por lo que preferimos usar **lenguaje neutro al género**. La [“Guía para el uso de un lenguaje inclusivo al género”][onu-genero] de la ONU puede ser útil para obtener ideas sobre cómo cumplir ese objetivo.

La disciplina de la informática es demasiado anglocéntrica. Gran parte de la terminología tiene origen en palabras cotidianas del inglés, pero al usarlas tal cual en español se vuelven jerga confusa. A través de esta traducción queremos también acercar a hablantes de español a la disciplina en general, por lo que preferimos **evitar el uso de anglicismos** cuando exista una buena alternativa en español.

[onu-genero]: https://authoring.prod.unwomen.org/sites/default/files/Headquarters/Attachments/Sections/Library/Gender-inclusive%20language/Guidelines-on-gender-inclusive-language-es.pdf

### Referencias útiles

- [Traducción del libro Pro Git](https://github.com/progit/progit2-es)
- [Traducción del libro The Rust Programming Language](https://github.com/RustLangES/rust-book-es)

## Pendientes

Esta es una lista de tareas por completar, en las que tal vez puedas aportar.

- Traducción borrador de varias páginas faltantes.

- Revisión y pulido de borradores; regularización del lenguaje.

- Revisión de que los links funcionan correctamente, y en lo posible usar links “permantenes” en donde sea más necesario, p.ej. links a código. Esto significa usar links a un commit específico en Github, y cosas así.

- Traducción de comentarios en código de ejemplo.

- Traducción de los ejemplos vinculados desde [js-integration-examples](https://github.com/elm-community/js-integration-examples). Tal vez hay que clonar el repositorio y mantener esa traducción aparte, pero creo que es mejor unificar en un sólo repositorio y mantener todo sincronizado.

- Adición de detalles importantes que no existen en la versión original. Están marcados como comentarios `TODO` en distintos archivos. Hay dos tipos:

  - `TODO`s nuestros. Cambios que mejorarían la experiencia de lectura para un hispanohablante.
  - `TODO`s de Evan mismo. Ideal sería agregar estas piezas faltantes, pero no es prioritario.

- Reemplazo de links externos en inglés a equivalentes en español.

- Corrección del REPL para que funcione. Así como está, no funciona por error de CORS. Posibles caminos:

  - Pedir a Evan que agregue el dominio a la lista blanca de CORS (aparentemente lo que hicieron en la [traducción japonesa](https://guide.elm-lang.jp)).
  - Poner el código de backend en otro dominio propio. No sé dónde está el código fuente, pero parece ser lo que hicieron en la [traducción francesa](https://guide.elm-france.fr).
  - Armar un REPL que opera en el navegador, usando las distintas versiones existentes de “Elm en Elm” o una compilación a WASM.

- Traducción de strings, nombres de variables y otro contenido en código de ejemplo, donde mejor haga sentido. El problema es que genera diferencia con el código original, por lo que mientras no tengamos el punto siguiente, no es muy beneficioso.

  - Se puede hacer con los ejemplos que usan Ellie y los del repositorio js-integration-examples.

- Versión propia del editor online, que contenga los ejemplos traducidos.
  - Evaluar si es mejor usar Ellie para esto. El problema es que Ellie tiene más funcionalidades que no le importan a un novato, y le falta una importante, que es ver el tipo de lo que uno tiene seleccionado. El texto del libro también tendría que ser actualizado para tomar en cuenta las diferencias.

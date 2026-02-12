# Cómo aportar

¡Gracias por tu interés! Esta es una pequeña guía para ayudarte en este proceso.

## Dudas y correcciones pequeñas

Puedes ir directo a la pestaña [“Issues”][issues] del proyecto en Github y crear un caso para contarnos el problema o preguntar lo que quieras.

Si quieres tomar el asunto en tus propias manos, puedes enviarnos un PR (“pull request”, solicitud de cambios) con tu corrección. El texto del libro está todo escrito en [archivos Markdown dentro del directorio `book/`][book-dir]. Si no tienes experiencia con Github o haciendo PRs, [aquí tienes una guía que explica la forma más fácil de hacerlo][pr-facil]. Eso sí, toma en cuenta que tenemos chequeos automáticos para asegurar que los archivos queden con formato convencional, por lo que puede que te aparezcan errores.

[issues]: https://github.com/agj/elm-guide-es/issues
[book-dir]: https://github.com/agj/elm-guide-es/tree/master/book
[pr-facil]: https://www.freecodecamp.org/espanol/news/como-crear-tu-primer-pull-request-en-github/

## Para aportes más grandes

Asumo que ya tienes experiencia usando editores de texto, el terminal y Github, y que sabes crear PRs.

### Configura tu entorno

El proyecto usa [Nix][nix] para simplificar la configuración del entorno de desarrollo. Nix es un gestor de paquetes que no ensucia tu entorno global, y habilita todas las herramientas necesarias para previsualizar el libro en tu navegador y darle formato a los archivos. Recomiendo que uses [el instalador experimental][nix-installer] para instalar Nix. Si ya tenías Nix instalado, entonces asegúrate de [tener “flakes” activos][flakes].

Una segunda dependencia útil pero no requerida es [direnv][direnv]. Permite que cuando entres vía terminal al directorio de este repositorio se levante automáticamente un shell Nix que contiene todo lo necesario para correr el proyecto.

Si no tienes direnv, no hay problema. Estando dentro del directorio, escribe este comando para lograr el mismo efecto:

```sh
nix develop -c $SHELL
```

Después de un rato en que se descargan las dependencias, ya tendrás todo configurado.

Las tareas ejecutables están gestionadas con el comando `just`. Corriendo ese comando sin argumentos verás una lista de tareas disponibles. Y si por ejemplo corres `just preview`, podrás cargar una previsualización del libro en tu navegador que se actualiza cada vez que hagas cambios en los archivos.

[nix]: https://nixos.org/
[nix-installer]: https://github.com/NixOS/nix-installer
[flakes]: https://nixos.wiki/wiki/Flakes
[direnv]: https://direnv.net/

## Traduciendo

El objetivo central de esta traducción es **contribuir a diseminar el uso de Elm y sus ideas en la comunidad hispanohablante de programadores**, particularmente de Hispanoamérica. Por supuesto, más allá de este grupo principal, todos son bienvenidos a hacer uso de esta traducción.

Los siguientes son otros ideales y directrices para este proyecto.

Por favor, **usa tu “inteligencia humana”** para cualquier cambio que quieras proponer, sin depender de la IA.

La idea es conservar el tono original del texto en inglés, que intenta ser **cercano y amistoso**, jamás críptico o rebuscado. Tratamos al lector de “tú” y no de “usted”. Cuando el texto habla de “you do x” (segunda persona), en general preferir “hacemos x” (primera persona plural, inclusiva), que en español suena menos acusatorio.

Dicho esto, la traducción está pensada para ser leída por gente de toda Hispanoamérica. Preferimos **no usar localismos** que sean difíciles de entender por gente de otras partes. Por lo mismo, evitamos usar mucho coloquialismo, ya que éstos son regionales por naturaleza.

Queremos que cualquier persona se sienta incluída cuando lea nuestra traducción, por lo que preferimos usar **lenguaje neutro al género**. La [“Guía para el uso de un lenguaje inclusivo al género”][onu-genero] de la ONU puede ser útil para obtener ideas sobre cómo cumplir ese objetivo.

La disciplina de la informática es demasiado anglocéntrica. Gran parte de la terminología tiene origen en palabras cotidianas del inglés, pero al usarlas tal cual en español se vuelven jerga confusa. A través de esta traducción queremos también acercar a hablantes de español a la disciplina en general, por lo que preferimos **evitar el uso de anglicismos** cuando exista una buena alternativa en español.

Por supuesto que queremos ser fieles al contenido original hasta cierto punto, pero donde hayan oportunidades de mejorar la experiencia del lector tal vez **nos permitiremos diverger**. Por ejemplo, si hay contenido desactualizado o faltante.

[onu-genero]: https://authoring.prod.unwomen.org/sites/default/files/Headquarters/Attachments/Sections/Library/Gender-inclusive%20language/Guidelines-on-gender-inclusive-language-es.pdf

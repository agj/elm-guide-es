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

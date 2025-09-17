# Instalar un editor de código

El primer paso es configurar un editor de código para que pueda interpretar archivos Elm.

![editor](images/editor.png)

Hay extensiones para varios editores, mantenidas por miembros de la comunidad. Aquí una lista incompleta:

- [VS Code](https://github.com/elm-tooling/elm-language-client-vscode)
- [IntelliJ](https://github.com/intellij-elm/intellij-elm)
- [Zed](https://zed.dev/docs/languages/elm)
- [Sublime Text](https://github.com/evancz/elm-syntax-highlighting/)
- [Vim](https://github.com/elm-tooling/elm-vim)
- [Emacs](https://github.com/jcollard/elm-mode)
- [Cualquier editor que soporte el protocolo LSP](https://github.com/elm-tooling/elm-language-server)

Puede ser un poco complicado configurar un editor, así que para propósitos de esta guía te voy a explicar cómo configurar Sublime Text en particular. Idealmente será de ayuda para gente que recién empieza a programar, o como segunda opción para gente que ya tenga un editor de su preferencia.

## Sublime Text

**Paso 1:** Descarga Sublime Text desde [aquí](https://www.sublimetext.com/).

**Paso 2:** Instala la extensión “Elm Syntax Highlighting”.

- [Mac](https://github.com/evancz/elm-syntax-highlighting/blob/master/install/mac.md)
- [Linux](https://github.com/evancz/elm-syntax-highlighting/blob/master/install/linux.md)
- [Windows](https://github.com/evancz/elm-syntax-highlighting/blob/master/install/windows.md)

<!-- TODO: Añadir una traducción abreviada de las guías del plugin de Sublime Text. -->

Después de completar esos pasos, al abrir archivos Elm los verás con coloreado de sintaxis, es decir, verás palabras claves como `import` y `type` en un color distinto, lo que hace que el código sea más fácil de leer.

> **Nota:** ¡Recuerda que hay otras alternativas! Revisa la lista más arriba y busca la que se ajuste mejor a tu configuración personal. Y si acaso no la encontraste en la lista, haz una búsqueda para tu editor preferido; puede que encuentres algo a tu medida.

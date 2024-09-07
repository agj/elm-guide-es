# Introducción a Elm

**[Elm](https://elm-lang.org/) es un lenguaje de programación funcional que compila a JavaScript.** Está hecho para construir sitios y aplicaciones web. Tiene un gran énfasis en ser simple y ofrecer herramientas de calidad.

Esta guía va a:

- Enseñarte los fundamentos de programar usando Elm.
- Mostrarte cómo crear aplicaciones interactivas usando la **Arquitectura Elm**.
- Enfatizar principios y patrones que pueden generalizarse al programar en cualquier lenguaje.

Al terminar, espero que no sólo seas capaz de crear excelentes aplicaciones web con Elm, pero que también entiendas las ideas y patrones centrales que crean la experiencia de usar Elm.

Si aún no estás comprometido con usar Elm, te garantizo que si le das una oportunidad y construyes un proyecto usándolo, vas a poder escribir mejor JavaScript que antes. Es muy fácil aplicar las mismas ideas.

## Sobre la traducción

Antes de empezar, un poquito de contexto. Estás leyendo la traducción no oficial al español hispanoamericano del libro de Evan Czaplicki, autor de Elm.

**Nota:** ¡Esta traducción aún está en desarrollo! Así que hay cosas que aún no están traducidas, posibles errores, y funcionalidades incompletas. Aún así, le hemos puesto mucho cariño y esperamos que te sea útil. ❤️

- [El libro original en inglés.](https://guide.elm-lang.org/)
- [Repositorio en Github de la traducción.](https://github.com/agj/elm-guide-es) ¡Entra aquí si quieres aportar o escribirnos un comentario!

¿Está al día la traducción? Puedes [revisar aquí si hay cambios nuevos en el libro original](https://github.com/evancz/guide.elm-lang.org/compare/a6030f9968724629c374b936c552d2b8d2b30f31...master).

## Un ejemplo sencillo

Ahora sí, entremos en materia. Este es un pequeño programa que te permite incrementar y decrementar un número:

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = 0, update = update, view = view }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
```

Pruébalo usando el editor online, [aquí](https://elm-lang.org/examples/buttons).

Al principio, seguro que el código te parecerá extraño, así que pronto vamos a entrar en cómo funciona este ejemplo.

## ¿Por qué un lenguaje _funcional_?

Puedes obtener ciertos beneficios programando en un _estilo_ funcional, pero hay algunas cosas que sólo puedes obtener de un _lenguaje_ funcional como Elm:

- Tener virtualmente ningún error en tiempo de ejecución.
- Mensajes de error amistosos.
- Capacidad de refactorizar sin peligro.
- Versionado semántico (_semver_) para todos los paquetes Elm.

Ninguna combinación de librerías de JS te dará estas garantías, ya que provienen del diseño del lenguaje mismo. Y gracias a estas garantías, es muy común que programadores de Elm digan que sienten **más confianza** que nunca al programar. Confianza en poder rápidamente añadir nuevas funcionalidades; confianza en poder refactorizar miles de líneas… Y sin la ansiedad de que se te pasó un detalle importante.

He puesto mucho énfasis en hacer que Elm sea fácil de aprender y usar, así que todo lo que pido de ti es que le des una oportunidad y formes tu opinión. Espero que sea una grata sorpresa.

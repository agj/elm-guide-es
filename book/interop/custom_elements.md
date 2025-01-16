# Elementos personalizados

En las últimas páginas hemos visto (1) cómo inicializar programas Elm desde JavaScript, (2) cómo pasar datos en forma de flags, y (3) cómo mandar mensajes entre Elm y JS usando puertos. Pero, adivina qué: ¡hay otra manera más de interoperar!

Los navegadores populares ya todos soportan [elementos personalizados](https://developer.mozilla.org/es/docs/Web/API/Web_components/Using_custom_elements), y ésta resulta ser una forma muy práctica de incluir JS en programas Elm.

Aquí tienes un [ejemplo mínimo](https://github.com/elm-community/js-integration-examples/tree/master/internationalization) de cómo usar elementos personalizados para hacer localización e internacionalización.

<!-- TODO: 👆 Agregar estos ejemplos al repositorio y traducirlos. -->

## Crear elementos personalizados

Supongamos que queremos localizar fechas, pero esto no es aún posible directo desde los paquetes básicos de Elm. Tal vez quieres escribir una función que localiza una fecha:

```javascript
//
//   localizeDate('sr-RS', 12, 5) === "петак, 1. јун 2012."
//   localizeDate('en-GB', 12, 5) === "Friday, 1 June 2012"
//   localizeDate('en-US', 12, 5) === "Friday, June 1, 2012"
//
function localizeDate(lang, year, month) {
  const dateTimeFormat = new Intl.DateTimeFormat(lang, {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return dateTimeFormat.format(new Date(year, month));
}
```

Pero, ¿cómo diantres la usamos en Elm? Las últimas versiones de los navegadores te permiten crear nuevos tipos de nodos DOM de esta forma:

```javascript
//
//   <intl-date lang="sr-RS" year="2012" month="5">
//   <intl-date lang="en-GB" year="2012" month="5">
//   <intl-date lang="en-US" year="2012" month="5">
//
customElements.define(
  "intl-date",
  class extends HTMLElement {
    // things required by Custom Elements
    constructor() {
      super();
    }
    connectedCallback() {
      this.setTextContent();
    }
    attributeChangedCallback() {
      this.setTextContent();
    }
    static get observedAttributes() {
      return ["lang", "year", "month"];
    }

    // Our function to set the textContent based on attributes.
    setTextContent() {
      const lang = this.getAttribute("lang");
      const year = this.getAttribute("year");
      const month = this.getAttribute("month");
      this.textContent = localizeDate(lang, year, month);
    }
  },
);
```

La partes más importantes son `attributeChangedCallback` y `observedAttributes`. Necesitas lógica como seta para detectar cambios en los atributos que te interesan.

Carga eso antes de inicializar tu programa Elm, y podrás escribir código Elm como el siguiente:

```elm
import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


viewDate : String -> Int -> Int -> Html msg
viewDate lang year month =
    node "intl-date"
        [ attribute "lang" lang
        , attribute "year" (String.fromInt year)
        , attribute "month" (String.fromInt month)
        ]
        []
```

Y así ya tienes acceso a `viewDate` para cuando necesites información localizada en tu vista.

Revisa el ejemplo completo [aquí](https://github.com/elm-community/js-integration-examples/tree/master/internationalization).

<!-- TODO: 👆 Agregar estos ejemplos al repositorio y traducirlos. -->

## Más información

Luke tiene mucha más experiencia usando elementos personalizados, y creo que [su charla de Elm Europe](https://www.youtube.com/watch?v=tyFe9Pw6TVE) (en inglés) es una excelente introducción.

<!-- TODO: 👆 ¿Proveer subtítulos? ¿Usar otra referencia? 🤔 -->

La documentación de los elementos personalizados puede ser un poco confusa, pero espero que esta introducción sea suficiente para que puedas empezar a incluir lógica simple que use `Intl`, incrustar widgets hechos en React, o cualquier cosa así según las necesidades de tu proyecto.

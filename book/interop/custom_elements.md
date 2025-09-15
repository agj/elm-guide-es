# Elementos personalizados

En las últimas páginas hemos visto (1) cómo inicializar programas Elm desde JavaScript, (2) cómo pasar datos en forma de flags, y (3) cómo mandar mensajes entre Elm y JS usando puertos. Pero hay otra manera de interoperar que nos queda por revisar.

Hay una funcionalidad relativamente reciente en navegadores web, llamada [elementos personalizados](https://developer.mozilla.org/es/docs/Web/API/Web_components/Using_custom_elements) (también conocidos como “componentes web”). Resulta que son una forma muy práctica de incluir JS en programas Elm.

Aquí tienes un [ejemplo mínimo pero completo](https://github.com/elm-community/js-integration-examples/tree/master/internationalization) (en inglés) de cómo usar elementos personalizados para hacer localización e internacionalización. A continuación, un poco de explicación de todo esto.

<!-- TODO: 👆 Agregar estos ejemplos al repositorio y traducirlos. -->

## Crear elementos personalizados

Supongamos que queremos localizar fechas. Esto aún no es posible usando sólo Elm. Tal vez queremos escribir una función así, que presenta una fecha con formato localizado:

```javascript
//   localizeDate('sr-RS', 12, 5) === "петак, 1. јун 2012."
//   localizeDate('en-GB', 12, 5) === "Friday, 1 June 2012"
//   localizeDate('en-US', 12, 5) === "Friday, June 1, 2012"

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

Pero, ¿cómo diantres la usamos desde Elm? Pues una forma es creando un nuevo tipo de nodo del DOM, de esta manera:

```javascript
//   <intl-date lang="sr-RS" year="2012" month="5">
//   <intl-date lang="en-GB" year="2012" month="5">
//   <intl-date lang="en-US" year="2012" month="5">

customElements.define(
  "intl-date",
  class extends HTMLElement {
    // Cosas requeridas para crear un elemento personalizado.
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

    // Nuestra función que cambia el texto del nodo en base a sus atributos.
    setTextContent() {
      const lang = this.getAttribute("lang");
      const year = this.getAttribute("year");
      const month = this.getAttribute("month");
      this.textContent = localizeDate(lang, year, month);
    }
  },
);
```

La partes más importantes son `attributeChangedCallback` (método gatillado cuando cambia un atributo) y `observedAttributes` (método con el que explicitamos cuáles son los atributos que nos interesan). Estas dos piezas son necesarias para detectar cambios en los atributos de nuestro elemento personalizado.

Si cargamos el código de arriba antes de inicializar nuestro programa Elm, podremos escribir código como el siguiente:

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

Y listo, tendremos esta función `viewDate` disponible para usar en algún lugar dentro de la vista, para mostrar fechas con formato localizado.

Revisa el ejemplo completo [aquí](https://github.com/elm-community/js-integration-examples/tree/master/internationalization).

<!-- TODO: 👆 Agregar estos ejemplos al repositorio y traducirlos. -->

## Más información

Luke tiene mucha más experiencia usando elementos personalizados, y creo que [su charla en Elm Europe](https://www.youtube.com/watch?v=tyFe9Pw6TVE) (en inglés) es un muy buen punto de partida.

<!-- TODO: 👆 ¿Proveer subtítulos? ¿Usar otra referencia? 🤔 -->

La documentación de los elementos personalizados puede ser un poco confusa, pero espero que este breve tutorial sea suficiente para que puedas empezar, por ejemplo, a usar APIs como `Intl`, incrustar cosas hechas en React, o cualquier otra cosa que necesite tu proyecto.

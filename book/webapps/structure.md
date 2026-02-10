# Estructurando aplicaciones web

Como dije en la página anterior, **todos los módulos debiesen escribirse en torno a un tipo central**. Por lo tanto, si yo estuviera construyendo una aplicación web para artículos de un blog, comenzaría con módulos como estos:

- `Main`
- `Page.Home`
- `Page.Search`
- `Page.Author`

Tendría un módulo para cada página, creados en torno a un tipo `Model`. Estos módulos siguen la Arquitectura Elm con los típicos `Model`, `init`, `update`, `view`, y cualquier otra funcion auxiliar que haga falta. De ahí en adelante simplemente dejaría crecer estos módulos, añadiendo los tipos y funciones que sean necesarios. Si llego a notar que creé un tipo personalizado junto a un par de funciones auxiliares, _puede_ que los mueva a un módulo propio.

Antes de entrar a ver algunos ejemplos, quiero enfatizar una estrategia importante.

## No planificar por adelantado

Fíjate en que mis módulos `Page` no hacen suposiciones sobre el futuro. No me anticipé a definir módulos que serán usados en múltiples lugares, o a pensar en cómo compartir funciones. Esto es muy a propósito.

Me ha ocurrido frecuentemente que comienzo mis proyectos teniendo un gran plan de cómo va a funcionar todo en conjunto. Por ejemplo, determino que, ya que las páginas para editar y ver artículos ambas están relacionadas con los artículos, lo correcto es escribir un módulo compartido `Post`. Pero mientras voy escribiendo la aplicación, noto que sólo la página de visualización de artículos necesita una fecha de publicación. Y realmente necesito manejar la edición de forma especial para cachear los datos al cerrar la pestaña. Y por lo mismo, los datos también necesitan guardarse de manera distinta en el servidor. Etcétera. Termino haciendo que el módulo `Post` se convierta en una confusa maraña que se encarga de todos estos casos particulares, y se hace más incómodo su uso en ambas páginas.

Si en cambio empezamos sólo creando módulos específicos para cada página, se hace mucho más fácil ver cuándo las cosas son **similares**, pero no **lo mismo**. Y esto es lo más típico en interfaces de usuario. En cuanto al editar y ver artículos, es muy probable que terminemos con un tipo `EditablePost` y otro `ViewablePost`, cada uno con una estructura distinta, sus propias funciones auxiliares y sus decodificadores de JSON. Tal vez esos tipos son suficientemente complejos como para que tengan su propio módulo. O tal vez no. Tendríamos que escribir el código y ver qué pasa.

Esto es posible porque el compilador hace que sea muy fácil hacer grandes refactorizaciones. Si de pronto me doy cuenta de que cometí un gran error que afecta a 20 archivos, puedo simplemente ir y corregirlo.

## Ejemplos

Estos son dos proyectos de código abierto que funcionan como ejemplos de la estructura que acabo de mencionar:

- [`elm-spa-example`](https://github.com/rtfeldman/elm-spa-example)
- [`package.elm-lang.org`](https://github.com/elm/package.elm-lang.org)

> ## Choque cultural
>
> La gente que viene de programar JavaScript tiende a traer sus hábitos, expectativas y ansiedades específicas de JavaScript consigo. Son legítimamente importantes en ese contexto, pero pueden causar serios problemas al transferirlos a Elm.
>
> ### Instintos defensivos
>
> En [“The Life of a File”](https://youtu.be/XpDsk374LDE) hago hincapié en cierto conocimiento popular del mundo de JavaScript que se puede convertir en una trampa en Elm.
>
> - ~~**“Prefiere archivos cortos.”**~~ En JavaScript, mientras más largo sea tu archivo, más probable será que se esconda alguna mutación que causará eventualmente un bug complicado. Pero en Elm, eso simplemente no es posible. Tu archivo podría tener hasta 2000 líneas y seguirá sin ser posible.
> - ~~**“Parte con la arquitectura correcta.”**~~ En JavaScript, refactorizar es extremadamente riesgoso. En muchos casos es menos costoso simplemente reescribir todo desde cero. Pero en Elm, refactorizar no implica gran costo ni riesgo. Puedes cambiar 20 archivos sin preocupación.
>
> Estos instintos defensivos nos protegen de problemas que no existen en Elm. Pero entender esto intelectualmente no es lo mismo que entenderlo en forma instintiva, y he observado que gente que programa JS se siente profundamente incómoda cuando ve archivos que superan las 400, 600, u 800 líneas. **Te invito a que superes tu propio límite de líneas por archivo.** Ve hasta dónde puedes llevarlo. Usa comentarios a modo de encabezados, crea funciones auxiliares, pero siempre déjalo todo en el mismo archivo. Resulta muy valioso experimentar personalmente esta situación.
>
> ### MVC
>
> Hay gente que ve la Arquitectura Elm y tiene el instinto de dividir su código en módulos `Model`, `Update` y `View`. ¡No lo hagas!
>
> Esto conlleva a tener fronteras debatibles y poco claras. ¿Qué pasa cuando `Post.estimatedReadTime` se use tanto en las funciones `update` como `view`? Es algo muy razonable, pero no hay una evidente _pertenencia_ a una u otra. ¿Tal vez necesitamos un módulo `Utils`? ¿Tal vez en realidad es alguna especie de controlador? El código resultante tiende a ser difícil de navegar, porque la ubicación de cada función se convirtió en una pregunta [ontológica](https://es.wikipedia.org/wiki/Ontolog%C3%ADa), y tus colegas tendrán cada uno su propia teoría. ¿Qué es lo más esencial de `estimatedReadTime`? ¿Será el concepto de “estimación”? Tal vez tu otro colega diga que no, que es el “tiempo”.
>
> **Si construímos cada módulo en torno a un tipo, muy rara vez nos toparemos con este tipo de preguntas.** Tenemos un módulo `Page.Home` que contiene su `Model`, `update` y `view`. Escribimos funciones auxiliares. Añadimos un tipo `Post`, eventualmente. Añadimos una función `estimatedReadTime`. Tal vez un día hayan suficientes funciones auxiliares sobre el tipo `Post`, y tal vez valga la pena separar ese código en su propio módulo. Usando esta convención acabamos gastando menos tiempo considerando y reconsiderando las fronteras entre módulos. En mi opinión, el código también queda mucho más claro.
>
> ### Componentes
>
> La gente acostumbrada a React espera que todo sea componentes. **Tratar intencionadamente de construir componentes es una fórmula para el desastre en Elm.** El problema fundamental es que los componentes son objetos:
>
> - componentes = estado localizado + métodos
> - estado localizado + métodos = objetos
>
> Sería extraño usar Elm y preguntarse, “¿cómo uso objetos para estructurar mi aplicación?”. ¡No hay objetos en Elm! Dentro de la comunidad Elm, la gente recomienda usar tipos personalizados y funciones.
>
> Pensar en términos de componentes nos impulsa a crear módulos basados en el diseño visual de nuestra aplicación. “Hay una barra lateral, así que necesito un módulo `Sidebar`”. Sería mucho más fácil simplemente hacer una función `viewSidebar` y pasarle los argumentos que necesita. Tal vez ni siquiera tiene estado, o tal vez necesita llevar cuenta de uno o dos valores. Pongámolos en el `Model` que ya tenemos. Si realmente vale la pena separarlo en su propio módulo, lo sabremos porque tendremos un tipo personalizado con varias funciones auxiliares relevantes.
>
> El punto es que escribir una función `viewSidebar` **no significa** que necesitemos crear también un `update` y otro tipo `Model` junto con ella. Resistamos el instinto. **Escribamos las funciones auxiliares que necesitamos y nada más.**

# Optimización

Hay dos principales maneras de optimizar un programa Elm: optimizar el rendimiento, y optimizar el tamaño de archivo resultante.

- **Rendimiento** — Lo más lento en los navegadores es el DOM, por un amplio margen. He hecho mucho perfilamiento para medir y mejorar el rendimiento de aplicaciones Elm, y la mayoría de ajustes no ofrecen un gran impacto. ¿Usar estructuras de datos más óptimas? El cambio es insignificante. ¿Guardar un caché del resultado de ciertas computaciones en el modelo? El cambio es insignificante _y además_ el código queda peor. Lo único que hace una gran diferencia es usar `Html.Lazy` y `Html.Keyed` para reducir la cantidad de operaciones sobre el DOM.

- **Tamaño de archivo** — Operar en un navegador implica que tenemos que cuidar los tiempos de descarga. Mientras más pequeños sean nuestros archivos, más rápido cargarán en dispositivos móviles y en conexiones lentas. Esto es tal vez más importante que cualquier optimización de rendimiento. Por fortuna, Elm compila a un código ya muy pequeño, así que no necesitas gastar esfuerzos haciendo que tu código quede más confuso, sólo por necesidad de mejorar este aspecto.

Ambos son importantes, así que este capítulo se enfocará en cómo funcionan estas optimizaciones.

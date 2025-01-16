# Tipos como bits

Todos estos son tipos en Elm:

- `Bool`
- `Int`
- `String`
- `( Int, Int )`
- `Maybe Int`
- ...

Ya adquirimos un entendimiento a nivel conceptual sobre ellos, pero ¿cómo los entiende un computador? ¿Cómo se almacena un `Maybe Int` en el disco duro?

## Bits

Un **bit** es una pequeña caja con dos posibles estados: cero o uno, prendido o apagado. La memoria de un computador es una larguísima secuencia de bits.

Lo único que tenemos a nuestra disposición es un montón de bits. Y tenemos que representarlo _todo_ usando eso.

## `Bool`

Un valor `Bool` puede ser `True` (verdadero) o `False` (falso). Es decir, ¡corresponde exactamente a un bit!

## `Int`

Un valor `Int` es un número como `0`, `1`, `2`, etc. No hay forma de hacerlo caber en un sólo bit, así que la única otra opción es usar múltiples bits. Lo normal es que un `Int` se represente como una secuencia de bits, como las siguientes:

```
00000000
00000001
00000010
00000011
...
```

Podemos asignarle significado arbitrariamente a cada una de estas secuencias. Tal vez `00000000` es cero, y `00000001` es uno. Genial, ya podemos empezar a asignar números a secuencias de bits en orden ascendente. Pero eventualmente se nos van a acabar los bits…

Usando un poco de matemática, sabemos que ocho bits sólo permiten (2^8 = 256) números. ¿Qué pasa con otros números perfectamente razonables, como 9000 y 8004?

La respuesta es sólo añadir más bits. Por largo tiempo, la gente usó 32 bits. Eso nos da espacio para (2^32 = 4.294.967.296) números, lo que cubre el rango de números que usamos típicamente los humanos. Hoy día, los computadores soportan números enteros de 64 bits, permitiendo (2^64 = 18.446.744.073.709.551.616) números. O sea, un enorme montón.

> **Nota:** Si te da curiosidad saber cómo funciona la adición, puedes leer sobre el [complemento a dos](https://es.wikipedia.org/wiki/Complemento_a_dos). Podrás ver que la manera en que se asignan los números a secuencias de bits no es arbitraria. Para optimizar la velocidad de la adición, esta forma particular de asignar números funciona muy bien.

## `String`

El string `"abc"` es la secuencia de caracteres `a` `b` `c`, así que empecemos intentando representar caracteres como bits.

Una de las formas originales de codificación de caracteres es la llamada [ASCII](https://en.wikipedia.org/wiki/ASCII). Igual que con los números enteros, decidieron listar secuencias de bits y a asignarles valores en forma arbitraria:

```
00000000
00000001
00000010
00000011
...
```

Cada carácter debía caber en ocho bits, lo que significa que sólo 256 caracteres pueden ser representados. Pero ya que es un estándar estadounidense y les interesaba codificar textos en inglés, es un número más que suficiente. Necesitas 26 letras minúsculas, 26 mayúsculas y 10 números. Llevamos 62. Queda mucho espacio para símbolos y algunas cosas raras. Puedes mirar [aquí](https://ascii.cl/) la lista con la que acabaron.

Ya tenemos una idea de qué pasa con cada carácter, pero ¿cómo sabe el computador dónde termina el `String` y empieza el dato siguiente? Al fin y al cabo todo es bits; cada carácter es indistinguible un valor `Int`. Necesitamos una forma de especificar dónde termina un string.

Hoy en día, los lenguajes suelen hacer esto almacenando la **longitud** del string. O sea que un string como `"hello"` se vería en memoria algo como `5` `h` `e` `l` `l` `o`. Añadimos la presuposición de que un `String` siempre empieza con 32 bits representando su longitud. Y así, sea el string de 0 o de 9000 caracteres de largo, siempre sabremos exáctamente dónde termina en memoria.

> **Nota:** Naturalmente, incluso los angloparlantes querían también poder representar textos en lenguajes que no son inglés. Eventualmente se ideó la codificación [UTF-8](https://es.wikipedia.org/wiki/UTF-8). Es una solución bastante brillante, y te sugiero que la investigues, si te interesa el tema. Resulta que obtener el “quinto carácter” es una tarea más difícil de lo que parece…

## `( Int, Int )`

¿Qué tal las tuplas? `( Int, Int )` es dos valores `Int`, y cada uno es una secuencia de bits. Nos basta con poner ambas secuencias una junto a la otra en memoria, y listo.

## Tipos personalizados

Los tipos personalizados son buenos para combinar distintos tipos, y estos tipos pueden tener muchas formas distintas. Pero primero veamos el caso simple del tipo `Color`:

```elm
type Color
    = Red
    | Yellow
    | Green
```

Podemos asignarle a cada caso un número: `Red = 0`, `Yellow = 1` y `Green = 2`. Ahora podemos usar la misma representación de `Int`. Aquí sólo necesitamos dos bits para cubrir todos los casos posibles, por lo que `00` es `Red`, `01` es `Yellow`, `10` es `Green` y `11` queda sin uso.

Pero ¿y qué pasa con los tipos personalizados que almacenan más información, como `Maybe Int`? Lo común es estos bits que representan cada variante sirvan como una “etiqueta” para los datos. Si definimos que `Nothing = 0` y `Just = 1`, quedaría como en estos ejemplos:

- `Nothing` = `0`
- `Just 12` = `1` `00001100`
- `Just 16` = `1` `00010000`

Una expresión `case` revisaría primero la “etiqueta” antes de decidir qué hacer. Si encuentra una etiqueta `0`, sabe que no hay más datos. Si encuentra un `1`, sabe que está seguida de una secuencia de bits que representan un `Int`.

Esta idea de “etiquetar” se parece a la de poner la longitud al principio de un valor `String`. Los valores almacenados pueden tener distinta longitud de bits, pero el código tiene la información suficiente para siempre identificar dónde empiezan y terminan.

## En resumen

Eventualmente, todos los valores que necesitamos pueden ser representados en bits. Esta página ofrece una perspectiva general de cómo funciona eso en la práctica.

Usualmente no hay razón de pensar en estos detalles, pero me resultó útil para profundizar mi entendimiento de los tipos personalizados y las expresiones `case`. Ojalá que te sirva a ti también.

> **Nota:** Si esto te pareció interesante, podría gustarte aprender también sobre la recolección de basura. El libro [“The garbage collection handbook”](http://gchandbook.org/) (en inglés) es un recurso sobre el tema que me gustó mucho.


# Ruleta Simulada - Técnicas de Apuesta

**Una herramienta en Bash que simula diferentes técnicas de apuesta en la ruleta para demostrar que la casa siempre gana.**

---

## Descripción

Este script simula una ruleta con distintas técnicas de apuestas (actualmente soporta Martingala e Inverse Labouchere) para apostar en par o impar. Permite ver cómo estas estrategias, aunque populares, no garantizan ganancias y que la casa siempre tiene ventaja.

---

## Características

- Simulación de técnicas de apuestas populares en ruleta:
  - Martingala
  - Inverse Labouchere
- Entrada de parámetros desde la terminal (dinero inicial y técnica a usar).
- Control de apuestas en par o impar.
- Muestra rachas de jugadas malas y patrones cuando se pierde todo el dinero.

---

## Requisitos

- Bash shell (versión 4 o superior recomendada).
- Terminal compatible con secuencias ANSI para colores.

---

## Uso

```bash
./ruleta.sh -m <dinero_inicial> -t <tecnica>
```

### Opciones

| Opción | Descripción                                                 |
|--------|-------------------------------------------------------------|
| `-m`   | Cantidad de dinero con la que quieres jugar                 |
| `-t`   | Técnica de apuesta (`martingala` o `InverseLabruchere`)     |

---

## Ejemplos

**Jugar con Martingala y 1000€:**

```bash
./ruleta.sh -m 1000 -t martingala
```

**Jugar con técnica Inverse Labouchere y 500€:**

```bash
./ruleta.sh -m 500 -t InverseLabruchere
```

---

## Consideraciones

- El script pide durante la ejecución la cantidad a apostar y si quieres jugar a par o impar.
- Solo acepta `"par"` o `"impar"` como opciones válidas.
- Cuando te quedes sin dinero, mostrará un resumen de la racha negativa y terminará la simulación.
- **No es un juego real ni debe usarse para apuestas reales**, es una simulación educativa.

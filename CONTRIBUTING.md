# Cómo contribuir

Gracias por el interés. Este repositorio acompaña una presentación en LatinR 2026 y se mantiene como proyecto de datos abiertos.

## Reportar un problema

Abre un *issue* en GitHub con:

- qué esperabas y qué ocurrió;
- la salida de `sessionInfo()` (versión de R y de los paquetes);
- si aplica, el script y la línea donde falla.

## Proponer cambios

1. Haz un *fork* y crea una rama descriptiva (`fix/etiquetas-contabilidad`, `docs/readme-instalacion`).
2. Restaura el entorno con `renv::restore()` y ejecuta `source("main.R")`.
3. Corre las pruebas: `Rscript tests/validar_resultados.R`. Deben pasar todas.
4. Si cambias un resultado analítico (una definición, un umbral, una fórmula), explica en el *pull request* por qué y qué cifras cambian.
5. No agregues paquetes que no se usen; si agregas uno, actualiza `renv.lock` con `renv::snapshot()`.

## Convenciones

- Scripts en `scripts/`, numerados en el orden en que los ejecuta `main.R`.
- Rutas relativas a la raíz del proyecto; nunca rutas absolutas.
- Toda cifra que aparezca en el reporte o en las diapositivas debe salir de `output/tablas/` o del boletín oficial del DANE (`data/reference/`). Nada se escribe a mano.
- Español en comentarios y documentación.

## Datos

Los microdatos de la EMICRON son publicados por el DANE. Si propones incorporar otra fuente, indica su origen y sus condiciones de uso.

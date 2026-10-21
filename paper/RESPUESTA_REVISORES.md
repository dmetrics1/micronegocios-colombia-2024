# Respuesta a los revisores — LatinR 2026, envío #24

**Trabajo:** *Minería de Reglas de Asociación y Caracterización de la Economía Popular en Colombia: Un Enfoque de Datos Abiertos Basado en R y Quarto*
**Autor:** Daniel José Molina Barrios
**Decisión:** aceptado como presentación de 15 minutos (7 de agosto de 2026)

Agradezco a ambos revisores sus comentarios. A continuación detallo cómo se atendió cada observación del revisor XxTZ. Todos los cambios están en el repositorio público ([github.com/dmetrics1/micronegocios-colombia-2024](https://github.com/dmetrics1/micronegocios-colombia-2024)) y se reproducen con `renv::restore()` + `source("main.R")`.

---

## Revisor XxTZ

### 1. Mostrar el flujo en R, ejemplos de código, el proceso de depuración y las reglas obtenidas

- El reporte incluye una nueva sección, **"Cómo se construyó en R"**, con los fragmentos centrales de cada etapa: consolidación de los 11 módulos con `data.table`, depuración de códigos de no respuesta, construcción de índices, estadística ponderada, Apriori con medidas ponderadas y segmentación.
- La presentación de 15 minutos se organizará alrededor de ese flujo, con código y reglas concretas.
- La auditoría del pipeline para esta versión detectó y corrigió cuatro errores, que se documentan en el código y en el reporte como parte del proceso de depuración:
  1. El conteo de personal ocupado usaba el módulo de trabajadores, que está incompleto. Ahora usa la definición del DANE (propietario + trabajadores pagados + socios + familiares) y reproduce exactamente el boletín: 82,3% de negocios unipersonales y 6.879.489 personas ocupadas.
  2. Un gráfico de personal promedio por sector mostraba, en realidad, el porcentaje de negocios por sector.
  3. Las etiquetas del tipo de contabilidad en Apriori estaban desplazadas una categoría.
  4. Dos porcentajes por departamento no estaban ponderados.

### 2. Cómo se construyeron los índices de madurez digital y formalización

Ambos índices suman criterios binarios (`scripts/02_limpiar.R`):

- **Formalización (0–5):** tiene RUT, registro en Cámara de Comercio, lleva algún registro contable, paga salud y pensión, declara renta. Promedio ponderado: 0,81; el 60,7% de los negocios no cumple ningún criterio.
- **Digital (0–4):** usa internet, usa redes sociales, tiene página web, usa celular para el negocio. Promedio ponderado: 1,36.

El reporte presenta la definición, el código y la distribución ponderada de ambos índices.

### 3. Cómo se definieron los tres grupos

La segmentación del resumen original (65% / 8% / 27%) no provenía de un procedimiento reproducible dentro del pipeline. Ahora se define de forma explícita en `scripts/06_segmentacion.R`, cruzando acceso a internet (P2524) y tenencia de RUT (P1633). Los grupos resultantes son mutuamente excluyentes y exhaustivos:

| Grupo | Definición | % ponderado |
|---|---|---|
| Excluidos | Sin internet y sin RUT | 46,2% |
| En transición | Solo una de las dos | 35,7% |
| Integrados | Internet y RUT | 18,2% |

El crédito, el ahorro, los pagos digitales y el celular no intervienen en la definición; se usan para describir a los grupos, de modo que la caracterización no es circular. Por ejemplo, la aceptación de transferencias pasa de 5,7% en los excluidos a 86,9% en los integrados. La lectura cualitativa se mantiene (un grupo mayoritario excluido, uno intermedio y una minoría integrada), pero las proporciones correctas son las nuevas.

### 4. ¿Se incorporaron los factores de expansión en soporte, confianza y lift?

En la versión original, no: `apriori()` trata todos los registros con igual peso. Ahora F_EXP se asigna como peso de cada transacción y se recalculan soporte, confianza y lift ponderados con `arules::support(..., weighted = TRUE)` (función `medidas_ponderadas()`). El reporte presenta ambas versiones.

| Comparación (soporte ≥ 15%, confianza ≥ 70%) | Valor |
|---|---|
| Reglas en el conjunto muestral | 55.906 |
| Reglas del conjunto muestral que también cumplen los umbrales al ponderar | 55.282 (99%) |
| Correlación entre lift muestral y ponderado | 0,996 |

Las conclusiones no cambian; la posición exacta de las reglas en el ranking sí varía, porque las de mayor lift tienen valores casi idénticos (entre 1,97 y 2,01).

### 5. Justificar los umbrales, describir el filtrado de redundantes y evaluar la estabilidad

- **Justificación:**
  - El soporte de 15% exige que cada patrón se observe en ~11.600 registros (más de 790.000 negocios en el universo), lo que prioriza patrones con peso poblacional para política pública.
  - La confianza de 70% exige que la regla se cumpla en 7 de cada 10 casos.
  - Los antecedentes se limitan a tres ítems para que las reglas sean interpretables.
- **Redundancia:** se usa `arules::is.redundant()`. Una regla se elimina si existe otra más general, con el mismo consecuente, de igual o mayor confianza. De 119.456 reglas quedan 55.906.
- **Estabilidad** (`scripts/07_sensibilidad_apriori.R`): rejilla de soporte {10, 15, 20, 25%} × confianza {60, 70, 80, 90%}.
  - El número de reglas no redundantes va de 34.724 a 83.119.
  - Las dos reglas de exclusión digital aparecen en las 16 combinaciones.
  - La regla de TIC acopladas aparece en todas las combinaciones con confianza de hasta 80%; solo sale al exigir 90%, porque su confianza es de 89,6%.

### 6. Moderar conclusiones: RUT "exógeno" y efectos de la inclusión digital

Ambas observaciones eran correctas y se corrigieron.

- **RUT:** la ausencia de reglas hacia "tiene RUT" se debía al umbral de soporte. Al bajarlo al 5% aparecen reglas formadas solo por variables digitales y de ubicación —por ejemplo, {internet en el local, acepta transferencias, local fijo} ⇒ {tiene RUT}, con confianza de 77% y lift de 3,4—. Además, la regla de mayor lift del análisis es {tiene RUT, usa celular} ⇒ {acepta transferencias} (2,01). La conclusión pasa a ser que **el RUT está asociado con la digitalización y con el local fijo**; la afirmación de exogeneidad se retiró.
- **Causalidad:** se eliminaron las afirmaciones de que la inclusión digital "produce" o "potencia" efectos fiscales o crediticios. El reporte señala explícitamente que las reglas describen co-ocurrencias en datos de corte transversal, y las recomendaciones de política se presentan como propuestas normativas, no como estimaciones de impacto.

### Otras correcciones de cifras

- Muestra: **78.501** negocios encuestados. Los 77.202 citados en el resumen original corresponden a los registros completos usados en Apriori.
- Cuadros: el pipeline genera **70** cuadros ponderados (no 85).
- Validación contra el boletín DANE: se contrastaron 10 indicadores clave de 9 cuadros (automatizado en `tests/validar_resultados.R`). Nueve coinciden con diferencias inferiores a 0,1 puntos porcentuales y uno (agricultura) difiere en 1,06 puntos.
- Regla {sin celular} ⇒ {sin internet}: confianza de 98,7% (98,9% ponderada) y lift de 1,96 (1,89 ponderado). El lift de 1,97 citado originalmente corresponde a la regla de tres antecedentes.
- Regla {celular + pagos digitales} ⇒ {internet}: la confianza es de 89,6%. El "81%" del resumen original confundía el lift (1,81) con la confianza.

---

## Revisor SC8q

Gracias por los comentarios. La presentación mantendrá el recorrido completo —desde la limpieza de la encuesta hasta el informe en Quarto— y dedicará tiempo a mostrar el uso del paquete `arules`.

---

## Resumen actualizado (borrador para la versión final)

> Este trabajo presenta un pipeline reproducible en R para consolidar, depurar y analizar los microdatos de la Encuesta de Micronegocios (EMICRON) 2024 del DANE: 78.501 negocios que representan a 5,3 millones de micronegocios en Colombia. Con data.table se integran los once módulos de la encuesta y se generan 70 cuadros ponderados por los factores de expansión. Con el paquete arules se aplican reglas de asociación (Apriori) sobre 30 variables categóricas, y el soporte, la confianza y el lift se recalculan ponderando cada registro por su factor de expansión. Los resultados muestran que la exclusión digital es acumulada —los negocios sin dispositivos, sin celular y sin transferencias casi nunca tienen internet (confianza de 99,6%)—, que las herramientas digitales co-ocurren como sistema (lift ponderado de 1,87) y que la formalización fiscal se asocia con los pagos digitales y el local fijo. Los patrones son estables en 16 combinaciones de umbrales y al incorporar los factores de expansión. Una segmentación reproducible por acceso a internet y tenencia de RUT ubica al 46,2% de los negocios como excluidos, al 35,7% en transición y al 18,2% como integrados. Al tratarse de asociaciones en datos de corte transversal, los resultados orientan la focalización de políticas sin establecer efectos causales. Todo el análisis se documenta en un reporte en Quarto, con las versiones de los paquetes fijadas mediante renv.

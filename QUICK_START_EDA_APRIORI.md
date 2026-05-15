# ⚡ QUICK START: EDA + APRIORI EN 2 MINUTOS

---

## 🎯 PASO 1: COPIA Y PEGA EN RSTUDIO

```r
setwd("C:/Users/Estudiante/OneDrive - Universidad del Magdalena/marca_personal_dm/portafolio/emicron")
source("EJECUTAR_EDA_APRIORI_AHORA.R")
```

**LISTO. Espera 2 minutos.**

---

## 📊 QUÉ VAS A VER EN LA CONSOLA

```
=====================================================================
 EJECUCIÓN RÁPIDA: EDA + APRIORI — EMICRON 2024
 (~30 variables categóricas para análisis de patrones)
=====================================================================

[✓] Base analítica lista: data/processed/base_analitica.rds

[1/2] Ejecutando 04_eda.R (Gráficos exploratorios)...

Base cargada para Caracterización Multidimensional. Filas: 800000
✅ CARACTERIZACIÓN MULTIDIMENSIONAL COMPLETADA.

[2/2] Ejecutando 05_apriori.R (Reglas de asociación)...

Base analítica cargada: 800000 filas x 180 columnas
Transacciones: 800000 × XXX items

[Apriori está buscando patrones...]

>>> 247 reglas encontradas
>>> 180 reglas no redundantes

=== TOP 30 REGLAS POR LIFT ===
[Se mostrarán las 30 reglas más sorprendentes]

=== REGLAS → FORMALIZACIÓN (tiene_rut=Sí) ===
>>> 45 reglas → tiene_rut=Sí

=== REGLAS → PAGOS DIGITALES ===
>>> 38 reglas → pagos digitales

=== REGLAS → ADOPCIÓN TIC (internet_en_local=Sí) ===
>>> 52 reglas → internet_en_local=Sí

=== REGLAS → NEGOCIOS CONSOLIDADOS (10+ años) ===
>>> 41 reglas → 10+_años

=== GENERANDO VISUALIZACIONES ===
  - Scatter plot...
  ✓ 13_apriori_scatter_reglas.png
  - Grafo de red (Top 20)...
  ✓ 14_apriori_grafo_top20.png
  - Matriz agrupada...
  ✓ 15_apriori_grouped_matrix.png
  - Barplot de formalización...
  ✓ 16_apriori_reglas_formal_barplot.png

=====================================================================
 ✅ EJECUCIÓN COMPLETADA
=====================================================================

📊 RESULTADOS GENERADOS:

  EDA (Gráficos):
    - output/figuras/01_dist_sector.png
    - output/figuras/02_dist_sexo.png
    - output/figuras/03_indices_multidimensionales.png
    - output/figuras/04_ingresos_sector.png

  APRIORI (Patrones y Reglas):
    - output/tablas/06_reglas_asociacion_todas.csv (todas las reglas)
    - output/tablas/06a_reglas_top30_lift.csv (top 30)
    - output/tablas/07b_reglas_formalizacion.csv
    - output/tablas/07c_reglas_pagos_digitales.csv
    - output/tablas/07d_reglas_tic.csv
    - output/tablas/07e_reglas_antiguedad.csv

  Visualizaciones Apriori:
    - output/figuras/12_apriori_item_frequency.png (items frecuentes)
    - output/figuras/13_apriori_scatter_reglas.png (soporte vs confianza)
    - output/figuras/14_apriori_grafo_top20.png (red de patrones)
    - output/figuras/15_apriori_grouped_matrix.png (matriz agrupada)
    - output/figuras/16_apriori_reglas_formal_barplot.png

=====================================================================
 PRÓXIMO PASO: Revisar patrones y hacer análisis posterior
=====================================================================
```

---

## 🖼️ QUÉ VAS A TENER DESPUÉS

### Carpeta: `output/figuras/`

```
01_dist_sector.png
   ├─ Gráfico de barras: Distribución por sector
   └─ Probablemente Servicios tenga la mayor parte

02_dist_sexo.png
   ├─ Gráfico de barras: Hombre vs Mujer
   └─ Verás la brecha de género

03_indices_multidimensionales.png
   ├─ 2 gráficos lado a lado
   ├─ Izq: Formalización (0-5)
   └─ Der: Digitalización (0-4)

04_ingresos_sector.png
   ├─ Ingresos promedios por sector
   └─ Qué sector gana más

12_apriori_item_frequency.png
   ├─ Top 30 items más frecuentes
   └─ Ej: "No tiene RUT" (45%), "No tiene internet" (41%)

13_apriori_scatter_reglas.png
   ├─ Soporte (x) vs Confianza (y)
   └─ Reglas = puntos, coloreados por Lift

14_apriori_grafo_top20.png
   ├─ Red de 20 mejores reglas
   ├─ Nodos = categorías
   └─ Aristas = relaciones

15_apriori_grouped_matrix.png
   ├─ Matriz de reglas agrupadas
   └─ Patrones organizados por similaridad

16_apriori_reglas_formal_barplot.png
   ├─ Top 15 reglas que llevan a formalización
   └─ Barra por barra qué influye más
```

### Carpeta: `output/tablas/`

```
06_reglas_asociacion_todas.csv
   ├─ TODAS las reglas encontradas (180+)
   └─ Columnas: lhs, rhs, support, confidence, lift

06a_reglas_top30_lift.csv
   ├─ Las 30 reglas más sorprendentes
   ├─ Ordenadas por LIFT (impacto)
   └─ MEJOR PARA REVISAR PRIMERO

07b_reglas_formalizacion.csv
   ├─ Solo reglas → tiene_rut=Sí
   ├─ Responde: ¿Qué lleva a formalizarse?
   └─ ~45 reglas

07c_reglas_pagos_digitales.csv
   ├─ Solo reglas → pagos digitales
   ├─ Responde: ¿Qué lleva a pagos digitales?
   └─ ~38 reglas

07d_reglas_tic.csv
   ├─ Solo reglas → internet_en_local=Sí
   ├─ Responde: ¿Qué lleva a tener internet?
   └─ ~52 reglas

07e_reglas_antiguedad.csv
   ├─ Solo reglas → 10+_años
   ├─ Responde: ¿Qué caracteriza negocios consolidados?
   └─ ~41 reglas
```

---

## 🔍 ANÁLISIS POSTERIOR: 5 MINUTOS

Una vez termina la ejecución:

### **PASO 1: Ver EDA gráficos** (2 min)
- Abre `output/figuras/01-04_*.png`
- Identifica cuál es el sector más grande
- Nota la brecha de género
- Mira dónde están los índices

### **PASO 2: Revisar Top 30 reglas** (3 min)
- Abre `output/tablas/06a_reglas_top30_lift.csv` en Excel
- Ordena por LIFT (columna última)
- Lee las primeras 10 reglas
- Pregúntate: ¿Esto tiene sentido?

### **PASO 3: Responder 5 preguntas** (5 min)
```
1. ¿Cuál es el PRIMER paso para formalización?
   (Mira 07b_reglas_formalizacion.csv)
   
2. ¿Hay un patrón de TIC? (internet → redes → pagos?)
   (Mira 07d_reglas_tic.csv y 07c_reglas_pagos_digitales.csv)
   
3. ¿Las mujeres se comportan diferente?
   (Busca "Mujer" en 06a_reglas_top30_lift.csv)
   
4. ¿Qué distingue a negocios de 10+ años?
   (Mira 07e_reglas_antiguedad.csv)
   
5. ¿Hay diferencias claras por sector?
   (Mira 06a_reglas_top30_lift.csv, busca "Sector_")
```

---

## 💡 EJEMPLO DE PATRÓN QUE ENCONTRARÁS

```
Si ves esta regla en TOP 30:

LHS: sector=Sector_9 AND tiempo_funcionamiento=10+_años
RHS: tiene_rut=Sí
Support: 18%
Confidence: 82%
Lift: 2.1

SIGNIFICA:
─────────
• 18% de negocios cumplen AMBAS condiciones 
  (sector 9, más de 10 años)
  
• De esos, 82% tiene RUT
  (mucho más que el promedio ~39%)
  
• Es 2.1x más probable tener RUT si cumples esas condiciones
  (sorpresa: 2.1 > 1, es un patrón fuerte)

ACCIÓN:
───────
→ Sector 9 + antigüedad lleva a RUT
→ Pregunta: ¿Cuál es el mecanismo?
   (¿porque exige sector? ¿porque 10 años da experiencia?)
```

---

## 🚦 QUÉ HACER SI ALGO FALLA

### Error: "base_analitica.rds no existe"
```r
# Ejecuta primero:
setwd("C:/Users/Estudiante/OneDrive - Universidad del Magdalena/marca_personal_dm/portafolio/emicron")
source("scripts/01_consolidar.R")
source("scripts/02_limpiar.R")

# Luego:
source("EJECUTAR_EDA_APRIORI_AHORA.R")
```

### Error: "paquete 'arules' no existe"
```r
# Instala:
install.packages("arules")
install.packages("arulesViz")
install.packages("ggplot2")

# Luego repite
```

### Apriori da 0 reglas
- Significa que no hay patrones con soporte ≥15% y confianza ≥70%
- Baja los umbrales en script 05:
  ```r
  parameter = list(supp = 0.10, conf = 0.50, ...)  # más permisivo
  ```

---

## 📌 TIMELINE TOTAL

```
Ahora:           Ejecutar scripts 04+05           2 minutos
                 ✓ Gráficos listos
                 ✓ Reglas CSV listos

2-5 min:         Ver gráficos EDA                3 minutos
                 ✓ Preguntas: ¿Qué sector?
                 ✓ ¿Qué género?
                 ✓ ¿Qué índices?

5-10 min:        Revisar Top 30 reglas           5 minutos
                 ✓ Leer mejores patrones
                 ✓ Identificar sorpresas

10-20 min:       Responder 5 preguntas           10 minutos
                 ✓ Formalización: qué lleva?
                 ✓ TIC: cuál es el flujo?
                 ✓ Género: hay diferencias?
                 ✓ Antigüedad: qué cambia?
                 ✓ Sector: qué distingue?

TOTAL:           ~20 minutos para análisis completo
```

---

## ✅ RESULTADO ESPERADO

**2 minutos de ejecución + 20 minutos de análisis = 22 minutos total**

**Outputs:**
- ✅ 4 gráficos EDA claros
- ✅ 180+ reglas de asociación encontradas
- ✅ Top 30 reglas identificadas
- ✅ 4 análisis dirigidos (formalización, TIC, pagos, antigüedad)
- ✅ Respuestas a 5 preguntas clave sobre micronegocios

**Next step:**
Luego ejecutas script 03 COMPLETO (77 cuadros) con CONFIANZA de que los patrones son reales.

---

## 🚀 ¡A EMPEZAR!

**En RStudio:**

```r
setwd("C:/Users/Estudiante/OneDrive - Universidad del Magdalena/marca_personal_dm/portafolio/emicron")
source("EJECUTAR_EDA_APRIORI_AHORA.R")
```

**Espera 2 minutos. Eso es todo. Los gráficos y patrones aparecerán automáticamente.**

---

**¿Preguntas? Después de ejecutar, comparte los resultados y hacemos análisis.**

# EMICRON 2024 - Análisis Integral de Micronegocios Colombianos

[![R](https://img.shields.io/badge/R-4.0%2B-276DC3?logo=r)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production-brightgreen.svg)]()

**Análisis completo de 5.3M micronegocios | 70+ cuadros DANE | Minería de patrones | Reportería interactiva**

## 🎯 Descripción

Este repositorio contiene un **pipeline de análisis integral** de la Encuesta de Micronegocios (EMICRON) 2024 del DANE, que combina:

✅ **Validación de cuadros oficiales DANE**  
✅ **70+ tablas estadísticas** procesadas y exportadas  
✅ **Análisis exploratorio (EDA)** con visualizaciones avanzadas  
✅ **Minería de reglas de asociación (Apriori)** para descubrir patrones  
✅ **Reportes HTML profesionales** con Quarto + R + CSS Grid  
✅ **Documentación completa** del flujo de análisis  

---

## 📊 Cobertura de Datos

| Métrica | Valor |
|---------|-------|
| **Universo** | 5,297,252 micronegocios (Colombia) |
| **Muestra** | 77,202 negocios encuestados |
| **Período** | 2024 |
| **Módulos** | 11 (Identificación, TIC, Ventas, etc.) |
| **Cuadros Generados** | 70+ estadísticos |
| **Fuente** | [DANE Oficial](https://www.dane.gov.co/) |

---

## 🚀 Inicio Rápido

### Requisitos Previos

```bash
# R 4.0+ instalado
# RStudio (recomendado)
# Quarto CLI (para reportes)
```

### Instalación de Dependencias

```r
# Ejecutar en R Console
packages <- c("tidyverse", "haven", "arules", "arulesViz", "data.table")
install.packages(packages)
```

```r
# En RStudio, abre emicron.Rproj y luego ejecuta el pipeline completo:
source("main.R")
```

### Generar Reportes HTML

```bash
cd reports/source
quarto render REPORTE_WIDE_PRO_2024.qmd --to html
```

**Resultado:** `REPORTE_WIDE_PRO_2024.html` (en la raíz del proyecto)

---

## 📁 Estructura del Proyecto

```
emicron/
│
├── 📄 README.md                    # Este archivo
├── 📄 EJECUTAR_AQUI.md             # Instrucciones de ejecución rápida y checklist
├── 📄 RUTA_A_10_PUNTOS_PERFECCION.md # Plan para perfeccionar el reporte final
├── 📄 Diccionario_EMICRON_2024.md  # Diccionario detallado de variables EMICRON
├── 📄 PROTOCOLO_MAESTRO_EMICRON.md # Protocolo de procesamiento y metodologías DANE
├── 📄 AUDITORIA_DATA_STORYTELLING_FINAL.md # Primera auditoría del reporte
├── 📄 AUDITORIA_SEGUIMIENTO_POST_CAMBIOS.md # Seguimiento de cambios realizados v2
├── 📄 AUDITORIA_FINAL_DOCUMENTO_EXPANDIDO.md # Auditoría final para reporte expandido v3
├── 📄 REPORTE_WIDE_PRO_2024.qmd    # Reporte interactivo final en Quarto (diseño ancho premium)
├── 📄 REPORTE_WIDE_PRO_2024.html   # Reporte interactivo compilado en formato HTML
├── 📄 custom-wide-pro.scss         # Estilos SCSS premium para el reporte
├── 📄 main.R                       # Pipeline principal unificado de ejecución secuencial
├── 📄 EJECUTAR_EDA_APRIORI_AHORA.R # Script rápido para ejecutar solo EDA + Apriori
├── 📄 ANALISIS_REGLAS_SOPORTE_24.R # Script de análisis de reglas con soporte >= 24%
├── 📄 emicron.Rproj                # Proyecto RStudio
└── 📄 .gitignore                   # Configuración de Git
│
├── 📂 data/
│   ├── raw/                        # Datos DANE originales (CSV)
│   │   └── 2024/
│   │       ├── capital_social.csv
│   │       ├── caracteristicas.csv
│   │       ├── costos_gastos.csv
│   │       └── ... (11 archivos oficiales DANE)
│   └── processed/                  # Datos RDS intermedios consolidados y limpios
│
├── 📂 scripts/                     # Pipeline de análisis R
│   ├── 00_config.R                 # Configuración global y carga de paquetes
│   ├── 01_consolidar.R             # Unión y consolidación de módulos DANE
│   ├── 02_limpiar.R                # Limpieza, feature engineering y etiquetado DANE
│   ├── 03_cuadros_boletin_COMPLETO.R # Generación de 85 cuadros estadísticos completos
│   ├── 04_eda.R                    # Análisis Exploratorio de Datos y visualizaciones
│   ├── 04b_graficos_cuadros_dane.R # Gráficos estadísticos de cuadros oficiales
│   └── 05_apriori.R                # Minería de reglas de asociación con algoritmo Apriori
│
├── 📂 reports/
│   ├── source/                     # Estilos y recursos Quarto adicionales
│   │   └── custom-emicron.scss
│   ├── html/                       # Reportes HTML generados
│   └── pdf/                        # Boletines DANE oficiales descargados
│
├── 📂 output/
│   ├── tablas/                     # CSVs con resultados de Apriori y cuadros
│   │   └── boletin/                # 85 archivos CSV con cuadros descriptivos ponderados
│   ├── figuras/                    # Visualizaciones exploratorias y de minería generadas
│   └── informes/                   # Informes auxiliares
│
└── 📂 docs/                        # Documentación complementaria y metodológica
    ├── CUADROS_NUEVOS_AGREGADOS.md # Catálogo detallado de los nuevos cuadros agregados
    ├── RESUMEN_CAMBIOS_FLUJO_COMPLETO.md # Registro del proceso de desarrollo y de cambios en el flujo
    ├── PLAN_EDA_APRIORI_ANALISIS_POSTERIOR.md # Plan estratégico del análisis posterior
    ├── PROMPT_EXTRACCION_GRAFICOS_DANE.md # Herramientas para validación contra PDF DANE
    ├── STATUS_EJECUCION_PIPELINE_V3.md # Estado actual del pipeline (100% completado y verificado)
    ├── GUIA_GRAFICOS_REPORTE_QMD.md # Guía metodológica de los 25 gráficos del reporte
    ├── INDICE_25_GRAFICOS_REPORTE.md # Índice estructurado de visualizaciones
    └── informe_caracterizacion_y_reglas.md # Síntesis ejecutiva de hallazgos descriptivos y Apriori
```

---

## 🔍 Flujo de Análisis

```
Data DANE (11 CSV)
       ↓
[01] Consolidar → Unión de todos los módulos DANE
       ↓
[02] Limpiar → Limpieza de datos, feature engineering y etiquetado DANE
       ↓
[03] Cuadros Boletín COMPLETO → Generación de 85 cuadros estadísticos ponderados
       ↓
output/tablas/boletin/ → 85 CSVs exportados con resultados descriptivos
       ↓
[04] EDA + [04b] Gráficos → Visualizaciones exploratorias y gráficos de boletines
       ↓
[05] Apriori → Minería de reglas de asociación (Algoritmo Apriori)
       ↓
docs/informe_caracterizacion_y_reglas.md ← Síntesis ejecutiva de patrones encontrados
       ↓
REPORTE_WIDE_PRO_2024.qmd → Renderizado interactivo final en HTML
```

---

## 📈 Cuadros Generados

**Por Tema:**
- ✅ Identificación y Caracterización (10)
- ✅ Aspecto Empresarial (8)
- ✅ Empleo y Personal (12)
- ✅ Financiero e Ingresos (15)
- ✅ TIC y Digitalización (8)
- ✅ Inclusión Financiera (7)
- ✅ Capital Social (8)

**Ubicación:** `output/tablas/boletin/*.csv`

---

## 🎨 Reportería

El reporte interactivo principal del proyecto se encuentra en la raíz:

- **REPORTE_WIDE_PRO_2024.qmd** — Reporte de alto impacto con diseño optimizado para pantalla ancha, rejilla CSS Grid, visualizaciones interactivas de ggplot2, tablas con formato dinámico y navegación estructurada.

**Características:**
- Visualizaciones interactivas con ggplot2 y formateo avanzado.
- Tablas profesionales con métricas ponderadas.
- Barra lateral de navegación sticky de 320px + contenido principal adaptativo.
- Estilos personalizados premium (basados en `custom-wide-pro.scss`).

---

## 🧪 Validación

✅ Cuadros validados contra boletines DANE oficiales  
✅ Hallazgos Apriori filtrados por soporte ≥15% y confianza ≥70%  
✅ Documentación de catálogo y cambios en `docs/CUADROS_NUEVOS_AGREGADOS.md`

---

## 📚 Documentación Completa

| Documento | Propósito | Ubicación |
|-----------|-----------|-----------|
| `PROTOCOLO_MAESTRO_EMICRON.md` | Metadatos y metodologías oficiales de procesamiento ponderado del DANE | Raíz |
| `Diccionario_EMICRON_2024.md` | Diccionario detallado de variables y variables derivadas | Raíz |
| `EJECUTAR_AQUI.md` | Guía de ejecución secuencial del pipeline y checklists de validación | Raíz |
| `RUTA_A_10_PUNTOS_PERFECCION.md` | Plan y criterios de excelencia analítica y de diseño del reporte | Raíz |
| `docs/STATUS_EJECUCION_PIPELINE_V3.md` | Estado técnico detallado del pipeline (100% Completado y verificado) | `docs/` |
| `docs/CUADROS_NUEVOS_AGREGADOS.md` | Catálogo detallado de los 85 cuadros generados y cobertura DANE | `docs/` |
| `docs/RESUMEN_CAMBIOS_FLUJO_COMPLETO.md` | Historial técnico de cambios y mejoras en el flujo de main.R | `docs/` |
| `docs/informe_caracterizacion_y_reglas.md` | Síntesis ejecutiva de hallazgos descriptivos y patrones Apriori | `docs/` |
| `docs/PLAN_EDA_APRIORI_ANALISIS_POSTERIOR.md` | Plan de análisis posterior, hipótesis y variables analíticas | `docs/` |
| `docs/PROMPT_EXTRACCION_GRAFICOS_DANE.md` | Herramientas automatizadas para validar contra reportes PDF oficiales | `docs/` |

---

## 🛠️ Stack Tecnológico

- **Lenguaje:** R 4.0+
- **Procesamiento:** tidyverse, data.table
- **Minería:** arules, arulesViz
- **Reportería:** Quarto, ggplot2
- **Estilos:** SCSS, CSS Grid

---

## 📊 Casos de Uso

- **Política Pública:** Entender factores de formalización y digitalización
- **Investigación Académica:** Análisis de economía informal en Colombia
- **Emprendimiento:** Identificar brechas y oportunidades por sector
- **Inclusión Financiera:** Caracterizar adopción de medios de pago

---

## 📄 Licencia

MIT License - Úsalo libremente con atribución.

---

## 👤 Autor

**Daniel Molina** | Análisis de Datos & Estadística  
📧 dm0025900@gmail.com

---

## 🙏 Créditos

- **Datos:** DANE - Encuesta de Micronegocios (EMICRON) 2024
- **Metodología:** Análisis exploratorio + Apriori (arules)
- **Reportería:** Quarto v1.0+

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

### Ejecutar el Pipeline

```r
# En RStudio, abre emicron.Rproj y luego:
source("scripts/00_config.R")           # ← Cargar configuración
source("scripts/01_consolidar.R")       # ← Consolidar datos DANE
source("scripts/03_cuadros_boletin.R") # ← Generar 70 cuadros
source("scripts/05_apriori.R")         # ← Análisis de patrones
```

### Generar Reportes HTML

```bash
cd reports/source
quarto render REPORTE_COMPLETO_EMICRON_2024.qmd --to html
```

**Resultado:** `reports/html/REPORTE_COMPLETO_EMICRON_2024.html`

---

## 📁 Estructura del Proyecto

```
emicron-2024-analysis/
│
├── 📄 README.md                    # Este archivo
├── 📄 .gitignore                   # Configuración git
│
├── 📂 data/
│   ├── raw/                        # Datos DANE originales (CSV)
│   │   └── 2024/
│   │       ├── capital_social.csv
│   │       ├── caracteristicas.csv
│   │       ├── costos_gastos.csv
│   │       └── ... (9 archivos)
│   └── processed/                  # Datos procesados
│
├── 📂 scripts/                      # Pipeline de análisis
│   ├── 00_config.R                 # Configuración global
│   ├── 01_consolidar.R             # Unión de módulos DANE
│   ├── 03_cuadros_boletin.R       # Generación de 70 cuadros
│   └── 05_apriori.R                # Minería de reglas (Apriori)
│
├── 📂 reports/
│   ├── source/                     # Reportes Quarto (.qmd)
│   │   ├── REPORTE_COMPLETO_EMICRON_2024.qmd
│   │   ├── REPORTE_UNIFICADO_EMICRON_2024.qmd
│   │   ├── custom-emicron.scss
│   │   └── custom-wide-pro.scss
│   ├── html/                       # Reportes HTML generados
│   └── pdf/                        # Boletines DANE originales
│
├── 📂 output/
│   ├── tablas/
│   │   └── boletin/                # 70+ CSV con cuadros
│   └── informes/
│
├── 📂 docs/                        # Documentación
│   ├── PROTOCOLO_MAESTRO_EMICRON.md
│   ├── Diccionario_EMICRON_2024.md
│   ├── HALLAZGOS_PRINCIPALES_APRIORI.md
│   └── STATUS_EJECUCION_PIPELINE_V3.md
│
└── emicron.Rproj                   # Proyecto RStudio
```

---

## 🔍 Flujo de Análisis

```
Data DANE (9 CSV)
       ↓
[01] Consolidar → Unión de módulos + limpieza
       ↓
[03] Cuadros → Generación de 70+ tablas estadísticas
       ↓
output/tablas/ → CSV exportados
       ↓
[05] Apriori → Minería de reglas de asociación
       ↓
docs/HALLAZGOS_PRINCIPALES_APRIORI.md ← Patrones encontrados
       ↓
Reportes HTML (Quarto) → Visualización final
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

Tres versiones de reportes generados con **Quarto + R + CSS Grid**:

1. **REPORTE_COMPLETO_EMICRON_2024.qmd** — Visión integral con TOC sticky
2. **REPORTE_UNIFICADO_EMICRON_2024.qmd** — Síntesis consolidada
3. **REPORTE_WIDE_PRO_2024.qmd** — Diseño optimizado para pantalla ancha

**Características:**
- Visualizaciones interactivas con ggplot2
- Tablas profesionales con formato
- TOC sticky de 320px + contenido responsivo
- Estilos personalizados EMICRON (azul #0072B2)

---

## 🧪 Validación

✅ Cuadros validados contra boletines DANE oficiales  
✅ Hallazgos Apriori filtrados por soporte ≥15% y confianza ≥70%  
✅ Documentación de cambios en `docs/COMPARACION_CUADROS_LEGACY_VS_ACTUAL.md`

---

## 📚 Documentación Completa

| Documento | Propósito |
|-----------|----------|
| `PROTOCOLO_MAESTRO_EMICRON.md` | Metadatos y diccionario de variables |
| `HALLAZGOS_PRINCIPALES_APRIORI.md` | Reglas y patrones descubiertos |
| `STATUS_EJECUCION_PIPELINE_V3.md` | Estado actual del análisis |
| `COMPARACION_CUADROS_LEGACY_VS_ACTUAL.md` | Validación de cambios |

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

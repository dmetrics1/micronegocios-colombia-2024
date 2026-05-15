---
name: r-reportes-impacto
description: >
  Crea informes, reportes y documentos profesionales de alto impacto en R usando R Markdown, Quarto, flexdashboard, officedown, pagedown y el ecosistema completo de publicación reproducible. Activa esta skill SIEMPRE que el usuario mencione: "informe en R", "reporte en R", "R Markdown", "Quarto", "documento reproducible", "reporte automático", "dashboard en R", "reporte con gráficos", "informe de datos", "reporte estadístico", "informe ejecutivo en R", "PDF con R", "Word con R", "HTML con R", "reporte técnico R", "informe académico R", "publicación con R", "reporte de análisis", "plantilla de reporte R", o cualquier combinación de R + informe/reporte/documento/publicación. También activa cuando el usuario tiene datos y quiere generar un informe o presentación profesional, aunque no mencione explícitamente "skill". Si están trabajando en R y quieren documentar o comunicar resultados, este skill aplica siempre.
---

# 📄 Informes y Reportes de Alto Impacto en R

## Ecosistema de Publicación en R — Elegir la Herramienta Correcta

| Objetivo | Herramienta | Formato salida |
|----------|-------------|----------------|
| Reporte técnico/académico | **Quarto** | PDF, HTML, Word, RevealJS |
| Dashboard interactivo | **flexdashboard** + Shiny | HTML |
| Word profesional con tablas | **officedown** | .docx |
| PDF paginado tipo libro | **pagedown** | PDF |
| Reporte paramétrico (lotes) | **Quarto** con params | Múltiples outputs |
| Presentación ejecutiva | **Quarto RevealJS** | HTML interactivo |
| Informe estático elegante | **R Markdown** + `prettydoc` | HTML |

> **Recomendación 2024-2025:** Usa **Quarto** por defecto. Es el sucesor oficial de R Markdown, más potente y con mejor diseño por default.

---

## Setup — Instalar Todo el Ecosistema

```r
paquetes <- c(
  # Core de publicación
  "quarto", "rmarkdown", "knitr",
  
  # Tablas de alta calidad
  "gt", "gtExtras", "gtsummary", "flextable", "kableExtra", "DT",
  
  # Word / PowerPoint profesional
  "officedown", "officer", "rvg",
  
  # PDF y HTML elegante
  "pagedown", "prettydoc", "rmdformats",
  
  # Dashboard
  "flexdashboard", "shiny", "bslib",
  
  # Análisis y reporte estadístico
  "tidyverse", "modelsummary", "parameters", "performance", "report",
  
  # Tipografía y diseño
  "showtext", "ggtext", "patchwork", "scales",
  
  # Misceláneos útiles
  "glue", "janitor", "skimr", "reactable", "sparkline"
)
install.packages(paquetes[!paquetes %in% installed.packages()[,"Package"]])
```

---

## 🏗️ Estructura YAML de Alto Impacto (Quarto)

### Para HTML Profesional

```yaml
---
title: "Análisis de Ventas — Q3 2024"
subtitle: "Reporte ejecutivo con tendencias y proyecciones"
author: 
  - name: "Tu Nombre"
    affiliation: "Empresa / Institución"
    email: "correo@empresa.com"
date: today
date-format: "D [de] MMMM [de] YYYY"
lang: es

format:
  html:
    theme: [cosmo, custom.scss]    # o: flatly, litera, journal
    toc: true
    toc-depth: 3
    toc-location: left             # left, right, body
    toc-title: "Contenido"
    number-sections: true
    code-fold: true                # código colapsable
    code-tools: true               # botón copiar código
    code-line-numbers: true
    smooth-scroll: true
    embed-resources: true          # HTML autónomo, sin dependencias
    fig-width: 9
    fig-height: 5.5
    fig-dpi: 300
    df-print: paged                # tablas paginadas automáticas

execute:
  echo: false          # ocultar código en output por default
  warning: false
  message: false
  cache: true          # cachear para builds rápidos

params:
  region: "Latinoamérica"
  año: 2024
  umbral_alerta: 0.05
---
```

### Para PDF Académico/Ejecutivo

```yaml
---
title: "Informe Técnico"
format:
  pdf:
    documentclass: article         # article, report, book
    papersize: letter
    margin-left: 2.5cm
    margin-right: 2.5cm
    margin-top: 3cm
    margin-bottom: 3cm
    toc: true
    toc-depth: 2
    number-sections: true
    colorlinks: true
    linkcolor: "0072B2"
    include-in-header:
      text: |
        \usepackage{fancyhdr}
        \usepackage{booktabs}
        \pagestyle{fancy}
        \fancyhead[L]{\textit{Informe Confidencial}}
        \fancyhead[R]{\thepage}
        \fancyfoot[C]{\textit{Tu Empresa — 2024}}
---
```

### Para Word Corporativo (con officedown)

```yaml
---
title: "Reporte Ejecutivo"
output:
  officedown::rdocx_document:
    reference_docx: assets/templates/plantilla-corporativa.docx
    plots:
      style: Normal
      align: center
      fig.lp: 'fig:'
    tables:
      style: Table
      layout: autofit
    page_size:
      width: 8.5
      height: 11
    page_margins:
      bottom: 1
      top: 1
      right: 1.25
      left: 1.25
---
```

---

## 📐 Estructura de Secciones de Alto Impacto

Consulta `references/estructura-secciones.md` para el esqueleto completo.

### Resumen de la Estructura Estándar:

```
1. PORTADA EJECUTIVA
   ├── Título, subtítulo, autor, fecha
   ├── Resumen ejecutivo (5-7 oraciones)
   └── Indicadores clave (KPIs) en tarjetas visuales

2. INTRODUCCIÓN / CONTEXTO
   ├── Problema u objetivo
   ├── Alcance del análisis
   └── Fuentes de datos

3. METODOLOGÍA (si aplica)

4. RESULTADOS / HALLAZGOS
   ├── Sección por tema/variable
   ├── Gráfico → Interpretación → Tabla de soporte
   └── Callouts con hallazgos clave

5. DISCUSIÓN / IMPLICACIONES

6. CONCLUSIONES Y RECOMENDACIONES
   ├── Puntos accionables numerados
   └── Próximos pasos

7. APÉNDICES (código, tablas completas, metadata)
```

---

## 🎴 KPI Cards / Tarjetas de Indicadores Clave

```r
# Con gt + gtExtras — Las más impactantes visualmente
library(gt)
library(gtExtras)

kpi_data <- tibble(
  indicador = c("Ventas totales", "Clientes nuevos", "Tasa de retención", "NPS"),
  valor     = c("$2.4M", "1,847", "89.3%", "72"),
  cambio    = c("+12.4%", "+8.1%", "-0.7%", "+5pts"),
  tendencia = list(c(1.8, 2.0, 1.9, 2.1, 2.4),
                   c(1600, 1650, 1700, 1780, 1847),
                   c(91, 90.5, 90.1, 89.8, 89.3),
                   c(65, 67, 69, 70, 72)),
  bueno     = c(TRUE, TRUE, FALSE, TRUE)
)

kpi_data %>%
  gt() %>%
  gt_plt_sparkline(tendencia, type = "shaded", palette = c("grey60", "transparent", "transparent", "#2196F3", "#2196F3")) %>%
  gt_color_rows(bueno, palette = c("#FFEBEE", "#E8F5E9"), columns = indicador) %>%
  gt_theme_espn() %>%
  cols_label(indicador = "Indicador", valor = "Valor", cambio = "vs periodo anterior", tendencia = "Tendencia") %>%
  tab_header(title = md("**Indicadores Clave de Desempeño**"), subtitle = "Q3 2024") %>%
  tab_options(table.width = pct(100))
```

---

## 📊 Tablas de Alto Impacto con gt

```r
library(gt)
library(gtExtras)

# Tabla ejecutiva completa
mi_tabla <- datos_resumen %>%
  gt(rowname_col = "categoria") %>%
  
  # Encabezado
  tab_header(
    title    = md("**Resumen de Resultados**"),
    subtitle = md("*Período: Enero–Diciembre 2024*")
  ) %>%
  
  # Grupos de columnas
  tab_spanner(label = "Ventas", columns = c(q1, q2, q3, q4)) %>%
  tab_spanner(label = "Comparativo", columns = c(año_ant, variacion)) %>%
  
  # Formato de números
  fmt_currency(columns = c(q1, q2, q3, q4, año_ant), currency = "USD", decimals = 0) %>%
  fmt_percent(columns = variacion, decimals = 1) %>%
  
  # Color condicional
  data_color(
    columns = variacion,
    method  = "numeric",
    palette = c("#FFCDD2", "white", "#C8E6C9"),
    domain  = c(-0.3, 0, 0.3)
  ) %>%
  
  # Barra de progreso en columna
  gt_plt_bar_pct(column = progreso, scaled = TRUE, fill = "#2196F3") %>%
  
  # Fuente y notas
  tab_source_note(md("**Fuente:** Sistema ERP — Extracción al 31/12/2024")) %>%
  tab_footnote(footnote = "Incluye ventas digitales y presenciales",
               locations = cells_column_labels(q4)) %>%
  
  # Estilo
  gt_theme_guardian() %>%  # guardian, espn, nytimes, dot_matrix, pff, excel, dark
  tab_options(
    table.width         = pct(100),
    heading.align       = "left",
    column_labels.font.weight = "bold"
  )

mi_tabla
```

---

## 💬 Callouts / Cajas de Alerta (Quarto nativo)

```markdown
::: {.callout-note}
## 📌 Nota importante
Este análisis excluye datos del mes de diciembre por cierre contable pendiente.
:::

::: {.callout-warning}
## ⚠️ Atención
La tasa de retención cayó 0.7 puntos porcentuales respecto al trimestre anterior.
:::

::: {.callout-tip}
## 💡 Recomendación
Implementar programa de fidelización en segmento B para recuperar la retención.
:::

::: {.callout-important}
## 🔴 Acción requerida
El margen EBITDA está por debajo del umbral mínimo (15%) en 3 regiones.
:::
```

---

## 🎨 CSS/SCSS Personalizado para HTML (Quarto)

Crea `custom.scss` en la misma carpeta del .qmd:

```scss
/*-- scss:defaults --*/
$font-family-sans-serif: "DM Sans", -apple-system, sans-serif;
$headings-font-family: "Outfit", sans-serif;
$body-bg: #FAFAF8;
$body-color: #1a1a1a;
$link-color: #2196F3;
$primary: #2196F3;

/*-- scss:rules --*/

/* Portada elegante */
.quarto-title-block {
  background: linear-gradient(135deg, #1B1B2F 0%, #2D3561 100%);
  color: white;
  padding: 3rem 2rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  
  .title { font-size: 2.2rem; font-weight: 800; }
  .subtitle { opacity: 0.85; font-size: 1.1rem; }
}

/* KPI cards */
.kpi-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
  border-left: 4px solid #2196F3;
  margin-bottom: 1rem;
}

/* Secciones con separador visual */
h2 {
  border-bottom: 2px solid #E8ECEF;
  padding-bottom: 0.5rem;
  margin-top: 2.5rem;
}

/* Tabla de contenidos sticky */
#TOC {
  position: sticky;
  top: 1rem;
  max-height: 90vh;
  overflow-y: auto;
}

/* Highlight de hallazgos clave */
.hallazgo {
  background: #FFF9C4;
  border-left: 4px solid #F9A825;
  padding: 1rem 1.5rem;
  margin: 1.5rem 0;
  border-radius: 0 8px 8px 0;
  font-weight: 500;
}
```

---

## 🔄 Reportes Paramétricos (Automáticos por Región/Cliente)

```r
# render_reportes.R — Genera un reporte por cada región automáticamente

library(quarto)
library(purrr)

regiones <- c("Bogotá", "Medellín", "Cali", "Barranquilla")

walk(regiones, function(region) {
  quarto_render(
    input       = "reporte_base.qmd",
    output_file = glue::glue("Reporte_{region}_2024.html"),
    execute_params = list(
      region = region,
      año    = 2024
    )
  )
  message("✅ Reporte generado: ", region)
})
```

---

## 📋 Tablas Estadísticas con gtsummary

```r
library(gtsummary)

# Tabla de características de la muestra (estilo clínico/académico)
datos %>%
  select(edad, sexo, tratamiento, resultado, p_valor) %>%
  tbl_summary(
    by = tratamiento,
    statistic = list(
      all_continuous()  ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits  = all_continuous() ~ 1,
    missing = "no",
    label   = list(
      edad      ~ "Edad (años)",
      sexo      ~ "Sexo",
      resultado ~ "Resultado primario"
    )
  ) %>%
  add_p(test = list(all_continuous() ~ "t.test")) %>%
  add_overall() %>%
  bold_labels() %>%
  modify_header(label = "**Variable**") %>%
  modify_caption("**Tabla 1.** Características basales por grupo") %>%
  as_gt() %>%
  gt_theme_guardian()
```

---

## 📱 Dashboard con flexdashboard + bslib

```r
---
title: "Dashboard Ejecutivo"
output:
  flexdashboard::flex_dashboard:
    theme:
      version: 5
      bootswatch: flatly       # flatly, litera, minty, pulse, sandstone
      base_font: !expr bslib::font_google("DM Sans")
      heading_font: !expr bslib::font_google("Outfit")
      primary: "#2196F3"
    orientation: rows
    vertical_layout: fill
    navbar:
      - { title: "Inicio", icon: "fa-home", href: "#" }
    logo: assets/logo.png
runtime: shiny                 # quitar si no necesitas interactividad
---
```

---

## 📚 Referencias Adicionales

- `references/estructura-secciones.md` — Esqueleto completo con código de cada sección
- `references/tablas-avanzadas.md` — gt, flextable, reactable, DT avanzado
- `references/word-pdf-avanzado.md` — officedown, pagedown, LaTeX en R
- `references/reporte-estadistico.md` — modelsummary, report, parameters, performance

---

## ✅ Checklist de Calidad del Reporte

**Antes de compartir:**
- [ ] ¿El resumen ejecutivo puede leerse en 60 segundos y entenderse solo?
- [ ] ¿Cada gráfico tiene título que describe la *conclusión* (no solo el tema)?
- [ ] ¿Las tablas tienen fuente, unidades y notas al pie?
- [ ] ¿Los callouts resaltan los hallazgos más accionables?
- [ ] ¿El TOC refleja la jerarquía real del documento?
- [ ] ¿El output es self-contained (sin rutas locales hardcodeadas)?
- [ ] ¿Probé el render en limpio (`Session → Restart R → Render`)?
- [ ] ¿Los parámetros están documentados si es reporte paramétrico?
- [ ] ¿El pie de página incluye fecha de generación y versión?
- [ ] ¿La tipografía es consistente en títulos, cuerpo y código?

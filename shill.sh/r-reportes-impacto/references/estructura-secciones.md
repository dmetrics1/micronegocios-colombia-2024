# Estructura Completa de Secciones — Código por Sección

## Plantilla Maestra .qmd — Esqueleto Completo

```markdown
---
title: "{{TÍTULO DEL REPORTE}}"
subtitle: "{{SUBTÍTULO — Período, Alcance, Versión}}"
author:
  - name: "{{Nombre Autor}}"
    affiliation: "{{Institución / Empresa}}"
date: today
date-format: "D [de] MMMM [de] YYYY"
lang: es
format:
  html:
    theme: [cosmo, custom.scss]
    toc: true
    toc-depth: 3
    toc-location: left
    toc-title: "📋 Contenido"
    number-sections: true
    code-fold: true
    embed-resources: true
    fig-width: 9
    fig-height: 5
execute:
  echo: false
  warning: false
  message: false
params:
  region: "Nacional"
  periodo: "Q3 2024"
---
```

---

## SECCIÓN 0: Setup Global (chunk oculto)

```r
#| label: setup
#| include: false

# Librerías
library(tidyverse)
library(gt)
library(gtExtras)
library(gtsummary)
library(patchwork)
library(ggtext)
library(scales)
library(showtext)
library(glue)
library(janitor)

# Tipografía
font_add_google("Outfit", "outfit")
font_add_google("DM Sans", "dm_sans")
showtext_auto()

# Tema ggplot global
tema_reporte <- theme_minimal(base_family = "dm_sans", base_size = 12) +
  theme(
    plot.background  = element_rect(fill = "#FAFAF8", color = NA),
    panel.background = element_rect(fill = "#FAFAF8", color = NA),
    plot.title       = element_markdown(family = "outfit", size = 14, face = "bold"),
    plot.subtitle    = element_markdown(size = 11, color = "grey40"),
    plot.caption     = element_markdown(size = 8, color = "grey55", hjust = 0),
    axis.ticks       = element_blank(),
    panel.grid.major = element_line(color = "grey90", linewidth = 0.4),
    panel.grid.minor = element_blank(),
    plot.margin      = margin(12, 12, 12, 12)
  )
theme_set(tema_reporte)

# Paleta corporativa
colores <- c(primario = "#2196F3", secundario = "#FF6B35",
             exito = "#4CAF50", alerta = "#FF9800", peligro = "#F44336",
             neutro = "#607D8B")

# Cargar datos
# datos <- read_csv("datos/datos_principales.csv")
# Aquí va la carga y limpieza inicial de datos

# Parámetros del reporte
region  <- params$region
periodo <- params$periodo
```

---

## SECCIÓN 1: Resumen Ejecutivo

```markdown
## Resumen Ejecutivo

::: {.callout-note appearance="minimal"}
Este reporte presenta el análisis de desempeño para **`r params$region`** 
durante el período **`r params$periodo`**. Los hallazgos principales indican...
:::
```

```r
#| label: kpi-cards
#| fig-cap: "Indicadores clave del período"

# KPI Cards con gt
tibble(
  Indicador = c("💰 Ingresos totales", "👥 Usuarios activos",
                "📈 Crecimiento MoM", "⭐ Satisfacción"),
  Valor     = c("$4.7M", "23,814", "+8.3%", "4.6/5"),
  Delta     = c("▲ 12.1%", "▲ 5.4%", "▲ 2.1pp", "▼ 0.2"),
  Estado    = c("✅", "✅", "✅", "⚠️")
) %>%
  gt() %>%
  cols_align(align = "center", columns = c(Valor, Delta, Estado)) %>%
  data_color(
    columns = Estado,
    method  = "factor",
    palette = c("⚠️" = "#FFF9C4", "✅" = "#E8F5E9")
  ) %>%
  gt_theme_guardian() %>%
  tab_options(table.width = pct(100), column_labels.font.weight = "bold")
```

---

## SECCIÓN 2: Contexto y Fuente de Datos

```markdown
## Contexto del Análisis

### Objetivo
[Descripción del objetivo del análisis]

### Fuentes de Datos
```

```r
#| label: tabla-fuentes

tibble(
  Fuente      = c("Sistema ERP", "CRM", "Encuesta NPS", "Google Analytics"),
  Registros   = c("124,847", "23,814", "1,205", "∞"),
  Período     = c("Ene–Sep 2024", "Ene–Sep 2024", "Ago–Sep 2024", "Ene–Sep 2024"),
  Actualizado = c("2024-09-30", "2024-09-30", "2024-09-15", "2024-09-30"),
  Calidad     = c("Alta", "Alta", "Media", "Alta")
) %>%
  gt() %>%
  data_color(columns = Calidad,
             method = "factor",
             palette = c("Alta" = "#E8F5E9", "Media" = "#FFF9C4", "Baja" = "#FFEBEE")) %>%
  gt_theme_guardian() %>%
  tab_header(title = md("**Fuentes de datos utilizadas**")) %>%
  tab_options(table.width = pct(100))
```

---

## SECCIÓN 3: Resultados — Patrón Gráfico → Hallazgo → Tabla

```r
#| label: grafico-tendencia-ventas
#| fig-cap: "Las ventas muestran recuperación sostenida desde mayo"
#| fig-alt: "Gráfico de líneas mostrando tendencia de ventas mensuales"

# PATRÓN RECOMENDADO:
# 1. Gráfico primero (impacto visual)
# 2. Callout con el hallazgo principal
# 3. Tabla de datos de soporte (colapsable)

datos_tendencia %>%
  ggplot(aes(x = mes, y = ventas, group = 1)) +
  geom_area(fill = "#2196F3", alpha = 0.15) +
  geom_line(color = "#2196F3", linewidth = 1.5) +
  geom_point(color = "#2196F3", size = 3) +
  geom_point(
    data = filter(datos_tendencia, ventas == max(ventas)),
    color = "#FF6B35", size = 5
  ) +
  geom_text(
    data = filter(datos_tendencia, ventas == max(ventas)),
    aes(label = glue("Máximo\n{scales::dollar(ventas)}")),
    nudge_y = 50000, size = 3.5, color = "#FF6B35", fontface = "bold"
  ) +
  scale_y_continuous(labels = scales::dollar_format(scale = 1e-6, suffix = "M")) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month") +
  labs(
    title    = "**Ventas mensuales** muestran recuperación sostenida",
    subtitle = glue("Período: {params$periodo} | Región: {params$region}"),
    caption  = "**Fuente:** Sistema ERP — Extracción al 30/09/2024",
    x = NULL, y = "Ventas (USD)"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

```markdown
::: {.callout-tip}
## 💡 Hallazgo principal
Las ventas acumuladas superaron la meta trimestral en **+8.3%**, impulsadas principalmente
por el segmento de clientes corporativos que creció 15.2% interanual.
:::
```

```r
#| label: tabla-ventas-detalle
#| tbl-cap: "Detalle mensual de ventas por categoría"

datos_tendencia %>%
  mutate(across(where(is.numeric), ~ scales::dollar(.))) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_options(table.width = pct(100))
```

---

## SECCIÓN 4: Análisis Comparativo (Antes/Después o por Grupos)

```r
#| label: comparativo-grupos
#| fig-width: 10
#| fig-height: 5

# Subplot izquierda: comparativo actual
p1 <- datos %>%
  ggplot(aes(x = reorder(segmento, valor), y = valor, fill = cumple_meta)) +
  geom_col(width = 0.7) +
  geom_hline(yintercept = meta, linetype = "dashed", color = "grey40", linewidth = 0.8) +
  annotate("text", x = 0.6, y = meta * 1.02, label = "Meta", 
           color = "grey40", size = 3.5, hjust = 0) +
  coord_flip() +
  scale_fill_manual(values = c("TRUE" = "#4CAF50", "FALSE" = "#F44336")) +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(legend.position = "none") +
  labs(title = "**A.** Desempeño por segmento", x = NULL, y = "Tasa de cumplimiento")

# Subplot derecha: evolución YoY
p2 <- datos_yoy %>%
  ggplot(aes(x = año, y = valor, color = segmento, group = segmento)) +
  geom_line(linewidth = 1.3) +
  geom_point(size = 2.5) +
  ggrepel::geom_label_repel(
    data = filter(datos_yoy, año == max(año)),
    aes(label = segmento), size = 3, show.legend = FALSE
  ) +
  scale_color_paletteer_d("rcartocolor::Vivid") +
  theme(legend.position = "none") +
  labs(title = "**B.** Evolución interanual", x = NULL, y = NULL)

p1 + p2 +
  plot_annotation(
    title   = "Análisis comparativo de segmentos",
    caption = "**Fuente:** CRM corporativo",
    theme   = tema_reporte
  )
```

---

## SECCIÓN 5: Análisis Estadístico con reporte automático

```r
#| label: modelo-estadistico

library(modelsummary)
library(parameters)
library(performance)

# Ajustar modelo
modelo <- lm(ventas ~ región + segmento + mes_num + año, data = datos)

# Tabla de resultados del modelo (publicación-ready)
modelsummary(
  list("Modelo OLS" = modelo),
  fmt        = 2,
  stars      = c('*' = .1, '**' = .05, '***' = .01),
  gof_omit   = "AIC|BIC|Log|F|RMSE",
  coef_rename = c(
    "(Intercept)"    = "Intercepto",
    "regiónBogotá"   = "Región: Bogotá",
    "mes_num"        = "Mes (numérico)"
  ),
  output = "gt"
) %>%
  gt_theme_guardian() %>%
  tab_header(
    title    = md("**Tabla 2.** Regresión lineal — Determinantes de ventas"),
    subtitle = md("*Variable dependiente: Ventas mensuales (USD)*")
  )

# Reporte en texto automático
library(report)
report(modelo)  # Genera párrafo APA-compliant automáticamente
```

---

## SECCIÓN 6: Conclusiones y Recomendaciones

```markdown
## Conclusiones y Recomendaciones

### Hallazgos principales

1. **[Hallazgo 1]**: Las ventas crecieron X% interanual, superando la meta en Y puntos.
2. **[Hallazgo 2]**: El segmento Z muestra señales de desaceleración que requieren atención.
3. **[Hallazgo 3]**: La retención de clientes cayó marginalmente pero sigue por encima del benchmark.

### Recomendaciones accionables

::: {.callout-important}
## 🔴 Prioridad Alta — Acción inmediata
Lanzar campaña de retención en segmento B antes del cierre del Q4.
**Responsable:** Gerencia Comercial | **Fecha límite:** 15/10/2024
:::

::: {.callout-warning}
## 🟡 Prioridad Media — Próximas 4 semanas
Revisar la política de precios en la región Occidente donde el margen está comprimido.
**Responsable:** Dirección Financiera | **Fecha límite:** 31/10/2024
:::

::: {.callout-note}
## 🔵 Prioridad Normal — Próximo trimestre
Implementar módulo de análisis predictivo para anticipar churn con 60 días de anticipación.
**Responsable:** Equipo de Datos | **Fecha límite:** Q1 2025
:::

### Próximos pasos

| # | Acción | Responsable | Fecha límite | Estado |
|---|--------|-------------|--------------|--------|
| 1 | Campaña retención | G. Comercial | 15/10/2024 | ⏳ Pendiente |
| 2 | Revisión precios | Dirección Fin. | 31/10/2024 | ⏳ Pendiente |
| 3 | Módulo predictivo | Equipo Datos | Q1 2025 | 📋 Planificado |
```

---

## SECCIÓN 7: Apéndices

```markdown
## Apéndices {.appendix}

### A. Código de análisis
```

```r
#| label: apendice-codigo
#| echo: true   # Mostrar código en apéndice
#| eval: false  # No re-ejecutar

# Todo el código de limpieza y transformación documentado aquí
datos_limpios <- datos_raw %>%
  clean_names() %>%
  filter(!is.na(ventas)) %>%
  mutate(
    fecha    = as.Date(fecha, "%Y-%m-%d"),
    mes      = floor_date(fecha, "month"),
    trimestre = quarter(fecha, with_year = TRUE)
  )
```

```markdown
### B. Metadata del reporte

| Campo | Valor |
|-------|-------|
| Versión | 1.0.0 |
| Fecha de generación | `r Sys.time()` |
| Generado con | R `r R.version.string`, Quarto `r quarto::quarto_version()` |
| Región analizada | `r params$region` |
| Período | `r params$periodo` |
| Hash de datos | `r digest::digest(datos, algo = "md5")` |
```

---

## Pie de Página Automático

```r
# En el YAML o en un chunk al final:
cat(glue::glue("
---
Reporte generado automáticamente el {format(Sys.time(), '%d/%m/%Y a las %H:%M')} 
con R {R.version.string} | Versión del reporte: 1.0.0  
Confidencial — Solo para uso interno
"))
```

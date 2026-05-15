---
name: r-graficos-impacto
description: >
  Crea gráficos de alto impacto visual en R usando las técnicas más modernas y librerías de vanguardia (ggplot2, ggdist, patchwork, ggtext, ggiraph, plotly, esquisse, ggforce, waffle, treemapify, rayshader, y más). Activa esta skill SIEMPRE que el usuario mencione: "gráfico en R", "visualización en R", "plot en R", "ggplot", "gráfico de alto impacto", "figura para publicación", "dashboard en R", "gráfico animado en R", "visualización de datos R", "gráfico bonito R", "gráfico profesional R", "chart R", "tidyverse visualización", o cualquier combinación de R + visualización/gráfico/figura/plot. También activa cuando el usuario sube datos y pide visualizarlos usando R, o cuando menciona querer gráficos "tipo Nature", "tipo revista científica", "publicación académica", "gráfico interactivo", "infografía con R", o pide mejorar un gráfico existente en R. Úsala incluso si el usuario no menciona explícitamente la palabra "skill" — si están trabajando con R y datos visuales, este skill aplica.
---

# 🎨 Gráficos de Alto Impacto en R

## Filosofía del Gráfico de Impacto

Un gráfico de alto impacto no solo muestra datos — **cuenta una historia**, evoca emoción y queda grabado en la memoria del lector. En 2024-2025, los gráficos top combinan:

1. **Diseño editorial** (tipografías, color con propósito, espacio en blanco)
2. **Novedad estadística** (raincloud plots, ridgeline plots, beeswarms, alluvial)
3. **Interactividad** (ggiraph, plotly, shiny)
4. **Animación** (gganimate, tweenr)
5. **Composición cinematográfica** (patchwork, cowplot, layout en grid)

---

## Setup Inicial — Instalar y Cargar el Ecosistema Completo

```r
# Instalar todo lo necesario (ejecutar una sola vez)
paquetes <- c(
  "tidyverse", "ggplot2", "ggdist", "ggridges", "ggbeeswarm",
  "patchwork", "cowplot", "ggtext", "glue", "scales",
  "ggiraph", "plotly", "gganimate", "gifski", "av",
  "ggforce", "ggalluvial", "waffle", "treemapify",
  "ggstream", "ggrepel", "shadowtext", "ggfx",
  "paletteer", "MetBrewer", "wesanderson", "scico",
  "extrafont", "showtext", "sysfonts",
  "rayshader", "rgl",
  "camcorder", "ggchicklet", "ggpol"
)
install.packages(paquetes[!paquetes %in% installed.packages()[,"Package"]])

# Cargar los esenciales
library(tidyverse)
library(ggplot2)
library(ggdist)
library(patchwork)
library(ggtext)
library(scales)
library(paletteer)
library(showtext)
```

---

## 🔤 Tipografía Premium con showtext

```r
# Cargar Google Fonts (gratuitas, de calidad editorial)
font_add_google("Outfit", "outfit")          # Moderna, limpia
font_add_google("Playfair Display", "playfair") # Elegante, serif
font_add_google("DM Sans", "dm_sans")         # Neutralidad profesional
font_add_google("Space Grotesk", "space")     # Tech/datos
font_add_google("Lora", "lora")               # Académica
showtext_auto()

# Ejemplo de uso en tema
mi_tema <- theme_minimal(base_family = "outfit", base_size = 14) +
  theme(
    plot.title    = element_text(family = "playfair", size = 20, face = "bold"),
    plot.subtitle = element_text(family = "dm_sans", size = 13, color = "grey40"),
    plot.caption  = element_text(family = "dm_sans", size = 9, color = "grey60"),
    plot.background = element_rect(fill = "#FAFAF8", color = NA),
    panel.background = element_rect(fill = "#FAFAF8", color = NA)
  )
```

---

## 🎨 Paletas de Color de Alto Impacto

```r
# Paletas curadas por categoría

# --- Científicas / Académicas ---
paletteer_d("MetBrewer::Hiroshige")   # Inspirada en grabados japoneses
paletteer_d("MetBrewer::Derain")      # Suaves, elegantes
paletteer_d("MetBrewer::Homer1")      # Cálidas, dramáticas
paletteer_c("scico::roma")            # Divergente perceptualmente uniforme
paletteer_c("scico::batlow")          # Para datos continuos, accesible

# --- Modernas / Editoriales ---
paletteer_d("rcartocolor::Vivid")     # Alta saturación, pop
paletteer_d("ggthemes::Tableau_10")   # Estándar industria
paletteer_d("ggsci::npg")             # Nature Publishing Group

# --- Minimalistas ---
c("#2D3047", "#E84855", "#FFFD82", "#A9E5BB", "#FCF6B1")  # Dark + accent
c("#1B1B2F", "#E94560", "#0F3460", "#533483")              # Night palette

# Definir paleta propia con nombre
mi_paleta <- c(
  azul      = "#2196F3",
  naranja   = "#FF6B35",
  verde     = "#4CAF50",
  morado    = "#9C27B0",
  gris      = "#607D8B"
)
```

---

## 📊 Los 12 Tipos de Gráficos de Mayor Impacto en 2024-2025

Consulta el archivo `references/tipos-graficos.md` para código completo de cada uno.

### Resumen rápido:

| Tipo | Librería | Cuándo usar |
|------|----------|-------------|
| **Raincloud plot** | ggdist + ggbeeswarm | Distribuciones + puntos individuales |
| **Ridgeline / Joy** | ggridges | Múltiples distribuciones temporales |
| **Alluvial / Sankey** | ggalluvial | Flujos y cambios entre categorías |
| **Beeswarm** | ggbeeswarm | Datos individuales sin solapamiento |
| **Stream graph** | ggstream | Series temporales de composición |
| **Waffle chart** | waffle | Proporciones (mejor que pie) |
| **Treemap** | treemapify | Jerarquías de tamaño |
| **Dumbbell** | ggplot2 | Comparaciones antes/después |
| **Lollipop** | ggplot2 | Barras con más elegancia |
| **Heatmap avanzado** | ggplot2 + ggtext | Correlaciones/matrices |
| **Slope chart** | ggplot2 | Evolución entre dos puntos |
| **3D con rayshader** | rayshader | Superficies y mapas dramáticos |

---

## 🏆 Tema Personalizado "Editorial" — Listo para Usar

```r
tema_editorial <- function(base_size = 14, bg = "#FAFAF8") {
  theme_minimal(base_size = base_size) +
  theme(
    # Fondo
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    
    # Títulos con ggtext (permite HTML/Markdown)
    plot.title    = element_markdown(
      size = base_size * 1.5, face = "bold",
      margin = margin(b = 8), lineheight = 1.2
    ),
    plot.subtitle = element_markdown(
      size = base_size * 0.95, color = "grey40",
      margin = margin(b = 16), lineheight = 1.4
    ),
    plot.caption  = element_markdown(
      size = base_size * 0.7, color = "grey55",
      margin = margin(t = 16), hjust = 0
    ),
    
    # Ejes
    axis.title   = element_text(size = base_size * 0.85, color = "grey30"),
    axis.text    = element_text(size = base_size * 0.8,  color = "grey40"),
    axis.ticks   = element_blank(),
    axis.line    = element_blank(),
    
    # Grid
    panel.grid.major = element_line(color = "grey90", linewidth = 0.4),
    panel.grid.minor = element_blank(),
    
    # Leyenda
    legend.position   = "top",
    legend.title      = element_text(size = base_size * 0.85, face = "bold"),
    legend.text       = element_text(size = base_size * 0.8),
    legend.key.size   = unit(0.9, "lines"),
    legend.background = element_rect(fill = NA, color = NA),
    
    # Márgenes generosos
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  )
}
```

---

## ✍️ Anotaciones y Títulos de Alto Impacto con ggtext

```r
# Títulos con color en palabras específicas (HTML inline)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(color = factor(cyl)), size = 3) +
  labs(
    title = "Los autos con <span style='color:#E84855'>**4 cilindros**</span> son más eficientes",
    subtitle = "Cada punto representa un vehículo del dataset clásico *mtcars*",
    caption = "**Fuente:** Motor Trend, 1974 | **Análisis:** Tu Nombre"
  ) +
  scale_color_manual(values = c("4" = "#E84855", "6" = "#2196F3", "8" = "#607D8B")) +
  tema_editorial() +
  theme(plot.title = element_markdown(size = 18))

# Anotaciones con flechas y cajas
p + annotate(
  "richtext",
  x = 5.4, y = 10,
  label = "**Punto atípico**<br>considerar excluir",
  fill = "white", label.color = "grey80",
  size = 3.5, hjust = 1
) +
geom_curve(
  aes(x = 5.2, y = 10.5, xend = 5.4, yend = 15),
  curvature = -0.3,
  arrow = arrow(length = unit(0.2, "cm")),
  color = "grey40"
)
```

---

## 🧩 Composición Multipanel con patchwork

```r
# Crear plots individuales
p1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point(size = 2, alpha = 0.7) +
  tema_editorial() + theme(legend.position = "none") +
  labs(title = "**A.** Dispersión")

p2 <- ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_density(alpha = 0.6, color = NA) +
  tema_editorial() + theme(legend.position = "none") +
  labs(title = "**B.** Distribución")

p3 <- ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
  ggdist::stat_halfeye(alpha = 0.8, width = 0.6, .width = 0, point_colour = NA) +
  tema_editorial() +
  labs(title = "**C.** Raincloud")

# Combinar con layouts creativos
(p1 | p2) / p3 +
  plot_annotation(
    title = "Análisis morfológico de *Iris*",
    caption = "Datos: Fisher (1936)",
    theme = tema_editorial()
  ) &
  scale_fill_paletteer_d("MetBrewer::Hiroshige")
```

---

## ⚡ Interactividad con ggiraph

```r
library(ggiraph)

# Convertir geoms a versiones interactivas
p_interactivo <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point_interactive(
    aes(
      tooltip = glue::glue("Peso: {wt} ton\nConsumo: {mpg} mpg\nCilindros: {cyl}"),
      data_id = rownames(mtcars),
      color = factor(cyl)
    ),
    size = 3, hover_nearest = TRUE
  ) +
  tema_editorial() +
  labs(title = "Hover sobre los puntos para ver detalles")

girafe(
  ggobj = p_interactivo,
  options = list(
    opts_hover(css = "fill:orange;stroke:black;r:6pt;"),
    opts_tooltip(css = "background:#1B1B2F;color:white;padding:8px;border-radius:4px;"),
    opts_sizing(rescale = TRUE)
  )
)
```

---

## 🎬 Animación con gganimate

```r
library(gganimate)

# Animación básica por año (ejemplo con gapminder)
# install.packages("gapminder")
library(gapminder)

p_anim <- gapminder %>%
  ggplot(aes(gdpPercap, lifeExp, size = pop, color = continent)) +
  geom_point(alpha = 0.7, show.legend = TRUE) +
  scale_x_log10(labels = scales::dollar_format()) +
  scale_size(range = c(2, 20), guide = "none") +
  paletteer::scale_color_paletteer_d("rcartocolor::Vivid") +
  tema_editorial() +
  labs(
    title = "Esperanza de vida vs PIB per cápita",
    subtitle = "Año: {frame_time}",
    x = "PIB per cápita (escala log)",
    y = "Esperanza de vida (años)"
  ) +
  transition_time(year) +
  ease_aes("cubic-in-out")

animate(p_anim, nframes = 100, fps = 10, width = 800, height = 600,
        renderer = gifski_renderer("gapminder.gif"))
```

---

## 💾 Exportar con Máxima Calidad

```r
# Para publicaciones (300 DPI, PNG transparente)
ggsave(
  "mi_grafico.png",
  plot = mi_plot,
  width = 10, height = 7, dpi = 300,
  bg = "transparent"
)

# Para revistas (PDF vectorial)
ggsave("mi_grafico.pdf", plot = mi_plot, width = 10, height = 7, device = cairo_pdf)

# Para presentaciones (alta resolución, fondo definido)
ggsave("mi_grafico_ppt.png", plot = mi_plot, width = 13.3, height = 7.5, dpi = 300)

# Guardar con camcorder (registra todo el proceso iterativo)
library(camcorder)
gg_record(dir = "plots/", device = "png", width = 10, height = 7, dpi = 300)
```

---

## 📚 Referencias Adicionales

- `references/tipos-graficos.md` — Código completo para los 12 tipos de gráficos
- `references/temas-avanzados.md` — Temas oscuros, neón, académicos, minimalistas extremos
- `references/color-ciencia.md` — Teoría del color aplicada a datos, accesibilidad, daltonismo

---

## ✅ Checklist de Calidad antes de Exportar

- [ ] ¿El título describe la *conclusión*, no solo el tema?
- [ ] ¿Los colores tienen propósito (no decoración)?
- [ ] ¿Eliminé toda la "chart junk" (gridlines innecesarias, bordes, rellenos vacíos)?
- [ ] ¿El texto es legible a tamaño de publicación final?
- [ ] ¿Incluí fuente de datos en el caption?
- [ ] ¿Revisé la accesibilidad (contraste ≥ 4.5:1, amigable para daltonismo)?
- [ ] ¿Exporté en la resolución correcta para el medio destino?

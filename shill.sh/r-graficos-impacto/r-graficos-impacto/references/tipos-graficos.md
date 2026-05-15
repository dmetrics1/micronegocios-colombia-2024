# Tipos de Gráficos de Alto Impacto — Código Completo

## 1. 🌧️ Raincloud Plot

El gráfico más citado en papers de psicología y neurociencia (2023-2025). Combina distribución, caja y puntos individuales.

```r
library(ggdist)
library(ggbeeswarm)

ggplot(iris, aes(x = Species, y = Sepal.Length, fill = Species, color = Species)) +
  # Mitad superior: distribución de densidad
  ggdist::stat_halfeye(
    adjust = 0.5, width = 0.6, .width = 0,
    justification = -0.2, point_colour = NA, alpha = 0.8
  ) +
  # Caja (sin outliers)
  geom_boxplot(
    width = 0.15, outlier.shape = NA,
    alpha = 0.5, color = "white", linewidth = 0.8
  ) +
  # Puntos individuales
  ggbeeswarm::geom_quasirandom(
    size = 1.8, alpha = 0.6, width = 0.1,
    show.legend = FALSE
  ) +
  coord_flip() +
  scale_fill_paletteer_d("MetBrewer::Hiroshige") +
  scale_color_paletteer_d("MetBrewer::Hiroshige") +
  tema_editorial() +
  labs(
    title = "Raincloud Plot: Longitud del sépalo en *Iris*",
    subtitle = "Distribución + caja + puntos individuales",
    x = NULL, y = "Longitud del sépalo (cm)"
  ) +
  theme(legend.position = "none")
```

---

## 2. 🏔️ Ridgeline / Joy Plot

Perfecto para distribuciones temporales o múltiples grupos superpuestos.

```r
library(ggridges)

# Con datos temporales
ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = Month, fill = after_stat(x))) +
  geom_density_ridges_gradient(
    scale = 3, rel_min_height = 0.01,
    color = "white", linewidth = 0.4
  ) +
  scale_fill_viridis_c(option = "C", name = "Temperatura °F") +
  tema_editorial() +
  labs(
    title = "Distribución de temperaturas en Lincoln, NE",
    subtitle = "Cada cresta representa la distribución mensual",
    x = "Temperatura (°F)", y = NULL
  )
```

---

## 3. 🌊 Stream Graph

Muestra composición cambiante en el tiempo. Dramático y memorable.

```r
library(ggstream)

# Datos de ejemplo
set.seed(42)
datos_stream <- tidyr::expand_grid(
  año = 2000:2024,
  categoria = c("Tecnología", "Salud", "Educación", "Energía", "Arte")
) %>%
  mutate(valor = abs(rnorm(n(), mean = 100, sd = 30)) * 
         ifelse(categoria == "Tecnología", (año - 1998) * 0.5, 1))

ggplot(datos_stream, aes(x = año, y = valor, fill = categoria)) +
  geom_stream(type = "mirror", bw = 0.75, extra_span = 0.001) +
  geom_stream_label(aes(label = categoria), type = "mirror", 
                    size = 3.5, color = "white", fontface = "bold") +
  scale_fill_paletteer_d("rcartocolor::Vivid") +
  tema_editorial() +
  theme(legend.position = "none") +
  labs(
    title = "Stream Graph: Evolución de sectores 2000–2024",
    x = NULL, y = "Participación relativa"
  )
```

---

## 4. 🔗 Alluvial / Sankey Plot

Para mostrar flujos y transiciones entre categorías.

```r
library(ggalluvial)

titanic_data <- as.data.frame(Titanic) %>%
  filter(Freq > 0)

ggplot(titanic_data,
       aes(axis1 = Class, axis2 = Sex, axis3 = Survived, y = Freq)) +
  geom_alluvium(aes(fill = Survived), width = 1/8, alpha = 0.8) +
  geom_stratum(width = 1/8, fill = "grey20", color = "white") +
  geom_label(stat = "stratum", aes(label = after_stat(stratum)),
             size = 3, fill = "white", color = "grey20") +
  scale_fill_manual(values = c("No" = "#E84855", "Yes" = "#4CAF50")) +
  tema_editorial() +
  labs(
    title = "Flujo de supervivencia en el Titanic",
    subtitle = "Clase → Género → Supervivencia",
    x = NULL, y = "Pasajeros"
  )
```

---

## 5. 🍩 Waffle Chart (mejor que el pie)

```r
library(waffle)

datos_waffle <- c(
  "Satisfechos" = 52,
  "Neutrales"   = 23,
  "Insatisfechos" = 25
)

waffle(
  datos_waffle,
  rows = 10,
  colors = c("#4CAF50", "#FFC107", "#F44336"),
  title = "Satisfacción del cliente (n = 100)",
  legend_pos = "bottom",
  size = 0.5
)
```

---

## 6. 🌳 Treemap

Para jerarquías y proporciones con múltiples niveles.

```r
library(treemapify)

datos_tree <- data.frame(
  area    = c(6, 11, 9, 4, 3, 5, 7, 3),
  fill    = c(2.3, 5.7, 4.1, 1.2, 0.8, 2.5, 3.8, 0.9),
  label   = c("Python", "JavaScript", "TypeScript", "Go", "Rust", "Java", "R", "Julia"),
  grupo   = c("Scripts", "Web", "Web", "Backend", "Backend", "Backend", "Análisis", "Análisis")
)

ggplot(datos_tree, aes(area = area, fill = fill, label = label, subgroup = grupo)) +
  geom_treemap(color = "white", linewidth = 2) +
  geom_treemap_subgroup_border(color = "white", linewidth = 4) +
  geom_treemap_subgroup_text(
    place = "topleft", reflow = TRUE, alpha = 0.5,
    color = "white", fontface = "bold", min.size = 0
  ) +
  geom_treemap_text(
    color = "white", place = "centre", reflow = TRUE,
    fontface = "bold"
  ) +
  scale_fill_paletteer_c("scico::batlow") +
  tema_editorial() +
  theme(legend.position = "none") +
  labs(title = "Popularidad de lenguajes de programación")
```

---

## 7. 💪 Dumbbell Chart (Antes vs Después)

```r
library(ggalt)   # para geom_dumbbell, o hacerlo manual:

datos_db <- tibble(
  pais    = c("Colombia", "México", "Brasil", "Chile", "Argentina"),
  antes   = c(45, 52, 38, 61, 55),
  despues = c(68, 71, 59, 78, 72)
)

ggplot(datos_db) +
  # Línea conectora
  geom_segment(
    aes(x = antes, xend = despues, y = reorder(pais, despues)),
    color = "grey70", linewidth = 2.5, lineend = "round"
  ) +
  # Punto inicial
  geom_point(aes(x = antes, y = pais), color = "#E84855", size = 5) +
  # Punto final
  geom_point(aes(x = despues, y = pais), color = "#4CAF50", size = 5) +
  # Etiquetas
  geom_text(aes(x = antes - 1.5, y = pais, label = antes), 
            color = "#E84855", fontface = "bold", size = 3.5) +
  geom_text(aes(x = despues + 1.5, y = pais, label = despues), 
            color = "#4CAF50", fontface = "bold", size = 3.5) +
  tema_editorial() +
  labs(
    title = "Índice de acceso a tecnología: **<span style='color:#E84855'>Antes</span>** vs **<span style='color:#4CAF50'>Después</span>**",
    subtitle = "Cambio 2018–2023 por país",
    x = "Índice (0–100)", y = NULL
  ) +
  theme(plot.title = element_markdown())
```

---

## 8. 🎯 Lollipop Chart

Alternativa elegante a las barras.

```r
datos_lolly <- mtcars %>%
  rownames_to_column("modelo") %>%
  arrange(desc(mpg)) %>%
  head(15) %>%
  mutate(modelo = fct_reorder(modelo, mpg),
         color_flag = mpg > 25)

ggplot(datos_lolly, aes(x = mpg, y = modelo)) +
  geom_segment(
    aes(x = 0, xend = mpg, y = modelo, yend = modelo, color = color_flag),
    linewidth = 1.5, lineend = "round"
  ) +
  geom_point(aes(color = color_flag), size = 4) +
  geom_text(aes(label = mpg, color = color_flag), 
            nudge_x = 0.8, size = 3.5, fontface = "bold") +
  scale_color_manual(values = c("FALSE" = "#607D8B", "TRUE" = "#FF6B35")) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.1))) +
  tema_editorial() +
  theme(legend.position = "none") +
  labs(
    title = "Los 15 autos más eficientes",
    subtitle = "<span style='color:#FF6B35'>**Naranja**</span>: más de 25 mpg",
    x = "Millas por galón (mpg)", y = NULL
  ) +
  theme(plot.subtitle = element_markdown())
```

---

## 9. 🔥 Heatmap Avanzado con Anotaciones

```r
library(reshape2)

# Correlación con anotación de valores
cor_matrix <- cor(mtcars) %>%
  melt() %>%
  rename(var1 = Var1, var2 = Var2, correlacion = value)

ggplot(cor_matrix, aes(var1, var2, fill = correlacion)) +
  geom_tile(color = "white", linewidth = 0.8) +
  geom_text(
    aes(label = round(correlacion, 2),
        color = abs(correlacion) > 0.6),
    size = 3, fontface = "bold"
  ) +
  scale_fill_gradient2(
    low = "#2196F3", mid = "white", high = "#E84855",
    midpoint = 0, limits = c(-1, 1),
    name = "Correlación"
  ) +
  scale_color_manual(values = c("TRUE" = "white", "FALSE" = "grey40"),
                     guide = "none") +
  coord_fixed() +
  tema_editorial() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  ) +
  labs(title = "Matriz de Correlación — Dataset *mtcars*")
```

---

## 10. 📈 Slope Chart

Para comparar dos puntos en el tiempo entre grupos.

```r
datos_slope <- tibble(
  grupo   = rep(c("Grupo A", "Grupo B", "Grupo C", "Grupo D"), 2),
  tiempo  = rep(c("2020", "2024"), each = 4),
  valor   = c(42, 67, 33, 78, 61, 55, 58, 89)
)

ggplot(datos_slope, aes(x = tiempo, y = valor, group = grupo, color = grupo)) +
  geom_line(linewidth = 2, lineend = "round") +
  geom_point(size = 4) +
  geom_text(
    data = filter(datos_slope, tiempo == "2020"),
    aes(label = paste0(grupo, " (", valor, ")")),
    nudge_x = -0.08, hjust = 1, size = 3.5, fontface = "bold"
  ) +
  geom_text(
    data = filter(datos_slope, tiempo == "2024"),
    aes(label = paste0(valor, "")),
    nudge_x = 0.08, hjust = 0, size = 3.5, fontface = "bold"
  ) +
  scale_color_paletteer_d("rcartocolor::Vivid") +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  tema_editorial() +
  theme(legend.position = "none", panel.grid.major.x = element_blank()) +
  labs(title = "Cambio de rendimiento 2020–2024", x = NULL, y = "Puntuación")
```

---

## 11. 🌐 Mapa de Calor Geográfico

```r
library(maps)
library(viridis)

# Mapa de EEUU con datos de crimen (incluido en R)
crime_data <- USArrests %>%
  rownames_to_column("region") %>%
  mutate(region = tolower(region))

us_map <- map_data("state") %>%
  left_join(crime_data, by = "region")

ggplot(us_map, aes(long, lat, group = group, fill = Murder)) +
  geom_polygon(color = "white", linewidth = 0.3) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  scale_fill_viridis_c(option = "magma", direction = -1, name = "Arrestos\npor 100k") +
  tema_editorial() +
  theme(
    axis.text = element_blank(), axis.title = element_blank(),
    panel.grid = element_blank(), axis.ticks = element_blank()
  ) +
  labs(title = "Tasa de arrestos por homicidio en EE.UU.")
```

---

## 12. 🏔️ Visualización 3D con rayshader

```r
library(rayshader)
library(ggplot2)

# Crear gráfico 2D primero
p_2d <- ggplot(faithful, aes(eruptions, waiting)) +
  geom_hex(bins = 20, color = "white") +
  scale_fill_viridis_c(option = "magma") +
  tema_editorial() +
  labs(title = "Old Faithful: Erupciones vs Espera")

# Convertir a 3D
plot_gg(p_2d,
  multicore = TRUE,
  width = 5, height = 5, scale = 300,
  zoom = 0.6, theta = 30, phi = 30,
  windowsize = c(1000, 800)
)

# Exportar render de alta calidad
render_highquality(
  filename = "3d_faithful.png",
  parallel = TRUE,
  samples = 300,
  width = 2000, height = 2000
)
```

---

## Tips de Producción

```r
# ── Evitar el clipping de texto en ggsave ──
ragg::agg_png("plot.png", width = 10, height = 7, units = "in", res = 300)
print(mi_plot)
dev.off()

# ── Registrar todos los plots con camcorder ──
library(camcorder)
gg_record(
  dir  = file.path(tempdir(), "recording"),
  device = "png",
  width  = 10, height = 7, dpi = 300
)
# Todos los plots se guardan automáticamente
gg_playback(name = "proceso.gif", first_image_duration = 3)

# ── Verificar accesibilidad de colores ──
library(colorBlindness)
cvdPlot(mi_plot)  # Simula los 3 tipos de daltonismo
```

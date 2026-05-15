# Temas Avanzados para R — Oscuro, Neón, Académico, Minimalista

## Tema Oscuro "Dark Mode Pro"

```r
tema_dark <- function(base_size = 14, accent = "#00E5FF") {
  theme_minimal(base_size = base_size) +
  theme(
    plot.background   = element_rect(fill = "#0D1117", color = NA),
    panel.background  = element_rect(fill = "#0D1117", color = NA),
    plot.title        = element_markdown(color = "white", size = base_size * 1.5, face = "bold"),
    plot.subtitle     = element_markdown(color = "#8B949E", size = base_size * 0.9),
    plot.caption      = element_markdown(color = "#8B949E", size = base_size * 0.7),
    axis.title        = element_text(color = "#8B949E"),
    axis.text         = element_text(color = "#8B949E"),
    axis.ticks        = element_blank(),
    panel.grid.major  = element_line(color = "#21262D", linewidth = 0.5),
    panel.grid.minor  = element_blank(),
    legend.background = element_rect(fill = "#0D1117", color = NA),
    legend.title      = element_text(color = "white"),
    legend.text       = element_text(color = "#8B949E"),
    strip.background  = element_rect(fill = "#161B22", color = NA),
    strip.text        = element_text(color = "white", face = "bold"),
    plot.margin       = margin(20, 20, 20, 20)
  )
}

# Paleta complementaria para dark mode
colores_dark <- c("#00E5FF", "#FF4081", "#69F0AE", "#FFD740", "#E040FB")
```

---

## Tema Neón "Cyber"

```r
tema_neon <- function(base_size = 14) {
  bg     <- "#0A0A0F"
  accent <- "#00FF88"
  
  theme_void(base_size = base_size) +
  theme(
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    plot.title       = element_markdown(
      color = accent, size = base_size * 1.6, face = "bold",
      margin = margin(b = 10)
    ),
    plot.subtitle    = element_markdown(color = "#888888", size = base_size * 0.9),
    axis.text        = element_text(color = "#555555", size = base_size * 0.75),
    axis.title       = element_text(color = "#555555", size = base_size * 0.85),
    panel.grid.major = element_line(color = "#1A1A2E", linewidth = 0.4),
    panel.grid.minor = element_blank(),
    legend.text      = element_text(color = "#888888"),
    legend.title     = element_text(color = accent),
    plot.margin      = margin(25, 25, 25, 25)
  )
}

# Colores neón
paleta_neon <- c("#00FF88", "#FF006E", "#00D4FF", "#FFE600", "#FF6B35")
```

---

## Tema "Nature / Science" (Publicación Académica)

```r
tema_academic <- function(base_size = 11) {
  # Usa Helvetica/Arial que son las fuentes estándar en revistas
  theme_bw(base_size = base_size) +
  theme(
    plot.background   = element_rect(fill = "white", color = NA),
    panel.background  = element_rect(fill = "white", color = "black", linewidth = 0.8),
    plot.title        = element_text(size = base_size * 1.2, face = "bold", hjust = 0),
    plot.subtitle     = element_text(size = base_size, color = "grey30"),
    axis.text         = element_text(size = base_size * 0.85, color = "black"),
    axis.title        = element_text(size = base_size, face = "bold"),
    axis.ticks        = element_line(color = "black", linewidth = 0.5),
    axis.ticks.length = unit(0.2, "cm"),
    panel.grid.major  = element_line(color = "grey92", linewidth = 0.4),
    panel.grid.minor  = element_blank(),
    legend.background = element_rect(fill = "white", color = "grey80"),
    legend.key        = element_rect(fill = "white"),
    strip.background  = element_rect(fill = "grey95", color = "black"),
    strip.text        = element_text(face = "bold", size = base_size * 0.9),
    plot.margin       = margin(10, 15, 10, 10)
  )
}

# Paleta Science/Nature compatible con daltonismo
paleta_academic <- c(
  "#0072B2",  # Azul
  "#E69F00",  # Naranja
  "#009E73",  # Verde
  "#CC79A7",  # Rosa
  "#56B4E9",  # Azul claro
  "#D55E00",  # Rojo-naranja
  "#F0E442"   # Amarillo
)
```

---

## Tema "Minimalista Extremo" (tipo Economist / Bloomberg)

```r
tema_economist <- function(base_size = 13) {
  theme_minimal(base_size = base_size) +
  theme(
    # Sin panel
    panel.background  = element_rect(fill = "#F8F7F2", color = NA),
    plot.background   = element_rect(fill = "#F8F7F2", color = NA),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "#DEDAD5", linewidth = 0.5),
    panel.grid.minor   = element_blank(),
    
    # Línea roja en la parte superior (estilo Economist)
    plot.title = element_text(
      size = base_size * 1.4, face = "bold", color = "#1A1A1A",
      margin = margin(t = 3, b = 5)
    ),
    
    # Subtítulo en gris claro
    plot.subtitle = element_text(
      size = base_size * 0.95, color = "#666666",
      margin = margin(b = 15)
    ),
    
    # Sin títulos de eje (se explican solos)
    axis.title = element_blank(),
    axis.text  = element_text(color = "#555555", size = base_size * 0.85),
    axis.ticks = element_blank(),
    
    # Caption con fuente en cursiva
    plot.caption = element_text(
      color = "#888888", size = base_size * 0.75,
      hjust = 0, face = "italic"
    ),
    
    legend.position   = "top",
    legend.title      = element_blank(),
    legend.text       = element_text(color = "#555555"),
    
    plot.margin = margin(15, 20, 15, 20)
  )
}

# Añadir barra roja superior (decorativa, estilo Economist)
agregar_barra_roja <- function(p, color = "#E3120B", height = 3) {
  p + 
    annotation_custom(
      grid::rectGrob(gp = grid::gpar(fill = color, col = NA)),
      xmin = -Inf, xmax = Inf,
      ymin = -Inf, ymax = -Inf
    )
}
```

---

## Tema "Retro / Vintage"

```r
tema_retro <- function(base_size = 13) {
  theme_minimal(base_size = base_size) +
  theme(
    plot.background  = element_rect(fill = "#F5E6D3", color = NA),
    panel.background = element_rect(fill = "#F5E6D3", color = NA),
    plot.title       = element_text(
      size = base_size * 1.5, face = "bold",
      color = "#3D2B1F", family = "serif"
    ),
    plot.subtitle    = element_text(color = "#6B4A3D", size = base_size * 0.9),
    axis.text        = element_text(color = "#6B4A3D"),
    axis.title       = element_text(color = "#3D2B1F", face = "bold"),
    panel.grid.major = element_line(color = "#D4B896", linewidth = 0.5),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(fill = "#F5E6D3", color = NA),
    legend.text      = element_text(color = "#6B4A3D"),
    plot.margin      = margin(20, 20, 20, 20)
  )
}

paleta_retro <- c("#8B4513", "#D2691E", "#CD853F", "#DEB887", "#F4A460",
                  "#556B2F", "#6B8E23", "#808000")
```

---

## Añadir Logos e Imágenes con ggimage / magick

```r
library(ggimage)
library(magick)

# Añadir logo a un plot
p +
  annotation_custom(
    rasterGrob(
      image_read("logo.png"),
      interpolate = TRUE
    ),
    xmin = 4.5, xmax = 5.5,
    ymin = 30, ymax = 35
  )

# Añadir imágenes en los puntos
datos_img <- tibble(
  x     = 1:3,
  y     = c(10, 15, 12),
  image = c("url_imagen_1.png", "url_imagen_2.png", "url_imagen_3.png")
)

ggplot(datos_img, aes(x, y)) +
  geom_image(aes(image = image), size = 0.1) +
  tema_editorial()
```

---

## Efectos Especiales con ggfx

```r
library(ggfx)

# Glow / resplandor (perfecto para dark mode)
ggplot(mtcars, aes(wt, mpg)) +
  with_outer_glow(
    geom_point(color = "#00FF88", size = 3),
    colour = "#00FF88", sigma = 8, expand = 3
  ) +
  tema_dark()

# Desenfoque
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  with_blur(
    geom_point(aes(color = Species), size = 3, alpha = 0.3),
    sigma = 3
  ) +
  geom_point(aes(color = Species), size = 2) +
  tema_editorial()

# Sombra
ggplot(datos, aes(x, y)) +
  with_shadow(
    geom_col(fill = "#2196F3"),
    sigma = 5, x_offset = 3, y_offset = 3
  ) +
  tema_editorial()
```

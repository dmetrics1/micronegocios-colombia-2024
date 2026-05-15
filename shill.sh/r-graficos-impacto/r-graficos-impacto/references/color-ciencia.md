# Ciencia del Color para Visualización de Datos en R

## Principios Fundamentales

### Los 4 Tipos de Paletas y Cuándo Usarlas

```r
# 1. CUALITATIVAS — Para categorías sin orden
#    Máximo 8-10 colores, perceptualmente equidistantes
paleta_cualitativa <- c(
  "#4E79A7", "#F28E2B", "#E15759", "#76B7B2",
  "#59A14F", "#EDC948", "#B07AA1", "#FF9DA7"
)  # Tableau clásico

# 2. SECUENCIAL — Para valores de bajo a alto
scale_fill_viridis_c(option = "viridis")   # Para daltónicos
scale_fill_viridis_c(option = "magma")     # Drama oscuro
scale_fill_viridis_c(option = "plasma")    # Energético
scale_fill_paletteer_c("scico::batlow")    # Perceptual uniforme

# 3. DIVERGENTE — Para datos con centro significativo (0, media)
scale_fill_gradient2(
  low = "#2196F3", mid = "white", high = "#E84855",
  midpoint = 0
)
scale_fill_paletteer_c("scico::roma")      # Divergente suave

# 4. HIGHLIGHT — Para enfatizar UN elemento
# Todos grises, uno de color
datos %>%
  mutate(color = ifelse(pais == "Colombia", "#FF6B35", "grey70")) %>%
  ggplot(aes(x, y, color = I(color))) +
  geom_point(size = 3)
```

---

## Reglas de Oro del Color en Dataviz

### Regla 1: Menos es Más
```r
# ❌ Mal: usar 8 colores distintos en barras
ggplot(datos, aes(categoria, valor, fill = categoria)) +
  geom_col()

# ✅ Bien: un color base + highlight
ggplot(datos, aes(categoria, valor)) +
  geom_col(fill = "grey80") +
  geom_col(data = filter(datos, categoria == "Principal"),
           fill = "#E84855")
```

### Regla 2: Color con Propósito Semántico
```r
# Verde = positivo/crecimiento/bueno
# Rojo = negativo/decrecimiento/peligro
# Azul = neutral/datos/información
# Naranja = alerta/advertencia
# Gris = no-dato/fondo/contexto

colores_semánticos <- list(
  positivo  = "#4CAF50",
  negativo  = "#F44336",
  neutral   = "#2196F3",
  alerta    = "#FF9800",
  contexto  = "#9E9E9E"
)
```

### Regla 3: Contraste Mínimo 4.5:1 (WCAG AA)
```r
library(colorspace)

# Verificar contraste
contrast_ratio("#FFFFFF", "#2196F3")  # Blanco sobre azul
contrast_ratio("#1B1B2F", "#00FF88")  # Dark bg sobre neón verde

# Herramienta: https://webaim.org/resources/contrastchecker/
```

---

## Accesibilidad — Daltonismo

```r
library(colorBlindness)

# Simular cómo ve tu gráfico alguien con daltonismo
cvdPlot(mi_plot)

# Las paletas más seguras para daltonismo
# (funcionan para deuteranopía, protanopía, tritanopía):

paleta_daltonico_segura <- c(
  "#000000",  # Negro
  "#E69F00",  # Naranja
  "#56B4E9",  # Azul cielo
  "#009E73",  # Verde azulado
  "#F0E442",  # Amarillo
  "#0072B2",  # Azul oscuro
  "#D55E00",  # Rojo-naranja
  "#CC79A7"   # Rosa-morado
)
# Fuente: Wong (2011) - Nature Methods

# Evitar SIEMPRE: rojo-verde juntos como oposición semántica
# ❌ Mal:  c("#FF0000", "#00FF00")
# ✅ Bien: c("#D55E00", "#0072B2")
```

---

## Paletas por Contexto / Audiencia

### Corporativo / Business
```r
# Paletas corporativas que se sienten "profesionales"
paleta_corp_azul  <- c("#003366", "#0052CC", "#0079FF", "#4DA6FF", "#99CCFF")
paleta_corp_verde <- c("#004D26", "#008040", "#00B359", "#40CC80", "#99EEC0")
paleta_corp_rojo  <- c("#660000", "#CC0000", "#FF3333", "#FF8080", "#FFCCCC")
```

### Científico / Académico
```r
# Perceptualmente uniformes, publicables en escala de grises
paletteer::paletteer_c("scico::batlow")   # Universal
paletteer::paletteer_c("scico::roma")     # Divergente
paletteer::paletteer_c("viridis::viridis") # El clásico
paletteer::paletteer_d("ggsci::npg")      # Nature Publishing Group
paletteer::paletteer_d("ggsci::lancet")   # The Lancet
```

### Arte / Creativo
```r
# Inspiradas en obras de arte
paletteer::paletteer_d("MetBrewer::Hiroshige")   # Hokusai
paletteer::paletteer_d("MetBrewer::VanGogh3")    # Van Gogh - Noche Estrellada
paletteer::paletteer_d("MetBrewer::Klimt")       # Klimt - El Beso
paletteer::paletteer_d("wesanderson::GrandBudapest1") # Wes Anderson
paletteer::paletteer_d("wesanderson::Moonrise3")
```

### Periodismo / Noticias
```r
# Limpias, legibles, neutrales
paletteer::paletteer_d("ggthemes::Tableau_10")
paletteer::paletteer_d("ggthemes::economist_pal")
# o manualmente:
paleta_periodismo <- c("#003F5C", "#58508D", "#BC5090", "#FF6361", "#FFA600")
```

---

## Gradientes Personalizados

```r
# Gradiente de 3 puntos
scale_fill_gradientn(
  colors = c("#003F5C", "#BC5090", "#FFA600"),
  values = scales::rescale(c(0, 0.5, 1))
)

# Gradiente perceptual con colorspace
library(colorspace)
paleta_grad <- sequential_hcl(10, palette = "Purple-Blue")
diverge_hcl(10, palette = "Blue-Red 3")

# Generar paleta a partir de imagen (extrae colores dominantes)
library(colorfindr)
get_colors("mi_imagen.jpg") %>%
  make_palette(n = 5)
```

---

## Herramientas Online Complementarias

- **Coolors.co** — Generador de paletas interactivo
- **Adobe Color** — Reglas de armonía (complementario, análogo, triádico)
- **ColorBrewer2.org** — Paletas científicas probadas
- **Viz Palette** — Prueba paletas en gráficos reales
- **Chroma.js Color Scale Helper** — Gradientes perceptuales
- **Paletton** — Diseño de paletas basado en teoría del color

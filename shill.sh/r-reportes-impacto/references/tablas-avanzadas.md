# Tablas Avanzadas en R — gt, flextable, reactable, DT

## gt — El Estándar para Publicación

### Temas gt disponibles (gtExtras)
```r
# Los 7 temas más usados:
gt_theme_guardian()    # Estilo The Guardian — elegante y limpio
gt_theme_espn()        # Deportivo, colorido, compacto
gt_theme_nytimes()     # New York Times — tipografía serif, sobrio
gt_theme_dot_matrix()  # Retro, para audiencias creativas
gt_theme_pff()         # Pro Football Focus — muy denso, mucha info
gt_theme_excel()       # Familiar para audiencias corporativas
gt_theme_dark()        # Modo oscuro, para presentaciones
```

### gt Completo con Todas las Funciones
```r
datos %>%
  gt(groupname_col = "categoria", rowname_col = "producto") %>%
  
  # === ENCABEZADO ===
  tab_header(
    title    = md("**Tabla de Ventas**"),
    subtitle = md("*Desempeño Q3 2024*")
  ) %>%
  
  # === SPANNERS (columnas agrupadas) ===
  tab_spanner("Trimestre 1", columns = c(ene, feb, mar)) %>%
  tab_spanner("Trimestre 2", columns = c(abr, may, jun)) %>%
  
  # === FORMATO ===
  fmt_currency(columns = where(is.numeric), currency = "USD", decimals = 0) %>%
  fmt_percent(columns = variacion, decimals = 1) %>%
  fmt_date(columns = fecha, date_style = "yMd") %>%
  fmt_number(columns = ratio, decimals = 2, sep_mark = ".", dec_mark = ",") %>%
  
  # === COLUMNAS CALCULADAS ===
  cols_add(total = ene + feb + mar + abr + may + jun) %>%
  
  # === ESTILOS CONDICIONALES ===
  tab_style(
    style    = cell_fill(color = "#E8F5E9"),
    locations = cells_body(columns = total, rows = total > 1000000)
  ) %>%
  tab_style(
    style    = list(cell_text(weight = "bold"), cell_fill(color = "#FFEBEE")),
    locations = cells_body(columns = variacion, rows = variacion < 0)
  ) %>%
  
  # === COLOR CONTINUO ===
  data_color(
    columns = total,
    method  = "numeric",
    palette = "Blues"
  ) %>%
  
  # === SPARKLINES (gtExtras) ===
  gt_plt_sparkline(tendencia, type = "shaded") %>%
  gt_plt_bar_pct(pct_meta, labels = TRUE, fill = "#2196F3") %>%
  gt_plt_bullet(col = real, target = meta, width = 45) %>%
  
  # === ICONOS Y EMOJIS ===
  gt_fa_rating(stars, icon = "star", max_rating = 5) %>%
  text_transform(
    locations = cells_body(columns = tendencia_dir),
    fn = function(x) {
      ifelse(x == "up", "▲", "▼")
    }
  ) %>%
  
  # === NOTAS Y FUENTES ===
  tab_footnote(
    footnote  = "Incluye descuentos aplicados",
    locations = cells_column_labels(columns = total)
  ) %>%
  tab_source_note(md("**Fuente:** ERP interno — Extracción 30/09/2024")) %>%
  
  # === OPCIONES GLOBALES ===
  tab_options(
    table.width                 = pct(100),
    heading.align               = "left",
    column_labels.font.weight   = "bold",
    column_labels.background.color = "#F5F5F5",
    row_group.font.weight       = "bold",
    row_group.background.color  = "#E8EAF6",
    summary_row.background.color = "#FFFDE7",
    grand_summary_row.background.color = "#FFF9C4",
    stub.border.width           = 0,
    table.border.top.color      = "transparent",
    table.border.bottom.color   = "transparent"
  ) %>%
  
  # === FILAS DE RESUMEN ===
  summary_rows(
    groups   = TRUE,
    columns  = where(is.numeric),
    fns      = list(Total = ~sum(.)),
    fmt      = ~ fmt_currency(., currency = "USD", decimals = 0)
  ) %>%
  grand_summary_rows(
    columns = where(is.numeric),
    fns     = list("Gran Total" = ~sum(.)),
    fmt     = ~ fmt_currency(., currency = "USD", decimals = 0)
  )
```

---

## flextable — Para Word y PowerPoint

```r
library(flextable)
library(officer)

ft <- datos %>%
  flextable() %>%
  
  # Encabezado
  add_header_row(
    values = c("", "Ventas por trimestre", ""),
    colwidths = c(1, 4, 1)
  ) %>%
  
  # Alineación
  align(align = "center", part = "header") %>%
  align(j = 1, align = "left", part = "all") %>%
  
  # Formato numérico
  colformat_double(j = 2:5, digits = 0, big.mark = ",", prefix = "$") %>%
  colformat_double(j = 6, digits = 1, suffix = "%") %>%
  
  # Estilo de encabezado
  bold(part = "header") %>%
  bg(bg = "#2196F3", part = "header") %>%
  color(color = "white", part = "header") %>%
  
  # Color condicional
  bg(
    i = ~ variacion < 0,
    bg = "#FFEBEE"
  ) %>%
  bg(
    i = ~ variacion >= 10,
    bg = "#E8F5E9"
  ) %>%
  
  # Bordes
  border_outer(part = "all", border = fp_border(color = "#BDBDBD")) %>%
  border_inner_h(border = fp_border(color = "#E0E0E0", width = 0.5)) %>%
  
  # Ancho de columnas
  set_table_properties(width = 1, layout = "autofit") %>%
  
  # Fuente
  font(fontname = "Calibri", part = "all") %>%
  fontsize(size = 10, part = "all") %>%
  fontsize(size = 11, part = "header") %>%
  
  # Nota al pie
  add_footer_row(
    values = "Fuente: Sistema ERP — Extracción 30/09/2024",
    colwidths = ncol(datos)
  ) %>%
  italic(part = "footer") %>%
  color(color = "grey50", part = "footer")

# Para insertar en Word
doc <- read_docx() %>%
  body_add_par("Análisis de Ventas", style = "heading 1") %>%
  body_add_flextable(ft) %>%
  body_add_par("", style = "Normal")

print(doc, target = "reporte.docx")
```

---

## reactable — Tablas HTML Interactivas

```r
library(reactable)
library(htmltools)

reactable(
  datos,
  
  # Búsqueda y filtros
  searchable   = TRUE,
  filterable   = TRUE,
  
  # Paginación
  pagination   = TRUE,
  defaultPageSize = 15,
  showPageSizeOptions = TRUE,
  pageSizeOptions = c(10, 15, 25, 50),
  
  # Ordenamiento
  sortable  = TRUE,
  resizable = TRUE,
  
  # Columnas con formato especial
  columns = list(
    ventas = colDef(
      name   = "Ventas",
      format = colFormat(prefix = "$", separators = TRUE),
      style  = function(value) {
        color <- if (value > 1000000) "#4CAF50" else if (value < 500000) "#F44336" else "black"
        list(color = color, fontWeight = "bold")
      }
    ),
    variacion = colDef(
      name = "Variación",
      format = colFormat(percent = TRUE, digits = 1),
      cell  = function(value) {
        icon <- if (value > 0) "▲" else "▼"
        color <- if (value > 0) "#4CAF50" else "#F44336"
        div(style = list(color = color, fontWeight = "bold"), paste(icon, abs(round(value*100, 1)), "%"))
      }
    ),
    barra = colDef(
      name = "vs Meta",
      cell = function(value) {
        width <- paste0(min(value * 100, 100), "%")
        color <- if (value >= 1) "#4CAF50" else "#2196F3"
        div(
          div(style = list(background = "#f0f0f0", borderRadius = "4px"),
              div(style = list(background = color, width = width, height = "14px", borderRadius = "4px")))
        )
      }
    )
  ),
  
  # Agrupación
  groupBy = "region",
  
  # Estilo global
  theme = reactableTheme(
    headerStyle = list(background = "#F5F5F5", fontWeight = "bold"),
    borderColor = "#E0E0E0",
    stripedColor = "#FAFAFA"
  ),
  
  # Highlight al hover
  highlight   = TRUE,
  striped     = TRUE,
  bordered    = TRUE,
  compact     = FALSE
)
```

---

## DT — DataTables para Exploración

```r
library(DT)

datatable(
  datos,
  extensions = c("Buttons", "ColReorder", "FixedHeader"),
  options = list(
    dom     = "Blfrtip",
    buttons = list(
      "copy",
      list(extend = "collection",
           buttons = c("csv", "excel", "pdf"),
           text = "Descargar")
    ),
    pageLength  = 20,
    fixedHeader = TRUE,
    colReorder  = TRUE,
    language = list(
      url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json"
    )
  ),
  filter   = "top",
  rownames = FALSE,
  class    = "display compact"
) %>%
  formatCurrency("ventas", currency = "$", digits = 0) %>%
  formatPercentage("variacion", digits = 1) %>%
  formatStyle(
    "variacion",
    color = styleInterval(0, c("red", "green")),
    fontWeight = "bold"
  ) %>%
  formatStyle(
    "estado",
    backgroundColor = styleEqual(
      c("Activo", "Inactivo", "Pendiente"),
      c("#E8F5E9", "#FFEBEE", "#FFF9C4")
    )
  )
```

---

## kableExtra — PDF y HTML Clásico

```r
library(kableExtra)

datos %>%
  kbl(
    caption = "Tabla 1. Resumen de resultados por región",
    col.names = c("Región", "Ventas", "Clientes", "Variación", "Estado"),
    format.args = list(big.mark = ","),
    align = c("l", "r", "r", "r", "c"),
    booktabs = TRUE,   # Para PDF LaTeX
    escape = FALSE     # Permite HTML en celdas
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = TRUE,
    font_size  = 13
  ) %>%
  column_spec(1, bold = TRUE, width = "10em") %>%
  column_spec(4, color = ifelse(datos$variacion < 0, "red", "green"),
              bold = TRUE) %>%
  row_spec(which(datos$es_top), background = "#E8F5E9", bold = TRUE) %>%
  add_header_above(c(" " = 1, "Financiero" = 2, "Comparativo" = 2)) %>%
  pack_rows("Región Andina", 1, 3) %>%
  pack_rows("Región Caribe", 4, 6) %>%
  footnote(
    general = "Fuente: ERP — Extracción 30/09/2024",
    symbol  = "Incluye ajustes por estacionalidad"
  )
```

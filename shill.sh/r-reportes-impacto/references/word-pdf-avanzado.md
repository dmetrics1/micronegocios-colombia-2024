# Word y PDF Avanzado con R — officedown, pagedown, LaTeX

## officedown — Word Profesional con Control Total

### Setup del documento
```r
---
output:
  officedown::rdocx_document:
    reference_docx: plantilla-corporativa.docx
    tables:
      style: "Table Professional"
      layout: autofit
      width: 1.0
      topcaption: true
    plots:
      style: Normal
      align: center
      topcaption: false
    page_size:
      width: 8.5
      height: 11
      orient: "portrait"
    page_margins:
      bottom: 1
      top: 1.2
      right: 1.25
      left: 1.25
      header: 0.5
      footer: 0.5
---
```

### Elementos de layout en officedown
```r
library(officedown)
library(officer)

# Salto de página
block_pour_docx(file_path = "portada.docx")

# Salto de sección
block_section(
  prop_section(
    page_size      = page_size(width = 11, height = 8.5, orient = "landscape"),
    page_margins   = page_mar(bottom = 0.5, top = 0.5),
    type           = "nextPage"
  )
)

# Columnas (tipo revista)
block_section(
  prop_section(
    type           = "continuous",
    section_columns = section_columns(widths = c(3, 3), sep = TRUE)
  )
)

# Tabla de contenidos desde R
block_toc(level = 2, style = "heading 2")

# Lista de figuras / tablas
block_toc(style = "Image Caption", label = "Figura")
block_toc(style = "Table Caption", label = "Tabla")
```

### Texto con formato rico en Word
```r
# Párrafo con estilos
fpar(
  ftext("Resultado: ", prop = fp_text(bold = TRUE, color = "#2196F3")),
  ftext("+12.4% de crecimiento interanual", prop = fp_text(italic = TRUE)),
  fp_p = fp_par(text.align = "justify")
)

# Cuadro de resumen ejecutivo (shaded box)
block_pour_docx(
  file_path = officer::read_docx() %>%
    body_add_par("RESUMEN EJECUTIVO", style = "heading 2") %>%
    body_add_par(
      "Las ventas del Q3 2024 superaron las proyecciones en 8.3%...",
      style = "Normal"
    ) %>%
    body_add_par("") 
)
```

---

## pagedown — PDF Paginado Tipo Libro/Revista

```r
---
title: "Informe Anual 2024"
subtitle: "Análisis de Desempeño Corporativo"
author: "Equipo de Análisis"
date: "2024"
output:
  pagedown::html_paged:
    toc: true
    toc_depth: 2
    number_sections: true
    self_contained: true
    css: ["default", "custom-page.css"]
    front_cover: "portada.jpg"
    back_cover: "contraportada.jpg"
---
```

### CSS para pagedown (custom-page.css)
```css
/* Variables de diseño */
:root {
  --color-primario: #2196F3;
  --color-acento: #FF6B35;
  --font-titulo: 'Outfit', sans-serif;
  --font-cuerpo: 'DM Sans', sans-serif;
}

/* Portada */
.front-page {
  background: linear-gradient(135deg, #1B1B2F 0%, #2D3561 100%);
  color: white;
}

/* Encabezado de página */
@page {
  @top-right { content: "Confidencial — 2024"; font-size: 9pt; color: grey; }
  @bottom-center { content: counter(page) " / " counter(pages); }
}

/* Estilo de capítulos */
h1.chapter {
  color: var(--color-primario);
  border-bottom: 3px solid var(--color-primario);
  padding-bottom: 0.3em;
  page-break-before: always;
}

/* Caja de nota */
.nota-importante {
  background: #E3F2FD;
  border-left: 4px solid var(--color-primario);
  padding: 1em;
  margin: 1.5em 0;
}
```

---

## Quarto PDF con LaTeX Avanzado

### Header LaTeX personalizado
```latex
% En el YAML del .qmd:
include-in-header:
  text: |
    % Paquetes
    \usepackage{fancyhdr}
    \usepackage{booktabs}
    \usepackage{longtable}
    \usepackage{array}
    \usepackage{multirow}
    \usepackage{colortbl}
    \usepackage{xcolor}
    \usepackage{graphicx}
    \usepackage{float}
    \usepackage{enumitem}
    \usepackage{tcolorbox}
    
    % Colores corporativos
    \definecolor{primario}{HTML}{2196F3}
    \definecolor{acento}{HTML}{FF6B35}
    \definecolor{exito}{HTML}{4CAF50}
    \definecolor{alerta}{HTML}{F44336}
    
    % Header/Footer
    \pagestyle{fancy}
    \fancyhf{}
    \fancyhead[L]{\color{gray}\small\leftmark}
    \fancyhead[R]{\color{gray}\small\textit{Confidencial}}
    \fancyfoot[C]{\color{gray}\small Página \thepage\ de \pageref{LastPage}}
    \renewcommand{\headrulewidth}{0.4pt}
    \renewcommand{\headrule}{\hbox to\headwidth{\color{primario}\leaders\hrule height \headrulewidth\hfill}}
    
    % Cajas de color
    \tcbuselibrary{skins}
    \newtcolorbox{notabox}[1][]{
      colback=blue!5, colframe=primario,
      fonttitle=\bfseries, title=#1
    }
    \newtcolorbox{alertabox}[1][]{
      colback=red!5, colframe=alerta,
      fonttitle=\bfseries, title=#1
    }
```

### Usar cajas LaTeX en Quarto
```markdown
```{=latex}
\begin{notabox}[Hallazgo Principal]
Las ventas superaron la meta en 8.3\%, impulsadas por el segmento corporativo.
\end{notabox}
```
```

---

## Generación Masiva de Reportes Word

```r
# Generar un Word por cliente automáticamente
library(officer)
library(flextable)
library(purrr)
library(dplyr)

clientes <- c("Empresa A", "Empresa B", "Empresa C")

walk(clientes, function(cliente) {
  datos_cliente <- datos %>% filter(empresa == cliente)
  
  # Crear tabla flextable
  ft <- datos_cliente %>%
    select(mes, ventas, meta, variacion) %>%
    flextable() %>%
    theme_booktabs() %>%
    set_table_properties(width = 1, layout = "autofit")
  
  # Crear gráfico y guardarlo
  p <- ggplot(datos_cliente, aes(mes, ventas)) +
    geom_line(color = "#2196F3", linewidth = 1.5) +
    tema_reporte
  
  ggsave(glue("temp_{cliente}.png"), p, width = 8, height = 4, dpi = 200)
  
  # Construir documento Word
  doc <- read_docx("plantilla.docx") %>%
    
    # Portada
    body_add_par(glue("Reporte: {cliente}"), style = "Title") %>%
    body_add_par(glue("Generado: {Sys.Date()}"), style = "Subtitle") %>%
    body_add_break() %>%
    
    # Contenido
    body_add_par("Desempeño de ventas", style = "heading 1") %>%
    body_add_gg(p, width = 6.5, height = 4) %>%
    body_add_par("") %>%
    body_add_par("Detalle mensual", style = "heading 2") %>%
    body_add_flextable(ft) %>%
    body_add_par(
      glue("Fuente: Sistema ERP — {Sys.Date()}"),
      style = "Caption"
    )
  
  # Guardar
  output_path <- glue("reportes/Reporte_{cliente}_{Sys.Date()}.docx")
  print(doc, target = output_path)
  message("✅ Generado: ", output_path)
  
  # Limpiar temporales
  file.remove(glue("temp_{cliente}.png"))
})
```

---

## Envío Automático por Email

```r
library(blastula)

# Crear email con gráfico embebido
email_body <- compose_email(
  body = md(glue("
# Reporte Mensual — {format(Sys.Date(), '%B %Y')}

Estimado equipo,

Adjunto el reporte de desempeño correspondiente a **{params$periodo}**.

## Resumen rápido

- 📈 Ventas: **$4.7M** (+12.1% vs mes anterior)
- 👥 Clientes activos: **23,814**
- ⭐ NPS: **72** (+5 puntos)

El reporte completo está adjunto en este correo.

---
*Generado automáticamente con R el {format(Sys.time(), '%d/%m/%Y %H:%M')}*
  ")),
  footer = md("Equipo de Análisis de Datos | Empresa XYZ")
)

# Enviar
smtp_send(
  email     = email_body,
  to        = "gerencia@empresa.com",
  from      = "datos@empresa.com",
  subject   = glue("📊 Reporte {params$periodo} — {params$region}"),
  credentials = creds_file(".email_creds"),
  attachments = glue("reportes/Reporte_{params$region}_{Sys.Date()}.pdf")
)
```

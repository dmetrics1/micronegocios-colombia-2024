# =====================================================================
# PRESENTACIÓN LatinR 2026 — build.R
# =====================================================================
# Genera todo lo que index.html necesita y que NO debe escribirse a mano:
#   - datos.js   → window.DATOS con todas las cifras (desde ../output/tablas)
#   - figs/dark/*.png y figs/light/*.png → gráficos con el tema DM
#
# Ejecutar desde la carpeta presentacion/:  Rscript build.R
# (requiere haber corrido ../main.R antes)
# =====================================================================

suppressPackageStartupMessages({
  library(data.table); library(ggplot2); library(scales); library(jsonlite)
  library(sf); library(igraph); library(tidygraph); library(ggraph); library(ggrepel)
  library(patchwork); library(ragg)
})
# Tokens, fuentes y etiquetas compartidos con el pipeline y el reporte
source(file.path("..", "scripts", "tema_dm.R"))

# ---------------------------------------------------------------------
# 1. DATOS
# ---------------------------------------------------------------------
leer <- function(f) fread(file.path("..", "output", "tablas", f), encoding = "UTF-8")
bol  <- function(f) fread(file.path("..", "output", "tablas", "boletin", f), encoding = "UTF-8")
v    <- function(f, fila) { d <- bol(f); d[d[[1]] == fila, Distribucion_Pct] }

seg    <- leer("11_segmentacion_grupos.csv")
subg   <- leer("11a_segmentacion_subgrupos.csv")
perfil <- leer("11b_perfil_grupos.csv")
esc    <- leer("11c_celular_x_internet.csv")
sens   <- leer("12_sensibilidad_umbrales.csv")
clave  <- leer("12a_reglas_clave.csv")
comp   <- leer("12b_ponderado_vs_muestral.csv")
rut5   <- leer("12d_reglas_rut_sin_formalizacion.csv")
reglas <- leer("06b_reglas_ponderadas.csv")
t39    <- leer("10_TABLA_RESUMEN_FILTRADA_20PCT.csv")
idx    <- leer("03_indices_distribucion.csv")
J2     <- bol("J2_Indicadores_por_Departamento.csv")
val    <- fread("../data/reference/validacion_dane.csv", encoding = "UTF-8")
extra  <- fread("../data/reference/dane_boletin_extra.csv", encoding = "UTF-8")

val[, generado := mapply(function(a, f, c) { d <- bol(a); d[d[[1]] == f][[c]] }, archivo, fila, columna)]
val[, dif := generado - valor_dane]

cv <- function(m) comp[medida == m, valor]
r_excl <- clave[hallazgo == "Exclusión digital acumulada"]
r_cel  <- clave[hallazgo == "Sin celular → sin internet"]
r_tic  <- clave[hallazgo == "TIC acopladas"]
r_max  <- reglas[which.max(lift)]
g <- function(n) seg[grupo == n]
pf <- function(n, col) perfil[grupo == n][[col]]

item_label <- etiqueta_item   # diccionario único en scripts/tema_dm.R
rule_parts <- function(r) {
  p <- strsplit(gsub("[{}]", "", r), " => ")[[1]]
  list(lhs = item_label(strsplit(p[1], ",")[[1]]), rhs = item_label(p[2]))
}

DATOS <- list(
  universo      = sum(seg$Universo),
  muestra       = sum(seg$Muestra),
  n_apriori     = round(reglas$count[1] / reglas$support[1]),
  n_modulos     = length(list.files("../data/raw/2024", pattern = "\\.csv$")),
  n_cuadros     = length(list.files("../output/tablas/boletin", pattern = "\\.csv$")),
  sin_rut       = v("F1_RUT.csv", "No"),
  sin_internet  = v("G9_Uso_Internet.csv", "No"),
  credito       = v("H2_Solicito_Credito.csv", "Sí"),
  celular       = v("G4A_Uso_Celular.csv", "Sí"),
  cuenta_propia = v("A1_Situacion_Empleo.csv", "Trabajador(a) por cuenta propia"),
  unipersonal   = v("E2_Rangos_Personal.csv", "1 persona"),
  mujeres       = v("A2_Sexo_Propietario.csv", "Mujer"),
  sin_camara    = v("F6_Camara_Comercio.csv", "No"),
  dispositivos  = v("G1_Dispositivos_Electronicos.csv", "Sí"),
  rut_rural     = extra[indicador == "Sin RUT" & grepl("rural", dominio), valor],
  rut_cabecera  = extra[indicador == "Sin RUT" & grepl("Cabeceras", dominio), valor],
  n_generadas   = sens[soporte == 0.15 & confianza == 0.70, n_reglas],
  n_no_redund   = sens[soporte == 0.15 & confianza == 0.70, n_no_redundantes],
  n_39          = nrow(t39),
  n_rut_15      = sum(grepl("=> {tiene_rut=Sí}", reglas$rules, fixed = TRUE)),
  n_combos      = nrow(sens),
  val_ok        = sum(abs(val$dif) <= 0.1),
  val_total     = nrow(val),
  val_max_dif   = max(abs(val$dif)),
  val_max_ind   = val$indicador[which.max(abs(val$dif))],
  regla_excl    = c(rule_parts(r_excl$regla), list(conf = r_excl$confidence_pond * 100, sop = r_excl$support_pond * 100,
                     lift = r_excl$lift_pond, lift_m = r_excl$lift, negocios = r_excl$support_pond * sum(seg$Universo))),
  regla_cel     = c(rule_parts(r_cel$regla), list(conf = r_cel$confidence_pond * 100, lift = r_cel$lift_pond)),
  regla_tic     = c(rule_parts(r_tic$regla), list(conf = r_tic$confidence_pond * 100, conf_m = r_tic$confidence * 100,
                     lift = r_tic$lift_pond, lift_m = r_tic$lift)),
  regla_rut     = c(rule_parts(rut5$regla[1]), list(conf = rut5$confidence_pond[1] * 100, lift = rut5$lift_pond[1], sop = rut5$support_pond[1] * 100)),
  regla_max     = c(rule_parts(r_max$rules), list(lift = r_max$lift, lift_p = r_max$lift_pond)),
  cor_lift      = cv("Correlación lift muestral vs ponderado"),
  en_ambos      = cv("Reglas en ambos conjuntos"),
  n_muestral    = cv("Reglas conjunto muestral (supp≥15%, conf≥70%)"),
  n_ponderado   = cv("Reglas conjunto ponderado (supp≥15%, conf≥70%)"),
  grupos        = seg[match(c("Excluidos", "En transición", "Integrados"), grupo), .(grupo, Muestra, Universo, Porcentaje)],
  sub_net_sinrut = subg[subgrupo == "Con internet, sin RUT", Porcentaje],
  sub_rut_sinnet = subg[subgrupo == "Con RUT, sin internet", Porcentaje],
  perfil        = perfil,
  cel_sin_net   = esc[Celular == "Usa celular" & Internet == "Sin internet", .(Universo, Porcentaje)],
  idx_form_prom = idx[Indice == "Formalización (0-5)", Promedio][1],
  idx_dig_prom  = idx[Indice == "Digital (0-4)", Promedio][1],
  idx_form_0    = idx[Indice == "Formalización (0-5)" & Puntaje == 0, Pct],
  idx_form_5    = idx[Indice == "Formalización (0-5)" & Puntaje == 5, Pct],
  comparacion   = comp,
  validacion    = val[, .(cuadro, indicador, valor_dane, generado = round(generado, 2), dif = round(dif, 2))],
  top3_deptos   = J2[order(-Pct_Distribucion)][1:3, .(COD_DEPTO_DESC, Pct_Distribucion, Pct_Con_Internet, Pct_Con_RUT)],
  generado_en   = format(Sys.time(), "%Y-%m-%d %H:%M")
)

writeLines(paste0("window.DATOS = ", toJSON(DATOS, auto_unbox = TRUE, digits = NA, pretty = TRUE), ";"),
           "datos.js", useBytes = TRUE)
message("✓ datos.js")

# ---------------------------------------------------------------------
# 2. FIGURAS (dos temas)
# ---------------------------------------------------------------------
tema <- dm_tokens   # tokens con colores convertidos a hex (scripts/tema_dm.R)
dm_theme <- function(t, base = 20) {
  theme_minimal(base_family = DM_FONT_BODY) +
    theme(
      text = element_text(size = base, colour = t$textBody),
      plot.title = element_text(family = DM_FONT_HEADING, colour = t$textTitle, face = "bold", size = base * 1.1),
      plot.subtitle = element_text(colour = t$textMuted, size = base * 0.8),
      axis.text = element_text(colour = t$textMuted, size = base * 0.85),
      axis.title = element_text(colour = t$textMuted, size = base * 0.85),
      legend.text = element_text(colour = t$textBody, size = base * 0.8),
      legend.title = element_text(colour = t$textMuted, size = base * 0.8),
      legend.position = "bottom", legend.background = element_blank(), legend.key = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(colour = t$chartGrid),
      plot.background = element_rect(fill = "transparent", colour = NA),
      panel.background = element_rect(fill = "transparent", colour = NA),
      strip.text = element_text(colour = t$textTitle, family = DM_FONT_HEADING, face = "bold", size = base),
      plot.margin = margin(10, 16, 8, 8)
    )
}
guardar <- function(p, nombre, w, h, dark) {
  dir <- file.path("figs", if (dark) "dark" else "light")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  agg_png(file.path(dir, paste0(nombre, ".png")), width = w * 2, height = h * 2, units = "px",
          res = 192, background = "transparent")
  print(p); dev.off()
}

figuras <- function(dark) {
  t <- tema(dark)
  seq_cols <- if (dark) DM_BLUE_TEAL_30[c(4, 12, 20, 30)] else DM_BLUE_TEAL_30[c(8, 15, 22, 30)]

  # --- Validación DANE: diferencias en p.p. ---
  vd <- copy(val)[, etiqueta := factor(paste0(cuadro, " · ", indicador), levels = rev(paste0(cuadro, " · ", indicador)))]
  p <- ggplot(vd, aes(x = dif, y = etiqueta)) +
    annotate("rect", xmin = -0.1, xmax = 0.1, ymin = -Inf, ymax = Inf, fill = t$positive, alpha = 0.10) +
    geom_vline(xintercept = 0, colour = t$textMuted, linewidth = 0.5) +
    geom_segment(aes(x = 0, xend = dif, yend = etiqueta), colour = t$ink$navy, linewidth = 1.8) +
    geom_point(aes(colour = abs(dif) <= 0.1), size = 6.5) +
    geom_text(aes(label = ifelse(abs(dif) > 0.1, paste0("+", format(round(dif, 2), decimal.mark = ",")), "")),
              hjust = -0.4, family = DM_FONT_MONO, colour = t$accent3, size = 6, fontface = "bold") +
    scale_colour_manual(values = c(`TRUE` = t$accent2, `FALSE` = t$accent3), guide = "none") +
    scale_x_continuous(labels = function(x) paste0(ifelse(x > 0, "+", ""), format(x, decimal.mark = ",")), limits = c(-1.3, 1.5)) +
    labs(x = "Diferencia pipeline − DANE (puntos porcentuales)", y = NULL) +
    dm_theme(t, 22)
  guardar(p, "validacion", 980, 720, dark)

  # --- Scatter soporte vs confianza ---
  set.seed(42)
  m <- reglas[sample(.N, min(.N, 25000))]
  hl <- rbind(r_excl, r_cel, r_tic)[, .(support, confidence, etiqueta = c("Exclusión acumulada", "Sin celular → sin internet", "TIC acopladas"))]
  p <- ggplot(m, aes(support, confidence)) +
    geom_point(aes(colour = lift_pond), alpha = if (dark) 0.2 else 0.25, size = 1.2) +
    geom_point(data = hl, colour = t$accent3, size = 7, shape = 21, stroke = 2, fill = NA) +
    geom_text_repel(data = hl, aes(label = etiqueta), colour = t$accent3, family = DM_FONT_BODY, size = 7,
                    nudge_y = -0.06, seed = 1, box.padding = 0.8, fontface = "bold") +
    scale_colour_gradientn(colours = seq_cols, name = "Lift ponderado") +
    scale_x_continuous(labels = label_percent(accuracy = 1)) +
    scale_y_continuous(labels = label_percent(accuracy = 1)) +
    labs(x = "Soporte", y = "Confianza") +
    dm_theme(t, 22) + theme(legend.position = "right", legend.key.height = unit(1.4, "cm"))
  guardar(p, "scatter", 1100, 620, dark)

  # --- Red de reglas ---
  top <- reglas[order(-lift_pond)][1:40]
  top <- rbind(top, reglas[grepl("=> {acepta_transferencia=Sí}", rules, fixed = TRUE)][order(-lift_pond)][1:6])
  edges <- rbindlist(lapply(seq_len(nrow(top)), function(i) {
    partes <- strsplit(gsub("[{}]", "", top$rules[i]), " => ")[[1]]
    data.table(from = strsplit(partes[1], ",")[[1]], to = partes[2], lift = top$lift_pond[i])
  }))[, .(n = .N, lift = max(lift)), by = .(from, to)]
  dominio <- function(x) fcase(
    grepl("^(usa_|internet_|tiene_sitio)", x), "TIC",
    grepl("^acepta_", x), "Medios de pago",
    grepl("^(tiene_rut|tiene_camara|tipo_contab|declara_|es_persona|paga_seg)", x), "Formalización",
    default = "Perfil y ubicación")
  nodes <- data.table(name = unique(c(edges$from, edges$to)))
  nodes[, `:=`(dom = dominio(name), label = item_label(name))]
  gr <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE) |> activate(nodes) |>
    mutate(grado = centrality_degree(mode = "all"))
  cols_dom <- c("TIC" = t$accent2, "Medios de pago" = if (dark) t$ink$pale else t$ink$deep,
                "Formalización" = t$accent3, "Perfil y ubicación" = t$textMuted)
  set.seed(7)
  p <- ggraph(gr, layout = "stress") +
    geom_edge_fan(aes(width = n, alpha = lift), colour = t$ink$navy,
                  arrow = arrow(length = unit(3.5, "mm"), type = "closed"), end_cap = circle(5, "mm")) +
    scale_edge_width(range = c(0.5, 3), guide = "none") + scale_edge_alpha(range = c(0.3, 0.9), guide = "none") +
    geom_node_point(aes(colour = dom, size = grado)) +
    geom_node_label(aes(label = label, colour = dom), family = DM_FONT_BODY, size = 5.6, repel = TRUE,
                    fill = t$surface1, label.size = 0, label.padding = unit(0.25, "lines"), show.legend = FALSE) +
    scale_colour_manual(values = cols_dom, name = NULL) + scale_size(range = c(3, 13), guide = "none") +
    dm_theme(t, 20) + theme(panel.grid = element_blank(), axis.text = element_blank(), axis.title = element_blank(),
                            legend.position = "top") +
    guides(colour = guide_legend(override.aes = list(size = 6)))
  guardar(p, "red", 1080, 860, dark)

  # --- Perfil de grupos ---
  cols_g <- c("Excluidos" = t$negative, "En transición" = t$accent3, "Integrados" = t$positive)
  pl <- melt(perfil[grupo != "Total", .(grupo,
    `Acepta transferencias` = Acepta_transferencia_pct, `Lleva registro contable` = Lleva_registro_pct,
    `Cámara de Comercio` = Camara_comercio_pct, `Ahorró el último año` = Ahorro_pct,
    `Solicitó crédito` = Solicito_credito_pct, `Zona rural` = Rural_pct)],
    id.vars = "grupo", variable.name = "indicador", value.name = "pct")
  pl[, grupo := factor(grupo, levels = names(cols_g))][, indicador := factor(indicador, levels = rev(unique(indicador)))]
  p <- ggplot(pl, aes(x = pct, y = indicador, colour = grupo)) +
    geom_line(aes(group = indicador), colour = t$line, linewidth = 5) +
    geom_point(size = 8) +
    geom_text(aes(label = format(round(pct), nsmall = 0)), colour = t$textTitle, family = DM_FONT_MONO, size = 4.2, fontface = "bold") +
    scale_colour_manual(values = cols_g, name = NULL) +
    scale_x_continuous(labels = label_percent(scale = 1, accuracy = 1), limits = c(-2, 102)) +
    labs(x = NULL, y = NULL) +
    dm_theme(t, 22) + guides(colour = guide_legend(override.aes = list(size = 7)))
  guardar(p, "perfil", 1000, 700, dark)

  # --- Mapas ---
  cod <- c(`05` = "Antioquia", `08` = "Atlántico", `11` = "Bogotá D.C.", `13` = "Bolívar", `15` = "Boyacá",
           `17` = "Caldas", `18` = "Caquetá", `19` = "Cauca", `20` = "Cesar", `23` = "Córdoba",
           `25` = "Cundinamarca", `27` = "Chocó", `41` = "Huila", `44` = "La Guajira", `47` = "Magdalena",
           `50` = "Meta", `52` = "Nariño", `54` = "Norte de Santander", `63` = "Quindío", `66` = "Risaralda",
           `68` = "Santander", `70` = "Sucre", `73` = "Tolima", `76` = "Valle del Cauca")
  co <- st_read("data/colombia_departamentos_simplificado.geojson", quiet = TRUE)
  co$COD_DEPTO_DESC <- cod[co$DPTO]
  co <- merge(co, J2, by = "COD_DEPTO_DESC", all.x = TRUE)
  co <- st_crop(co, xmin = -80, ymin = -4.3, xmax = -66.8, ymax = 13.5)
  mapa <- function(var, titulo) {
    co$valor <- co[[var]]
    ggplot(co) +
      geom_sf(aes(fill = valor), colour = t$bgBody, linewidth = 0.4) +
      scale_fill_gradientn(colours = DM_BLUE_TEAL_30[c(3, 10, 18, 26, 30)], limits = c(0, 100),
                           labels = label_percent(scale = 1, accuracy = 1), name = NULL, na.value = t$surface3) +
      labs(subtitle = titulo) +
      dm_theme(t, 24) +
      theme(axis.text = element_blank(), panel.grid = element_blank(),
            plot.subtitle = element_text(colour = t$textTitle, family = DM_FONT_HEADING, face = "bold", size = 34, hjust = 0.5),
            legend.position = "right", legend.key.height = unit(2.2, "cm"), legend.key.width = unit(0.6, "cm"),
            plot.margin = margin(0, 0, 0, 0))
  }
  p <- (mapa("Pct_Con_Internet", "Con internet") + mapa("Pct_Con_RUT", "Con RUT")) +
    plot_annotation(theme = theme(plot.background = element_rect(fill = "transparent", colour = NA)))
  guardar(p, "mapas", 1700, 640, dark)

  # --- Rejilla de sensibilidad ---
  s <- copy(sens)
  p <- ggplot(s, aes(x = factor(paste0(soporte * 100, "%")), y = factor(paste0(confianza * 100, "%")))) +
    geom_tile(aes(fill = n_no_redundantes), colour = t$bgBody, linewidth = 2) +
    geom_text(aes(label = format(n_no_redundantes, big.mark = ".", decimal.mark = ",")), family = DM_FONT_MONO,
              fontface = "bold", colour = "#F9FAFB", size = 6) +
    geom_text(aes(label = ifelse(`TIC acopladas`, "", "✕ TIC")), colour = t$accent3, size = 5,
              family = DM_FONT_BODY, nudge_y = -0.32, fontface = "bold") +
    scale_fill_gradientn(colours = DM_BLUE_TEAL_30[c(26, 20, 14)], trans = "log10", guide = "none") +
    labs(x = "Soporte mínimo", y = "Confianza mínima") +
    dm_theme(t, 22) + theme(panel.grid = element_blank())
  guardar(p, "sensibilidad", 760, 600, dark)

  # --- Lift muestral vs ponderado ---
  p <- ggplot(m, aes(lift, lift_pond)) +
    geom_abline(colour = t$textMuted, linetype = 2) +
    geom_point(colour = t$accent2, alpha = if (dark) 0.15 else 0.2, size = 1.1) +
    annotate("label", x = 0.9, y = 2.0, hjust = 0, label = paste0("r = ", format(round(cv("Correlación lift muestral vs ponderado"), 3), decimal.mark = ",")),
             family = DM_FONT_MONO, fontface = "bold", size = 8, fill = t$surface1, colour = t$textTitle, label.size = 0) +
    labs(x = "Lift sin ponderar (muestra)", y = "Lift ponderado por F_EXP") +
    dm_theme(t, 22)
  guardar(p, "ponderado", 720, 600, dark)

  # --- Índices ---
  ix <- copy(idx)[, Indice := factor(Indice, levels = c("Formalización (0-5)", "Digital (0-4)"))]
  p <- ggplot(ix, aes(x = factor(Puntaje), y = Pct, fill = Indice)) +
    geom_col(width = 0.7) +
    geom_text(aes(label = paste0(round(Pct), "%")), vjust = -0.4, family = DM_FONT_MONO, colour = t$textBody, size = 5.5) +
    facet_wrap(~ Indice, scales = "free_x") +
    scale_fill_manual(values = c(t$accent, t$accent2), guide = "none") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
    labs(x = "Criterios cumplidos", y = "% de micronegocios") +
    dm_theme(t, 20)
  guardar(p, "indices", 900, 560, dark)

  message("✓ figuras ", if (dark) "dark" else "light")
}

figuras(TRUE)
figuras(FALSE)
message("✅ build completado")

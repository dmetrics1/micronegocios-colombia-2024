# =====================================================================
# TEMA VISUAL DM — compartido por el pipeline, el reporte y las diapositivas
# =====================================================================
# Una sola fuente de verdad para colores, tipografía y etiquetas de los
# gráficos. Lo usan:
#   - scripts/00_config.R            (todos los gráficos del pipeline)
#   - REPORTE_WIDE_PRO_2024.qmd      (tablas del reporte)
#   - presentacion/build.R           (figuras de las diapositivas)
#
# Los colores salen de assets/dm/tokens.R, copia del sistema de diseño DM
# (dm-design-system/dist/tokens.R). Para cambiar un color, cámbialo allá y
# vuelve a copiar el archivo; no lo escribas a mano en los scripts.
# =====================================================================

.dm_raiz <- if (file.exists("main.R")) "." else ".."
source(file.path(.dm_raiz, "assets", "dm", "tokens.R"))

# tokens.R trae algunos colores en formato CSS rgba(); R necesita hex con alfa
rgba_a_hex <- function(s) {
  if (!grepl("^rgba", s)) return(s)
  v <- as.numeric(strsplit(gsub("rgba\\(|\\)|\\s", "", s), ",")[[1]])
  grDevices::rgb(v[1], v[2], v[3], v[4] * 255, maxColorValue = 255)
}
dm_tokens <- function(dark = FALSE) {
  t <- if (dark) DM_THEME_DARK else DM_THEME_LIGHT
  for (k in c("line", "chartGrid", "cardBg", "cardBorder")) t[[k]] <- rgba_a_hex(t[[k]])
  t
}

# Fuentes de marca (TTF estáticos incluidos en el repo; no requieren instalación)
local({
  dir_f <- file.path(.dm_raiz, "assets", "dm", "fonts-ttf")
  if (requireNamespace("systemfonts", quietly = TRUE) && dir.exists(dir_f)) {
    f <- function(x) file.path(dir_f, x)
    systemfonts::register_font("Inter", plain = f("inter-400.ttf"), bold = f("inter-700.ttf"))
    systemfonts::register_font("Space Grotesk", plain = f("space-grotesk-600.ttf"),
                               bold = f("space-grotesk-700.ttf"))
    systemfonts::register_font("JetBrains Mono", plain = f("jetbrains-mono-500.ttf"),
                               bold = f("jetbrains-mono-700.ttf"))
  }
})

# ---------------------------------------------------------------------
# Paleta para el reporte (tema claro DM)
# ---------------------------------------------------------------------
DM <- dm_tokens(dark = FALSE)
DM_BARRA   <- DM$accent                              # barras de distribución (un solo tono)
DM_RAMPA   <- DM_BLUE_TEAL_30[c(11, 17, 23, 30)]     # escalas continuas (legible sobre fondo blanco)
DM_GRUPOS  <- c("Excluidos" = DM$negative, "En transición" = DM$accent3, "Integrados" = DM$positive)
DM_DOMINIO <- c("TIC" = DM$accent2, "Medios de pago" = DM$ink$navy,
                "Formalización" = DM$accent3, "Perfil y ubicación" = DM$textMuted)

# Tema ggplot2 DM (claro por defecto; dark = TRUE para fondos oscuros)
tema_dm <- function(base = 12, dark = FALSE) {
  t <- dm_tokens(dark)
  ggplot2::theme_minimal(base_size = base, base_family = DM_FONT_BODY) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = t$textBody),
      plot.title = ggplot2::element_text(family = DM_FONT_HEADING, colour = t$textTitle,
                                         face = "bold", size = base * 1.15),
      plot.subtitle = ggplot2::element_text(colour = t$textMuted, size = base * 0.85),
      plot.caption = ggplot2::element_text(colour = t$textMuted, size = base * 0.7, hjust = 0),
      axis.text = ggplot2::element_text(colour = t$textMuted),
      axis.title = ggplot2::element_text(colour = t$textMuted, size = base * 0.85),
      legend.text = ggplot2::element_text(colour = t$textBody),
      legend.title = ggplot2::element_text(colour = t$textMuted),
      legend.position = "bottom",
      legend.background = ggplot2::element_blank(), legend.key = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(colour = t$chartGrid),
      strip.text = ggplot2::element_text(family = DM_FONT_HEADING, colour = t$textTitle,
                                         face = "bold"),
      plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      panel.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      plot.margin = ggplot2::margin(8, 12, 6, 6)
    )
}

# Guardar figuras: fondo transparente y motor ragg (respeta las fuentes registradas)
guardar_fig <- function(filename, plot = ggplot2::last_plot(), width, height, dpi = 300, ...) {
  ggplot2::ggsave(filename, plot, width = width, height = height, dpi = dpi,
                  device = ragg::agg_png, bg = "transparent", ...)
}

# Formato numérico en español (coma decimal), como en el reporte y las diapositivas
num_dm <- function(x, d = 1) formatC(x, format = "f", digits = d, big.mark = ".", decimal.mark = ",")
pct_dm <- function(x, d = 1) paste0(num_dm(x, d), "%")
eje_dm <- scales::label_number(big.mark = ".", decimal.mark = ",")

# Barras horizontales de una distribución: un solo tono, cifra al final de cada barra
barras_dm <- function(df, cat, val, etiqueta = pct_dm,
                      eje = "Porcentaje (%)", ordenar = TRUE) {
  df <- as.data.frame(df)
  df$.cat <- df[[cat]]; df$.val <- df[[val]]
  df <- df[!is.na(df$.val), ]
  x_cat <- if (ordenar) stats::reorder(df$.cat, df$.val) else factor(df$.cat, levels = rev(unique(df$.cat)))
  ggplot2::ggplot(df, ggplot2::aes(x = x_cat, y = .val)) +
    ggplot2::geom_col(fill = DM_BARRA, width = 0.62) +
    ggplot2::geom_text(ggplot2::aes(label = etiqueta(.val)), hjust = -0.15, size = 3.6,
                       family = DM_FONT_MONO, fontface = "bold", colour = DM$textTitle) +
    ggplot2::coord_flip() +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.14))) +
    ggplot2::labs(x = NULL, y = eje) +
    tema_dm() +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank(),
                   axis.text.y = ggplot2::element_text(colour = DM$textBody))
}

# ---------------------------------------------------------------------
# Etiquetas legibles de los ítems de las reglas de asociación
# ---------------------------------------------------------------------
DM_ITEMS <- c(
  "usa_dispositivos=No" = "sin computador ni tableta", "usa_dispositivos=Sí" = "usa computador o tableta",
  "usa_celular_negocio=No" = "sin celular de negocio", "usa_celular_negocio=Sí" = "usa celular",
  "internet_en_local=No" = "sin internet en el local", "internet_en_local=Sí" = "internet en el local",
  "acepta_transferencia=No" = "sin transferencias", "acepta_transferencia=Sí" = "acepta transferencias",
  "acepta_tarjeta_debito=No" = "sin tarjeta débito", "acepta_tarjeta_debito=Sí" = "acepta tarjeta débito",
  "acepta_tarjeta_credito=No" = "sin tarjeta crédito", "acepta_tarjeta_credito=Sí" = "acepta tarjeta crédito",
  "acepta_cheque=No" = "sin cheque", "acepta_factura_plazo=No" = "sin factura a plazo",
  "acepta_efectivo=Sí" = "acepta efectivo", "acepta_efectivo=No" = "no acepta efectivo",
  "usa_redes_sociales=No" = "sin redes sociales", "usa_redes_sociales=Sí" = "usa redes sociales",
  "tiene_sitio_web=No" = "sin sitio web", "tiene_sitio_web=Sí" = "tiene sitio web",
  "tiene_rut=No" = "sin RUT", "tiene_rut=Sí" = "tiene RUT",
  "tiene_camara_comercio=No" = "sin Cámara de Comercio", "tiene_camara_comercio=Sí" = "Cámara de Comercio",
  "tipo_contabilidad=Sin_registro" = "sin registro contable",
  "tipo_contabilidad=Cuaderno_u_otro" = "cuaderno u otro registro",
  "tipo_contabilidad=Libro_diario" = "libro diario", "tipo_contabilidad=Balance_PyG" = "balance o PyG",
  "declara_iva=No_responsable" = "no responsable de IVA", "declara_iva=Sí" = "declara IVA",
  "declara_renta=No_responsable" = "no declara renta", "declara_renta=Sí" = "declara renta",
  "declara_ica=No_responsable" = "no responsable de ICA", "declara_ica=Sí" = "declara ICA",
  "tipo_ubicacion=Local_fijo" = "local fijo", "tipo_ubicacion=Vivienda" = "opera en la vivienda",
  "paga_arriendo_local=Sí" = "paga arriendo", "paga_arriendo_local=No" = "no paga arriendo",
  "rol_propietario=Cuenta_propia" = "cuenta propia", "rol_propietario=Patrón" = "patrón o empleador",
  "es_persona_juridica=No" = "persona natural", "es_persona_juridica=Sí" = "persona jurídica",
  "sexo_propietario=Hombre" = "propietario hombre", "sexo_propietario=Mujer" = "propietaria mujer",
  "tiempo_funcionamiento=10+_años" = "10+ años", "paga_seg_social_prop=No" = "sin seguridad social",
  "paga_seg_social_prop=Sí" = "paga seguridad social",
  "tiene_personal=No" = "sin personal", "tiene_personal=Sí" = "tiene personal",
  "tiene_ahorros=No" = "no ahorra", "tiene_ahorros=Sí" = "ahorra",
  "solicito_credito=No" = "no pidió crédito", "solicito_credito=Sí" = "pidió crédito",
  "fuente_capital_inicial=Ahorros" = "inició con ahorros",
  "motivo_creacion=Sin_alternativa" = "creado sin alternativa"
)
etiqueta_item <- function(x) {
  o <- DM_ITEMS[x]
  o[is.na(o)] <- gsub("_", " ", x[is.na(o)])
  unname(o)
}
# "{a=No,b=Sí} => {c=No}"  →  "sin a + b ⇒ sin c"
regla_legible <- function(r) {
  vapply(r, function(x) {
    p <- strsplit(gsub("[{}]", "", x), " => ")[[1]]
    paste0(paste(etiqueta_item(strsplit(p[1], ",")[[1]]), collapse = " + "),
           "  ⇒  ", etiqueta_item(p[2]))
  }, character(1), USE.NAMES = FALSE)
}

# =====================================================================
# PROYECTO: Reglas de Asociación en Micronegocios (EMICRON 2024)
# SCRIPT 05: Minería de Reglas de Asociación (Apriori)
# =====================================================================
# Aplica el algoritmo Apriori para descubrir reglas de co-ocurrencia
# entre las características de los micronegocios, usando 30 variables
# categóricas originales del DANE.
#
# apriori() minera sobre la muestra (cada registro pesa igual). Después
# se recalculan soporte, confianza y lift ponderados por F_EXP con
# medidas_ponderadas() (00_config.R) para reportar valores del universo.
#
# Análisis dirigidos: Formalización, Pagos Digitales, TIC, Antigüedad
# Paquetes: arules, arulesViz, ggplot2
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. CARGAR BASE ANALÍTICA
# =====================================================================
ruta_base <- file.path(DIR_DATA_PROCESSED, "base_analitica.rds")
base <- readRDS(ruta_base)
setDT(base)
message(sprintf("Base analítica cargada: %d filas x %d columnas", nrow(base), ncol(base)))

vars_apriori <- c(
  # --- Originales MCA (16) ---
  # Formalización
  "tiene_rut", "tiene_camara_comercio", "tipo_contabilidad",
  # TIC
  "internet_en_local", "usa_redes_sociales", "usa_dispositivos",
  "usa_celular_negocio", "tiene_sitio_web",
  # Formas de pago
  "acepta_efectivo", "acepta_cheque", "acepta_transferencia",
  "acepta_factura_plazo", "acepta_tarjeta_debito", "acepta_tarjeta_credito",
  # Sector y antigüedad
  "tiempo_funcionamiento", "sector_economico_12",
  
  # --- NUEVAS: Perfil del propietario (4) ---
  "sexo_propietario",       # P35
  "rol_propietario",        # P3033
  "P3031",                  # Tiene personal (no renombrada en 02_limpiar)
  "P1056",                  # Nombre comercial / Persona Juridica (ajustado)
  
  # --- NUEVAS: Emprendimiento (2) ---
  "motivo_creacion",        # P3051
  "fuente_capital_inicial", # P3052
  
  # --- NUEVAS: Ubicación (2) ---
  "tipo_ubicacion",         # P3053
  "paga_arriendo",          # P469 renombrada
  
  # --- NUEVAS: Seguridad social propietario (1) ---
  "paga_seg_social_prop",   # P3088
  
  # --- NUEVAS: Formalización tributaria (3) ---
  "P2991",                  # Declara renta
  "P2992",                  # Declara IVA
  "P2993",                  # Declara ICA
  
  # --- NUEVAS: Inclusión financiera (2) ---
  "solicito_credito",       # P1765
  "tiene_ahorros"           # P3014
)

# F_EXP viaja junto a las variables para poder ponderar las reglas después
base_apr <- base[, c(vars_apriori, "F_EXP"), with = FALSE]

# Imputar NAs en variables check-all-that-apply (NA = No marcó = "No")
vars_pago <- c("acepta_efectivo", "acepta_cheque", "acepta_transferencia",
               "acepta_factura_plazo", "acepta_tarjeta_debito", "acepta_tarjeta_credito")
vars_tic <- c("internet_en_local", "usa_redes_sociales", "usa_dispositivos",
              "usa_celular_negocio", "tiene_sitio_web")
vars_bin_nuevas <- c("P3031", "P1056", "paga_arriendo", "solicito_credito", "tiene_ahorros")

for (v in c(vars_pago, vars_tic, vars_bin_nuevas)) {
  if (v %in% names(base_apr)) {
    set(base_apr, which(is.na(base_apr[[v]])), v, 2L)
  }
}

# Imputar NAs en P2991/P2992/P2993 (9=No Informa → tratar como No responsable)
for (v in c("P2991", "P2992", "P2993")) {
  set(base_apr, which(is.na(base_apr[[v]])), v, 3L)
  set(base_apr, which(base_apr[[v]] == 9L), v, 3L)
}

# Imputar NA en paga_seg_social_prop
set(base_apr, which(is.na(base_apr[["paga_seg_social_prop"]])), "paga_seg_social_prop", 2L)

base_apr <- na.omit(base_apr)
message(sprintf("Observaciones para Apriori: %d", nrow(base_apr)))

# Separar el factor de expansión (no es un ítem de las transacciones)
pesos <- base_apr$F_EXP
base_apr[, F_EXP := NULL]

# 3. RECODIFICAR A ETIQUETAS LEGIBLES
# =====================================================================
message("\n=== RECODIFICANDO VARIABLES ===")

recode_sino <- function(x) fifelse(x == 1, "Sí", "No")

# --- Binarias originales ---
for (v in c("tiene_rut", "tiene_camara_comercio",
            "internet_en_local", "usa_redes_sociales", "usa_dispositivos",
            "usa_celular_negocio", "tiene_sitio_web",
            "acepta_efectivo", "acepta_cheque", "acepta_transferencia",
            "acepta_factura_plazo", "acepta_tarjeta_debito", "acepta_tarjeta_credito")) {
  base_apr[, (v) := recode_sino(get(v))]
}

for (v in c("P3031", "P1056", "paga_arriendo", "solicito_credito", "tiene_ahorros")) {
  base_apr[, (v) := recode_sino(get(v))]
}

# Renombrar P-codes a nombres legibles
setnames(base_apr, "P3031", "tiene_personal")
setnames(base_apr, "P1056", "es_persona_juridica")
setnames(base_apr, "paga_arriendo", "paga_arriendo_local")

# --- Contabilidad (P640, según Diccionario EMICRON 2024) ---
base_apr[, tipo_contabilidad := fcase(
  tipo_contabilidad == 1, "Balance_PyG",
  tipo_contabilidad == 2, "Libro_diario",
  tipo_contabilidad == 3, "Cuaderno_u_otro",
  tipo_contabilidad == 4, "Informes",
  tipo_contabilidad == 5, "Sin_registro",
  default = "Sin_registro"
)]

# --- Antigüedad ---
base_apr[, tiempo_funcionamiento := fcase(
  tiempo_funcionamiento == 1, "<1_año",
  tiempo_funcionamiento == 2, "1a3_años",
  tiempo_funcionamiento == 3, "3a5_años",
  tiempo_funcionamiento == 4, "5a10_años",
  tiempo_funcionamiento == 5, "10+_años",
  default = "Desconocido"
)]

# --- Sector ---
base_apr[, sector_economico_12 := paste0("Sector_", sector_economico_12)]

# --- Sexo propietario ---
base_apr[, sexo_propietario := fcase(
  sexo_propietario == 1, "Hombre",
  sexo_propietario == 2, "Mujer",
  default = "Desconocido"
)]

# --- Rol propietario ---
base_apr[, rol_propietario := fcase(
  rol_propietario == 1, "Patrón",
  rol_propietario == 2, "Cuenta_propia",
  default = "Desconocido"
)]

# --- Motivo de creación ---
base_apr[, motivo_creacion := fcase(
  motivo_creacion == 1, "Sin_alternativa",
  motivo_creacion == 2, "Oportunidad",
  motivo_creacion == 3, "Tradicion_familiar",
  motivo_creacion == 4, "Complementar_ingreso",
  motivo_creacion == 5, "Ejercer_oficio",
  motivo_creacion == 6, "Sin_experiencia",
  motivo_creacion == 7, "Otro",
  default = "Desconocido"
)]

# --- Fuente de capital inicial ---
base_apr[, fuente_capital_inicial := fcase(
  fuente_capital_inicial == 1, "Ahorros",
  fuente_capital_inicial == 2, "Prestamo_familiar",
  fuente_capital_inicial == 3, "Prestamo_banco",
  fuente_capital_inicial == 4, "Prestamista",
  fuente_capital_inicial == 5, "Capital_semilla",
  fuente_capital_inicial == 6, "Sin_financiacion",
  fuente_capital_inicial == 7, "No_sabe",
  fuente_capital_inicial == 8, "Otro",
  default = "Desconocido"
)]

# --- Tipo de ubicación ---
base_apr[, tipo_ubicacion := fcase(
  tipo_ubicacion == 1, "Vivienda",
  tipo_ubicacion == 2, "Local_fijo",
  tipo_ubicacion == 3, "Puerta_a_puerta",
  tipo_ubicacion == 4, "Ambulante",
  tipo_ubicacion == 5, "Vehiculo",
  tipo_ubicacion == 6, "Obra_construccion",
  tipo_ubicacion == 7, "Finca",
  tipo_ubicacion == 8, "Otra",
  default = "Desconocido"
)]

# --- Seguridad social propietario ---
base_apr[, paga_seg_social_prop := fcase(
  paga_seg_social_prop == 1, "Sí",
  paga_seg_social_prop == 2, "No",
  paga_seg_social_prop == 3, "Solo_salud",
  paga_seg_social_prop == 4, "Solo_pension",
  default = "No"
)]

# --- Declaraciones tributarias (P2991, P2992, P2993) ---
for (v in c("P2991", "P2992", "P2993")) {
  base_apr[, (v) := fcase(
    get(v) == 1, "Sí",
    get(v) == 2, "No",
    get(v) == 3, "No_responsable",
    default = "No_responsable"
  )]
}
setnames(base_apr, c("P2991", "P2992", "P2993"),
         c("declara_renta", "declara_iva", "declara_ica"))

# --- Convertir TODO a factor ---
for (v in names(base_apr)) {
  set(base_apr, j = v, value = as.factor(base_apr[[v]]))
}

message(sprintf("✓ %d variables recodificadas a etiquetas legibles.", ncol(base_apr)))

# 4. CONVERTIR A TRANSACCIONES
# =====================================================================
message("\n=== CONVIRTIENDO A TRANSACCIONES ===")
trans <- as(as.data.frame(base_apr), "transactions")
transactionInfo(trans)$weight <- pesos
message(sprintf("Transacciones: %d × %d items", length(trans), nitems(trans)))

# Guardar transacciones (con pesos) para el análisis de sensibilidad (07)
saveRDS(trans, file.path(DIR_DATA_PROCESSED, "transacciones_apriori.rds"))

# Gráfico de frecuencia: los 30 ítems más comunes, con etiquetas legibles
frec <- sort(itemFrequency(trans), decreasing = TRUE)[1:30]
df_frec <- data.frame(item = etiqueta_item(names(frec)), pct = as.numeric(frec) * 100)
p_frec <- barras_dm(df_frec, cat = "item", val = "pct", eje = "% de registros que presentan el ítem")
guardar_fig(file.path(DIR_OUTPUT_FIGS, "12_apriori_item_frequency.png"), p_frec, width = 9, height = 7.5)
message("✓ Gráfico: 12_apriori_item_frequency.png")

# =====================================================================
# 5. APRIORI — REGLAS GENERALES
# =====================================================================
message("\n=== EJECUTANDO APRIORI (REGLAS GENERALES) ===")

reglas <- apriori(
  trans,
  parameter = list(supp = 0.15, conf = 0.70, minlen = 2, maxlen = 4),
  control = list(verbose = TRUE)
)

message(sprintf("\n>>> %d reglas encontradas", length(reglas)))
reglas <- reglas[!is.redundant(reglas)]
message(sprintf(">>> %d reglas no redundantes", length(reglas)))

# Top 30 por Lift
reglas_top <- sort(reglas, by = "lift", decreasing = TRUE)
reglas_top30 <- head(reglas_top, 30)

message("\n=== TOP 30 REGLAS POR LIFT ===")
inspect(reglas_top30)

# Guardar
reglas_df <- as(reglas, "data.frame")
write.csv(reglas_df, file.path(DIR_OUTPUT_TABS, "06_reglas_asociacion_todas.csv"), row.names = FALSE)

# Medidas ponderadas por F_EXP (representativas del universo de 5,3M)
reglas_pond_df <- cbind(as.data.table(reglas_df), medidas_ponderadas(reglas, trans))
write.csv(reglas_pond_df, file.path(DIR_OUTPUT_TABS, "06b_reglas_ponderadas.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
message(sprintf(">>> Correlación lift muestral vs ponderado: %.4f",
                cor(reglas_pond_df$lift, reglas_pond_df$lift_pond)))

reglas_top30_df <- as(reglas_top30, "data.frame")
write.csv(reglas_top30_df, file.path(DIR_OUTPUT_TABS, "06a_reglas_top30_lift.csv"), row.names = FALSE)

# =====================================================================
# 6. REGLAS DIRIGIDAS: FORMALIZACIÓN
# =====================================================================
message("\n=== REGLAS → FORMALIZACIÓN (tiene_rut=Sí) ===")

reglas_rut <- apriori(
  trans,
  parameter = list(supp = 0.15, conf = 0.60, minlen = 2, maxlen = 4),
  appearance = list(rhs = "tiene_rut=Sí", default = "lhs"),
  control = list(verbose = FALSE)
)
reglas_rut <- reglas_rut[!is.redundant(reglas_rut)]
reglas_rut <- sort(reglas_rut, by = "lift", decreasing = TRUE)

message(sprintf(">>> %d reglas → tiene_rut=Sí", length(reglas_rut)))
if (length(reglas_rut) > 0) {
  inspect(head(reglas_rut, 15))
  write.csv(as(reglas_rut, "data.frame"),
            file.path(DIR_OUTPUT_TABS, "07b_reglas_formalizacion.csv"), row.names = FALSE)
}

# =====================================================================
# 7. REGLAS DIRIGIDAS: MEDIOS DE PAGO DIGITALES
# =====================================================================
message("\n=== REGLAS → PAGOS DIGITALES ===")

reglas_pago <- apriori(
  trans,
  parameter = list(supp = 0.15, conf = 0.50, minlen = 2, maxlen = 4),
  appearance = list(
    rhs = c("acepta_transferencia=Sí", "acepta_tarjeta_debito=Sí", "acepta_tarjeta_credito=Sí"),
    default = "lhs"
  ),
  control = list(verbose = FALSE)
)
reglas_pago <- reglas_pago[!is.redundant(reglas_pago)]
reglas_pago <- sort(reglas_pago, by = "lift", decreasing = TRUE)

message(sprintf(">>> %d reglas → pagos digitales", length(reglas_pago)))
if (length(reglas_pago) > 0) {
  inspect(head(reglas_pago, 15))
  write.csv(as(reglas_pago, "data.frame"),
            file.path(DIR_OUTPUT_TABS, "07c_reglas_pagos_digitales.csv"), row.names = FALSE)
}

# =====================================================================
# 8. REGLAS DIRIGIDAS: ADOPCIÓN TIC
# =====================================================================
message("\n=== REGLAS → ADOPCIÓN TIC (internet_en_local=Sí) ===")

reglas_tic <- apriori(
  trans,
  parameter = list(supp = 0.15, conf = 0.60, minlen = 2, maxlen = 4),
  appearance = list(rhs = "internet_en_local=Sí", default = "lhs"),
  control = list(verbose = FALSE)
)
reglas_tic <- reglas_tic[!is.redundant(reglas_tic)]
reglas_tic <- sort(reglas_tic, by = "lift", decreasing = TRUE)

message(sprintf(">>> %d reglas → internet_en_local=Sí", length(reglas_tic)))
if (length(reglas_tic) > 0) {
  inspect(head(reglas_tic, 15))
  write.csv(as(reglas_tic, "data.frame"),
            file.path(DIR_OUTPUT_TABS, "07d_reglas_tic.csv"), row.names = FALSE)
}

# =====================================================================
# 9. REGLAS DIRIGIDAS: ANTIGÜEDAD DEL NEGOCIO
# =====================================================================
message("\n=== REGLAS → NEGOCIOS CONSOLIDADOS (10+ años) ===")

reglas_antiguedad <- apriori(
  trans,
  parameter = list(supp = 0.15, conf = 0.50, minlen = 2, maxlen = 4),
  appearance = list(rhs = "tiempo_funcionamiento=10+_años", default = "lhs"),
  control = list(verbose = FALSE)
)
reglas_antiguedad <- reglas_antiguedad[!is.redundant(reglas_antiguedad)]
reglas_antiguedad <- sort(reglas_antiguedad, by = "lift", decreasing = TRUE)

message(sprintf(">>> %d reglas → 10+_años", length(reglas_antiguedad)))
if (length(reglas_antiguedad) > 0) {
  inspect(head(reglas_antiguedad, 15))
  write.csv(as(reglas_antiguedad, "data.frame"),
            file.path(DIR_OUTPUT_TABS, "07e_reglas_antiguedad.csv"), row.names = FALSE)
}

# =====================================================================
# 10. VISUALIZACIONES (identidad DM: scripts/tema_dm.R)
# =====================================================================
# Todas las figuras se construyen con ggplot2/ggraph a partir de las
# reglas, con etiquetas legibles y colores del sistema de diseño DM.
# =====================================================================
message("\n=== GENERANDO VISUALIZACIONES ===")

# Dominio temático de cada ítem (color de los nodos en las redes)
dominio_item <- function(x) fcase(
  grepl("^(usa_|internet_|tiene_sitio)", x), "TIC",
  grepl("^acepta_", x), "Medios de pago",
  grepl("^(tiene_rut|tiene_camara|tipo_contab|declara_|es_persona|paga_seg)", x), "Formalización",
  default = "Perfil y ubicación"
)

# Red de reglas: nodos = ítems, flechas = antecedente → consecuente
red_reglas <- function(r, archivo, width = 11, height = 8, semilla = 7) {
  df <- cbind(as(r, "data.frame"), medidas_ponderadas(r, trans))
  aristas <- rbindlist(lapply(seq_len(nrow(df)), function(i) {
    p <- strsplit(gsub("[{}]", "", df$rules[i]), " => ")[[1]]
    data.table(from = strsplit(p[1], ",")[[1]], to = p[2], lift = df$lift_pond[i])
  }))[, .(n = .N, lift = max(lift)), by = .(from, to)]
  nodos <- data.table(name = unique(c(aristas$from, aristas$to)))
  nodos[, `:=`(dominio = dominio_item(name), etiqueta = etiqueta_item(name))]
  g <- tbl_graph(nodes = nodos, edges = aristas, directed = TRUE) |>
    activate(nodes) |> mutate(grado = centrality_degree(mode = "all"))
  set.seed(semilla)
  p <- ggraph(g, layout = "stress") +
    geom_edge_fan(aes(width = n, alpha = lift), colour = DM$ink$blue,
                  arrow = arrow(length = unit(2.5, "mm"), type = "closed"), end_cap = circle(3.5, "mm")) +
    scale_edge_width(range = c(0.4, 2.2), guide = "none") +
    scale_edge_alpha(range = c(0.3, 0.85), guide = "none") +
    geom_node_point(aes(colour = dominio, size = grado)) +
    geom_node_label(aes(label = etiqueta, colour = dominio), family = DM_FONT_BODY, size = 3.6,
                    repel = TRUE, fill = "white", label.padding = unit(0.18, "lines"),
                    show.legend = FALSE) +
    scale_colour_manual(values = DM_DOMINIO, name = NULL) +
    scale_size(range = c(2.5, 9), guide = "none") +
    guides(colour = guide_legend(override.aes = list(size = 4))) +
    theme(panel.grid = element_blank(), panel.grid.major = element_blank(), axis.text = element_blank(), axis.title = element_blank(),
          legend.position = "top")
  guardar_fig(file.path(DIR_OUTPUT_FIGS, archivo), p, width = width, height = height)
  message("  ✓ ", archivo)
}

# Barras de reglas (lift ponderado), una regla por fila con su texto legible
barras_reglas <- function(r, archivo, n = 12, width = 10, height = 6) {
  r <- head(sort(r, by = "lift"), n)
  df <- cbind(as(r, "data.frame"), medidas_ponderadas(r, trans))
  df$regla <- factor(regla_legible(df$rules), levels = rev(unique(regla_legible(df$rules))))
  p <- ggplot(df, aes(x = regla, y = lift_pond, fill = confidence_pond * 100)) +
    geom_col(width = 0.65) +
    geom_text(aes(label = formatC(lift_pond, format = "f", digits = 2, decimal.mark = ",")),
              hjust = -0.15, size = 3.4, family = DM_FONT_MONO, fontface = "bold", colour = DM$textTitle) +
    coord_flip() +
    scale_fill_gradientn(colours = DM_RAMPA, name = "Confianza (%)", labels = eje_dm) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.2)), labels = eje_dm) +
    labs(x = NULL, y = "Lift ponderado") +
    theme(panel.grid.major.y = element_blank(), axis.text.y = element_text(colour = DM$textBody, size = 9),
          legend.position = "right")
  guardar_fig(file.path(DIR_OUTPUT_FIGS, archivo), p, width = width, height = height)
  message("  ✓ ", archivo)
}

# 10a. Soporte vs confianza (color = lift ponderado)
message("  - Scatter soporte vs confianza...")
df_sc <- cbind(reglas_df[, c("support", "confidence")], medidas_ponderadas(reglas, trans))
p_scatter <- ggplot(df_sc, aes(support, confidence, colour = lift_pond)) +
  geom_point(alpha = 0.25, size = 0.9) +
  scale_colour_gradientn(colours = DM_RAMPA, name = "Lift\nponderado", labels = eje_dm) +
  scale_x_continuous(labels = label_percent(accuracy = 1)) +
  scale_y_continuous(labels = label_percent(accuracy = 1)) +
  labs(x = "Soporte", y = "Confianza",
       caption = sprintf("%s reglas no redundantes · soporte ≥ 15 %% · confianza ≥ 70 %%",
                         format(nrow(df_sc), big.mark = ".", decimal.mark = ","))) +
  theme(legend.position = "right")
guardar_fig(file.path(DIR_OUTPUT_FIGS, "13_apriori_scatter_reglas.png"), p_scatter, width = 9, height = 5.5)
message("  ✓ 13_apriori_scatter_reglas.png")

# 10b. Red de las 20 reglas con mayor lift
message("  - Red top 20...")
if (length(reglas_top) >= 20) red_reglas(head(reglas_top, 20), "14_apriori_grafo_top20.png")

# 10c. Matriz: qué ítems del antecedente acompañan a cada consecuente (50 reglas con mayor lift)
message("  - Matriz antecedentes × consecuentes...")
if (length(reglas) >= 20) {
  top50 <- head(sort(reglas, by = "lift"), 50)
  df50  <- cbind(as(top50, "data.frame"), medidas_ponderadas(top50, trans))
  mat <- rbindlist(lapply(seq_len(nrow(df50)), function(i) {
    p <- strsplit(gsub("[{}]", "", df50$rules[i]), " => ")[[1]]
    data.table(antecedente = strsplit(p[1], ",")[[1]], consecuente = p[2], lift = df50$lift_pond[i])
  }))[, .(reglas = .N, lift = mean(lift)), by = .(antecedente, consecuente)]
  mat[, `:=`(antecedente = etiqueta_item(antecedente), consecuente = etiqueta_item(consecuente))]
  orden <- mat[, .(n = sum(reglas)), by = antecedente][order(n), antecedente]
  mat[, antecedente := factor(antecedente, levels = orden)]
  p_grouped <- ggplot(mat, aes(x = consecuente, y = antecedente, size = reglas, colour = lift)) +
    geom_point() +
    scale_size(range = c(2, 10), name = "N.º de reglas") +
    guides(size = guide_legend(override.aes = list(colour = DM$accent))) +
    scale_colour_gradientn(colours = DM_RAMPA, name = "Lift\nponderado", labels = eje_dm) +
    labs(x = "Consecuente", y = "Ítem del antecedente") +
    theme(legend.position = "right", axis.text.y = element_text(colour = DM$textBody))
  guardar_fig(file.path(DIR_OUTPUT_FIGS, "15_apriori_grouped_matrix.png"), p_grouped, width = 9, height = 6.5)
  message("  ✓ 15_apriori_grouped_matrix.png")
}

# 10d. Reglas hacia formalización (solo si existen con los umbrales principales)
if (length(reglas_rut) >= 5) barras_reglas(reglas_rut, "16_apriori_formalizacion_top15.png", n = 15)

# 10e. Reglas hacia pagos digitales
message("  - Reglas hacia pagos digitales...")
if (length(reglas_pago) >= 5) barras_reglas(reglas_pago, "17_apriori_reglas_pagos.png", n = 12)

# 10f. Red de las reglas hacia negocios con 10+ años
message("  - Red antigüedad...")
if (length(reglas_antiguedad) >= 5) red_reglas(head(reglas_antiguedad, 15), "18_apriori_grafo_antiguedad.png")

# =====================================================================
# 11. TABLA RESUMEN UNIFICADA (Frecuencia + Confianza + Lift)
# =====================================================================
message("\n=== GENERANDO TABLA RESUMEN UNIFICADA ===")

# Función auxiliar para extraer tabla limpia
reglas_a_tabla <- function(reglas_obj, categoria, top_n = 20) {
  if (length(reglas_obj) == 0) return(NULL)
  r <- head(sort(reglas_obj, by = "lift", decreasing = TRUE), top_n)
  df <- as(r, "data.frame")
  mp <- medidas_ponderadas(r, trans)

  # Separar LHS => RHS
  partes <- strsplit(as.character(df$rules), " => ")
  df$Antecedente <- sapply(partes, `[`, 1)
  df$Consecuente <- sapply(partes, `[`, 2)
  
  # Limpiar llaves
  df$Antecedente <- gsub("[{}]", "", df$Antecedente)
  df$Consecuente <- gsub("[{}]", "", df$Consecuente)
  
  data.table(
    Categoria     = categoria,
    Antecedente   = df$Antecedente,
    Consecuente   = df$Consecuente,
    Soporte       = round(df$support, 4),
    Confianza     = round(df$confidence, 4),
    Lift          = round(df$lift, 2),
    Frecuencia    = df$count,
    Soporte_pond   = round(mp$support_pond, 4),
    Confianza_pond = round(mp$confidence_pond, 4),
    Lift_pond      = round(mp$lift_pond, 2)
  )
}

# Construir tabla unificada
tabla_resumen <- rbindlist(list(
  reglas_a_tabla(reglas,           "General",          30),
  reglas_a_tabla(reglas_rut,       "Formalización",    20),
  reglas_a_tabla(reglas_pago,      "Pagos Digitales",  20),
  reglas_a_tabla(reglas_tic,       "Adopción TIC",     20),
  reglas_a_tabla(reglas_antiguedad,"Antigüedad 10+",   20)
), fill = TRUE)

# Ordenar por categoría y lift descendente
setorder(tabla_resumen, Categoria, -Lift)

# Exportar
write.csv(tabla_resumen,
          file.path(DIR_OUTPUT_TABS, "08_tabla_resumen_reglas.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

message(sprintf("  ✓ Tabla unificada: %d reglas en 5 categorías", nrow(tabla_resumen)))
message("  → output/tablas/08_tabla_resumen_reglas.csv")

# Mostrar en consola las primeras filas por categoría
for (cat in unique(tabla_resumen$Categoria)) {
  message(sprintf("\n--- %s (Top 5) ---", cat))
  sub <- tabla_resumen[Categoria == cat][1:min(5, .N)]
  print(sub[, .(Antecedente, Consecuente, Soporte, Confianza, Lift, Frecuencia)])
}

# =====================================================================
# 12. FILTRADO FINAL: TABLA POR SUPPORT > 20%
# =====================================================================
message("\n=== FILTRANDO TABLA DE RESUMEN (Support > 20%) ===")

tabla_filtrada <- tabla_resumen[Soporte > 0.20]
setorder(tabla_filtrada, -Lift)

message(sprintf("  Total en tabla resumen: %d reglas", nrow(tabla_resumen)))
message(sprintf("  Con soporte > 20%%: %d reglas (%.1f%%)",
                nrow(tabla_filtrada),
                nrow(tabla_filtrada)/nrow(tabla_resumen)*100))

write.csv(tabla_filtrada,
          file.path(DIR_OUTPUT_TABS, "10_TABLA_RESUMEN_FILTRADA_20PCT.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

message("  → output/tablas/10_TABLA_RESUMEN_FILTRADA_20PCT.csv")

# Mostrar distribución por categoría
if ("Categoria" %in% names(tabla_filtrada)) {
  message("\n  Distribución por categoría (support > 20%):")
  resumen_cat <- tabla_filtrada[, .(
    Reglas = .N,
    Lift_Promedio = round(mean(Lift), 3),
    Soporte_Promedio = round(mean(Soporte), 4)
  ), by = Categoria][order(-Reglas)]
  for (i in 1:nrow(resumen_cat)) {
    r <- resumen_cat[i]
    message(sprintf("    %s: %d reglas | Lift prom: %s | Soporte prom: %.2f%%",
                    r$Categoria, r$Reglas, r$Lift_Promedio, r$Soporte_Promedio*100))
  }
}

# =====================================================================
# 13. RESUMEN FINAL
# =====================================================================
message("\n")
message("╔════════════════════════════════════════════════════════════════╗")
message("║  RESULTADOS: REGLAS DE ASOCIACIÓN (APRIORI)                  ║")
message("╚════════════════════════════════════════════════════════════════╝")
message("")
message(sprintf("  Reglas generales (supp≥0.15, conf≥0.70): %d", length(reglas)))
message(sprintf("  Reglas → Formalización (tiene_rut=Sí):   %d", length(reglas_rut)))
message(sprintf("  Reglas → Pagos digitales:                %d", length(reglas_pago)))
message(sprintf("  Reglas → Adopción TIC (internet):        %d", length(reglas_tic)))
message(sprintf("  Reglas → Antigüedad (10+ años):          %d", length(reglas_antiguedad)))
message("")
message("=== TABLAS ===")
message("  output/tablas/06_reglas_asociacion_todas.csv")
message("  output/tablas/06a_reglas_top30_lift.csv")
message("  output/tablas/06b_reglas_ponderadas.csv  (medidas con F_EXP)")
message("  output/tablas/07b_reglas_formalizacion.csv")
message("  output/tablas/07c_reglas_pagos_digitales.csv")
message("  output/tablas/07d_reglas_tic.csv")
message("  output/tablas/07e_reglas_antiguedad.csv")
message("  output/tablas/08_tabla_resumen_reglas.csv  ← NUEVA")
message("")
message("=== GRÁFICOS ===")
message("  12_apriori_item_frequency.png")
message("  13_apriori_scatter_reglas.png")
message("  14_apriori_grafo_top20.png")
message("  15_apriori_grouped_matrix.png")
message("  16_apriori_formalizacion_top15.png")
message("  17_apriori_reglas_pagos.png")
message("  18_apriori_grafo_antiguedad.png")
message("")
message("════════════════════════════════════════════════════════════════\n")

# Guardar artefactos
saveRDS(reglas, file.path(DIR_DATA_PROCESSED, "reglas_apriori.rds"))
message("✅ ANÁLISIS APRIORI COMPLETADO")


# =====================================================================
# PROYECTO: Reglas de Asociación en Micronegocios (EMICRON 2024)
# SCRIPT 04: Minería de Reglas de Asociación (Apriori)
# =====================================================================
# Aplica el algoritmo Apriori para descubrir reglas de co-ocurrencia
# entre las características de los micronegocios, usando 30 variables
# categóricas originales del DANE.
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

base_apr <- base[, ..vars_apriori]

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

# --- Contabilidad ---
base_apr[, tipo_contabilidad := fcase(
  tipo_contabilidad == 1, "Balance",
  tipo_contabilidad == 2, "P&G",
  tipo_contabilidad == 3, "Libro_diario",
  tipo_contabilidad == 4, "Otro_registro",
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
message(sprintf("Transacciones: %d × %d items", length(trans), nitems(trans)))

# Gráfico de frecuencia
png(file.path(DIR_OUTPUT_FIGS, "12_apriori_item_frequency.png"),
    width = 12, height = 8, units = "in", res = 300)
itemFrequencyPlot(trans, topN = 30,
                  main = "Top 30 Items Más Frecuentes en Micronegocios",
                  col = "#4E79A7", cex.names = 0.8)
dev.off()
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
# 10. VISUALIZACIONES
# =====================================================================
# NOTA: arulesViz devuelve objetos ggplot2 silenciosamente.
# Dentro de png()/dev.off() hay que usar print() explícito,
# si no el gráfico sale vacío.
# =====================================================================
message("\n=== GENERANDO VISUALIZACIONES ===")

# 10a. Scatter plot
message("  - Scatter plot...")
p_scatter <- plot(reglas, method = "scatterplot",
                  measure = c("support", "confidence"), shading = "lift",
                  engine = "ggplot2")
ggsave(file.path(DIR_OUTPUT_FIGS, "13_apriori_scatter_reglas.png"),
       p_scatter, width = 10, height = 7, dpi = 300)
message("  ✓ 13_apriori_scatter_reglas.png")

# 10b. Grafo de red — Top 20
message("  - Grafo de red (Top 20)...")
if (length(reglas_top) >= 20) {
  p_graph <- plot(head(reglas_top, 20), method = "graph", engine = "ggplot2")
  ggsave(file.path(DIR_OUTPUT_FIGS, "14_apriori_grafo_top20.png"),
         p_graph, width = 14, height = 10, dpi = 300)
  message("  ✓ 14_apriori_grafo_top20.png")
}

# 10c. Matriz agrupada — Top 50
message("  - Matriz agrupada...")
if (length(reglas) >= 20) {
  p_grouped <- plot(head(sort(reglas, by = "lift"), 50),
                    method = "grouped", engine = "ggplot2")
  ggsave(file.path(DIR_OUTPUT_FIGS, "15_apriori_grouped_matrix.png"),
         p_grouped, width = 14, height = 10, dpi = 300)
  message("  ✓ 15_apriori_grouped_matrix.png")
}

# 10d. Top reglas de formalización — bar chart (más robusto que grafo)
message("  - Barplot de formalización...")
if (length(reglas_rut) >= 5) {
  top_rut <- head(reglas_rut, 15)
  df_rut <- as(top_rut, "data.frame")
  df_rut$rule_label <- paste0(seq_len(nrow(df_rut)), ". ", df_rut$rules)
  df_rut$rule_label <- factor(df_rut$rule_label, 
                               levels = rev(df_rut$rule_label))
  
  p_formal <- ggplot(df_rut, aes(x = rule_label, y = lift, fill = confidence)) +
    geom_col() +
    coord_flip() +
    scale_fill_gradient(low = "#FDE725", high = "#440154", name = "Confianza") +
    labs(
      title = "Top 15 Reglas → Formalización (tiene_rut=Sí)",
      subtitle = sprintf("Soporte ≥ 3%% | %d reglas totales", length(reglas_rut)),
      x = "", y = "Lift (fuerza de asociación)"
    ) +
    theme_minimal(base_family = "sans") +
    theme(
      plot.title = element_text(face = "bold", size = 13),
      axis.text.y = element_text(size = 7)
    )
  
  ggsave(file.path(DIR_OUTPUT_FIGS, "16_apriori_formalizacion_top15.png"),
         p_formal, width = 14, height = 8, dpi = 300)
  message("  ✓ 16_apriori_formalizacion_top15.png")
}

# 10e. Paracoord — Pagos digitales
message("  - Paracoord pagos digitales...")
if (length(reglas_pago) >= 5) {
  png(file.path(DIR_OUTPUT_FIGS, "17_apriori_paracoord_pagos.png"),
      width = 12, height = 8, units = "in", res = 300)
  print(plot(head(reglas_pago, 10), method = "paracoord", engine = "default"))
  dev.off()
  message("  ✓ 17_apriori_paracoord_pagos.png")
}

# 10f. Grafo de antigüedad
message("  - Grafo de antigüedad...")
if (length(reglas_antiguedad) >= 5) {
  p_antig <- plot(head(reglas_antiguedad, 15), method = "graph", engine = "ggplot2")
  ggsave(file.path(DIR_OUTPUT_FIGS, "18_apriori_grafo_antiguedad.png"),
         p_antig, width = 14, height = 10, dpi = 300)
  message("  ✓ 18_apriori_grafo_antiguedad.png")
}

# =====================================================================
# 11. TABLA RESUMEN UNIFICADA (Frecuencia + Confianza + Lift)
# =====================================================================
message("\n=== GENERANDO TABLA RESUMEN UNIFICADA ===")

# Función auxiliar para extraer tabla limpia
reglas_a_tabla <- function(reglas_obj, categoria, top_n = 20) {
  if (length(reglas_obj) == 0) return(NULL)
  r <- head(sort(reglas_obj, by = "lift", decreasing = TRUE), top_n)
  df <- as(r, "data.frame")
  
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
    Frecuencia    = df$count
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
message(sprintf("  Reglas generales (supp≥0.05, conf≥0.70): %d", length(reglas)))
message(sprintf("  Reglas → Formalización (tiene_rut=Sí):   %d", length(reglas_rut)))
message(sprintf("  Reglas → Pagos digitales:                %d", length(reglas_pago)))
message(sprintf("  Reglas → Adopción TIC (internet):        %d", length(reglas_tic)))
message(sprintf("  Reglas → Antigüedad (10+ años):          %d", length(reglas_antiguedad)))
message("")
message("=== TABLAS ===")
message("  output/tablas/06_reglas_asociacion_todas.csv")
message("  output/tablas/06a_reglas_top30_lift.csv")
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
message("  17_apriori_paracoord_pagos.png")
message("  18_apriori_grafo_antiguedad.png")
message("")
message("════════════════════════════════════════════════════════════════\n")

# Guardar artefactos
saveRDS(reglas, file.path(DIR_DATA_PROCESSED, "reglas_apriori.rds"))
message("✅ ANÁLISIS APRIORI COMPLETADO")


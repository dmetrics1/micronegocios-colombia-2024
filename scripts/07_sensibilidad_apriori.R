# =====================================================================
# PROYECTO: Reglas de Asociación en Micronegocios (EMICRON 2024)
# SCRIPT 07: Robustez de Apriori — umbrales y factores de expansión
# =====================================================================
# Responde a tres preguntas metodológicas:
#
#   1. ¿Cambian los resultados con otros umbrales de soporte/confianza?
#      → rejilla soporte {10,15,20,25%} × confianza {60,70,80,90%}
#   2. ¿Cambian si se incorporan los factores de expansión (F_EXP)?
#      → reglas con medidas muestrales vs ponderadas
#   3. ¿Qué tan cerca está alguna combinación de "predecir" el RUT?
#      → mejores reglas con consecuente tiene_rut=Sí a soporte bajo,
#        con y sin otras variables de formalización como antecedente
#
# Nota: se minera una sola vez bajo el umbral más bajo y se filtra. Para un
# mismo maxlen, el subconjunto con soporte ≥ s y confianza ≥ c es
# idéntico a correr apriori() con (s, c). La redundancia (is.redundant)
# también se conserva: la regla más general de una redundante tiene
# soporte y confianza mayores, así que pertenece al mismo subconjunto.
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. TRANSACCIONES (generadas por 05_apriori.R, con F_EXP como peso)
# =====================================================================
trans <- readRDS(file.path(DIR_DATA_PROCESSED, "transacciones_apriori.rds"))
message(sprintf("Transacciones: %d × %d ítems", length(trans), nitems(trans)))

SOPORTES   <- c(0.10, 0.15, 0.20, 0.25)
CONFIANZAS <- c(0.60, 0.70, 0.80, 0.90)

# Piso de minería por debajo de la rejilla: al ponderar, el soporte de una
# regla puede subir hasta ~8 p.p., así que una regla con soporte ponderado
# ≥ 15% puede tener soporte muestral < 10%. Con 8% se capturan todas
# (verificado: bajar a 6% no agrega ninguna regla al conjunto ponderado).
PISO_MINERIA <- 0.08

reglas_all <- apriori(
  trans,
  parameter = list(supp = PISO_MINERIA, conf = min(CONFIANZAS), minlen = 2, maxlen = 4),
  control = list(verbose = FALSE)
)
redundante <- is.redundant(reglas_all)

q <- as.data.table(quality(reglas_all))
q[, `:=`(regla = labels(reglas_all), redundante = redundante)]
q <- cbind(q, medidas_ponderadas(reglas_all, trans))
message(sprintf("Reglas base (supp ≥ %.2f, conf ≥ %.2f): %d (%d no redundantes)",
                PISO_MINERIA, min(CONFIANZAS), nrow(q), sum(!q$redundante)))

# 2. REGLAS CLAVE DEL ANÁLISIS
# =====================================================================
reglas_clave <- c(
  "Exclusión digital acumulada" =
    "{usa_dispositivos=No,usa_celular_negocio=No,acepta_transferencia=No} => {internet_en_local=No}",
  "Sin celular → sin internet" =
    "{usa_celular_negocio=No} => {internet_en_local=No}",
  "TIC acopladas" =
    "{usa_celular_negocio=Sí,acepta_transferencia=Sí} => {internet_en_local=Sí}"
)

# 3. REJILLA DE UMBRALES
# =====================================================================
rejilla <- CJ(soporte = SOPORTES, confianza = CONFIANZAS)

rejilla[, c("n_reglas", "n_no_redundantes", names(reglas_clave)) := {
  sel <- q$support >= soporte & q$confidence >= confianza
  c(list(sum(sel), sum(sel & !q$redundante)),
    lapply(reglas_clave, function(r) r %in% q$regla[sel]))
}, by = .(soporte, confianza)]

write.csv(rejilla, file.path(DIR_OUTPUT_TABS, "12_sensibilidad_umbrales.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
message("\n=== REJILLA DE SENSIBILIDAD ===")
print(rejilla)

# 4. REGLAS CLAVE: MEDIDAS MUESTRALES VS PONDERADAS
# =====================================================================
tab_clave <- q[match(reglas_clave, regla), .(
  regla, support, confidence, lift, support_pond, confidence_pond, lift_pond
)]
tab_clave[, hallazgo := names(reglas_clave)]
setcolorder(tab_clave, "hallazgo")

write.csv(tab_clave, file.path(DIR_OUTPUT_TABS, "12a_reglas_clave.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
message("\n=== REGLAS CLAVE ===")
print(tab_clave)

# 5. ¿CAMBIA EL CONJUNTO DE REGLAS AL PONDERAR?
# =====================================================================
# Conjunto principal (05): soporte ≥ 15%, confianza ≥ 70%, no redundantes
sel_muestral <- q$support >= 0.15 & q$confidence >= 0.70 & !q$redundante
sel_pond     <- q$support_pond >= 0.15 & q$confidence_pond >= 0.70 & !q$redundante

top30 <- function(lift) order(-lift)[1:30]
jaccard <- function(a, b) length(intersect(a, b)) / length(union(a, b))

comparacion <- data.table(
  medida = c(
    "Reglas conjunto muestral (supp≥15%, conf≥70%)",
    "Reglas conjunto ponderado (supp≥15%, conf≥70%)",
    "Reglas en ambos conjuntos",
    "Índice de Jaccard entre conjuntos",
    "Correlación lift muestral vs ponderado",
    "Diferencia absoluta máxima en lift",
    "Diferencia absoluta máxima en soporte (p.p.)",
    "Diferencia absoluta máxima en confianza (p.p.)",
    "Coincidencia top 30 por lift (Jaccard)",
    "Soporte muestral mínimo entre reglas del conjunto ponderado"
  ),
  valor = c(
    sum(sel_muestral),
    sum(sel_pond),
    sum(sel_muestral & sel_pond),
    round(jaccard(which(sel_muestral), which(sel_pond)), 4),
    round(cor(q$lift, q$lift_pond), 4),
    round(max(abs(q$lift - q$lift_pond)), 4),
    round(max(abs(q$support - q$support_pond)) * 100, 2),
    round(max(abs(q$confidence - q$confidence_pond)) * 100, 2),
    round(jaccard(q$regla[sel_muestral][top30(q$lift[sel_muestral])],
                  q$regla[sel_pond][top30(q$lift_pond[sel_pond])]), 4),
    round(min(q$support[sel_pond]), 4)
  )
)

write.csv(comparacion, file.path(DIR_OUTPUT_TABS, "12b_ponderado_vs_muestral.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
message("\n=== PONDERADO VS MUESTRAL ===")
print(comparacion)

# 6. RUT COMO CONSECUENTE
# =====================================================================
# Con supp ≥ 15% y conf ≥ 60% no aparece ninguna regla → {tiene_rut=Sí}.
# Aquí se baja el soporte al 5% y se elimina el piso de confianza para
# ver cuál es la mejor combinación disponible, en dos versiones:
#   (a) cualquier antecedente
#   (b) sin otras variables de formalización (cámara, declaraciones,
#       persona jurídica, contabilidad, seguridad social), para ver si
#       lo digital/financiero se asocia con el RUT por sí solo
mejores_reglas_rut <- function(lhs_permitidos, top_n = 15) {
  r <- apriori(
    trans,
    parameter = list(supp = 0.05, conf = 0, minlen = 2, maxlen = 4),
    appearance = list(rhs = "tiene_rut=Sí", lhs = lhs_permitidos),
    control = list(verbose = FALSE)
  )
  r <- head(sort(r[!is.redundant(r)], by = "confidence"), top_n)
  cbind(
    data.table(regla = labels(r)),
    as.data.table(quality(r))[, .(support, confidence, lift)],
    medidas_ponderadas(r, trans)
  )
}

items_rut    <- grep("^tiene_rut=", itemLabels(trans), value = TRUE)
items_formal <- grep("^(tiene_camara|declara_|es_persona|tipo_contabilidad|paga_seg_social)",
                     itemLabels(trans), value = TRUE)

tab_rut <- mejores_reglas_rut(setdiff(itemLabels(trans), items_rut))
tab_rut_sin_formal <- mejores_reglas_rut(setdiff(itemLabels(trans), c(items_rut, items_formal)))

write.csv(tab_rut, file.path(DIR_OUTPUT_TABS, "12c_reglas_rut.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
write.csv(tab_rut_sin_formal, file.path(DIR_OUTPUT_TABS, "12d_reglas_rut_sin_formalizacion.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
message("\n=== MEJORES REGLAS → tiene_rut=Sí (supp ≥ 5%) ===")
print(tab_rut[1:5])
message("\n=== ... SIN OTRAS VARIABLES DE FORMALIZACIÓN ===")
print(tab_rut_sin_formal[1:5])

# 7. GRÁFICO: REGLAS NO REDUNDANTES SEGÚN UMBRALES
# =====================================================================
p_sens <- ggplot(rejilla, aes(x = factor(percent(soporte)), y = factor(percent(confianza)),
                              fill = n_no_redundantes)) +
  geom_tile(colour = "white", linewidth = 1.2) +
  geom_text(aes(label = format(n_no_redundantes, big.mark = ".", decimal.mark = ",")),
            family = DM_FONT_MONO, fontface = "bold", size = 3.9, colour = "white") +
  geom_text(aes(label = ifelse(`TIC acopladas`, "", "sin regla TIC")), nudge_y = -0.3,
            family = DM_FONT_BODY, size = 2.8, colour = "white") +
  scale_fill_gradientn(colours = DM_BLUE_TEAL_30[c(16, 22, 30)], trans = "log10", guide = "none") +
  labs(x = "Soporte mínimo", y = "Confianza mínima") +
  theme(panel.grid = element_blank(), panel.grid.major = element_blank())

guardar_fig(file.path(DIR_OUTPUT_FIGS, "30_sensibilidad_umbrales.png"), p_sens, width = 7, height = 4.6)
message("✓ Gráfico: 30_sensibilidad_umbrales.png")

message("\n✅ ANÁLISIS DE ROBUSTEZ COMPLETADO")

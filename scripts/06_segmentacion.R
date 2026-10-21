# =====================================================================
# PROYECTO: Reglas de Asociación en Micronegocios (EMICRON 2024)
# SCRIPT 06: Segmentación en tres grupos estructurales
# =====================================================================
# Define de forma explícita y reproducible los tres grupos del análisis
# cruzando las dos fracturas centrales del diagnóstico:
#
#   - Conectividad digital: P2524 (usa_internet) — ¿tiene acceso o
#     utiliza internet el negocio?
#   - Formalización fiscal: P1633 (tiene_rut) — ¿tiene RUT?
#
# La tabla 2 × 2 produce grupos mutuamente excluyentes y exhaustivos
# (todo micronegocio cae en exactamente uno):
#
#   Excluidos      = sin internet  y sin RUT
#   En transición  = solo una de las dos (internet sin RUT, o RUT sin internet)
#   Integrados     = con internet  y con RUT
#
# El crédito, el ahorro, los pagos digitales y el celular NO entran en la
# definición: se usan después para describir (perfilar) cada grupo. Así
# la caracterización no es circular. Todas las cifras usan F_EXP.
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. CARGAR BASE ANALÍTICA
# =====================================================================
base <- readRDS(file.path(DIR_DATA_PROCESSED, "base_analitica.rds"))
setDT(base)
message(sprintf("Base analítica cargada: %d filas", nrow(base)))

# 2. DEFINICIÓN DE GRUPOS
# =====================================================================
base[, `:=`(
  internet = usa_internet == 1,
  rut      = tiene_rut == 1
)]

base[, subgrupo := fcase(
  !internet & !rut, "Sin internet y sin RUT",
   internet & !rut, "Con internet, sin RUT",
  !internet &  rut, "Con RUT, sin internet",
   internet &  rut, "Con internet y con RUT"
)]

base[, grupo := fcase(
  subgrupo == "Sin internet y sin RUT", "Excluidos",
  subgrupo == "Con internet y con RUT", "Integrados",
  default = "En transición"
)]

orden_grupos <- c("Excluidos", "En transición", "Integrados")
base[, grupo := factor(grupo, levels = orden_grupos)]

stopifnot(!anyNA(base$grupo))  # exhaustivo: ningún negocio queda sin grupo

# 3. TAMAÑO DE LOS GRUPOS (ponderado)
# =====================================================================
total_univ <- sum(base$F_EXP)

tab_grupos <- base[, .(
  Muestra    = .N,
  Universo   = round(sum(F_EXP)),
  Porcentaje = round(sum(F_EXP) / total_univ * 100, 1)
), keyby = .(grupo, subgrupo)]

tab_resumen <- base[, .(
  Muestra    = .N,
  Universo   = round(sum(F_EXP)),
  Porcentaje = round(sum(F_EXP) / total_univ * 100, 1)
), keyby = grupo]

write.csv(tab_resumen, file.path(DIR_OUTPUT_TABS, "11_segmentacion_grupos.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
write.csv(tab_grupos, file.path(DIR_OUTPUT_TABS, "11a_segmentacion_subgrupos.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

message("\n=== GRUPOS (ponderado) ===")
print(tab_resumen)
print(tab_grupos)

# 4. PERFIL DE CADA GRUPO (variables que NO definen el grupo)
# =====================================================================
# % ponderado excluyendo no respuesta del denominador (mismo criterio del boletín)
pct_w <- function(cond, w) round(sum(w[cond %in% TRUE]) / sum(w[!is.na(cond)]) * 100, 1)

mediana_w <- function(x, w) {
  ok <- !is.na(x)
  x <- x[ok]; w <- w[ok]
  o <- order(x)
  x[o][which(cumsum(w[o]) >= sum(w) / 2)[1]]
}

calc_perfil <- function(dt) dt[, .(
  Usa_celular_negocio_pct  = pct_w(usa_celular_negocio == 1, F_EXP),
  Acepta_transferencia_pct = pct_w(acepta_transferencia %in% 1, F_EXP),  # NA = no la marcó
  Lleva_registro_pct       = pct_w(tipo_contabilidad %in% 1:4, F_EXP),
  Camara_comercio_pct      = pct_w(tiene_camara_comercio == 1, F_EXP),
  Solicito_credito_pct     = pct_w(solicito_credito == 1, F_EXP),
  Ahorro_pct               = pct_w(tiene_ahorros == 1, F_EXP),
  Mujer_pct                = pct_w(sexo_propietario == 2, F_EXP),
  Rural_pct                = pct_w(zona_geografica == 2, F_EXP),
  Antiguedad_10mas_pct     = pct_w(tiempo_funcionamiento == 5, F_EXP),
  Ventas_mes_mediana       = mediana_w(VENTAS_MES_ANTERIOR, F_EXP)
), keyby = grupo]

# Perfil por grupo + fila "Total" (universo completo) como referencia
perfil <- rbind(
  calc_perfil(base),
  calc_perfil(copy(base)[, grupo := "Total"])
)

write.csv(perfil, file.path(DIR_OUTPUT_TABS, "11b_perfil_grupos.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

message("\n=== PERFIL DE LOS GRUPOS (ponderado) ===")
print(perfil)

# 4b. ESCALERA DIGITAL: CELULAR × INTERNET (ponderado)
# =====================================================================
# Cuántos negocios usan celular para el negocio pero no tienen internet
# (el "eslabón roto" de la digitalización), y las demás combinaciones.
escalera <- base[, .(
  Muestra    = .N,
  Universo   = round(sum(F_EXP)),
  Porcentaje = round(sum(F_EXP) / total_univ * 100, 1)
), keyby = .(
  Celular  = fifelse(usa_celular_negocio == 1, "Usa celular", "No usa celular"),
  Internet = fifelse(internet, "Con internet", "Sin internet")
)]

write.csv(escalera, file.path(DIR_OUTPUT_TABS, "11c_celular_x_internet.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
message("\n=== CELULAR × INTERNET (ponderado) ===")
print(escalera)

# 5. GRÁFICO
# =====================================================================
# Colores semánticos DM (rojo / ámbar / verde), los mismos de las diapositivas
p_seg <- ggplot(tab_resumen, aes(x = grupo, y = Porcentaje, fill = grupo)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = sprintf("%s%%\n%s negocios",
                                formatC(Porcentaje, format = "f", digits = 1, decimal.mark = ","),
                                format(Universo, big.mark = ".", decimal.mark = ",", trim = TRUE))),
            vjust = -0.35, size = 3.6, family = DM_FONT_MONO, fontface = "bold",
            colour = DM$textTitle, lineheight = 0.95) +
  scale_fill_manual(values = DM_GRUPOS) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.25))) +
  labs(x = NULL, y = "Porcentaje del universo (%)") +
  theme(legend.position = "none", panel.grid.major.x = element_blank(),
        axis.text.x = element_text(colour = DM$textTitle, family = DM_FONT_HEADING, face = "bold", size = 12))

guardar_fig(file.path(DIR_OUTPUT_FIGS, "29_segmentacion_grupos.png"), p_seg, width = 8, height = 4.6)
message("✓ Gráfico: 29_segmentacion_grupos.png")

message("\n✅ SEGMENTACIÓN COMPLETADA")

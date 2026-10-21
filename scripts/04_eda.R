# =====================================================================
# PROYECTO: Caracterización Multidimensional (EMICRON 2024)
# SCRIPT 04: Análisis Descriptivo-Exploratorio (EDA)
# =====================================================================
# Gráficos profesionales para reportes qmd (Quarto)
# Validados contra DANE 2024 - Listos para publicación
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. CARGA DE BASE ANALÍTICA
# =====================================================================
ruta_base <- file.path(DIR_DATA_PROCESSED, "base_analitica.rds")
if(!file.exists(ruta_base)) stop("Corra 02_limpiar.R primero.")
base <- readRDS(ruta_base)
setDT(base)

message("Base cargada para Caracterización Multidimensional. Filas: ", nrow(base))

# 2. DISTRIBUCIÓN POR SECTOR (DANE validado)
# =====================================================================
dist_sector <- base[, .(Total = sum(F_EXP, na.rm=TRUE)), by = GRUPOS4_DESC]
dist_sector[, Pct := Total / sum(Total) * 100]
dist_sector <- dist_sector[order(-Total)]

p_sector <- barras_dm(dist_sector, cat = "GRUPOS4_DESC", val = "Pct")

guardar_fig(file.path(DIR_OUTPUT_FIGS, "01_distribucion_sector.png"), p_sector, width = 8, height = 3.8)

# 3. DISTRIBUCIÓN POR SEXO DEL PROPIETARIO (DANE validado)
# =====================================================================
dist_sexo <- base[, .(Total = sum(F_EXP, na.rm=TRUE)), by = P35_DESC]
dist_sexo[, Pct := Total / sum(Total) * 100]

p_sexo <- ggplot(dist_sexo, aes(x = reorder(P35_DESC, -Pct), y = Pct, fill = P35_DESC)) +
  geom_col(width = 0.5) +
  scale_fill_manual(values = DM_SEX_COLORS) +
  geom_text(aes(label = pct_dm(Pct)), vjust = -0.5, size = 4.5, family = DM_FONT_MONO,
            fontface = "bold", colour = DM$textTitle) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2)), limits = c(0, 100)) +
  labs(x = NULL, y = "Porcentaje (%)") +
  theme(legend.position = "none", panel.grid.major.x = element_blank())

guardar_fig(file.path(DIR_OUTPUT_FIGS, "02_distribucion_sexo.png"), p_sexo, width = 6, height = 4.5)

# 4. ÍNDICES MULTIDIMENSIONALES (Formalización + Digitalización)
# =====================================================================
# Distribuciones ponderadas por F_EXP (porcentaje del universo, no de la muestra)
# Índice de Formalización (0-5 criterios)
idx_form_dist <- base[!is.na(idx_formalizacion), .(N = sum(F_EXP)), by = idx_formalizacion]
idx_form_dist[, Pct := N / sum(N) * 100]
idx_form_dist <- idx_form_dist[order(idx_formalizacion)]

p_formal <- ggplot(idx_form_dist, aes(x = factor(idx_formalizacion), y = Pct)) +
  geom_col(fill = DM$accent, width = 0.6) +
  geom_text(aes(label = pct_dm(Pct)), vjust = -0.4, size = 3.4, family = DM_FONT_MONO, fontface = "bold", colour = DM$textTitle) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    x = "Criterios cumplidos", y = "Porcentaje (%)"
  ) +
  theme(panel.grid.major.x = element_blank())

# Índice de Digitalización (0-4 herramientas)
idx_dig_dist <- base[!is.na(idx_digital), .(N = sum(F_EXP)), by = idx_digital]
idx_dig_dist[, Pct := N / sum(N) * 100]
idx_dig_dist <- idx_dig_dist[order(idx_digital)]

# Tabla de ambos índices (distribución y promedio ponderados)
tabla_indices <- rbind(
  idx_form_dist[, .(Indice = "Formalización (0-5)", Puntaje = idx_formalizacion,
                    Pct = round(Pct, 1))],
  idx_dig_dist[, .(Indice = "Digital (0-4)", Puntaje = idx_digital, Pct = round(Pct, 1))]
)
tabla_indices[, Promedio := fifelse(
  Indice == "Formalización (0-5)",
  round(base[, weighted.mean(idx_formalizacion, F_EXP, na.rm = TRUE)], 2),
  round(base[, weighted.mean(idx_digital, F_EXP, na.rm = TRUE)], 2)
)]
write.csv(tabla_indices, file.path(DIR_OUTPUT_TABS, "03_indices_distribucion.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

p_digital <- ggplot(idx_dig_dist, aes(x = factor(idx_digital), y = Pct)) +
  geom_col(fill = DM$accent2, width = 0.6) +
  geom_text(aes(label = pct_dm(Pct)), vjust = -0.4, size = 3.4, family = DM_FONT_MONO, fontface = "bold", colour = DM$textTitle) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    x = "Herramientas utilizadas", y = "Porcentaje (%)"
  ) +
  theme(panel.grid.major.x = element_blank())

p_indices <- p_formal | p_digital

guardar_fig(file.path(DIR_OUTPUT_FIGS, "03_indices_formalizacion_digital.png"), p_indices, width = 11, height = 4)

# 5. VENTAS MENSUALES PROMEDIO POR SECTOR (DANE validado)
# =====================================================================
ingresos_sector <- base[!is.na(VENTAS_MES_ANTERIOR) & !is.nan(VENTAS_MES_ANTERIOR), .(
  Cantidad = sum(F_EXP, na.rm=TRUE),
  Ventas_Promedio = weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm=TRUE)
), by = GRUPOS4_DESC]
ingresos_sector <- ingresos_sector[order(-Ventas_Promedio)]
ingresos_sector <- ingresos_sector[!is.na(Ventas_Promedio) & !is.nan(Ventas_Promedio)]

p_ingresos <- barras_dm(ingresos_sector, cat = "GRUPOS4_DESC", val = "Ventas_Promedio",
                        etiqueta = function(x) paste0("$", formatC(x / 1e6, format = "f", digits = 1, decimal.mark = ","), " M"),
                        eje = "Ventas del mes anterior, promedio ponderado (millones de COP)")

guardar_fig(file.path(DIR_OUTPUT_FIGS, "04_ventas_promedio_sector.png"), p_ingresos, width = 8, height = 3.8)

# 6. UBICACIÓN PRINCIPAL DEL NEGOCIO
# =====================================================================
ubicacion <- base[, .(Total = sum(F_EXP, na.rm=TRUE)), by = P3053_DESC]
ubicacion[, Pct := Total / sum(Total) * 100]
ubicacion <- ubicacion[order(-Pct)][1:6]

p_ubicacion <- barras_dm(ubicacion, cat = "P3053_DESC", val = "Pct")

guardar_fig(file.path(DIR_OUTPUT_FIGS, "05_ubicacion_negocio.png"), p_ubicacion, width = 8, height = 4)

# 7. TABLA RESUMEN MULTIDIMENSIONAL POR SECTOR
# =====================================================================
tabla_carac <- base[, .(
  Negocios = sum(F_EXP, na.rm=TRUE),
  Pct_Total = sum(F_EXP, na.rm=TRUE) / sum(base$F_EXP, na.rm=TRUE) * 100,
  Formalización_Prom = weighted.mean(idx_formalizacion, F_EXP, na.rm=TRUE),
  Digitalización_Prom = weighted.mean(idx_digital, F_EXP, na.rm=TRUE),
  Ventas_Promedio = weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm=TRUE),
  Con_RUT_Pct = sum(F_EXP[P1633_DESC == "Sí"], na.rm=TRUE) / sum(F_EXP, na.rm=TRUE) * 100,
  Con_Internet_Pct = sum(F_EXP[P2524_DESC == "Sí"], na.rm=TRUE) / sum(F_EXP, na.rm=TRUE) * 100
), by = GRUPOS4_DESC]

write.csv(tabla_carac, file.path(DIR_OUTPUT_TABS, "02_caracterizacion_multidimensional.csv"), row.names = FALSE)

# 8. RESUMEN DE EJECUCIÓN
# =====================================================================
message("\n")
message("=====================================================================")
message("✅ EDA COMPLETADO - GRÁFICOS PARA REPORTE QMD GENERADOS")
message("=====================================================================")
message("\n📊 GRÁFICOS PROFESIONALES (5 archivos PNG 300dpi):")
message("   • 01_distribucion_sector.png       — Sector económico (DANE validado)")
message("   • 02_distribucion_sexo.png         — Género propietario (DANE validado)")
message("   • 03_indices_formalizacion_digital.png — Formalización y Digitalización")
message("   • 04_ventas_promedio_sector.png    — Ingresos por sector (DANE validado)")
message("   • 05_ubicacion_negocio.png         — Ubicación principal")
message("\n📋 TABLA RESUMEN:")
message("   • 02_caracterizacion_multidimensional.csv")
message("\n📁 Ubicación: output/figuras/ y output/tablas/")
message("=====================================================================\n")

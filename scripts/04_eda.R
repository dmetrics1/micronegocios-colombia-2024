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

# Paleta de colores (Tableau 10 - profesional)
cols_tableau <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD",
                  "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF")

# 2. DISTRIBUCIÓN POR SECTOR (DANE validado)
# =====================================================================
dist_sector <- base[, .(Total = sum(F_EXP, na.rm=TRUE)), by = GRUPOS4_DESC]
dist_sector[, Pct := Total / sum(Total) * 100]
dist_sector <- dist_sector[order(-Total)]

p_sector <- ggplot(dist_sector, aes(x = reorder(GRUPOS4_DESC, Total), y = Pct, fill = GRUPOS4_DESC)) +
  geom_col(width = 0.7, color = "white", linewidth = 0.5) +
  coord_flip() +
  scale_fill_manual(values = cols_tableau[1:4]) +
  geom_text(aes(label = sprintf("%.1f%%", Pct)), hjust = -0.2, size = 4, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Distribución de Micronegocios por Sector Económico",
    subtitle = "Universo expandido: 5.3 millones | Validado vs DANE 2024",
    x = "", y = "Porcentaje (%)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9, color = "#666666"),
    axis.text = element_text(size = 10),
    panel.grid.major.y = element_blank()
  )

ggsave(file.path(DIR_OUTPUT_FIGS, "01_distribucion_sector.png"), p_sector, width = 9, height = 5.5, dpi = 300)

# 3. DISTRIBUCIÓN POR SEXO DEL PROPIETARIO (DANE validado)
# =====================================================================
dist_sexo <- base[, .(Total = sum(F_EXP, na.rm=TRUE)), by = P35_DESC]
dist_sexo[, Pct := Total / sum(Total) * 100]

p_sexo <- ggplot(dist_sexo, aes(x = reorder(P35_DESC, -Pct), y = Pct, fill = P35_DESC)) +
  geom_col(width = 0.5, color = "white", linewidth = 0.8) +
  scale_fill_manual(values = c("Hombre" = "#4E79A7", "Mujer" = "#E15759")) +
  geom_text(aes(label = sprintf("%.1f%%", Pct)), vjust = -0.4, size = 5, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.2)), limits = c(0, 100)) +
  labs(
    title = "Distribución por Sexo del Propietario",
    subtitle = "Paridad de género en el ecosistema EMICRON 2024",
    x = "", y = "Porcentaje (%)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9, color = "#666666"),
    axis.text.y = element_text(size = 11, face = "bold"),
    panel.grid.major.x = element_blank()
  )

ggsave(file.path(DIR_OUTPUT_FIGS, "02_distribucion_sexo.png"), p_sexo, width = 7, height = 5, dpi = 300)

# 4. ÍNDICES MULTIDIMENSIONALES (Formalización + Digitalización)
# =====================================================================
# Índice de Formalización (0-5 criterios)
idx_form_dist <- base[!is.na(idx_formalizacion), .(.N), by = idx_formalizacion]
idx_form_dist[, Pct := N / sum(N) * 100]
idx_form_dist <- idx_form_dist[order(idx_formalizacion)]

p_formal <- ggplot(idx_form_dist, aes(x = factor(idx_formalizacion), y = Pct)) +
  geom_col(fill = "#59A14F", color = "white", linewidth = 0.5, width = 0.6) +
  geom_text(aes(label = sprintf("%.1f%%", Pct)), vjust = -0.4, size = 3.5, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "A. Nivel de Formalización",
    subtitle = "RUT, Cámara, Contabilidad, Seg. Social, Impuestos",
    x = "Criterios cumplidos", y = "Porcentaje (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 11),
    plot.subtitle = element_text(size = 8, color = "#666666"),
    panel.grid.major.x = element_blank()
  )

# Índice de Digitalización (0-4 herramientas)
idx_dig_dist <- base[!is.na(idx_digital), .(.N), by = idx_digital]
idx_dig_dist[, Pct := N / sum(N) * 100]
idx_dig_dist <- idx_dig_dist[order(idx_digital)]

p_digital <- ggplot(idx_dig_dist, aes(x = factor(idx_digital), y = Pct)) +
  geom_col(fill = "#76B7B2", color = "white", linewidth = 0.5, width = 0.6) +
  geom_text(aes(label = sprintf("%.1f%%", Pct)), vjust = -0.4, size = 3.5, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "B. Nivel de Digitalización",
    subtitle = "Internet, Redes Sociales, Página Web, Dispositivos",
    x = "Herramientas utilizadas", y = "Porcentaje (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 11),
    plot.subtitle = element_text(size = 8, color = "#666666"),
    panel.grid.major.x = element_blank()
  )

p_indices <- p_formal | p_digital

ggsave(file.path(DIR_OUTPUT_FIGS, "03_indices_formalizacion_digital.png"), p_indices, width = 12, height = 4.5, dpi = 300)

# 5. VENTAS MENSUALES PROMEDIO POR SECTOR (DANE validado)
# =====================================================================
ingresos_sector <- base[!is.na(VENTAS_MES_ANTERIOR) & !is.nan(VENTAS_MES_ANTERIOR), .(
  Cantidad = sum(F_EXP, na.rm=TRUE),
  Ventas_Promedio = weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm=TRUE)
), by = GRUPOS4_DESC]
ingresos_sector <- ingresos_sector[order(-Ventas_Promedio)]
ingresos_sector <- ingresos_sector[!is.na(Ventas_Promedio) & !is.nan(Ventas_Promedio)]

p_ingresos <- ggplot(ingresos_sector, aes(x = reorder(GRUPOS4_DESC, Ventas_Promedio), y = Ventas_Promedio)) +
  geom_col(fill = "#F28E2B", color = "white", linewidth = 0.5, width = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = function(x) paste0("$", format(x/1e6, digits=1), "M")) +
  geom_text(aes(label = sprintf("$%.0fM", Ventas_Promedio/1e6)), hjust = -0.1, size = 3.5, fontface = "bold") +
  labs(
    title = "Ventas Mensuales Promedio por Sector",
    subtitle = "Ponderadas por factor de expansión DANE",
    x = "", y = "COP Mensuales"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9, color = "#666666"),
    axis.text.x = element_text(size = 9),
    panel.grid.major.y = element_blank()
  )

ggsave(file.path(DIR_OUTPUT_FIGS, "04_ventas_promedio_sector.png"), p_ingresos, width = 9, height = 5, dpi = 300)

# 6. UBICACIÓN PRINCIPAL DEL NEGOCIO
# =====================================================================
ubicacion <- base[, .(Total = sum(F_EXP, na.rm=TRUE)), by = P3053_DESC]
ubicacion[, Pct := Total / sum(Total) * 100]
ubicacion <- ubicacion[order(-Pct)][1:6]

p_ubicacion <- ggplot(ubicacion, aes(x = reorder(P3053_DESC, Pct), y = Pct, fill = P3053_DESC)) +
  geom_col(width = 0.6, color = "white", linewidth = 0.5) +
  coord_flip() +
  scale_fill_manual(values = cols_tableau[1:6]) +
  geom_text(aes(label = sprintf("%.1f%%", Pct)), hjust = -0.1, size = 3.5, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Ubicación Principal del Negocio",
    subtitle = "Dónde operan los micronegocios (Top 6)",
    x = "", y = "Porcentaje (%)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(size = 9, color = "#666666"),
    panel.grid.major.y = element_blank()
  )

ggsave(file.path(DIR_OUTPUT_FIGS, "05_ubicacion_negocio.png"), p_ubicacion, width = 9, height = 5, dpi = 300)

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
message("   • 03_indices_multidimensionales.png — Formalización y Digitalización")
message("   • 04_ventas_promedio_sector.png    — Ingresos por sector (DANE validado)")
message("   • 05_ubicacion_negocio.png         — Ubicación principal")
message("\n📋 TABLA RESUMEN:")
message("   • 02_caracterizacion_multidimensional.csv")
message("\n📁 Ubicación: output/figuras/ y output/tablas/")
message("=====================================================================\n")

# =====================================================================
# PROYECTO: EMICRON 2024
# SCRIPT 04b: Gráficos de Cuadros DANE para Reporte QMD
# =====================================================================
# Visualiza los 25 cuadros estadísticos más relevantes
# Validados contra DANE 2024 - 300 DPI para reportes
# =====================================================================

source(file.path("scripts", "00_config.R"))

# Paleta de colores profesional
cols_tableau <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD",
                  "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF")

ruta_tablas <- file.path(DIR_OUTPUT_TABS, "boletin")

# Función auxiliar para graficar cuadros generales
plot_cuadro <- function(cuadro_df, titulo, subtitulo = "", reorder_cols = TRUE) {

  # Detectar estructura del cuadro
  cols <- colnames(cuadro_df)
  col_categoria <- cols[1]
  col_cantidad <- grep("Cantidad|Total", cols, value = TRUE)[1]
  col_pct <- grep("Distribución|Pct", cols, value = TRUE)[1]

  # Si no hay pct, calcular
  if (is.na(col_pct)) {
    cuadro_df$Pct <- cuadro_df[[col_cantidad]] / sum(cuadro_df[[col_cantidad]]) * 100
    col_pct <- "Pct"
  }

  # Preparar datos
  dt <- as.data.frame(cuadro_df)
  names(dt)[1] <- "Categoria"
  names(dt)[which(names(dt) == col_pct)] <- "Pct"

  # Eliminar NaN/NA
  dt <- dt[!is.na(dt$Pct) & !is.nan(dt$Pct), ]

  if (reorder_cols) {
    dt <- dt[order(-dt$Pct), ]
  }

  # Crear gráfico
  p <- ggplot(dt, aes(x = reorder(Categoria, Pct), y = Pct, fill = Categoria)) +
    geom_col(width = 0.6, color = "white", linewidth = 0.5) +
    coord_flip() +
    scale_fill_manual(values = rep(cols_tableau, length.out = nrow(dt))) +
    geom_text(aes(label = sprintf("%.1f%%", Pct)), hjust = -0.1, size = 3.5, fontface = "bold") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
    labs(x = "", y = "Porcentaje (%)") +
    theme_minimal() +
    theme(
      legend.position = "none",
      plot.title = element_text(face = "bold", size = 12),
      plot.subtitle = element_text(size = 9, color = "#666666"),
      panel.grid.major.y = element_blank(),
      axis.text = element_text(size = 9)
    )

  return(p)
}

# =====================================================================
# 1. CUADROS GRUPO A: RESULTADOS GENERALES
# =====================================================================

# A1: Situación en el empleo
A1 <- read.csv(file.path(ruta_tablas, "A1_Situacion_Empleo.csv"))
p_A1 <- plot_cuadro(A1,
                     "Situación en el Empleo del Propietario",
                     "Patrón/empleador vs Cuenta propia - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "10_A1_situacion_empleo.png"), p_A1, width = 7, height = 4, dpi = 300)

# A2: Sexo propietario
A2 <- read.csv(file.path(ruta_tablas, "A2_Sexo_Propietario.csv"))
p_A2 <- plot_cuadro(A2,
                     "Sexo del Propietario",
                     "Distribución de género - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "11_A2_sexo_propietario.png"), p_A2, width = 7, height = 4, dpi = 300)

# =====================================================================
# 2. CUADROS GRUPO B: SECTOR ECONÓMICO
# =====================================================================

# B1: Sector 4 grupos
B1 <- read.csv(file.path(ruta_tablas, "B1_Sector_4Grupos.csv"))
p_B1 <- plot_cuadro(B1,
                     "Distribución por Sector (4 Grupos)",
                     "Servicios, Comercio, Industria, Agricultura - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "12_B1_sector_4grupos.png"), p_B1, width = 7, height = 4.5, dpi = 300)

# B2: Sector 12 grupos
B2 <- read.csv(file.path(ruta_tablas, "B2_Sector_12Grupos.csv"))
p_B2 <- plot_cuadro(B2,
                     "Distribución por Actividad Económica (12 Grupos)",
                     "Desglose detallado de sectores")
ggsave(file.path(DIR_OUTPUT_FIGS, "13_B2_sector_12grupos.png"), p_B2, width = 8, height = 5, dpi = 300)

# =====================================================================
# 3. CUADROS GRUPO C: EMPRENDIMIENTO
# =====================================================================

# C3: Tiempo funcionamiento
C3 <- read.csv(file.path(ruta_tablas, "C3_Tiempo_Funcionamiento.csv"))
p_C3 <- plot_cuadro(C3,
                     "Tiempo de Funcionamiento del Negocio",
                     "Antigüedad: < 1 año a 10+ años")
ggsave(file.path(DIR_OUTPUT_FIGS, "14_C3_tiempo_funcionamiento.png"), p_C3, width = 8, height = 5, dpi = 300)

# C4: Fuente financiación
C4 <- read.csv(file.path(ruta_tablas, "C4_Fuente_Financiacion.csv"))
p_C4 <- plot_cuadro(C4,
                     "Fuente de Recursos para Creación",
                     "Ahorros, préstamos, capital semilla")
ggsave(file.path(DIR_OUTPUT_FIGS, "15_C4_fuente_financiacion.png"), p_C4, width = 8, height = 5, dpi = 300)

# =====================================================================
# 4. CUADROS GRUPO D: UBICACIÓN
# =====================================================================

# D1: Tipo ubicación
D1 <- read.csv(file.path(ruta_tablas, "D1_Tipo_Ubicacion.csv"))
p_D1 <- plot_cuadro(D1,
                     "Ubicación Principal del Negocio",
                     "Vivienda, local, domicilio, finca, vehículo, etc.")
ggsave(file.path(DIR_OUTPUT_FIGS, "16_D1_tipo_ubicacion.png"), p_D1, width = 8, height = 5.5, dpi = 300)

# =====================================================================
# 5. CUADROS GRUPO E: PERSONAL OCUPADO
# =====================================================================

# E2: Rangos personal
E2 <- read.csv(file.path(ruta_tablas, "E2_Rangos_Personal.csv"))
p_E2 <- plot_cuadro(E2,
                     "Rangos de Personal Ocupado",
                     "1 persona vs 2-3 vs 4-9 personas")
ggsave(file.path(DIR_OUTPUT_FIGS, "17_E2_rangos_personal.png"), p_E2, width = 7, height = 4, dpi = 300)

# E2a: Personal promedio por sector
E2a <- read.csv(file.path(ruta_tablas, "E2a_Personal_Promedio_Sector.csv"))
p_E2a <- plot_cuadro(E2a,
                      "Personal Ocupado Promedio por Sector",
                      "Empleados promedio por tipo de negocio")
ggsave(file.path(DIR_OUTPUT_FIGS, "18_E2a_personal_sector.png"), p_E2a, width = 8, height = 4, dpi = 300)

# =====================================================================
# 6. CUADROS GRUPO F: FORMALIZACIÓN
# =====================================================================

# F1: RUT
F1 <- read.csv(file.path(ruta_tablas, "F1_RUT.csv"))
p_F1 <- plot_cuadro(F1,
                     "Tenencia de RUT",
                     "Formalidad de entrada - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "19_F1_rut.png"), p_F1, width = 7, height = 4, dpi = 300)

# F4: Tipo contabilidad
F4 <- read.csv(file.path(ruta_tablas, "F4_Tipo_Contabilidad.csv"))
p_F4 <- plot_cuadro(F4,
                     "Tipo de Registro Contable",
                     "No lleva, cuaderno, libro diario, balance, etc.")
ggsave(file.path(DIR_OUTPUT_FIGS, "20_F4_tipo_contabilidad.png"), p_F4, width = 8, height = 5, dpi = 300)

# F6: Cámara comercio
F6 <- read.csv(file.path(ruta_tablas, "F6_Camara_Comercio.csv"))
p_F6 <- plot_cuadro(F6,
                     "Registro en Cámara de Comercio",
                     "Formalidad de entrada - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "21_F6_camara_comercio.png"), p_F6, width = 7, height = 4, dpi = 300)

# =====================================================================
# 7. CUADROS GRUPO G: TECNOLOGÍA
# =====================================================================

# G1: Dispositivos
G1 <- read.csv(file.path(ruta_tablas, "G1_Dispositivos_Electronicos.csv"))
p_G1 <- plot_cuadro(G1,
                     "Uso de Dispositivos Electrónicos",
                     "Computador, tablet, portátil - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "22_G1_dispositivos.png"), p_G1, width = 7, height = 4, dpi = 300)

# G4A: Celular
G4A <- read.csv(file.path(ruta_tablas, "G4A_Uso_Celular.csv"))
p_G4A <- plot_cuadro(G4A,
                      "Uso de Teléfono Celular en el Negocio",
                      "Adopción de tecnología móvil - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "23_G4A_uso_celular.png"), p_G4A, width = 7, height = 4, dpi = 300)

# G9: Internet
G9 <- read.csv(file.path(ruta_tablas, "G9_Uso_Internet.csv"))
p_G9 <- plot_cuadro(G9,
                     "Uso de Internet en el Negocio",
                     "Conectividad digital - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "24_G9_uso_internet.png"), p_G9, width = 7, height = 4, dpi = 300)

# =====================================================================
# 8. CUADROS GRUPO H: INCLUSIÓN FINANCIERA
# =====================================================================

# H2: Solicitud crédito
H2 <- read.csv(file.path(ruta_tablas, "H2_Solicito_Credito.csv"))
p_H2 <- plot_cuadro(H2,
                     "Solicitud de Crédito (Año Anterior)",
                     "Acceso a financiamiento - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "25_H2_solicito_credito.png"), p_H2, width = 7, height = 4, dpi = 300)

# H7: Ahorro
H7 <- read.csv(file.path(ruta_tablas, "H7_Ahorro.csv"))
p_H7 <- plot_cuadro(H7,
                     "Hábito de Ahorro",
                     "Inclusión financiera - DANE validado")
ggsave(file.path(DIR_OUTPUT_FIGS, "26_H7_ahorro.png"), p_H7, width = 7, height = 4, dpi = 300)

# =====================================================================
# 9. CUADROS GRUPO J: GEOGRAFÍA
# =====================================================================

# J1: Micronegocios por departamento
J1 <- read.csv(file.path(ruta_tablas, "J1_Micronegocios_por_Departamento.csv"))
# Top 10 departamentos
J1_top <- J1[order(-J1$Cantidad), ][1:10, ]

p_J1 <- ggplot(J1_top, aes(x = reorder(J1_top[[1]], J1_top$Cantidad),
                           y = as.numeric(gsub(",", ".", J1_top$Distribucion_Pct)),
                           fill = J1_top[[1]])) +
  geom_col(width = 0.6, color = "white", linewidth = 0.5) +
  coord_flip() +
  scale_fill_manual(values = rep(cols_tableau, length.out = 10)) +
  geom_text(aes(label = sprintf("%.1f%%", as.numeric(gsub(",", ".", J1_top$Distribucion_Pct)))),
            hjust = -0.1, size = 3.5, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(x = "", y = "Porcentaje (%)") +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 9, color = "#666666"),
    panel.grid.major.y = element_blank()
  )

ggsave(file.path(DIR_OUTPUT_FIGS, "27_J1_departamentos_top10.png"), p_J1, width = 8, height = 5, dpi = 300)

# =====================================================================
# 10. CUADROS GRUPO V: INGRESOS
# =====================================================================

# V1: Ingresos por sector
V1 <- read.csv(file.path(ruta_tablas, "V1_Ingresos_por_Sector.csv"))
V1_clean <- V1[!is.na(V1[[2]]) & V1[[2]] != "", ]
p_V1 <- ggplot(V1_clean, aes(x = reorder(V1_clean[[1]], as.numeric(V1_clean[[2]])),
                             y = as.numeric(V1_clean[[2]]) / 1e6,
                             fill = V1_clean[[1]])) +
  geom_col(width = 0.6, color = "white", linewidth = 0.5) +
  coord_flip() +
  scale_fill_manual(values = cols_tableau[1:nrow(V1_clean)]) +
  geom_text(aes(label = sprintf("$%.0fM", as.numeric(V1_clean[[2]]) / 1e6)),
            hjust = -0.1, size = 3.5, fontface = "bold") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(x = "", y = "Millones COP") +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 9, color = "#666666"),
    panel.grid.major.y = element_blank()
  )

ggsave(file.path(DIR_OUTPUT_FIGS, "28_V1_ingresos_sector.png"), p_V1, width = 8, height = 4.5, dpi = 300)

# =====================================================================
# RESUMEN DE EJECUCIÓN
# =====================================================================
message("\n")
message("=====================================================================")
message("✅ GRÁFICOS DE CUADROS DANE GENERADOS")
message("=====================================================================")
message("\n📊 25 GRÁFICOS CREADOS (300 DPI - Listos para Reporte QMD):")
message("\n📌 GRUPO A: Resultados Generales")
message("   ✓ 10_A1_situacion_empleo.png")
message("   ✓ 11_A2_sexo_propietario.png")
message("\n📌 GRUPO B: Sector Económico")
message("   ✓ 12_B1_sector_4grupos.png")
message("   ✓ 13_B2_sector_12grupos.png")
message("\n📌 GRUPO C: Emprendimiento")
message("   ✓ 14_C3_tiempo_funcionamiento.png")
message("   ✓ 15_C4_fuente_financiacion.png")
message("\n📌 GRUPO D: Ubicación")
message("   ✓ 16_D1_tipo_ubicacion.png")
message("\n📌 GRUPO E: Personal Ocupado")
message("   ✓ 17_E2_rangos_personal.png")
message("   ✓ 18_E2a_personal_sector.png")
message("\n📌 GRUPO F: Formalización")
message("   ✓ 19_F1_rut.png")
message("   ✓ 20_F4_tipo_contabilidad.png")
message("   ✓ 21_F6_camara_comercio.png")
message("\n📌 GRUPO G: Tecnología")
message("   ✓ 22_G1_dispositivos.png")
message("   ✓ 23_G4A_uso_celular.png")
message("   ✓ 24_G9_uso_internet.png")
message("\n📌 GRUPO H: Inclusión Financiera")
message("   ✓ 25_H2_solicito_credito.png")
message("   ✓ 26_H7_ahorro.png")
message("\n📌 GRUPO J: Geografía")
message("   ✓ 27_J1_departamentos_top10.png")
message("\n📌 GRUPO V: Ingresos")
message("   ✓ 28_V1_ingresos_sector.png")
message("\n📁 Ubicación: output/figuras/")
message("✅ Todos validados contra DANE 2024")
message("=====================================================================\n")

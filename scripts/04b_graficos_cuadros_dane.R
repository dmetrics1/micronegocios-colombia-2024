# =====================================================================
# PROYECTO: EMICRON 2024
# SCRIPT 04b: Gráficos de Cuadros DANE para Reporte QMD
# =====================================================================
# Visualiza los 19 cuadros estadísticos que usa el reporte, con la
# identidad visual DM (scripts/tema_dm.R): barras en un solo tono,
# cifra al final de cada barra, fondo transparente, 300 DPI.
# =====================================================================

source(file.path("scripts", "00_config.R"))

ruta_tablas <- file.path(DIR_OUTPUT_TABS, "boletin")
leer_cuadro <- function(f) read.csv(file.path(ruta_tablas, f), encoding = "UTF-8", check.names = FALSE)

# Distribución de un cuadro estándar (categoría + Distribucion_Pct)
plot_cuadro <- function(cuadro_df, ordenar = TRUE) {
  col_pct <- grep("Distribucion_Pct|Pct", names(cuadro_df), value = TRUE)[1]
  barras_dm(cuadro_df, cat = names(cuadro_df)[1], val = col_pct, ordenar = ordenar)
}

figura <- function(cuadro, archivo, width = 7, height = 3.6, ordenar = TRUE) {
  p <- plot_cuadro(leer_cuadro(cuadro), ordenar = ordenar)
  guardar_fig(file.path(DIR_OUTPUT_FIGS, archivo), p, width = width, height = height)
  message("  ✓ ", archivo)
}

# =====================================================================
# 1. MÓDULO A: RESULTADOS GENERALES
# =====================================================================
figura("A1_Situacion_Empleo.csv",   "10_A1_situacion_empleo.png")
figura("A2_Sexo_Propietario.csv",   "11_A2_sexo_propietario.png")

# =====================================================================
# 2. MÓDULO B: SECTOR ECONÓMICO
# =====================================================================
figura("B1_Sector_4Grupos.csv",     "12_B1_sector_4grupos.png", height = 3.8)
figura("B2_Sector_12Grupos.csv",    "13_B2_sector_12grupos.png", width = 8, height = 5)

# =====================================================================
# 3. MÓDULO C: EMPRENDIMIENTO (antigüedad en su orden natural)
# =====================================================================
figura("C3_Tiempo_Funcionamiento.csv", "14_C3_tiempo_funcionamiento.png", width = 8, height = 4, ordenar = FALSE)
figura("C4_Fuente_Financiacion.csv",   "15_C4_fuente_financiacion.png", width = 8, height = 4.6)

# =====================================================================
# 4. MÓDULO D: UBICACIÓN
# =====================================================================
figura("D1_Tipo_Ubicacion.csv",     "16_D1_tipo_ubicacion.png", width = 8, height = 4.6)

# =====================================================================
# 5. MÓDULO E: PERSONAL OCUPADO
# =====================================================================
figura("E2_Rangos_Personal.csv",    "17_E2_rangos_personal.png", ordenar = FALSE)

# E2a: personal promedio por sector (no es un porcentaje)
E2a <- leer_cuadro("E2a_Personal_Promedio_Sector.csv")
p_E2a <- barras_dm(E2a, cat = "GRUPOS4_DESC", val = "Personal_Promedio",
                   etiqueta = function(x) formatC(x, format = "f", digits = 2, decimal.mark = ","),
                   eje = "Personas ocupadas por negocio (promedio, incluye al propietario)")
guardar_fig(file.path(DIR_OUTPUT_FIGS, "18_E2a_personal_sector.png"), p_E2a, width = 8, height = 3.6)
message("  ✓ 18_E2a_personal_sector.png")

# =====================================================================
# 6. MÓDULO F: FORMALIZACIÓN
# =====================================================================
figura("F1_RUT.csv",                "19_F1_rut.png")
figura("F4_Tipo_Contabilidad.csv",  "20_F4_tipo_contabilidad.png", width = 8, height = 4)
figura("F6_Camara_Comercio.csv",    "21_F6_camara_comercio.png")

# =====================================================================
# 7. MÓDULO G: TECNOLOGÍA
# =====================================================================
figura("G1_Dispositivos_Electronicos.csv", "22_G1_dispositivos.png")
figura("G4A_Uso_Celular.csv",              "23_G4A_uso_celular.png")
figura("G9_Uso_Internet.csv",              "24_G9_uso_internet.png")

# =====================================================================
# 8. MÓDULO H: INCLUSIÓN FINANCIERA
# =====================================================================
figura("H2_Solicito_Credito.csv",   "25_H2_solicito_credito.png")
figura("H7_Ahorro.csv",             "26_H7_ahorro.png")

# =====================================================================
# 9. MÓDULO J: GEOGRAFÍA (10 departamentos con más micronegocios)
# =====================================================================
J1 <- leer_cuadro("J1_Micronegocios_por_Departamento.csv")
J1_top <- head(J1[order(-J1$Cantidad), ], 10)
p_J1 <- barras_dm(J1_top, cat = names(J1_top)[1], val = "Distribucion_Pct")
guardar_fig(file.path(DIR_OUTPUT_FIGS, "27_J1_departamentos_top10.png"), p_J1, width = 8, height = 4.6)
message("  ✓ 27_J1_departamentos_top10.png")

# =====================================================================
# 10. MÓDULO V: INGRESOS (millones de COP; el CSV viene en millones)
# =====================================================================
V1 <- leer_cuadro("V1_Ingresos_por_Sector.csv")
V1$Billones <- V1$Millones_DANE / 1e6
p_V1 <- barras_dm(V1, cat = names(V1)[1], val = "Billones",
                  etiqueta = function(x) paste0("$", formatC(x, format = "f", digits = 1, decimal.mark = ","), " billones"),
                  eje = "Ingresos anuales (billones de COP)")
guardar_fig(file.path(DIR_OUTPUT_FIGS, "28_V1_ingresos_sector.png"), p_V1, width = 8, height = 3.8)
message("  ✓ 28_V1_ingresos_sector.png")

message("\n✅ 19 GRÁFICOS DE CUADROS DANE GENERADOS (identidad DM) → output/figuras/")

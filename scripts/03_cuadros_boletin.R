# =====================================================================
# PROYECTO: EMICRON 2024
# SCRIPT 03: Generación de Cuadros Estadísticos (Consolidado)
# =====================================================================
# Este script consolida la generación de tabulados de:
# 1. Distribución y Cantidades (Metodología DANE)
# 2. Ingresos Nominales y Comparativa Metodológica
# 3. Personal Ocupado y Caracterización Laboral
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. CARGA DE DATOS
# =====================================================================
ruta_base <- file.path(DIR_DATA_PROCESSED, "base_analitica.rds")
if (!file.exists(ruta_base)) stop("Error: Debe ejecutar 01_consolidar.R y 02_limpiar.R primero.")
base <- readRDS(ruta_base)
setDT(base)

# Directorio de salida
dir_boletin <- file.path(DIR_OUTPUT_TABS, "boletin")
if (!dir.exists(dir_boletin)) dir.create(dir_boletin, recursive = TRUE)

# =====================================================================
# 2. FUNCIONES AUXILIARES DE CÁLCULO
# =====================================================================

# 2.1 Distribución y Cantidad
calc_dist <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)
  res <- dt[!is.na(get(variable)), .(
    Cantidad = sum(F_EXP, na.rm = TRUE)
  ), by = variable]
  res[, Distribucion_Pct := round((Cantidad / sum(Cantidad)) * 100, 2)]
  setorderv(res, variable)
  return(res)
}

# 2.2 Ingresos Nominales Comparativos (Millones COP)
calc_ingresos_comp <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)
  
  # Asegurar cálculo de ingresos
  if (!"Ingresos_Anuales_DANE" %in% names(dt)) {
    dt[, Ingresos_Anuales_DANE := fifelse(is.na(VENTAS_MES_ANTERIOR), 0, VENTAS_MES_ANTERIOR) * 12 * F_EXP]
  }
  
  res <- dt[!is.na(get(variable)), .(
    Millones_DANE = sum(Ingresos_Anuales_DANE, na.rm = TRUE) / 1e6
  ), by = variable]
  
  res[, Distribucion_Ingresos := round((Millones_DANE / sum(Millones_DANE)) * 100, 2)]
  res[, Millones_DANE := formatC(Millones_DANE, format="f", big.mark=".", decimal.mark=",", digits=1)]
  setorderv(res, variable)
  return(res)
}

# =====================================================================
# 3. GENERACIÓN DE CUADROS
# =====================================================================
message("\n=== GENERANDO TABULADOS ESTADÍSTICOS CONSOLIDADOS ===")
cuadros <- list()

# --- GRUPO A: Demografía y Empleo ---
cuadros[["A1_Situacion_Empleo"]] <- calc_dist(base, "P3033_DESC")
cuadros[["A2_Sexo_Propietario"]] <- calc_dist(base, "P35_DESC")

# --- GRUPO B: Actividad Económica ---
cuadros[["B1_Sector_4G"]]  <- calc_dist(base, "GRUPOS4_DESC")
cuadros[["B2_Sector_12G"]] <- calc_dist(base, "GRUPOS12_DESC")

# --- GRUPO C: Emprendimiento ---
cuadros[["C1_Motivo_Creacion"]]    <- calc_dist(base, "P3051_DESC")
cuadros[["C2_Fuente_Financiacion"]] <- calc_dist(base, "P3052_DESC")
cuadros[["C3_Tiempo_Funcionamiento"]] <- calc_dist(base, "P639_DESC")

# --- GRUPO D: Ubicación y Sitio ---
cuadros[["D1_Tipo_Ubicacion"]] <- calc_dist(base, "P3053_DESC")
cuadros[["D2_Paga_Arriendo"]]  <- calc_dist(base, "P469_DESC")

# --- GRUPO E: Personal Ocupado ---
# Cálculo de rango de personal
if (!"personal_total" %in% colnames(base)) {
  base[, personal_total := fifelse(is.na(n_total_personal_ocu), 0, n_total_personal_ocu) + 1]
}
base[, Rango_Personal := fcase(
  personal_total == 1, "1 persona",
  personal_total >= 2 & personal_total <= 3, "2 a 3 personas",
  personal_total >= 4 & personal_total <= 5, "4 a 5 personas",
  default = "6 o más"
)]
cuadros[["E1_Rango_Personal"]] <- calc_dist(base, "Rango_Personal")

# --- GRUPO F: Formalización ---
cuadros[["F1_Tiene_RUT"]]      <- calc_dist(base, "P1633_DESC")
cuadros[["F2_Tiene_Camara"]]   <- calc_dist(base, "P1055_DESC")
cuadros[["F3_Contabilidad"]]   <- calc_dist(base, "P640_DESC")
cuadros[["F4_Seguridad_Social"]] <- calc_dist(base, "P3088_DESC")

# --- GRUPO G: Tecnología (TIC) ---
cuadros[["G1_Usa_Internet"]]   <- calc_dist(base, "P2524_DESC")
cuadros[["G2_Internet_Local"]] <- calc_dist(base, "P1093_DESC")
cuadros[["G3_Redes_Sociales"]] <- calc_dist(base, "P1559_DESC")
cuadros[["G4_Celular_Negocio"]] <- calc_dist(base, "P976_DESC")

# --- GRUPO H: Inclusión Financiera ---
cuadros[["H1_Solicito_Credito"]] <- calc_dist(base, "P1765_DESC")
cuadros[["H2_Tiene_Ahorros"]]    <- calc_dist(base, "P3014_DESC")

# --- GRUPO J: Geografía (Departamentos) ---
cuadros[["J1_Micronegocios_por_Departamento"]] <- calc_dist(base, "COD_DEPTO_DESC")

# --- GRUPO V: Ingresos (Valor Nominal) ---
cuadros[["V1_Ingresos_por_Sector"]] <- calc_ingresos_comp(base, "GRUPOS4_DESC")
cuadros[["V2_Ingresos_por_Sexo"]]   <- calc_ingresos_comp(base, "P35_DESC")

# =====================================================================
# 3.5 NUEVOS CUADROS: INDICADORES MULTIDIMENSIONALES POR GRUPO
# =====================================================================
message("\n=== GENERANDO CUADROS MULTIDIMENSIONALES ADICIONALES ===")

# 3.5.1 INGRESOS DETALLADOS POR SECTOR (Promedio, Mediana, Mínimo, Máximo)
calc_ingresos_detallado <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)

  # Asegurar cálculo de ingresos
  if (!"Ingresos_Mensuales_DANE" %in% names(dt)) {
    dt[, Ingresos_Mensuales_DANE := fifelse(is.na(VENTAS_MES_ANTERIOR), 0, VENTAS_MES_ANTERIOR)]
  }

  res <- dt[!is.na(get(variable)), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Ingresos_Promedio = weighted.mean(Ingresos_Mensuales_DANE, F_EXP, na.rm = TRUE),
    Ingresos_Total_Mensual = sum(Ingresos_Mensuales_DANE * F_EXP, na.rm = TRUE),
    Ingresos_Total_Anual = sum(Ingresos_Mensuales_DANE * F_EXP * 12, na.rm = TRUE)
  ), by = variable]

  res[, Ingresos_Promedio := round(Ingresos_Promedio, 2)]
  res[, Ingresos_Total_Mensual := round(Ingresos_Total_Mensual, 0)]
  res[, Ingresos_Total_Anual := round(Ingresos_Total_Anual, 0)]

  return(res)
}

cuadros[["V3_Ingresos_Detallado_Sector"]] <- calc_ingresos_detallado(base, "GRUPOS4_DESC")
cuadros[["V4_Ingresos_Detallado_Sexo"]]   <- calc_ingresos_detallado(base, "P35_DESC")
cuadros[["V5_Ingresos_Detallado_Antigüedad"]] <- calc_ingresos_detallado(base, "P639_DESC")

# 3.5.2 PERSONAL OCUPADO PROMEDIO POR SECTOR
calc_personal <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)

  res <- dt[!is.na(get(variable)), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Personal_Promedio = weighted.mean(n_total_personal_ocu, F_EXP, na.rm = TRUE),
    Personal_Total_Expandido = sum(n_total_personal_ocu * F_EXP, na.rm = TRUE),
    Trab_Remunerados_Promedio = weighted.mean(n_trab_remunerados, F_EXP, na.rm = TRUE)
  ), by = variable]

  res[, Personal_Promedio := round(Personal_Promedio, 2)]
  res[, Trab_Remunerados_Promedio := round(Trab_Remunerados_Promedio, 2)]

  return(res)
}

cuadros[["E2_Personal_Promedio_Sector"]] <- calc_personal(base, "GRUPOS4_DESC")
cuadros[["E3_Personal_Promedio_Sexo"]]   <- calc_personal(base, "P35_DESC")

# 3.5.3 INDICADORES AGREGADOS POR DEPARTAMENTO (Multidimensional)
calc_dpto_multidim <- function(dt) {
  res <- dt[, .(
    Cantidad_Negocios = sum(F_EXP, na.rm = TRUE),
    Pct_Distribucion = round(sum(F_EXP, na.rm = TRUE) / dt[, sum(F_EXP, na.rm = TRUE)] * 100, 2),
    Ingresos_Promedio = round(weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm = TRUE), 2),
    Personal_Promedio = round(weighted.mean(n_total_personal_ocu, F_EXP, na.rm = TRUE), 2),
    Idx_Formalizacion_Prom = round(weighted.mean(idx_formalizacion, F_EXP, na.rm = TRUE), 2),
    Idx_Digital_Prom = round(weighted.mean(idx_digital, F_EXP, na.rm = TRUE), 2),
    Pct_Con_RUT = round(sum(P1633 == 1, na.rm = TRUE) * 100 / sum(!is.na(P1633)), 2),
    Pct_Con_Internet = round(sum(P2524 == 1, na.rm = TRUE) * 100 / sum(!is.na(P2524)), 2)
  ), by = "COD_DEPTO_DESC"]

  setorderv(res, "Cantidad_Negocios", order = -1)
  return(res)
}

cuadros[["K1_Indicadores_por_Departamento"]] <- calc_dpto_multidim(base)

# 3.5.4 TABLAS CRUZADAS: SEXO x SECTOR
calc_cruzada_sexo_sector <- function(dt) {
  res <- dt[!is.na(P35_DESC) & !is.na(GRUPOS4_DESC), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Ingresos_Promedio = round(weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm = TRUE), 2)
  ), by = c("P35_DESC", "GRUPOS4_DESC")]

  return(res)
}

cuadros[["X1_Cruzada_Sexo_Sector"]] <- calc_cruzada_sexo_sector(base)

# 3.5.5 TABLAS CRUZADAS: ANTIGÜEDAD x FORMALIZACIÓN
calc_cruzada_antig_formal <- function(dt) {
  res <- dt[!is.na(P639_DESC) & !is.na(idx_formalizacion), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Pct = round(sum(F_EXP, na.rm = TRUE) / dt[, sum(F_EXP, na.rm = TRUE)] * 100, 2)
  ), by = c("P639_DESC", "idx_formalizacion")]

  setorderv(res, c("P639_DESC", "idx_formalizacion"))
  return(res)
}

cuadros[["X2_Cruzada_Antigüedad_Formalización"]] <- calc_cruzada_antig_formal(base)

# 3.5.6 FORMAS DE PAGO: Distribución
calc_formas_pago <- function(dt) {
  res_list <- list()

  vars_pago <- c("P1764_1_DESC", "P1764_2_DESC", "P1764_3_DESC",
                 "P1764_4_DESC", "P1764_5_DESC", "P1764_6_DESC")

  for (v in vars_pago) {
    if (v %in% colnames(dt)) {
      temp <- dt[get(v) == "Sí", .(
        Forma_Pago = gsub("_DESC", "", v),
        Cantidad = sum(F_EXP, na.rm = TRUE),
        Pct = round(sum(F_EXP, na.rm = TRUE) / dt[, sum(F_EXP, na.rm = TRUE)] * 100, 2)
      )]
      res_list[[v]] <- temp
    }
  }

  if (length(res_list) > 0) {
    return(rbindlist(res_list, fill = TRUE))
  }
  return(NULL)
}

cuadros[["H3_Formas_Pago"]] <- calc_formas_pago(base)

# 3.5.7 RESUMEN POR GRUPOS12 (Desglose más fino de actividad económica)
cuadros[["B3_Sector_12G_Detallado"]] <- base[!is.na(GRUPOS12_DESC), .(
  Cantidad = sum(F_EXP, na.rm = TRUE),
  Distribucion_Pct = round(sum(F_EXP, na.rm = TRUE) / sum(base[, F_EXP], na.rm = TRUE) * 100, 2),
  Ingresos_Promedio = round(weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm = TRUE), 2),
  Personal_Promedio = round(weighted.mean(n_total_personal_ocu, F_EXP, na.rm = TRUE), 2)
), by = "GRUPOS12_DESC"][order(-Cantidad)]

# =====================================================================
# 4. GUARDADO Y EXPORTACIÓN
# =====================================================================
for (n in names(cuadros)) {
  if (!is.null(cuadros[[n]])) {
    write.csv(cuadros[[n]], file.path(dir_boletin, paste0(n, ".csv")),
              row.names = FALSE, fileEncoding = "UTF-8")
    message(sprintf("  ✓ %s: %d filas", n, nrow(cuadros[[n]])))
  }
}

message(sprintf("\n✓ Se han generado %d tabulados en: %s", length(cuadros), dir_boletin))

# Resumen rápido
cat("\n--- TABLA DE CONTROL: CANTIDAD TOTAL DE MICRONEGOCIOS (EXPANDIDO) ---\n")
total <- base[, .(Total_Negocios = sum(F_EXP, na.rm = TRUE))]
print(total)

cat("\n--- RESUMEN DE CUADROS GENERADOS ---\n")
cat("✓ Cuadros de distribución: A, B, C, D, E, F, G, H, J\n")
cat("✓ Cuadros de ingresos: V1-V5\n")
cat("✓ Cuadros de personal: E2-E3\n")
cat("✓ Cuadros multidimensionales: K1 (Departamentos)\n")
cat("✓ Tablas cruzadas: X1-X2\n")
cat("✓ Formas de pago: H3\n")
cat("✓ Desglose 12 grupos: B3\n")

message("\n✅ PROCESO DE TABULADOS COMPLETADO (Versión Mejorada)")

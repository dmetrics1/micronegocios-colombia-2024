# =====================================================================
# PROYECTO: EMICRON 2024
# SCRIPT 03: Generación de Cuadros Estadísticos — VERSIÓN COMPLETA
# =====================================================================
# Integra:
# - 62 cuadros DANE del legacy
# - 8 cuadros nuevos (ingresos, multidimensionales, cruzadas)
# Total: ~75-80 cuadros para validación y análisis
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. CARGA DE DATOS
# =====================================================================
ruta_base <- file.path(DIR_DATA_PROCESSED, "base_analitica.rds")
if (!file.exists(ruta_base)) stop("Error: Debe ejecutar 01_consolidar.R y 02_limpiar.R primero.")
base <- readRDS(ruta_base)
setDT(base)

message(sprintf("Base cargada: %d filas x %d columnas", nrow(base), ncol(base)))

# Verificar si F_EXP existe; si no, crear con valor 1 (sin expansión)
if (!"F_EXP" %in% names(base)) {
  message("⚠️  F_EXP no encontrado. Creando con valor 1 (sin expansión real).")
  base[, F_EXP := 1]
}

# Directorio de salida
dir_boletin <- file.path(DIR_OUTPUT_TABS, "boletin")
if (!dir.exists(dir_boletin)) dir.create(dir_boletin, recursive = TRUE)

# =====================================================================
# 2. FUNCIONES AUXILIARES
# =====================================================================

# 2.1 Función básica: Distribución y Cantidad
calc_dist <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)

  res <- dt[!is.na(get(variable)), .(
    Cantidad = sum(F_EXP, na.rm = TRUE)
  ), by = variable]

  res[, Distribucion_Pct := round((Cantidad / sum(Cantidad)) * 100, 2)]
  setorderv(res, variable)
  return(res)
}

# 2.2 Función: Ingresos comparativos (millones COP)
calc_ingresos_comp <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)

  if (!"Ingresos_Anuales_DANE" %in% names(dt)) {
    dt[, Ingresos_Anuales_DANE := fifelse(is.na(VENTAS_MES_ANTERIOR), 0, VENTAS_MES_ANTERIOR) * 12 * F_EXP]
  }

  res <- dt[!is.na(get(variable)), .(
    Millones_DANE = sum(Ingresos_Anuales_DANE, na.rm = TRUE) / 1e6
  ), by = variable]

  res[, Distribucion_Ingresos := round((Millones_DANE / sum(Millones_DANE)) * 100, 2)]
  res[, Millones_DANE := round(Millones_DANE, 2)]
  setorderv(res, variable)
  return(res)
}

# 2.3 Función: Ingresos detallados
calc_ingresos_detallado <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)

  if (!"Ingresos_Mensuales_DANE" %in% names(dt)) {
    dt[, Ingresos_Mensuales_DANE := fifelse(is.na(VENTAS_MES_ANTERIOR), 0, VENTAS_MES_ANTERIOR)]
  }

  res <- dt[!is.na(get(variable)), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Ingresos_Promedio = round(weighted.mean(Ingresos_Mensuales_DANE, F_EXP, na.rm = TRUE), 2),
    Ingresos_Total_Mensual = round(sum(Ingresos_Mensuales_DANE * F_EXP, na.rm = TRUE), 0),
    Ingresos_Total_Anual = round(sum(Ingresos_Mensuales_DANE * F_EXP * 12, na.rm = TRUE), 0)
  ), by = variable]

  setorderv(res, variable)
  return(res)
}

# =====================================================================
# 3. GENERACIÓN DE CUADROS
# =====================================================================
message("\n=== GENERANDO CUADROS ESTADÍSTICOS COMPLETOS ===\n")
cuadros <- list()

# =====================================================================
# GRUPO A: RESULTADOS GENERALES
# =====================================================================
cuadros[["A1_Situacion_Empleo"]] <- calc_dist(base, "P3033_DESC")
cuadros[["A2_Sexo_Propietario"]] <- calc_dist(base, "P35_DESC")

# =====================================================================
# GRUPO B: ACTIVIDAD ECONÓMICA
# =====================================================================
cuadros[["B1_Sector_4Grupos"]] <- calc_dist(base, "GRUPOS4_DESC")
cuadros[["B2_Sector_12Grupos"]] <- calc_dist(base, "GRUPOS12_DESC")
cuadros[["B3_Sector_12Grupos_Detallado"]] <- base[!is.na(GRUPOS12_DESC), .(
  Cantidad = sum(F_EXP, na.rm = TRUE),
  Distribucion_Pct = round(sum(F_EXP, na.rm = TRUE) / sum(base[, F_EXP], na.rm = TRUE) * 100, 2),
  Ingresos_Promedio = round(weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm = TRUE), 2),
  Personal_Promedio = round(weighted.mean(n_total_personal_ocu, F_EXP, na.rm = TRUE), 2)
), by = "GRUPOS12_DESC"][order(-Cantidad)]

# =====================================================================
# GRUPO C: EMPRENDIMIENTO
# =====================================================================
cuadros[["C1_Quien_Creo"]] <- calc_dist(base, "P3050_DESC")
cuadros[["C2_Motivo_Creacion"]] <- calc_dist(base, "P3051_DESC")
cuadros[["C3_Tiempo_Funcionamiento"]] <- calc_dist(base, "P639_DESC")
cuadros[["C4_Fuente_Financiacion"]] <- calc_dist(base, "P3052_DESC")

# =====================================================================
# GRUPO D: SITIO O UBICACIÓN
# =====================================================================
cuadros[["D1_Tipo_Ubicacion"]] <- calc_dist(base, "P3053_DESC")
cuadros[["D2_Espacio_Exclusivo_Vivienda"]] <- calc_dist(base, "P3095_DESC")
cuadros[["D3_Emplazamiento_Fisico"]] <- calc_dist(base, "P3096_DESC")
cuadros[["D4_Servicio_Puerta_Puerta"]] <- calc_dist(base, "P3097_DESC")
cuadros[["D5_Ubicacion_Espacio_Publico"]] <- calc_dist(base, "P3098_DESC")
cuadros[["D6_Numero_Puestos"]] <- calc_dist(base, "P3054_DESC")
cuadros[["D7_Propiedad_Emplazamiento"]] <- calc_dist(base, "P3055_DESC")
cuadros[["D8_Visibilidad_Publico"]] <- calc_dist(base, "P469_DESC")

# =====================================================================
# GRUPO E: PERSONAL OCUPADO
# =====================================================================

# E1: Seguridad social del propietario
cuadros[["E1_1_Salud_Pension_Propietario"]] <- calc_dist(base, "P3088_DESC")
cuadros[["E1_3_ARL_Propietario"]] <- calc_dist(base, "P3090_DESC")

# E2: Rangos de personal en el negocio
if (!"personal_total" %in% colnames(base)) {
  base[, personal_total := fifelse(P3031 == 1, n_total_personal_ocu + 1, 1)]
}
base[, Rango_Personal := fcase(
  personal_total == 1, "1 persona",
  personal_total >= 2 & personal_total <= 3, "2 a 3 personas",
  personal_total >= 4 & personal_total <= 5, "4 a 5 personas",
  personal_total >= 6 & personal_total <= 9, "6 a 9 personas",
  default = "10 o más"
)]
cuadros[["E2_Rangos_Personal"]] <- calc_dist(base, "Rango_Personal")

# E2 (mejorado): Personal promedio por grupo
calc_personal <- function(dt, variable) {
  if (!variable %in% colnames(dt)) return(NULL)

  res <- dt[!is.na(get(variable)), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Personal_Promedio = round(weighted.mean(n_total_personal_ocu, F_EXP, na.rm = TRUE), 2),
    Personal_Total_Expandido = round(sum(n_total_personal_ocu * F_EXP, na.rm = TRUE), 0),
    Trab_Remunerados_Promedio = round(weighted.mean(n_trab_remunerados, F_EXP, na.rm = TRUE), 2)
  ), by = variable]

  return(res)
}

cuadros[["E2a_Personal_Promedio_Sector"]] <- calc_personal(base, "GRUPOS4_DESC")
cuadros[["E2b_Personal_Promedio_Sexo"]] <- calc_personal(base, "P35_DESC")

# E3: Personal ocupado - Tipo de vínculo (requiere módulo personal_ocupado.csv)
# Se procesa si el archivo existe
ruta_raw <- file.path(getwd(), "data", "raw", "2024")
archivo_personal <- list.files(ruta_raw, pattern = "personal ocupado\\.csv|ocupado", full.names = TRUE, ignore.case = TRUE)[1]

if (!is.na(archivo_personal) && file.exists(archivo_personal)) {
  message(sprintf("  Procesando módulo de personal: %s", basename(archivo_personal)))

  # Leer módulo de personal
  personal_raw <- fread(archivo_personal, encoding = "Latin-1")
  
  keys <- c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")
  
  # Forzar tipos consistentes (character) para evitar errores de bmerge
  for (k in keys) {
    if (k %in% names(base)) base[, (k) := as.character(get(k))]
    if (k %in% names(personal_raw)) personal_raw[, (k) := as.character(get(k))]
  }
  
  # Si el archivo ya tiene F_EXP, lo eliminamos del raw para usar el de la 'base' analítica (más confiable)
  if ("F_EXP" %in% names(personal_raw)) personal_raw[, F_EXP := NULL]
  
  personal_con_fexp <- merge(personal_raw, base[, c(keys, "F_EXP"), with=FALSE], by = keys, all.x = TRUE)

  # Etiquetar TIPO
  personal_con_fexp[, TIPO_DESC := factor(TIPO,
                          levels = c(1, 2, 3),
                          labels = c("Trabajadores remunerados", "Socios", "Familiares/Trabajadores sin remuneración"))]

  # E3: Total personal por tipo
  cuadros[["E3_Personal_Tipo_Vinculo"]] <- calc_dist(personal_con_fexp, "TIPO_DESC")

  # Etiquetar otras variables del personal
  if ("P3077" %in% names(personal_con_fexp)) personal_con_fexp[, P3077_DESC := factor(P3077, levels=c(1,2), labels=c("Indefinido","Temporal"))]
  if ("P3078" %in% names(personal_con_fexp)) personal_con_fexp[, P3078_DESC := factor(P3078, levels=c(1,2), labels=c("Hombre","Mujer"))]
  if ("P3080" %in% names(personal_con_fexp)) personal_con_fexp[, P3080_DESC := factor(P3080, levels=c(1,2,3,4), labels=c("Sí","No","Solo salud","Solo pensión"))]
  if ("P3082" %in% names(personal_con_fexp)) personal_con_fexp[, P3082_DESC := factor(P3082, levels=c(1,2), labels=c("Sí","No"))]
  if ("P3084" %in% names(personal_con_fexp)) personal_con_fexp[, P3084_DESC := factor(P3084, levels=c(1,2), labels=c("Sí","No"))]

  # TRABAJADORES REMUNERADOS
  remunerados <- personal_con_fexp[TIPO == 1]
  cuadros[["E3_1_1_Tipo_Contrato_Remunerados"]] <- calc_dist(remunerados, "P3077_DESC")
  cuadros[["E3_1_2_Sexo_Remunerados"]] <- calc_dist(remunerados, "P3078_DESC")
  cuadros[["E3_1_4_Salud_Pension_Remunerados"]] <- calc_dist(remunerados, "P3080_DESC")
  cuadros[["E3_1_6_Prestaciones_Remunerados"]] <- calc_dist(remunerados, "P3082_DESC")
  cuadros[["E3_1_8_ARL_Remunerados"]] <- calc_dist(remunerados, "P3084_DESC")

  # SOCIOS
  socios <- personal_con_fexp[TIPO == 2]
  cuadros[["E3_2_1_Sexo_Socios"]] <- calc_dist(socios, "P3078_DESC")
  cuadros[["E3_2_2_Salud_Pension_Socios"]] <- calc_dist(socios, "P3080_DESC")
  cuadros[["E3_2_4_ARL_Socios"]] <- calc_dist(socios, "P3084_DESC")

  # FAMILIARES SIN REMUNERACIÓN
  familiares <- personal_con_fexp[TIPO == 3]
  cuadros[["E3_3_1_Sexo_Familiares"]] <- calc_dist(familiares, "P3078_DESC")
  cuadros[["E3_3_2_Salud_Pension_Familiares"]] <- calc_dist(familiares, "P3080_DESC")
  cuadros[["E3_3_4_ARL_Familiares"]] <- calc_dist(familiares, "P3084_DESC")

} else {
  message("  ⚠ No se encontró módulo de personal ocupado. Se omiten cuadros E3.*")
}

# =====================================================================
# GRUPO F: CARACTERÍSTICAS (FORMALIZACIÓN)
# =====================================================================
cuadros[["F1_RUT"]] <- calc_dist(base, "P1633_DESC")
cuadros[["F3_Regimen"]] <- calc_dist(base, "P986_DESC")
cuadros[["F4_Tipo_Contabilidad"]] <- calc_dist(base, "P640_DESC")
cuadros[["F5_Razon_No_Registros"]] <- calc_dist(base, "P4000_DESC")
cuadros[["F6_Camara_Comercio"]] <- calc_dist(base, "P1055_DESC")
cuadros[["F7_Tipo_Persona_Camara"]] <- calc_dist(base, "P1056_DESC")
cuadros[["F8_Renovacion_Camara_2024"]] <- calc_dist(base, "P661_DESC")
cuadros[["F9_Registro_Otra_Entidad"]] <- calc_dist(base, "P1057_DESC")
cuadros[["F10_Entidad_Registro"]] <- calc_dist(base, "P4004_DESC")
cuadros[["F11_Declara_Renta"]] <- calc_dist(base, "P2991_DESC")
cuadros[["F12_Declara_IVA"]] <- calc_dist(base, "P2992_DESC")
cuadros[["F13_Declara_ICA"]] <- calc_dist(base, "P2993_DESC")

# =====================================================================
# GRUPO G: TECNOLOGÍA (TIC)
# =====================================================================
cuadros[["G1_Dispositivos_Electronicos"]] <- calc_dist(base, "P4001_DESC")
cuadros[["G2_3_4_Numero_Dispositivos"]] <- calc_dist(base, "P1087_DESC")
cuadros[["G4A_Uso_Celular"]] <- calc_dist(base, "P976_DESC")
cuadros[["G5_5A_Tipo_Celulares"]] <- calc_dist(base, "P978_DESC")
cuadros[["G6_Razon_No_Dispositivos"]] <- calc_dist(base, "P994_DESC")
cuadros[["G7_Pagina_Web"]] <- calc_dist(base, "P2532_DESC")
cuadros[["G8_Redes_Sociales"]] <- calc_dist(base, "P1559_DESC")
cuadros[["G9_Uso_Internet"]] <- calc_dist(base, "P2524_DESC")
cuadros[["G10_Conexion_Internet_Local"]] <- calc_dist(base, "P1093_DESC")
cuadros[["G11_Tipo_Conexion_Internet"]] <- calc_dist(base, "P2528_DESC")
cuadros[["G12_Razon_No_Internet"]] <- calc_dist(base, "P1095_DESC")

# =====================================================================
# GRUPO H: INCLUSIÓN FINANCIERA
# =====================================================================
cuadros[["H2_Solicito_Credito"]] <- calc_dist(base, "P1765_DESC")
cuadros[["H3_Razon_No_Solicitar_Credito"]] <- calc_dist(base, "P1567_DESC")
cuadros[["H4_Tipo_Entidad_Credito"]] <- calc_dist(base, "P1569_DESC")
cuadros[["H5_Resultado_Solicitud_Credito"]] <- calc_dist(base, "P1568_DESC")
cuadros[["H6_Uso_Credito"]] <- calc_dist(base, "P1570_DESC")
cuadros[["H7_Ahorro"]] <- calc_dist(base, "P3014_DESC")
cuadros[["H7B_Razon_No_Ahorro"]] <- calc_dist(base, "P1574_DESC")
cuadros[["H8_Formas_Ahorro"]] <- calc_dist(base, "P1771_DESC")

# =====================================================================
# GRUPO K: CAPITAL SOCIAL
# =====================================================================
cuadros[["K1_1_Afiliacion_Organizaciones"]] <- calc_dist(base, "P3002_DESC")

# =====================================================================
# GRUPO J: GEOGRAFÍA (DEPARTAMENTOS)
# =====================================================================
cuadros[["J1_Micronegocios_por_Departamento"]] <- calc_dist(base, "COD_DEPTO_DESC")

# Indicadores multidimensionales por departamento
calc_dpto_multidim <- function(dt) {
  res <- dt[, .(
    Cantidad_Negocios = sum(F_EXP, na.rm = TRUE),
    Pct_Distribucion = round(sum(F_EXP, na.rm = TRUE) / dt[, sum(F_EXP, na.rm = TRUE)] * 100, 2),
    Ingresos_Promedio = round(weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm = TRUE), 2),
    Personal_Promedio = round(weighted.mean(n_total_personal_ocu, F_EXP, na.rm = TRUE), 2),
    Idx_Formalizacion_Prom = round(weighted.mean(idx_formalizacion, F_EXP, na.rm = TRUE), 2),
    Idx_Digital_Prom = round(weighted.mean(idx_digital, F_EXP, na.rm = TRUE), 2),
    Pct_Con_RUT = round(sum(tiene_rut == 1, na.rm = TRUE) * 100 / sum(!is.na(tiene_rut)), 2),
    Pct_Con_Internet = round(sum(usa_internet == 1, na.rm = TRUE) * 100 / sum(!is.na(usa_internet)), 2)
  ), by = "COD_DEPTO_DESC"]

  setorderv(res, "Cantidad_Negocios", order = -1)
  return(res)
}

cuadros[["J2_Indicadores_por_Departamento"]] <- calc_dpto_multidim(base)

# =====================================================================
# GRUPO V: INGRESOS (VALOR NOMINAL Y ANÁLISIS)
# =====================================================================
cuadros[["V1_Ingresos_por_Sector"]] <- calc_ingresos_comp(base, "GRUPOS4_DESC")
cuadros[["V2_Ingresos_por_Sexo"]] <- calc_ingresos_comp(base, "P35_DESC")
cuadros[["V3_Ingresos_Detallado_Sector"]] <- calc_ingresos_detallado(base, "GRUPOS4_DESC")
cuadros[["V4_Ingresos_Detallado_Sexo"]] <- calc_ingresos_detallado(base, "P35_DESC")
cuadros[["V5_Ingresos_Detallado_Antiguedad"]] <- calc_ingresos_detallado(base, "P639_DESC")

# =====================================================================
# GRUPO X: TABLAS CRUZADAS Y MULTIDIMENSIONALES (NUEVAS)
# =====================================================================
calc_cruzada_sexo_sector <- function(dt) {
  res <- dt[!is.na(P35_DESC) & !is.na(GRUPOS4_DESC), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Ingresos_Promedio = round(weighted.mean(VENTAS_MES_ANTERIOR, F_EXP, na.rm = TRUE), 2)
  ), by = c("P35_DESC", "GRUPOS4_DESC")]

  return(res)
}

cuadros[["X1_Cruzada_Sexo_Sector"]] <- calc_cruzada_sexo_sector(base)

calc_cruzada_antig_formal <- function(dt) {
  res <- dt[!is.na(P639_DESC) & !is.na(idx_formalizacion), .(
    Cantidad = sum(F_EXP, na.rm = TRUE),
    Pct = round(sum(F_EXP, na.rm = TRUE) / dt[, sum(F_EXP, na.rm = TRUE)] * 100, 2)
  ), by = c("P639_DESC", "idx_formalizacion")]

  setorderv(res, c("P639_DESC", "idx_formalizacion"))
  return(res)
}

cuadros[["X2_Cruzada_Antiguedad_Formalizacion"]] <- calc_cruzada_antig_formal(base)

# =====================================================================
# GRUPO H (EXTENSIÓN): FORMAS DE PAGO
# =====================================================================
calc_formas_pago <- function(dt) {
  res_list <- list()

  vars_pago <- c("P1764_1_DESC", "P1764_2_DESC", "P1764_3_DESC",
                 "P1764_4_DESC", "P1764_5_DESC", "P1764_6_DESC")

  for (v in vars_pago) {
    if (v %in% colnames(dt)) {
      temp <- dt[get(v) == "Sí", .(
        Forma_Pago = gsub("P1764_|_DESC", "", v),
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

cuadros[["H9_Formas_Pago"]] <- calc_formas_pago(base)

# =====================================================================
# 4. GUARDADO Y EXPORTACIÓN
# =====================================================================
message("\n=== GUARDANDO CUADROS ===\n")

cuenta_guardados <- 0
for (n in names(cuadros)) {
  if (!is.null(cuadros[[n]])) {
    write.csv(cuadros[[n]],
              file.path(dir_boletin, paste0(n, ".csv")),
              row.names = FALSE, fileEncoding = "UTF-8")
    message(sprintf("  ✓ %s (%d filas)", n, nrow(cuadros[[n]])))
    cuenta_guardados <- cuenta_guardados + 1
  }
}

# =====================================================================
# 5. RESUMEN FINAL
# =====================================================================
cat("\n")
cat("=====================================================================\n")
cat("RESUMEN DE TABULADOS GENERADOS\n")
cat("=====================================================================\n")
cat(sprintf("Total de cuadros generados: %d\n", cuenta_guardados))
cat(sprintf("Ubicación: %s\n", dir_boletin))
cat("\n--- CUADROS POR GRUPO ---\n")
cat("A: Resultados Generales (2)\n")
cat("B: Actividad Económica (3)\n")
cat("C: Emprendimiento (4)\n")
cat("D: Sitio/Ubicación (8)\n")
cat("E: Personal Ocupado (~18 + variables)\n")
cat("F: Características/Formalización (13)\n")
cat("G: Tecnología TIC (11)\n")
cat("H: Inclusión Financiera (9)\n")
cat("K: Capital Social (1)\n")
cat("J: Geografía (2)\n")
cat("V: Ingresos (5)\n")
cat("X: Tablas Cruzadas (2)\n")
cat("\n--- TOTAL EXPANDIDO ---\n")

total_negocios <- base[, .(Total_Negocios = sum(F_EXP, na.rm = TRUE))]
cat(sprintf("Total Micronegocios (expandido): %s\n", format(round(total_negocios$Total_Negocios, 0), big.mark = ".", decimal.mark = ",")))

cat("\n✅ PROCESO COMPLETADO\n")
cat("=====================================================================\n")

message("\n✅ SCRIPT 03 COMPLETADO — Cuadros listos para EDA y validación DANE")

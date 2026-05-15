library(data.table)
source(file.path("scripts", "00_config.R"))

# =====================================================================
# Función para mergear módulos de la EMICRON 
# (Excluye el módulo de personal ocupado por tener múltiples filas)
# =====================================================================
merge_emicron <- function(año, base_dir = NULL) {
  
  if (is.null(base_dir)) {
    # Ajusta esta ruta según donde descomprimas los datos
    base_dir <- file.path(getwd(), "data", "raw", año)
  }
  
  key_variables <- c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")
  
  all_files <- list.files(
    path = base_dir, 
    pattern = "*.csv", 
    full.names = TRUE, 
    ignore.case = TRUE
  )
  
  if (length(all_files) == 0) {
    stop(paste("No se encontraron CSVs en:", base_dir))
  }
  
  message(sprintf("Encontrados %d archivos para año %s", length(all_files), año))
  
  # Leer primer archivo como base
  final_df <- fread(
    file = all_files[1], 
    encoding = "Latin-1",
    colClasses = list(character = c("COD_DPTO", "COD_DEPTO", "AREA"))
  )
  message(sprintf("  Base: %s (%d filas, %d cols)", basename(all_files[1]), nrow(final_df), ncol(final_df)))
  
  # Iterar sobre los archivos restantes
  for (file in all_files[-1]) {
    df <- fread(
      file = file, 
      encoding = "Latin-1",
      colClasses = list(character = c("COD_DPTO", "COD_DEPTO", "AREA"))
    )
    
    # EXCLUIR módulo de personal ocupado (trabajadores) si tiene SECUENCIA_PH
    if ("SECUENCIA_PH" %in% colnames(df)) {
      message(sprintf("  OMITIDO (múltiples filas por micronegocio): %s", basename(file)))
      next
    }
    
    # Encontrar las claves comunes para el merge
    merge_keys <- intersect(colnames(df), key_variables)
    
    if (length(merge_keys) == 0) {
      message(sprintf("  OMITIDO (sin claves de merge): %s", basename(file)))
      next
    }
    
    # Merge
    final_df <- merge(final_df, df, by = merge_keys, all.x = TRUE)
    
    # Renombrar .x y eliminar .y
    cols_x <- grep("\\.x$", colnames(final_df), value = TRUE)
    if (length(cols_x) > 0) {
      setnames(final_df, old = cols_x, new = gsub("\\.x$", "", cols_x))
    }
    
    cols_y <- grep("\\.y$", colnames(final_df), value = TRUE)
    if (length(cols_y) > 0) {
      final_df[, (cols_y) := NULL]
    }
    
    message(sprintf("  Mergeado: %s → %d cols total", basename(file), ncol(final_df)))
  }
  
  message(sprintf("Base final: %d filas × %d columnas", nrow(final_df), ncol(final_df)))
  return(final_df)
}

# =====================================================================
# Función para agregar el módulo de personal ocupado y mergearlo
# =====================================================================
agregar_personal_ocupado <- function(base, año, base_dir = NULL) {
  
  if (is.null(base_dir)) {
    base_dir <- file.path(getwd(), "data", "raw", año)
  }
  
  # Buscar el archivo que tiene SECUENCIA_PH
  all_files <- list.files(base_dir, pattern = "*.csv", full.names = TRUE, ignore.case = TRUE)
  
  archivo_personal <- NULL
  for (file in all_files) {
    cols <- colnames(fread(file, nrows = 0))
    if ("SECUENCIA_PH" %in% cols) {
      archivo_personal <- file
      break
    }
  }
  
  if (is.null(archivo_personal)) {
    message("No se encontró módulo de personal ocupado (trabajadores). Se omite.")
    return(base)
  }
  
  message(sprintf("Agregando personal ocupado desde: %s", basename(archivo_personal)))
  
  personal <- fread(
    archivo_personal, 
    encoding = "Latin-1",
    colClasses = list(character = c("COD_DPTO", "COD_DEPTO", "AREA"))
  )
  
  keys <- c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")
  
  # Agregar a nivel de micronegocio
  personal_agg <- personal[, .(
    n_trab_remunerados    = sum(TIPO == 1, na.rm = TRUE),
    n_socios              = sum(TIPO == 2, na.rm = TRUE),
    n_fam_sin_pago        = sum(TIPO == 3, na.rm = TRUE),
    n_total_personal_ocu  = .N,
    salario_total_mes     = as.numeric(sum(ifelse(TIPO == 1, P3079, 0), na.rm = TRUE)),
    salario_promedio      = as.numeric(mean(ifelse(TIPO == 1, P3079, NA_real_), na.rm = TRUE)),
    salario_max           = as.numeric(suppressWarnings(max(ifelse(TIPO == 1, P3079, NA_real_), na.rm = TRUE))),
    n_con_salud_pension   = sum(P3080 == 1, na.rm = TRUE),
    n_sin_salud_pension   = sum(P3080 == 2, na.rm = TRUE),
    n_solo_salud          = sum(P3080 == 3, na.rm = TRUE),
    n_solo_pension        = sum(P3080 == 4, na.rm = TRUE),
    n_con_prestaciones    = sum(P3082 == 1 & TIPO == 1, na.rm = TRUE),
    n_con_arl             = sum(P3084 == 1, na.rm = TRUE),
    n_con_caja_comp       = sum(P2990 == 1, na.rm = TRUE),
    antiguedad_prom_meses = as.numeric(mean(P3085, na.rm = TRUE)),
    antiguedad_min_meses  = as.numeric(suppressWarnings(min(P3085, na.rm = TRUE))),
    antiguedad_max_meses  = as.numeric(suppressWarnings(max(P3085, na.rm = TRUE))),
    edad_promedio_trab    = as.numeric(mean(P3099, na.rm = TRUE)),
    edad_min_trab         = as.numeric(suppressWarnings(min(P3099, na.rm = TRUE))),
    edad_max_trab         = as.numeric(suppressWarnings(max(P3099, na.rm = TRUE))),
    n_hombres             = sum(P3078 == 1, na.rm = TRUE),
    n_mujeres             = sum(P3078 == 2, na.rm = TRUE),
    n_contrato_indefinido = sum(P3077 == 1 & TIPO == 1, na.rm = TRUE),
    n_contrato_temporal   = sum(P3077 == 2 & TIPO == 1, na.rm = TRUE)
  ), by = keys]
  
  # Ratios
  personal_agg[, `:=`(
    pct_con_salud_pension = fifelse(n_total_personal_ocu > 0, n_con_salud_pension / n_total_personal_ocu, 0),
    pct_con_arl           = fifelse(n_total_personal_ocu > 0, n_con_arl / n_total_personal_ocu, 0),
    pct_mujeres           = fifelse(n_total_personal_ocu > 0, n_mujeres / n_total_personal_ocu, 0),
    pct_contrato_indef    = fifelse(n_trab_remunerados > 0, n_contrato_indefinido / n_trab_remunerados, 0)
  )]
  
  # Limpiar Inf/-Inf
  cols_numeric <- names(personal_agg)[sapply(personal_agg, is.numeric)]
  for (col in cols_numeric) {
    set(personal_agg, which(is.infinite(personal_agg[[col]])), col, NA_real_)
  }
  
  # Merge con base
  resultado <- merge(base, personal_agg, by = keys, all.x = TRUE)
  
  # Rellenar NA con 0 en conteos y porcentajes
  cols_conteo <- grep("^n_", names(personal_agg), value = TRUE)
  cols_pct <- grep("^pct_", names(personal_agg), value = TRUE)
  for (col in c(cols_conteo, cols_pct)) {
    if (col %in% names(resultado)) {
      set(resultado, which(is.na(resultado[[col]])), col, 0)
    }
  }
  
  message(sprintf("  Base final con personal: %d filas × %d columnas", nrow(resultado), ncol(resultado)))
  return(resultado)
}

# =====================================================================
# EJECUCIÓN (Ejemplo para 2024)
# =====================================================================
E_2024 <- merge_emicron("2024")
E_2024 <- agregar_personal_ocupado(E_2024, "2024")

# Guardar base procesada
saveRDS(E_2024, file = file.path(DIR_DATA_PROCESSED, "emicron_2024_consolidada.rds"))

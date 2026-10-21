# =====================================================================
# SCRIPT PRINCIPAL (MAIN) - PROYECTO: EMICRON 2024
# Pipeline: Boletines DANE + EDA + Apriori + Segmentación
# =====================================================================
# Este script ejecuta secuencialmente todo el pipeline analítico:
# 1. Consolidación de módulos
# 2. Limpieza y Etiquetado DANE
# 3. Generación de Cuadros Estadísticos (Boletín)
# 4. Análisis Exploratorio (EDA) y gráficos de cuadros DANE
# 5. Minería de Reglas de Asociación (Apriori, con medidas ponderadas)
# 6. Segmentación en tres grupos estructurales
# 7. Robustez de Apriori (umbrales y factores de expansión)
#
# Requisitos: ejecutar desde la raíz del proyecto (emicron.Rproj) y
# restaurar los paquetes con renv::restore() la primera vez.
# =====================================================================

# Limpiar entorno antes de empezar (opcional pero recomendado)
rm(list = ls())

# Verificaciones previas: mensajes claros en vez de errores crípticos
# =====================================================================
if (!file.exists("scripts/00_config.R")) {
  stop("Ejecuta main.R desde la raíz del proyecto (la carpeta donde está emicron.Rproj).")
}
csv_raw <- list.files("data/raw/2024", pattern = "\\.csv$")
if (length(csv_raw) < 11) {
  stop(sprintf(paste0("Se esperaban los 11 CSV de la EMICRON 2024 en data/raw/2024/ y hay %d. ",
                      "Descárgalos de https://microdatos.dane.gov.co (ver README)."), length(csv_raw)))
}
paquetes <- c("data.table", "arules", "arulesViz", "ggplot2", "patchwork", "scales",
              "ggraph", "tidygraph", "ragg", "systemfonts")
faltan <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltan) > 0) {
  stop("Faltan paquetes: ", paste(faltan, collapse = ", "), ". Ejecuta renv::restore() primero.")
}

# Tiempo de inicio
inicio_total <- Sys.time()

cat("=====================================================================\n")
cat(" INICIANDO PIPELINE: BOLETINES + EDA + APRIORI — EMICRON 2024\n")
cat("=====================================================================\n\n")

# 1. Consolidación de Módulos
# =====================================================================
cat("[1/8] Ejecutando 01_consolidar.R...\n")
source("scripts/01_consolidar.R")

# 2. Limpieza, Feature Engineering y Etiquetado DANE
# =====================================================================
cat("\n[2/8] Ejecutando 02_limpiar.R...\n")
source("scripts/02_limpiar.R")

# 3. Cuadros Estadísticos (Réplica Boletín DANE) — VERSIÓN COMPLETA
# =====================================================================
cat("\n[3/8] Ejecutando 03_cuadros_boletin_COMPLETO.R...\n")
source("scripts/03_cuadros_boletin_COMPLETO.R") # 85 cuadros DANE

# 4. Análisis Exploratorio de Datos (EDA)
# =====================================================================
cat("\n[4/8] Ejecutando 04_eda.R...\n")
source("scripts/04_eda.R")

# 4b. Gráficos de Cuadros DANE para Reporte QMD
# =====================================================================
cat("\n[5/8] Ejecutando 04b_graficos_cuadros_dane.R...\n")
source("scripts/04b_graficos_cuadros_dane.R")

# 5. Reglas de Asociación (Apriori)
# =====================================================================
cat("\n[6/8] Ejecutando 05_apriori.R...\n")
source("scripts/05_apriori.R")

# 6. Segmentación en tres grupos
# =====================================================================
cat("\n[7/8] Ejecutando 06_segmentacion.R...\n")
source("scripts/06_segmentacion.R")

# 7. Robustez de Apriori
# =====================================================================
cat("\n[8/8] Ejecutando 07_sensibilidad_apriori.R...\n")
source("scripts/07_sensibilidad_apriori.R")

cat("\n=====================================================================\n")
cat(" ¡PIPELINE COMPLETADO CON ÉXITO!\n")
cat(" Tiempo total de ejecución:", round(difftime(Sys.time(), inicio_total, units = "mins"), 2), "minutos\n")
cat(" Los boletines se encuentran en 'output/tablas/boletin/'.\n")
cat(" Apriori, segmentación y robustez se encuentran en 'output/tablas/'.\n")
cat(" Siguiente paso: quarto render REPORTE_WIDE_PRO_2024.qmd\n")
cat("=====================================================================\n")

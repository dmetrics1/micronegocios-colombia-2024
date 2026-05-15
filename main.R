# =====================================================================
# SCRIPT PRINCIPAL (MAIN) - PROYECTO: EMICRON 2024
# Pipeline: Boletines DANE + EDA + Apriori
# =====================================================================
# Este script ejecuta secuencialmente todo el pipeline analítico:
# 1. Consolidación de módulos
# 2. Limpieza y Etiquetado DANE
# 3. Generación de Cuadros Estadísticos (Boletín)
# 4. Análisis Exploratorio (EDA)
# 5. Minería de Reglas de Asociación (Apriori)
# =====================================================================

# Limpiar entorno antes de empezar (opcional pero recomendado)
rm(list = ls())

# Tiempo de inicio
inicio_total <- Sys.time()

cat("=====================================================================\n")
cat(" INICIANDO PIPELINE: BOLETINES + EDA + APRIORI — EMICRON 2024\n")
cat("=====================================================================\n\n")

# 1. Consolidación de Módulos
# =====================================================================
cat("[1/5] Ejecutando 01_consolidar.R...\n")
source("scripts/01_consolidar.R")

# 2. Limpieza, Feature Engineering y Etiquetado DANE
# =====================================================================
cat("\n[2/5] Ejecutando 02_limpiar.R...\n")
source("scripts/02_limpiar.R")

# 3. Cuadros Estadísticos (Réplica Boletín DANE) — VERSIÓN COMPLETA
# =====================================================================
cat("\n[3/5] Ejecutando 03_cuadros_boletin_COMPLETO.R...\n")
source("scripts/03_cuadros_boletin_COMPLETO.R") # 80+ cuadros DANE

# 4. Análisis Exploratorio de Datos (EDA)
# =====================================================================
cat("\n[4/6] Ejecutando 04_eda.R...\n")
source("scripts/04_eda.R")

# 4b. Gráficos de Cuadros DANE para Reporte QMD
# =====================================================================
cat("\n[4b/6] Ejecutando 04b_graficos_cuadros_dane.R...\n")
source("scripts/04b_graficos_cuadros_dane.R")

# 5. Reglas de Asociación (Apriori)
# =====================================================================
cat("\n[5/6] Ejecutando 05_apriori.R...\n")
source("scripts/05_apriori.R")

cat("\n=====================================================================\n")
cat(" ¡PIPELINE COMPLETADO CON ÉXITO!\n")
cat(" Tiempo total de ejecución:", round(difftime(Sys.time(), inicio_total, units = "mins"), 2), "minutos\n")
cat(" Los boletines se encuentran en 'output/tablas/boletin/'.\n")
cat(" Los resultados de Apriori se encuentran en 'output/tablas/'.\n")
cat("=====================================================================\n")

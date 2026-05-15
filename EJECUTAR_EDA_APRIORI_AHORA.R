# =====================================================================
# SCRIPT RÁPIDO: EDA + APRIORI (Sin esperar a script 03 COMPLETO)
# =====================================================================
# Ejecuta solo los scripts 04 (EDA) y 05 (Apriori)
# Usa las ~30 variables categóricas para encontrar patrones
# =====================================================================

# Configurar directorio de trabajo (Opcional si usas RProject)
# setwd(".") # El directorio base es la carpeta del proyecto

cat("=====================================================================\n")
cat(" EJECUCIÓN RÁPIDA: EDA + APRIORI — EMICRON 2024\n")
cat(" (~30 variables categóricas para análisis de patrones)\n")
cat("=====================================================================\n\n")

# VERIFICAR QUE base_analitica.rds EXISTE
ruta_base <- "data/processed/base_analitica.rds"
if (!file.exists(ruta_base)) {
  stop("ERROR: Debes ejecutar primero:\n  source('scripts/01_consolidar.R')\n  source('scripts/02_limpiar.R')")
}

cat("[✓] Base analítica lista:", ruta_base, "\n\n")

# =====================================================================
# 1. EJECUTAR EDA (Script 04)
# =====================================================================
cat("[1/2] Ejecutando 04_eda.R (Gráficos exploratorios)...\n\n")
source("scripts/04_eda.R")

# =====================================================================
# 2. EJECUTAR APRIORI (Script 05)
# =====================================================================
cat("\n[2/2] Ejecutando 05_apriori.R (Reglas de asociación)...\n\n")
source("scripts/05_apriori.R")

# =====================================================================
# FIN
# =====================================================================
cat("\n")
cat("=====================================================================\n")
cat(" ✅ EJECUCIÓN COMPLETADA\n")
cat("=====================================================================\n")
cat("\n📊 RESULTADOS GENERADOS:\n\n")
cat("  EDA (Gráficos):\n")
cat("    - output/figuras/01_dist_sector.png\n")
cat("    - output/figuras/02_dist_sexo.png\n")
cat("    - output/figuras/03_indices_multidimensionales.png\n")
cat("    - output/figuras/04_ingresos_sector.png\n\n")
cat("  APRIORI (Patrones y Reglas):\n")
cat("    - output/tablas/06_reglas_asociacion_todas.csv (todas las reglas)\n")
cat("    - output/tablas/06a_reglas_top30_lift.csv (top 30)\n")
cat("    - output/tablas/07b_reglas_formalizacion.csv\n")
cat("    - output/tablas/07c_reglas_pagos_digitales.csv\n")
cat("    - output/tablas/07d_reglas_tic.csv\n")
cat("    - output/tablas/07e_reglas_antiguedad.csv\n\n")
cat("  Visualizaciones Apriori:\n")
cat("    - output/figuras/12_apriori_item_frequency.png (items frecuentes)\n")
cat("    - output/figuras/13_apriori_scatter_reglas.png (soporte vs confianza)\n")
cat("    - output/figuras/14_apriori_grafo_top20.png (red de patrones)\n")
cat("    - output/figuras/15_apriori_grouped_matrix.png (matriz agrupada)\n\n")
cat("=====================================================================\n")
cat(" PRÓXIMO PASO: Revisar patrones y hacer análisis posterior\n")
cat("=====================================================================\n")

# =====================================================================
# PROYECTO: Reglas de Asociación y Caracterización de Micronegocios (EMICRON 2024)
# SCRIPT 00: Configuración general y carga de paquetes
# =====================================================================

# 1. CARGA DE PAQUETES
# =====================================================================
# Solo los paquetes que usa el pipeline (versiones fijadas en renv.lock)
suppressPackageStartupMessages({
  # Manipulación y limpieza
  library(data.table)

  # Reglas de Asociación (Apriori)
  library(arules)
  library(arulesViz)

  # Visualización
  library(ggplot2)
  library(patchwork)
  library(scales)
  library(ggraph)      # redes de reglas (05_apriori.R)
  library(tidygraph)
})

# 2. DEFINICIÓN DE RUTAS (PATHS)
# =====================================================================
# Definimos las rutas relativas al root del proyecto
PROJECT_ROOT <- getwd()  # Asumimos que la sesión corre desde la carpeta base "emicron"

# Rutas de datos
DIR_DATA_RAW <- file.path(PROJECT_ROOT, "data", "raw", "2024")
DIR_DATA_PROCESSED <- file.path(PROJECT_ROOT, "data", "processed")

# Rutas de resultados
DIR_OUTPUT_FIGS <- file.path(PROJECT_ROOT, "output", "figuras")
DIR_OUTPUT_TABS <- file.path(PROJECT_ROOT, "output", "tablas")

# Crear directorios si no existen
dirs_to_create <- c(DIR_DATA_PROCESSED, DIR_OUTPUT_FIGS, DIR_OUTPUT_TABS)
for (d in dirs_to_create) {
  if (!dir.exists(d)) {
    dir.create(d, recursive = TRUE)
    message("Directorio creado: ", d)
  }
}

# 3. CONSTANTES GLOBALES
# =====================================================================
AÑO_ANALISIS <- "2024"
SEMILLA <- 42

# 4. CONFIGURACIÓN DATA.TABLE Y ESTÉTICA
# =====================================================================
setDTthreads(percent = 80) # Usar 80% de los cores disponibles
options(datatable.print.class = TRUE)

# Identidad visual DM: paleta, tipografía, guardar_fig(), barras_dm(),
# etiqueta_item() y regla_legible() (ver scripts/tema_dm.R)
source(file.path("scripts", "tema_dm.R"))
theme_set(tema_dm())

# 5. FUNCIONES AUXILIARES
# =====================================================================
# Medidas de reglas PONDERADAS por el factor de expansión.
# apriori() trata cada registro con igual peso; aquí se recalculan
# soporte, confianza y lift usando transactionInfo(trans)$weight (F_EXP),
# de modo que las medidas representan al universo y no a la muestra.
medidas_ponderadas <- function(reglas, trans) {
  s_xy <- support(items(reglas), trans, weighted = TRUE)
  s_x  <- support(lhs(reglas),   trans, weighted = TRUE)
  s_y  <- support(rhs(reglas),   trans, weighted = TRUE)
  data.table(
    support_pond    = s_xy,
    confidence_pond = s_xy / s_x,
    lift_pond       = s_xy / (s_x * s_y)
  )
}

message("Entorno configurado correctamente. Paquetes y rutas cargados.")

# =====================================================================
# PROYECTO: Tipologías y Permanencia de Micronegocios (EMICRON + ML)
# SCRIPT 00: Configuración general y carga de paquetes
# =====================================================================

# 1. CARGA DE PAQUETES
# =====================================================================
# Usamos suppressPackageStartupMessages para limpiar la salida en consola
suppressPackageStartupMessages({
  # Manipulación y limpieza
  library(data.table)
  
  # ML no supervisado (MCA + Clustering)
  library(FactoMineR)
  library(factoextra)
  library(cluster)
  
  # Reglas de Asociación (Apriori)
  library(arules)
  library(arulesViz)
  
  # ML supervisado
  library(tidymodels)
  library(xgboost)
  
  # Interpretabilidad
  library(shapviz)
  
  # Visualización
  library(ggplot2)
  library(patchwork)
  library(scales)
  library(pheatmap)
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

# Tema base para ggplot2
theme_set(theme_minimal(base_family = "sans") +
            theme(
              plot.title = element_text(face = "bold", size = 14),
              plot.subtitle = element_text(color = "gray30", size = 11),
              axis.text = element_text(color = "gray30"),
              strip.background = element_rect(fill = "gray90", color = NA),
              legend.position = "bottom"
            ))

message("Entorno configurado correctamente. Paquetes y rutas cargados.")

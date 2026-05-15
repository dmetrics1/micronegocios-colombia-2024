library(data.table)

# =====================================================================
# SCRIPT PARA GENERAR CUADROS DE CANTIDAD Y DISTRIBUCIÓN (EMICRON)
# =====================================================================
# Este script genera los cuadros solicitados. Omite los de "porcentaje" 
# y los de "resumen" según la instrucción.
# Utiliza las variables con sufijo "_DESC" que contienen las etiquetas.

generar_cuadros_distribucion <- function(datos_emicron, ruta_raw = NULL) {
  
  setDT(datos_emicron)
  
  # Función auxiliar para calcular Cantidad y Distribución (%)
  calc_dist <- function(dt, variable) {
    if (!variable %in% colnames(dt)) return(NULL)
    
    # Agrupar por la variable, sumar el factor de expansión
    res <- dt[!is.na(get(variable)), .(
      Cantidad = sum(F_EXP, na.rm = TRUE)
    ), by = variable]
    
    # Calcular la distribución (porcentaje)
    res[, Distribucion_Pct := round((Cantidad / sum(Cantidad)) * 100, 2)]
    
    # Ordenar por la variable
    setorderv(res, variable)
    return(res)
  }
  
  cuadros <- list()
  
  # =====================================================================
  # RESULTADOS GENERALES
  # =====================================================================
  cuadros[["Cuadro A1.10 Cantidad y distribución de micronegocios según situación en el empleo del propietario"]] <- calc_dist(datos_emicron, "P3033_DESC")
  cuadros[["Cuadro A1.12 Cantidad y distribución de micronegocios según sexo del propietario"]] <- calc_dist(datos_emicron, "P35_DESC")
  cuadros[["Cuadro B.1 Cantidad y distribución de micronegocios según actividad económica (4 grupos)"]] <- calc_dist(datos_emicron, "GRUPOS4_DESC")
  cuadros[["Cuadro B.2 Cantidad y distribución de micronegocios según actividad económica (12 grupos)"]] <- calc_dist(datos_emicron, "GRUPOS12_DESC")
  
  # =====================================================================
  # MÓDULO EMPRENDIMIENTO
  # =====================================================================
  cuadros[["Cuadro C.1 Cantidad y distribución de micronegocios según quién creó o constituyó el negocio"]] <- calc_dist(datos_emicron, "P3050_DESC")
  cuadros[["Cuadro C.2 Cantidad y distribución de micronegocios según motivo principal para la creación o constitución del negocio"]] <- calc_dist(datos_emicron, "P3051_DESC")
  cuadros[["Cuadro C.3 Cantidad y distribución de micronegocios según tiempo de funcionamiento"]] <- calc_dist(datos_emicron, "P639_DESC")
  cuadros[["Cuadro C.4 Cantidad y distribución de micronegocios según mayor fuente de recursos para la creación o constitución del negocio"]] <- calc_dist(datos_emicron, "P3052_DESC")
  
  # =====================================================================
  # MÓDULO SITIO O UBICACIÓN
  # =====================================================================
  cuadros[["Cuadro D.1 Cantidad y distribución de micronegocios según sitio o ubicación"]] <- calc_dist(datos_emicron, "P3053_DESC")
  cuadros[["Cuadro D.2 Cantidad y distribución de micronegocios ubicados en la vivienda con o sin espacio exclusivo para la actividad"]] <- calc_dist(datos_emicron, "P3095_DESC")
  cuadros[["Cuadro D.3 Cantidad y distribución de micronegocios según emplazamiento físico del negocio"]] <- calc_dist(datos_emicron, "P3096_DESC")
  cuadros[["Cuadro D.4 Cantidad y distribución de micronegocios según tipo de servicio de puerta en puerta (a domicilio)"]] <- calc_dist(datos_emicron, "P3097_DESC")
  cuadros[["Cuadro D.5 Cantidad y distribución de micronegocios ambulantes según ubicación en espacio público"]] <- calc_dist(datos_emicron, "P3098_DESC")
  cuadros[["Cuadro D.6 Cantidad y distribución de micronegocios según número de puestos o establecimientos"]] <- calc_dist(datos_emicron, "P3054_DESC")
  cuadros[["Cuadro D.7 Cantidad y distribución de micronegocios según propiedad del emplazamiento"]] <- calc_dist(datos_emicron, "P3055_DESC")
  cuadros[["Cuadro D.8 Cantidad y distribución de micronegocios según visibilidad al público"]] <- calc_dist(datos_emicron, "P469_DESC")
  
  # =====================================================================
  # MÓDULO PERSONAL OCUPADO (Propietario)
  # =====================================================================
  cuadros[["Cuadro E.1.1 Cantidad y distribución de micronegocios según aporte a salud y pensión del propietario"]] <- calc_dist(datos_emicron, "P3088_DESC")
  cuadros[["Cuadro E.1.3 Cantidad y distribución de micronegocios según aporte a ARL del propietario"]] <- calc_dist(datos_emicron, "P3090_DESC")
  
  # Cuadro E.2: Rangos de personal ocupado
  if (!"personal_total" %in% colnames(datos_emicron)) {
    datos_emicron[, personal_total := ifelse(P3031 == 1, n_total_personal_ocu + 1, 1)]
  }
  datos_emicron[, Rango_Personal := fcase(
    personal_total == 1, "1 persona",
    personal_total >= 2 & personal_total <= 3, "2 a 3 personas",
    personal_total >= 4 & personal_total <= 5, "4 a 5 personas",
    personal_total >= 6 & personal_total <= 9, "6 a 9 personas",
    default = "10 o más"
  )]
  cuadros[["Cuadro E.2 Cantidad y distribución de micronegocios según rangos de personal ocupado"]] <- calc_dist(datos_emicron, "Rango_Personal")
  
  # =====================================================================
  # MÓDULO PERSONAL OCUPADO (Trabajadores)
  # =====================================================================
  if (is.null(ruta_raw)) ruta_raw <- file.path(getwd(), "data", "raw", "2024")
  archivo_personal <- list.files(ruta_raw, pattern = "personal ocupado\\.csv", full.names = TRUE, ignore.case = TRUE)[1]
  
  if (!is.na(archivo_personal) && file.exists(archivo_personal)) {
    personal_raw <- fread(archivo_personal, encoding = "Latin-1")
    
    # Traer el F_EXP de la base consolidada al personal raw usando las llaves
    keys <- c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")
    personal_con_fexp <- merge(personal_raw, datos_emicron[, c(keys, "F_EXP"), with=FALSE], by = keys, all.x = TRUE)
    
    # Aplicar etiquetas al TIPO
    personal_con_fexp[, TIPO_DESC := factor(TIPO, 
                            levels = c(1, 2, 3), 
                            labels = c("Trabajadores remunerados", "Socios", "Familiares/Trabajadores sin remuneración"))]
    
    # E.3
    cuadros[["Cuadro E.3 Cantidad y distribución del personal ocupado por los micronegocios según tipo de vínculo"]] <- calc_dist(personal_con_fexp, "TIPO_DESC")
    
    # Como estas tablas dependen del raw que no ha pasado por el etiquetador general,
    # aplicamos etiquetas rápidamente a las columnas que se usarán:
    if ("P3077" %in% names(personal_con_fexp)) personal_con_fexp[, P3077_DESC := factor(P3077, levels=c(1,2), labels=c("Contrato a término indefinido","Temporal"))]
    if ("P3078" %in% names(personal_con_fexp)) personal_con_fexp[, P3078_DESC := factor(P3078, levels=c(1,2), labels=c("Hombre","Mujer"))]
    if ("P3080" %in% names(personal_con_fexp)) personal_con_fexp[, P3080_DESC := factor(P3080, levels=c(1,2,3,4), labels=c("Sí","No","Solo salud","Solo pensión"))]
    if ("P3082" %in% names(personal_con_fexp)) personal_con_fexp[, P3082_DESC := factor(P3082, levels=c(1,2), labels=c("Sí","No"))]
    if ("P3084" %in% names(personal_con_fexp)) personal_con_fexp[, P3084_DESC := factor(P3084, levels=c(1,2), labels=c("Sí","No"))]
    
    # TRABAJADORES REMUNERADOS (TIPO == 1)
    remunerados <- personal_con_fexp[TIPO == 1]
    cuadros[["Cuadro E.3.1.1 Cantidad y distribución de trabajadores remunerados por los micronegocios según tipo de contrato"]] <- calc_dist(remunerados, "P3077_DESC")
    cuadros[["Cuadro E.3.1.2 Cantidad y distribución de trabajadores remunerados por los micronegocios según sexo"]] <- calc_dist(remunerados, "P3078_DESC")
    cuadros[["Cuadro E.3.1.4 Cantidad y distribución de trabajadores remunerados por los micronegocios según aporte a salud y pensión"]] <- calc_dist(remunerados, "P3080_DESC")
    cuadros[["Cuadro E.3.1.6 Cantidad y distribución de trabajadores remunerados por los micronegocios según pago de prestaciones sociales"]] <- calc_dist(remunerados, "P3082_DESC")
    cuadros[["Cuadro E.3.1.8 Cantidad y distribución de trabajadores remunerados por los micronegocios según aporte a ARL"]] <- calc_dist(remunerados, "P3084_DESC")
    
    # SOCIOS (TIPO == 2)
    socios <- personal_con_fexp[TIPO == 2]
    cuadros[["Cuadro E.3.2.1 Cantidad y distribución de socios según sexo"]] <- calc_dist(socios, "P3078_DESC")
    cuadros[["Cuadro E.3.2.2 Cantidad y distribución de socios según aporte a salud y pensión"]] <- calc_dist(socios, "P3080_DESC")
    cuadros[["Cuadro E.3.2.4 Cantidad y distribución de socios según aporte a ARL"]] <- calc_dist(socios, "P3084_DESC")
    
    # FAMILIARES SIN REMUNERACIÓN (TIPO == 3)
    familiares <- personal_con_fexp[TIPO == 3]
    cuadros[["Cuadro E.3.3.1 Cantidad y distribución de trabajadores o familiares sin remuneración según sexo"]] <- calc_dist(familiares, "P3078_DESC")
    cuadros[["Cuadro E.3.3.2 Cantidad y distribución de trabajadores o familiares sin remuneración según aporte a salud y pensión"]] <- calc_dist(familiares, "P3080_DESC")
    cuadros[["Cuadro E.3.3.4 Cantidad y distribución de trabajadores o familiares sin remuneración según aporte a ARL"]] <- calc_dist(familiares, "P3084_DESC")
  } else {
    message("No se encontró el módulo de personal ocupado para calcular los cuadros E.3.*")
  }
  
  # =====================================================================
  # MÓDULO CARACTERÍSTICAS
  # =====================================================================
  cuadros[["Cuadro F.1 Cantidad y distribución de micronegocios según tenencia de Registro Único Tributario (RUT)"]] <- calc_dist(datos_emicron, "P1633_DESC")
  cuadros[["Cuadro F.3 Cantidad y distribución de micronegocios según régimen al cual pertenece"]] <- calc_dist(datos_emicron, "P986_DESC")
  cuadros[["Cuadro F.4 Cantidad y distribución de micronegocios según tipo de registro contable"]] <- calc_dist(datos_emicron, "P640_DESC")
  cuadros[["Cuadro F.5 Cantidad y distribución de micronegocios según motivos para no llevar registros contables"]] <- calc_dist(datos_emicron, "P4000_DESC")
  cuadros[["Cuadro F.6 Cantidad y distribución de micronegocios según tenencia de registro en Cámara de Comercio"]] <- calc_dist(datos_emicron, "P1055_DESC")
  cuadros[["Cuadro F.7 Cantidad y distribución de micronegocios según tipo de persona inscrita en la matrícula mercantil"]] <- calc_dist(datos_emicron, "P1056_DESC")
  cuadros[["Cuadro F.8 Cantidad y distribución de micronegocios según obtención o renovación del registro en Cámara de Comercio durante 2024"]] <- calc_dist(datos_emicron, "P661_DESC")
  cuadros[["Cuadro F.9 Cantidad y distribución de micronegocios según tenencia de registro ante entidad diferente a Cámara de Comercio (1)"]] <- calc_dist(datos_emicron, "P1057_DESC")
  cuadros[["Cuadro F.10 Cantidad y distribución de micronegocios según entidad ante la cual realizó registro"]] <- calc_dist(datos_emicron, "P4004_DESC")
  cuadros[["Cuadro F.11 Cantidad y distribución de micronegocios según declaración de impuesto a la renta renta"]] <- calc_dist(datos_emicron, "P2991_DESC")
  cuadros[["Cuadro F.12 Cantidad y distribución de micronegocios según declaración de Impuesto al Valor Agregado"]] <- calc_dist(datos_emicron, "P2992_DESC")
  cuadros[["Cuadro F.13 Cantidad y distribución de micronegocios según declaración de Impuesto de Industria y Comercio"]] <- calc_dist(datos_emicron, "P2993_DESC")
  
  # =====================================================================
  # MÓDULO TIC
  # =====================================================================
  cuadros[["Cuadro G.1 Cantidad y distribución de micronegocios según tenencia de dispositivos electrónicos (computadores o tabletas portátiles)"]] <- calc_dist(datos_emicron, "P4001_DESC")
  cuadros[["Cuadro G.2,3,4 Cantidad y distribución de micronegocios según número de dispositivos electrónicos en uso en el negocio"]] <- calc_dist(datos_emicron, "P1087_DESC")
  cuadros[["Cuadro G.4A Cantidad y distribución de micronegocios según uso del teléfono móvil celular"]] <- calc_dist(datos_emicron, "P976_DESC")
  cuadros[["Cuadro G.5,5A Cantidad y distribución de micronegocios según tipo y número de teléfonos móviles celulares en uso en el negocio"]] <- calc_dist(datos_emicron, "P978_DESC")
  cuadros[["Cuadro G.6 Cantidad y distribución de micronegocios según razón para no usar dispositivos electrónicos y teléfonos móviles celulares"]] <- calc_dist(datos_emicron, "P994_DESC")
  cuadros[["Cuadro G.7 Cantidad y distribución de micronegocios según tenencia de página web o presencia en sitio web"]] <- calc_dist(datos_emicron, "P2532_DESC")
  cuadros[["Cuadro G.8 Cantidad y distribución de micronegocios según presencia en redes sociales"]] <- calc_dist(datos_emicron, "P1559_DESC")
  cuadros[["Cuadro G.9 Cantidad y distribución de micronegocios según uso del servicio de internet"]] <- calc_dist(datos_emicron, "P2524_DESC")
  cuadros[["Cuadro G.10 Cantidad y distribución de micronegocios según conexión a internet dentro del negocio"]] <- calc_dist(datos_emicron, "P1093_DESC")
  cuadros[["Cuadro G.11 Cantidad y distribución de micronegocios según tipo de conexión para el acceso a internet"]] <- calc_dist(datos_emicron, "P2528_DESC")
  cuadros[["Cuadro G.12 Cantidad y distribución de micronegocios según razones para no usar servicio de internet"]] <- calc_dist(datos_emicron, "P1095_DESC")
  
  # =====================================================================
  # MÓDULO INCLUSIÓN FINANCIERA
  # =====================================================================
  cuadros[["Cuadro H.2 Cantidad y distribución de micronegocios según solicitud de crédito en el año anterior (2023)"]] <- calc_dist(datos_emicron, "P1765_DESC")
  cuadros[["Cuadro H.3 Cantidad y distribución de micronegocios según razones para no solicitar crédito"]] <- calc_dist(datos_emicron, "P1567_DESC")
  cuadros[["Cuadro H.4 Cantidad y distribución de micronegocios según tipo de entidad a la cual se solicitó el crédito"]] <- calc_dist(datos_emicron, "P1569_DESC")
  cuadros[["Cuadro H.5 Cantidad y distribución de micronegocios según resultado de la solicitud de crédito"]] <- calc_dist(datos_emicron, "P1568_DESC")
  cuadros[["Cuadro H.6 Cantidad y distribución de micronegocios según el uso del crédito obtenido"]] <- calc_dist(datos_emicron, "P1570_DESC")
  cuadros[["Cuadro H.7 Cantidad y distribución de micronegocios según ahorro en el año anterior (2023)"]] <- calc_dist(datos_emicron, "P3014_DESC")
  cuadros[["Cuadro H.7B Cantidad y distribución de micronegocios según razones para no ahorrar"]] <- calc_dist(datos_emicron, "P1574_DESC")
  cuadros[["Cuadro H.8 Cantidad y distribución de micronegocios según formas de ahorro"]] <- calc_dist(datos_emicron, "P1771_DESC")
  
  # =====================================================================
  # MÓDULO CAPITAL SOCIAL
  # =====================================================================
  cuadros[["Cuadro K1.1 Cantidad y distribución de micronegocios según afiliación a diferentes tipos de organización"]] <- calc_dist(datos_emicron, "P3002_DESC")
  
  return(cuadros)
}

# =====================================================================
# FUNCIÓN PARA IMPRIMIR LOS CUADROS CON SU TÍTULO
# =====================================================================
imprimir_cuadros <- function(lista_cuadros) {
  for (nombre in names(lista_cuadros)) {
    cuadro <- lista_cuadros[[nombre]]
    
    # Solo imprime si el cuadro se generó correctamente
    if (!is.null(cuadro) && nrow(cuadro) > 0) {
      cat("\n=====================================================================\n")
      cat(nombre, "\n")
      cat("=====================================================================\n")
      print(cuadro)
      cat("\n")
    }
  }
}

# =====================================================================
# EJECUCIÓN (Ejemplo)
# =====================================================================
# 1. Asegúrate de tener cargada tu base etiquetada
# source("scripts/03_diccionario_etiquetas.R")
# E_2024 <- etiquetar_emicron(E_2024)
#
# 2. Generar cuadros
cuadros_dane <- generar_cuadros_distribucion(E_2024)
#
# 3. Imprimir
imprimir_cuadros(cuadros_dane)

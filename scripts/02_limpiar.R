# =====================================================================
# PROYECTO: Tipologías y Permanencia de Micronegocios (EMICRON + ML)
# SCRIPT 02: Limpieza, Feature Engineering y Renombramiento
# =====================================================================

source(file.path("scripts", "00_config.R"))

# 1. CARGA DE LA BASE CONSOLIDADA
# =====================================================================
# Asumimos que 01_consolidar.R ya se corrió y guardó la base consolidada
ruta_base <- file.path(DIR_DATA_PROCESSED, "emicron_2024_consolidada.rds")

if (!file.exists(ruta_base)) {
  message("La base consolidada no existe. Corriendo 01_consolidar.R primero...")
  source(file.path("scripts", "01_consolidar.R"))
  # En 01_consolidar.R se genera el objeto E_2024
  base <- copy(E_2024)
} else {
  base <- readRDS(ruta_base)
  setDT(base)
}

message(sprintf("Base cargada: %d filas x %d columnas", nrow(base), ncol(base)))

# 2. SELECCIÓN DE VARIABLES (Opcional, pero recomendado para aligerar memoria)
# =====================================================================
vars_seleccionadas <- c(
  "DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA", "F_EXP",
  # Target / Emprendimiento
  "P639", 
  # Identificación
  "P35", "P241", "P3033", "P3031", "GRUPOS4", "GRUPOS12",
  # Geografía
  "AREA", "COD_DEPTO", "CLASE_TE",
  # Emprendimiento
  "P3050", "P3051", "P3052",
  # Ubicación
  "P3053", "P3095", "P3096", "P3097", "P3098", "P3054", "P3055", "P469",
  # Formalización
  "P1633", "P986", "P640", "P4000", "P1055", "P1056", "P661", "P1057", "P4004",
  "P3088", "P3090", "P2991", "P2992", "P2993",
  # TIC
  "P2524", "P1559", "P2532", "P976", "P4001", "P1093", "P1087", "P978", "P994", "P2528", "P1095",
  # Financiero
  "VENTAS_MES_ANTERIOR", "CONSUMO_INTERMEDIO", "VALOR_AGREGADO", "P3072",
  # Inclusión financiera — formas de pago
  "P1764_1", "P1764_2", "P1764_3", "P1764_4", "P1764_5", "P1764_6",
  "P1765", "P1567", "P1568", "P1569", "P1570", "P3014", "P1574", "P1771",
  # Personal (Agregadas en paso anterior)
  "n_total_personal_ocu", "n_trab_remunerados", "pct_con_salud_pension", 
  "pct_mujeres", "salario_promedio", "antiguedad_prom_meses",
  # Capital Social
  "P3002", "P3004"
)

# Quedarnos solo con las que existan en la base (para evitar errores si falta alguna)
vars_presentes <- intersect(vars_seleccionadas, names(base))
base <- base[, ..vars_presentes]

# 3. TRATAMIENTO DE CÓDIGOS DE NO RESPUESTA (98, 99)
# =====================================================================
# Muchas numéricas o categóricas pueden tener 98 (No Sabe) o 99 (No Informa)
# Las convertimos a NA. Excluímos llaves y variables donde 99 pueda ser válido (edad).
vars_limpiar <- setdiff(names(base), c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA", "F_EXP", "P241", "AREA", "COD_DEPTO"))

for (j in vars_limpiar) {
  if (is.numeric(base[[j]])) {
    set(base, which(base[[j]] %in% c(98, 99, 998, 999)), j, NA)
  }
}

# 4. CARACTERIZACIÓN MULTIDIMENSIONAL (ÍNDICES)
# =====================================================================

# 4.1 ÍNDICE DE FORMALIZACIÓN (0 a 5)
base[, idx_formalizacion := (
  fifelse(P1633 == 1, 1L, 0L, na=0L) +          # Tiene RUT
  fifelse(P1055 == 1, 1L, 0L, na=0L) +          # Tiene Cámara de Comercio
  fifelse(P640 %in% c(1, 2, 3, 4), 1L, 0L, na=0L) + # Lleva algún registro contable
  fifelse(P3088 == 1, 1L, 0L, na=0L) +          # Paga seguridad social (propietario)
  fifelse(P2991 == 1, 1L, 0L, na=0L)            # Declara impuesto de renta
)]

# 4.2 ÍNDICE DIGITAL (0 a 4)
base[, idx_digital := (
  fifelse(P2524 == 1, 1L, 0L, na=0L) +          # Usa internet
  fifelse(P1559 == 1, 1L, 0L, na=0L) +          # Tiene redes sociales
  fifelse(P2532 == 1, 1L, 0L, na=0L) +          # Tiene página web
  fifelse(P976 == 1, 1L, 0L, na=0L)             # Usa celular para el negocio
)]

# 5. FEATURE ENGINEERING: RATIOS FINANCIEROS
# =====================================================================
base[, `:=`(
  margen_operativo = fifelse(
    !is.na(VENTAS_MES_ANTERIOR) & VENTAS_MES_ANTERIOR > 0,
    (VENTAS_MES_ANTERIOR - fifelse(is.na(CONSUMO_INTERMEDIO), 0, CONSUMO_INTERMEDIO)) / VENTAS_MES_ANTERIOR,
    NA_real_
  ),
  productividad = fifelse(
    !is.na(n_total_personal_ocu) & n_total_personal_ocu > 0,
    fifelse(is.na(VALOR_AGREGADO), 0, VALOR_AGREGADO) / (n_total_personal_ocu + 1),  # +1 por el propietario
    VALOR_AGREGADO
  ),
  ratio_costos = fifelse(
    !is.na(VENTAS_MES_ANTERIOR) & VENTAS_MES_ANTERIOR > 0,
    fifelse(is.na(CONSUMO_INTERMEDIO), 0, CONSUMO_INTERMEDIO) / VENTAS_MES_ANTERIOR,
    NA_real_
  )
)]

# 6. FEATURE ENGINEERING: CAPITAL SOCIAL
# =====================================================================
base[, n_organizaciones := (
  fifelse(P3002 == 1, 1L, 0L, na=0L) +
  fifelse(P3004 == 1, 1L, 0L, na=0L)
)]

# 7. FILTRADO FINAL Y CALIDAD DE DATOS
# =====================================================================
# Solo nos quedamos con micronegocios con factor de expansión válido
base <- base[!is.na(F_EXP) & F_EXP > 0]

# =====================================================================
# =====================================================================
# 8. ETIQUETADO DESCRIPTIVO (DANE)
# =====================================================================
# Función interna para aplicar etiquetas del diccionario EMICRON 2024
etiquetar_emicron <- function(datos) {
  setDT(datos)
  # Resultados Generales
  datos[, P3033_DESC := factor(P3033, levels = c(1, 2), labels = c("Patrón o empleador(a)", "Trabajador(a) por cuenta propia"))]
  datos[, P35_DESC := factor(P35, levels = c(1, 2), labels = c("Hombre", "Mujer"))]
  datos[, GRUPOS4_DESC := factor(as.numeric(GRUPOS4), levels = 1:4, labels = c("Agricultura, ganadería...", "Industria", "Comercio", "Servicios"))]
  datos[, GRUPOS12_DESC := factor(as.numeric(GRUPOS12), levels = 1:12, labels = c("Agro", "Minería", "Industria", "Construcción", "Comercio", "Transporte", "Alojamiento/Comida", "Información", "Inmobiliaria/Admin", "Educación", "Salud", "Arte/Otras"))]
  
  # Emprendimiento
  datos[, P3050_DESC := factor(P3050, levels = 1:6, labels = c("Usted solo", "Familiares", "No familiares", "Otras personas", "Un familiar", "Otro"))]
  datos[, P3051_DESC := factor(P3051, levels = 1:7, labels = c("Sin alternativa", "Oportunidad", "Tradición", "Mejorar ingreso", "Oficio", "Sin experiencia", "Otro"))]
  datos[, P639_DESC := factor(P639, levels = 1:5, labels = c("<1 año", "1-3 años", "3-5 años", "5-10 años", "10+ años"))]
  datos[, P3052_DESC := factor(P3052, levels = 1:8, labels = c("Ahorros", "Préstamos fam", "Préstamos banc", "Prestamistas", "Cap semilla", "No requirió", "NS/NR", "Otro"))]
  
  # Ubicación
  datos[, P3053_DESC := factor(P3053, levels = 1:8, labels = c("Vivienda", "Local/Oficina", "Domicilio", "Ambulante", "Vehículo", "Obra", "Finca", "Otra"))]
  datos[, P3055_DESC := factor(P3055, levels = 1:6, labels = c("Propio pagado", "Pagándolo", "Arriendo", "Usufructo", "Posesión", "Otro"))]
  datos[, P469_DESC := factor(P469, levels = c(1, 2), labels = c("Sí", "No"))]
  
  # Formalización
  datos[, P1633_DESC := factor(P1633, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P986_DESC := factor(P986, levels = c(1, 2), labels = c("Común", "Simplificado"))]
  datos[, P640_DESC := factor(P640, levels = 1:5, labels = c("Balance/PyG", "Libro diario", "Cuaderno/Excel", "Informes", "No lleva"))]
  datos[, P4000_DESC := factor(P4000, levels = 1:3, labels = c("No se necesita", "No sabe como llevar registros", "No aplica"))]
  datos[, P1055_DESC := factor(P1055, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1056_DESC := factor(P1056, levels = c(1, 2), labels = c("Persona natural", "Persona jurídica"))]
  datos[, P661_DESC := factor(P661, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1057_DESC := factor(P1057, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P4004_DESC := factor(P4004, levels = 1:4, labels = c("Alcaldía", "ICA", "Ministerio", "Otro"))]
  datos[, P2991_DESC := factor(P2991, levels = c(1, 2, 3, 9), labels = c("Sí", "No", "No responsable", "No Informa"))]
  datos[, P2992_DESC := factor(P2992, levels = c(1, 2, 3, 9), labels = c("Sí", "No", "No responsable", "No Informa"))]
  datos[, P2993_DESC := factor(P2993, levels = c(1, 2, 3, 9), labels = c("Sí", "No", "No responsable", "No Informa"))]

  # TIC
  datos[, P4001_DESC := factor(P4001, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1087_DESC := as.factor(P1087)] # Número de dispositivos
  datos[, P976_DESC := factor(P976, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P978_DESC := as.factor(P978)] # Tipo de celulares
  datos[, P994_DESC := factor(P994, levels = 1:3, labels = c("Muy costoso", "No se necesita", "Personal no sabe"))]
  datos[, P2532_DESC := factor(P2532, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1559_DESC := factor(P1559, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P2524_DESC := factor(P2524, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1093_DESC := factor(P1093, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P2528_DESC := factor(P2528, levels = c(1, 2), labels = c("Fijo", "Móvil"))]
  datos[, P1095_DESC := factor(P1095, levels = 1:6, labels = c("Costoso", "No necesita", "No sabe", "Sin dispositivo", "Mala calidad", "Sin cobertura"))]

  # Inclusión Financiera
  datos[, P1765_DESC := factor(P1765, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1567_DESC := factor(P1567, levels = 1:6, labels = c("No necesita", "Miedo deudas", "Sin requisitos", "Intereses altos", "Reportado", "Otro"))]
  datos[, P1569_DESC := factor(P1569, levels = 1:7, labels = c("Banco", "Proveedor", "Empeño", "Microcrédito/ONG", "Gota a gota", "Familia/Amigos", "Otro"))]
  datos[, P1568_DESC := factor(P1568, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1570_DESC := factor(P1570, levels = 1:3, labels = c("Negocio", "Personal", "Ambos"))]
  datos[, P3014_DESC := factor(P3014, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1574_DESC := factor(P1574, levels = 1:5, labels = c("No alcanzó", "No interesa", "No sabe", "No ofrecieron", "Desconfianza"))]
  datos[, P1771_DESC := factor(P1771, levels = 1:7, labels = c("Banco/Ahorro", "Coop/Fondo", "Grupo/Natillera", "Familia/Amigos", "Activos", "Vivienda", "Otro"))]

  # Capital Social
  datos[, P3002_DESC := factor(P3002, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P3054_DESC := as.factor(P3054)] # Número de puestos
  datos[, P1055_DESC := factor(P1055, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P3088_DESC := factor(P3088, levels = 1:4, labels = c("Sí", "No", "Solo salud", "Solo pensión"))]
  
  # TIC e Inclusión
  datos[, P4001_DESC := factor(P4001, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P976_DESC := factor(P976, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P2524_DESC := factor(P2524, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1093_DESC := factor(P1093, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P1765_DESC := factor(P1765, levels = c(1, 2), labels = c("Sí", "No"))]
  datos[, P3014_DESC := factor(P3014, levels = c(1, 2), labels = c("Sí", "No"))]
  
  # Geografía y Región
  datos[, COD_DEPTO_DESC := factor(as.numeric(COD_DEPTO), 
      levels = c(5, 8, 11, 13, 15, 17, 18, 19, 20, 23, 25, 27, 41, 44, 47, 50, 52, 54, 63, 66, 68, 70, 73, 76), 
      labels = c("Antioquia", "Atlántico", "Bogotá D.C.", "Bolívar", "Boyacá", "Caldas", "Caquetá", "Cauca", "Cesar", "Córdoba", "Cundinamarca", "Chocó", "Huila", "La Guajira", "Magdalena", "Meta", "Nariño", "Norte de Santander", "Quindío", "Risaralda", "Santander", "Sucre", "Tolima", "Valle del Cauca"))]
  
  return(datos)
}

message("\n=== APLICANDO ETIQUETAS DANE (_DESC) ===")
base <- etiquetar_emicron(base)

# 9. RENOMBRAMIENTO DE VARIABLES P_XXX → NOMBRES DESCRIPTIVOS
# =====================================================================
# Integrado desde el antiguo 02b_renombrar_variables.R para simplificar
# el pipeline a un solo paso de limpieza.
#
# NOTA: P3033 es el ROL del propietario (Patrón vs Cuenta Propia),
#       NO el nivel educativo. Corregido aquí.
# =====================================================================

renombres <- c(
  # Demográficas y Clasificación
  "P35" = "sexo_propietario",
  "P241" = "edad_propietario",
  "P3033" = "rol_propietario",            # Patrón(1) vs Cuenta Propia(2)
  "GRUPOS4" = "sector_economico",
  "GRUPOS12" = "sector_economico_12",
  "CLASE_TE" = "zona_geografica",
  
  # Emprendimiento e Historia
  "P639" = "tiempo_funcionamiento",
  "P3051" = "motivo_creacion",
  "P3052" = "fuente_capital_inicial",
  
  # Ubicación Física
  "P3053" = "tipo_ubicacion",
  "P3055" = "comparte_con_vivienda",
  "P469" = "paga_arriendo",
  
  # Variables usadas para Formalización
  "P1633" = "tiene_rut",
  "P1055" = "tiene_camara_comercio",
  "P640" = "tipo_contabilidad",
  "P3088" = "paga_seg_social_prop",
  
  # TIC
  "P4001" = "usa_dispositivos",
  "P976" = "usa_celular_negocio",
  "P2524" = "usa_internet",
  "P1093" = "internet_en_local",
  "P1559" = "usa_redes_sociales",
  "P2532" = "tiene_sitio_web",
  
  # Formas de pago (Inclusión Financiera)
  "P1764_1" = "acepta_efectivo",
  "P1764_2" = "acepta_cheque",
  "P1764_3" = "acepta_transferencia",
  "P1764_4" = "acepta_factura_plazo",
  "P1764_5" = "acepta_tarjeta_debito",
  "P1764_6" = "acepta_tarjeta_credito",
  
  # Otras Inclusión financiera
  "P1765" = "solicito_credito",
  "P3014" = "tiene_ahorros",
  "P3072" = "ganancia_mensual"
)

# Aplicar renombres solo a las variables que existen en la base
cols_existentes <- intersect(names(renombres), names(base))
nuevos_nombres <- renombres[cols_existentes]

setnames(base, old = cols_existentes, new = nuevos_nombres)

message(sprintf("✓ %d variables renombradas a nombres descriptivos.", length(cols_existentes)))

# 10. GUARDADO
# =====================================================================
ruta_salida <- file.path(DIR_DATA_PROCESSED, "base_analitica.rds")
saveRDS(base, file = ruta_salida)
message(sprintf("Base analítica procesada y guardada en: %s", ruta_salida))

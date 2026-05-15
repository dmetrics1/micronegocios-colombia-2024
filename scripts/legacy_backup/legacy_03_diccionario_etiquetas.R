library(data.table)

# =====================================================================
# SCRIPT 03: APLICAR ETIQUETAS DEL DICCIONARIO A LAS VARIABLES
# =====================================================================
# Este script crea nuevas variables (terminadas en _DESC) con las 
# etiquetas categóricas correspondientes al Diccionario EMICRON 2024,
# conservando intactas las variables numéricas originales para 
# posibles modelos de Machine Learning futuros.

etiquetar_emicron <- function(datos) {
  
  # Aseguramos que sea data.table
  setDT(datos)
  
  # =====================================================================
  # RESULTADOS GENERALES
  # =====================================================================
  datos[, P3033_DESC := factor(P3033, 
      levels = c(1, 2), 
      labels = c("Patrón o empleador(a)", "Trabajador(a) por cuenta propia"))]

  datos[, P35_DESC := factor(P35, 
      levels = c(1, 2), 
      labels = c("Hombre", "Mujer"))]

  datos[, GRUPOS4_DESC := factor(as.numeric(GRUPOS4), 
      levels = 1:4, 
      labels = c("Agricultura, ganadería, caza, silvicultura y pesca", "Industria manufacturera", "Comercio", "Servicios"))]

  datos[, GRUPOS12_DESC := factor(as.numeric(GRUPOS12), 
      levels = 1:12, 
      labels = c("Agricultura, ganadería, caza, silvicultura y pesca", "Minería", "Industria manufacturera", "Construcción", "Comercio y reparación de vehículos automotores", "Transporte y almacenamiento", "Alojamiento y servicios de comida", "Información y comunicaciones", "Actividades inmobiliarias, profesionales y administrativas", "Educación", "Actividades de atención a la salud humana", "Actividades artísticas, de entretenimiento y otras"))]

  # =====================================================================
  # MÓDULO EMPRENDIMIENTO
  # =====================================================================
  datos[, P3050_DESC := factor(P3050, 
      levels = c(1, 2, 3, 4, 5, 6), 
      labels = c("Usted solo", "Usted y otro(s) familiares", "Usted y otra(s) persona(s) no familiar(es)", "Otras personas", "Un familiar", "Otro"))]

  datos[, P3051_DESC := factor(P3051, 
      levels = c(1, 2, 3, 4, 5, 6, 7), 
      labels = c("No tiene otra alternativa de ingresos", "Lo identificó como oportunidad de negocio", "Por tradición familiar o lo heredó", "Para complementar o mejorar el ingreso", "Para ejercer su oficio o profesión", "No tenía experiencia para un empleo", "Otro"))]

  datos[, P639_DESC := factor(P639, 
      levels = c(1, 2, 3, 4, 5), 
      labels = c("Menos de un año", "De 1 a menos de 3 años", "De 3 a menos de 5 años", "De 5 a menos de 10 años", "10 años y más"))]

  datos[, P3052_DESC := factor(P3052, 
      levels = c(1, 2, 3, 4, 5, 6, 7, 8), 
      labels = c("Ahorros personales", "Préstamos familiares", "Préstamos bancarios", "Prestamistas", "Capital semilla", "No requirió financiación", "No sabe", "Otro"))]

  # =====================================================================
  # MÓDULO SITIO O UBICACIÓN
  # =====================================================================
  datos[, P3053_DESC := factor(P3053, 
      levels = c(1, 2, 3, 4, 5, 6, 7, 8), 
      labels = c("En su vivienda o en otra vivienda", "Local, tienda, taller, fábrica, oficina", "De puerta en puerta (a domicilio)", "Ambulante - sitio al descubierto", "Vehículo con o sin motor", "Obra y construcción", "Finca", "Otra"))]

  datos[, P3095_DESC := factor(P3095, 
      levels = c(1, 2), 
      labels = c("Tiene espacio exclusivo para la actividad", "No tiene espacio exclusivo para la actividad"))]

  datos[, P3096_DESC := factor(P3096, 
      levels = c(1, 2, 3, 4), 
      labels = c("Local - tienda", "Taller - fábrica", "Oficina - consultorio", "En kiosco - caseta"))]

  datos[, P3097_DESC := factor(P3097, 
      levels = c(1, 2), 
      labels = c("En el domicilio de sus clientes", "Visitando locales o negocios de sus clientes"))]

  datos[, P3098_DESC := factor(P3098, 
      levels = c(1, 2), 
      labels = c("Móvil", "Estacionaria"))]

  datos[, P3055_DESC := factor(P3055, 
      levels = c(1, 2, 3, 4, 5, 6), 
      labels = c("Propio, totalmente pagado", "Propio, lo están pagando", "En arriendo o subarriendo", "En usufructo", "Posesión sin titulo u ocupante de hecho", "Otro"))]

  datos[, P469_DESC := factor(P469, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  # =====================================================================
  # MÓDULO PERSONAL OCUPADO (Propietario)
  # =====================================================================
  datos[, P3088_DESC := factor(P3088, 
      levels = c(1, 2, 3, 4), 
      labels = c("Sí", "No", "Solo salud", "Solo pensión"))]

  datos[, P3090_DESC := factor(P3090, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  # =====================================================================
  # MÓDULO CARACTERÍSTICAS
  # =====================================================================
  datos[, P1633_DESC := factor(P1633, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P986_DESC := factor(P986, 
      levels = c(1, 2), 
      labels = c("Común", "Simplificado"))]

  datos[, P640_DESC := factor(P640, 
      levels = c(1, 2, 3, 4, 5), 
      labels = c("Balance general o P y G", "Libro de registro diario de operaciones", "Otro tipo de cuentas (cuaderno, excel)", "Informes financieros/laborales/tributarios", "No lleva registros"))]

  datos[, P4000_DESC := factor(P4000, 
      levels = c(1, 2, 3), 
      labels = c("No se necesita", "No sabe como llevar registros", "No aplica"))]

  datos[, P1055_DESC := factor(P1055, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1056_DESC := factor(P1056, 
      levels = c(1, 2), 
      labels = c("Como persona natural comerciante", "Como persona jurídica"))]

  datos[, P661_DESC := factor(P661, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1057_DESC := factor(P1057, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P4004_DESC := factor(P4004, 
      levels = c(1, 2, 3, 4), 
      labels = c("Alcaldía", "Instituto Colombiano Agropecuario (ICA)", "Ministerio", "Otro"))]

  datos[, P2991_DESC := factor(P2991, 
      levels = c(1, 2, 3, 9), 
      labels = c("Sí", "No", "No es responsable de este impuesto", "No Informa"))]

  datos[, P2992_DESC := factor(P2992, 
      levels = c(1, 2, 3, 9), 
      labels = c("Sí", "No", "No es responsable de este impuesto", "No Informa"))]

  datos[, P2993_DESC := factor(P2993, 
      levels = c(1, 2, 3, 9), 
      labels = c("Sí", "No", "No es responsable de este impuesto", "No Informa"))]

  # =====================================================================
  # MÓDULO TIC
  # =====================================================================
  datos[, P4001_DESC := factor(P4001, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P976_DESC := factor(P976, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P994_DESC := factor(P994, 
      levels = c(1, 2, 3), 
      labels = c("Es muy costoso", "No se necesita", "El personal no sabe usarlo"))]

  datos[, P2532_DESC := factor(P2532, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1559_DESC := factor(P1559, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P2524_DESC := factor(P2524, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1093_DESC := factor(P1093, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P2528_DESC := factor(P2528, 
      levels = c(1, 2), 
      labels = c("Fijo", "Móvil"))]

  datos[, P1095_DESC := factor(P1095, 
      levels = c(1, 2, 3, 4, 5, 6), 
      labels = c("Es muy costoso", "No lo necesita", "El personal no sabe usarlo", "No tiene dispositivo para conectarse", "El servicio no es de buena calidad", "No hay cobertura del servicio"))]

  # =====================================================================
  # MÓDULO INCLUSIÓN FINANCIERA
  # =====================================================================
  datos[, P1765_DESC := factor(P1765, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1567_DESC := factor(P1567, 
      levels = c(1, 2, 3, 4, 5, 6), 
      labels = c("No lo necesita", "Miedo a las deudas", "No cumple los requisitos", "Intereses muy altos", "Reportado negativamente", "Otro"))]

  datos[, P1569_DESC := factor(P1569, 
      levels = c(1, 2, 3, 4, 5, 6, 7), 
      labels = c("Institución financiera regulada", "Crédito de proveedores", "Casa de empeño", "Entidades Micro crediticias (ONG)", "Prestamista, gota a gota", "Familiares o amigos", "Otro"))]

  datos[, P1568_DESC := factor(P1568, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1570_DESC := factor(P1570, 
      levels = c(1, 2, 3), 
      labels = c("Para invertir en el negocio", "Para cubrir gastos personales", "Ambas"))]

  datos[, P3014_DESC := factor(P3014, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]

  datos[, P1574_DESC := factor(P1574, 
      levels = c(1, 2, 3, 4, 5), 
      labels = c("No le alcanzó", "No necesita / No le interesa", "No sabe como ahorrar", "No le han ofrecido productos", "No confía en bancos"))]

  datos[, P1771_DESC := factor(P1771, 
      levels = c(1, 2, 3, 4, 5, 6, 7), 
      labels = c("Institución financiera / cuenta de ahorro", "Cooperativas o fondos de empleados", "Grupo de ahorro / cadena / natillera", "Familiares o amigos", "Compra de activos (joyas, casas, lotes, etc)", "En su vivienda", "Otro"))]

  # =====================================================================
  # MÓDULO CAPITAL SOCIAL
  # =====================================================================
  datos[, P3002_DESC := factor(P3002, 
      levels = c(1, 2), 
      labels = c("Sí", "No"))]
      
  # NOTA: Las variables de los trabajadores (P3077, P3078, P3080, P3082, P3084)
  # se etiquetan directamente en el script "04_cuadros_boletin.R" al cargar
  # el CSV en crudo (personal ocupado.csv), porque sus filas están a nivel 
  # trabajador y no a nivel micronegocio.

  message("¡Nuevas variables _DESC generadas y agregadas a la base de datos!")
  
  return(datos)
}

# =====================================================================
# EJECUCIÓN (Ejemplo)
# =====================================================================
# 1. Cargas este script:
# source("scripts/03_diccionario_etiquetas.R")
#
# 2. Se lo aplicas a tu base E_2024 (creará las columnas _DESC)
# E_2024 <- etiquetar_emicron(E_2024)
# 
# 3. Y luego sigues con los cuadros:
# source("scripts/04_cuadros_boletin.R")
# cuadros_dane <- generar_cuadros_distribucion(E_2024)
# imprimir_cuadros(cuadros_dane)

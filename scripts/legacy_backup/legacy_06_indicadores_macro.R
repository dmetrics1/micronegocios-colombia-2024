library(data.table)

# =====================================================================
# SCRIPT 06: INDICADORES MACROECONÓMICOS (TABLA RESUMEN ABSOLUTOS)
# =====================================================================
# Este script calcula exactamente los grandes agregados nacionales:
# Número de micronegocios, Personal ocupado, Ventas, Consumo Intermedio,
# Valor Agregado, Sueldos, Prestaciones, Remuneración Total e Ingreso Mixto.

# Función interna que recibe cualquier base (nacional o filtrada) y saca los 9 indicadores
calcular_agregados_macro <- function(dt) {
  
  # 1. NÚMERO DE MICRONEGOCIOS
  num_micronegocios <- sum(dt$F_EXP, na.rm = TRUE)
  
  # 2. PERSONAL OCUPADO
  if (!"total_trabajadores" %in% names(dt)) {
    dt[, total_trabajadores := fifelse(is.na(P3032_1), 0, P3032_1) +
                               fifelse(is.na(P3032_2), 0, P3032_2) +
                               fifelse(is.na(P3032_3), 0, P3032_3)]
  }
  trabajadores_expandidos <- sum(dt$total_trabajadores * dt$F_EXP, na.rm = TRUE)
  personal_ocupado <- num_micronegocios + trabajadores_expandidos
  
  # 3. VENTAS O INGRESOS
  vars_ventas <- c("P3057", "P3058", "P3059", "P3060", "P3061", "P3062", 
                   "P4002", "P3063", "P3064", "P3065", "P3066", "P3067", 
                   "P3092", "P3093", "P4036")
  
  dt[, Ventas_Mensuales_Manual := 0]
  for (v in vars_ventas) {
    if (v %in% names(dt)) dt[, Ventas_Mensuales_Manual := Ventas_Mensuales_Manual + fifelse(is.na(get(v)), 0, get(v))]
  }
  dt[, Ventas_Anuales_Total := Ventas_Mensuales_Manual * 12 * F_EXP]
  ventas_miles_pesos <- sum(dt$Ventas_Anuales_Total, na.rm = TRUE) / 1000
  
  # 4. CONSUMO INTERMEDIO
  vars_ci_mensual <- c("P3056_A", "P3056_B", "P3056_C", "P3056_D", "P3056_E",
                       "P3017_A", "P3017_B", "P3017_C", "P3017_D", "P3017_E",
                       "P3017_F", "P3017_G", "P3017_H", "P3017_K")
  # NOTA: P3017_I (Licencias) y P3017_J (Impuestos) SE EXCLUYEN del 
  # Consumo Intermedio porque metodológicamente son impuestos a la producción.
  vars_ci_anual <- c("P3017_L")
  
  dt[, CI_Mensual_Manual := 0]
  for (v in vars_ci_mensual) {
    if (v %in% names(dt)) dt[, CI_Mensual_Manual := CI_Mensual_Manual + fifelse(is.na(get(v)), 0, get(v))]
  }
  dt[, CI_Anual_Manual := 0]
  for (v in vars_ci_anual) {
    if (v %in% names(dt)) dt[, CI_Anual_Manual := CI_Anual_Manual + fifelse(is.na(get(v)), 0, get(v))]
  }
  dt[, Consumo_Intermedio_Anual := (CI_Mensual_Manual * 12 + CI_Anual_Manual) * F_EXP]
  ci_miles_pesos <- sum(dt$Consumo_Intermedio_Anual, na.rm = TRUE) / 1000
  
  # 5. VALOR AGREGADO
  dt[, Valor_Agregado_Anual := Ventas_Anuales_Total - Consumo_Intermedio_Anual]
  va_miles_pesos <- sum(dt$Valor_Agregado_Anual, na.rm = TRUE) / 1000
  
  # 6. SUELDOS Y SALARIOS
  if ("SUELDOS" %in% names(dt)) {
    dt[, Sueldos_Anuales := fifelse(is.na(SUELDOS), 0, SUELDOS) * 12 * F_EXP]
  } else {
    dt[, Sueldos_Anuales := 0]
  }
  ss_miles_pesos <- sum(dt$Sueldos_Anuales, na.rm = TRUE) / 1000
  
  # 7. PRESTACIONES SOCIALES
  if ("PRESTACIONES" %in% names(dt)) {
    dt[, Prestaciones_Anuales := fifelse(is.na(PRESTACIONES), 0, PRESTACIONES) * 12 * F_EXP]
  } else {
    dt[, Prestaciones_Anuales := 0]
  }
  ps_miles_pesos <- sum(dt$Prestaciones_Anuales, na.rm = TRUE) / 1000
  
  # 8. REMUNERACIÓN TOTAL
  dt[, Remuneracion_Total_Anual := Sueldos_Anuales + Prestaciones_Anuales]
  rt_miles_pesos <- sum(dt$Remuneracion_Total_Anual, na.rm = TRUE) / 1000
  
  # 9. INGRESO MIXTO
  dt[, Ingreso_Mixto_Anual := Valor_Agregado_Anual - Remuneracion_Total_Anual]
  im_miles_pesos <- sum(dt$Ingreso_Mixto_Anual, na.rm = TRUE) / 1000
  
  # Armar tabla
  tabla_resumen <- data.table(
    Indicadores = c(
      "Número de micronegocios", 
      "Personal ocupado", 
      "Ventas o ingresos (miles de pesos)",
      "Consumo intermedio (miles de pesos)",
      "Valor agregado (miles de pesos)",
      "Sueldos y salarios (miles de pesos)",
      "Prestaciones sociales (miles de pesos)",
      "Remuneración total (miles de pesos)",
      "Ingreso mixto (miles de pesos)"
    ),
    Absolutos_2024 = c(
      num_micronegocios, personal_ocupado, ventas_miles_pesos,
      ci_miles_pesos, va_miles_pesos, ss_miles_pesos,
      ps_miles_pesos, rt_miles_pesos, im_miles_pesos
    )
  )
  
  tabla_resumen[, Formato_DANE := formatC(Absolutos_2024, format="f", big.mark=".", decimal.mark=",", digits=0)]
  return(tabla_resumen)
}

# =====================================================================
# FUNCIÓN 1: MACRO TOTAL NACIONAL
# =====================================================================
generar_macro_2024 <- function(datos_emicron) {
  setDT(datos_emicron)
  return(calcular_agregados_macro(datos_emicron))
}

# =====================================================================
# FUNCIÓN 2: MACRO VENDEDORES AMBULANTES
# =====================================================================
# Filtra la base para la variable P3053 (Sitio o Ubicación) 
# Categoría 4: Ambulante - sitio al descubierto
generar_macro_ambulantes <- function(datos_emicron) {
  setDT(datos_emicron)
  
  if (!"P3053" %in% names(datos_emicron)) {
    stop("La variable P3053 (ubicación del negocio) no se encuentra en la base.")
  }
  
  # Filtrar vendedores ambulantes
  dt_ambulantes <- datos_emicron[P3053 == 4]
  
  return(calcular_agregados_macro(dt_ambulantes))
}

# =====================================================================
# EJECUCIÓN:
# =====================================================================
# resumen_nacional <- generar_macro_2024(E_2024)
# print(resumen_nacional)
#
# resumen_ambulantes <- generar_macro_ambulantes(E_2024)
# print(resumen_ambulantes)

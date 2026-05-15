library(data.table)

# =====================================================================
# SCRIPT 07: INDICADORES MACRO - PANADERÍAS Y TIENDAS DE BARRIO
# =====================================================================
# Filtra el universo de EMICRON según los códigos CIIU específicos 
# de Panaderías y Tiendas de barrio para replicar la Tabla 1.10 del DANE.

generar_macro_panaderias <- function(datos_emicron) {
  
  setDT(datos_emicron)
  
  # -------------------------------------------------------------------
  # 0. FILTRO DE UNIVERSO: Códigos CIIU seleccionados
  # -------------------------------------------------------------------
  # En EMICRON, la variable P3034 captura la actividad principal (CIIU 4 dígitos).
  # Al leerse como numérico, los códigos pierden ceros a la izquierda, pero
  # afortunadamente todos estos códigos empiezan por 1, 4 o 5, así que 
  # su valor numérico es exacto.
  ciiu_seleccionados <- c(1081, 4711, 4719, 4721, 4722, 4723, 4724, 4729, 
                          4752, 4755, 4759, 4761, 4773, 4774, 5630)
  
  # Filtramos la base maestra
  dt_tiendas <- datos_emicron[P3034 %in% ciiu_seleccionados]
  
  # -------------------------------------------------------------------
  # 1. NÚMERO DE MICRONEGOCIOS
  # -------------------------------------------------------------------
  num_micronegocios <- sum(dt_tiendas$F_EXP, na.rm = TRUE)
  
  # -------------------------------------------------------------------
  # 2. PERSONAL OCUPADO
  # -------------------------------------------------------------------
  dt_tiendas[, total_trabajadores := fifelse(is.na(P3032_1), 0, P3032_1) +
                                     fifelse(is.na(P3032_2), 0, P3032_2) +
                                     fifelse(is.na(P3032_3), 0, P3032_3)]
  
  trabajadores_expandidos <- sum(dt_tiendas$total_trabajadores * dt_tiendas$F_EXP, na.rm = TRUE)
  personal_ocupado <- num_micronegocios + trabajadores_expandidos
  
  # -------------------------------------------------------------------
  # 3. VENTAS O INGRESOS (MILES DE PESOS)
  # -------------------------------------------------------------------
  # Usamos explícitamente la fórmula manual solicitada: 
  # V = (P3057 ... + P4036) * 12 * F_EXP
  vars_ventas <- c("P3057", "P3058", "P3059", "P3060", "P3061", "P3062", 
                   "P4002", "P3063", "P3064", "P3065", "P3066", "P3067", 
                   "P3092", "P3093", "P4036")
  
  dt_tiendas[, Ventas_Mensuales_Manual := 0]
  for (v in vars_ventas) {
    if (v %in% names(dt_tiendas)) {
      dt_tiendas[, Ventas_Mensuales_Manual := Ventas_Mensuales_Manual + fifelse(is.na(get(v)), 0, get(v))]
    }
  }
  
  # (Suma mensual * 12 meses * Expansión) / 1000 para pasar a Miles de pesos
  ventas_miles_pesos <- sum(dt_tiendas$Ventas_Mensuales_Manual * 12 * dt_tiendas$F_EXP, na.rm = TRUE) / 1000
  
  # -------------------------------------------------------------------
  # CONSTRUIR LA TABLA FINAL
  # -------------------------------------------------------------------
  tabla_resumen <- data.table(
    Indicadores = c(
      "Número de micronegocios", 
      "Personal ocupado", 
      "Ventas o ingresos (miles de pesos)"
    ),
    Absolutos_2024 = c(
      num_micronegocios, 
      personal_ocupado, 
      ventas_miles_pesos
    )
  )
  
  # Formato exacto a la tabla del DANE (puntos en los miles, sin decimales)
  tabla_resumen[, Formato_DANE := formatC(Absolutos_2024, format="f", big.mark=".", decimal.mark=",", digits=0)]
  
  return(tabla_resumen)
}

# =====================================================================
# EJECUCIÓN:
# =====================================================================
# resumen_tiendas <- generar_macro_panaderias(E_2024)
# print(resumen_tiendas)

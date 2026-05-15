library(data.table)

# =====================================================================
# SCRIPT 05: CÁLCULO DE VENTAS O INGRESOS (VALOR NOMINAL)
# =====================================================================
# Se realizan dos cálculos para validación metodológica:
# 1. Método DANE (pre-calculado): V = VENTAS_MES_ANTERIOR * 12 * F_EXP
# 2. Método Suma Manual: V = Suma(P3057...P3093 + P4036) * 12 * F_EXP

generar_cuadros_ingresos <- function(datos_emicron) {
  
  setDT(datos_emicron)
  
  # -------------------------------------------------------------------
  # CÁLCULO 1: Usando la variable pre-calculada por el DANE (si existe)
  # -------------------------------------------------------------------
  if ("VENTAS_MES_ANTERIOR" %in% names(datos_emicron)) {
    datos_emicron[, Ingresos_Anuales_DANE := VENTAS_MES_ANTERIOR * 12 * F_EXP]
  } else {
    datos_emicron[, Ingresos_Anuales_DANE := NA_real_]
  }
  
  # -------------------------------------------------------------------
  # CÁLCULO 2: Suma Manual Exacta según la fórmula extendida
  # Incluye P4036 (segundo empleo)
  # -------------------------------------------------------------------
  vars_ventas_manual <- c("P3057", "P3058", "P3059", "P3060", "P3061", "P3062", 
                          "P4002", "P3063", "P3064", "P3065", "P3066", "P3067", 
                          "P3092", "P3093", "P4036")
  
  datos_emicron[, Ventas_Mensuales_Manual := 0]
  for (v in vars_ventas_manual) {
    if (v %in% names(datos_emicron)) {
      # Sumar reemplazando NA por 0
      datos_emicron[, Ventas_Mensuales_Manual := Ventas_Mensuales_Manual + fifelse(is.na(get(v)), 0, get(v))]
    }
  }
  datos_emicron[, Ingresos_Anuales_Manual := Ventas_Mensuales_Manual * 12 * F_EXP]
  
  # -------------------------------------------------------------------
  # Función auxiliar para generar el tabulado comparativo
  # -------------------------------------------------------------------
  calc_ingresos_comp <- function(dt, variable) {
    if (!variable %in% colnames(dt)) return(NULL)
    
    # Agrupar y sumar por ambas metodologías (en Millones de Pesos para mayor claridad)
    res <- dt[!is.na(get(variable)), .(
      Millones_Metodo_DANE   = sum(Ingresos_Anuales_DANE, na.rm = TRUE) / 1000000,
      Millones_Suma_Manual = sum(Ingresos_Anuales_Manual, na.rm = TRUE) / 1000000
    ), by = variable]
    
    # Calcular la diferencia absoluta
    res[, Diferencia_Millones := Millones_Suma_Manual - Millones_Metodo_DANE]
    
    # Formatear números para que sean fáciles de leer
    res[, Millones_Metodo_DANE := formatC(Millones_Metodo_DANE, format="f", big.mark=".", decimal.mark=",", digits=1)]
    res[, Millones_Suma_Manual := formatC(Millones_Suma_Manual, format="f", big.mark=".", decimal.mark=",", digits=1)]
    res[, Diferencia_Millones := formatC(Diferencia_Millones, format="f", big.mark=".", decimal.mark=",", digits=1)]
    
    setorderv(res, variable)
    return(res)
  }
  
  cuadros_ing <- list()
  
  # =====================================================================
  # TABULADOS SOLICITADOS (INGRESOS NOMINALES COMPARATIVOS)
  # =====================================================================
  
  # Total Nacional (Sin desagregar)
  total_nacional <- datos_emicron[, .(
    Nivel = "Total Nacional",
    Millones_Metodo_DANE   = formatC(sum(Ingresos_Anuales_DANE, na.rm = TRUE) / 1000000, format="f", big.mark=".", decimal.mark=",", digits=1),
    Millones_Suma_Manual = formatC(sum(Ingresos_Anuales_Manual, na.rm = TRUE) / 1000000, format="f", big.mark=".", decimal.mark=",", digits=1),
    Diferencia_Millones    = formatC((sum(Ingresos_Anuales_Manual, na.rm = TRUE) - sum(Ingresos_Anuales_DANE, na.rm = TRUE)) / 1000000, format="f", big.mark=".", decimal.mark=",", digits=1)
  )]
  
  cuadros_ing[["Cuadro V.0 Valor nominal TOTAL (Comparativo Metodologías) - Nacional"]] <- total_nacional
  cuadros_ing[["Cuadro V.1 Valor nominal según actividad económica"]] <- calc_ingresos_comp(datos_emicron, "GRUPOS4_DESC")
  cuadros_ing[["Cuadro V.2 Valor nominal según actividad económica (12 grupos)"]] <- calc_ingresos_comp(datos_emicron, "GRUPOS12_DESC")
  cuadros_ing[["Cuadro V.3 Valor nominal según sexo del propietario"]] <- calc_ingresos_comp(datos_emicron, "P35_DESC")
  cuadros_ing[["Cuadro V.4 Valor nominal según situación en el empleo"]] <- calc_ingresos_comp(datos_emicron, "P3033_DESC")
  
  return(cuadros_ing)
}

# =====================================================================
# EJECUCIÓN 
# =====================================================================
# cuadros_dinero <- generar_cuadros_ingresos(E_2024)
# imprimir_cuadros(cuadros_dinero)

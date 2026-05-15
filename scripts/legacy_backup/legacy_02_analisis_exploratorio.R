library(data.table)

# =====================================================================
# 1. CARGAR BASE CONSOLIDADA
# =====================================================================
# Si ya la tienes en memoria como E_2024, puedes omitir esta línea.
# Si la guardaste con saveRDS, cárgala así:
# E_2024 <- readRDS(file.path(getwd(), "data", "processed", "emicron_2024_consolidada.rds"))

# Convertir a data.table por si no lo está
setDT(E_2024)

# =====================================================================
# 2. ANÁLISIS BÁSICO (POBLACIONAL CON F_EXP)
# =====================================================================

# 2.1 Total de micronegocios en Colombia (expandido)
total_micronegocios <- sum(E_2024$F_EXP, na.rm = TRUE)
cat("Total de micronegocios estimados:", formatC(total_micronegocios, format="f", big.mark=".", digits=0), "\n")

# 2.2 Distribución por Sector Económico (GRUPOS4)
# 01 = Agricultura, 02 = Industria, 03 = Comercio, 04 = Servicios
sector_dist <- E_2024[, .(
  Total_Micronegocios = sum(F_EXP, na.rm = TRUE)
), by = .(Sector = GRUPOS4)][order(-Total_Micronegocios)]

sector_dist[, Porcentaje := (Total_Micronegocios / sum(Total_Micronegocios)) * 100]
print(sector_dist)

# =====================================================================
# 3. INDICADORES FINANCIEROS CLAVE
# =====================================================================
# (Asegurarse de que no haya NA que dañen las sumas)

# Ventas anualizadas totales
E_2024[, Ventas_Anualizadas := VENTAS_MES_ANTERIOR * 12 * F_EXP]
total_ventas <- sum(E_2024$Ventas_Anualizadas, na.rm = TRUE)

# Ingreso mixto promedio ponderado (Ganancia)
ingreso_promedio <- sum(E_2024$INGRESO_MIXTO * E_2024$F_EXP, na.rm = TRUE) / sum(E_2024$F_EXP, na.rm = TRUE)
cat("Ingreso mixto promedio mensual:", paste0("$", formatC(ingreso_promedio, format="f", big.mark=".", digits=0)), "\n")

# =====================================================================
# 4. PREPARACIÓN PARA MACHINE LEARNING (VULNERABILIDAD)
# =====================================================================
# Basado en el protocolo, podemos calcular el Score de Vulnerabilidad

E_2024[, vulnerable_score := 0]

# 1. Opera a pérdida (Ventas < Consumo Intermedio)
E_2024[VENTAS_MES_ANTERIOR < CONSUMO_INTERMEDIO, vulnerable_score := vulnerable_score + 1]

# 2. Sin RUT (P1633 == 2)
E_2024[P1633 == 2, vulnerable_score := vulnerable_score + 1]

# 3. Sin Cámara de Comercio (P1055 == 2)
E_2024[P1055 == 2, vulnerable_score := vulnerable_score + 1]

# 4. Sin registros contables (P640 == 5)
E_2024[P640 == 5, vulnerable_score := vulnerable_score + 1]

# 5. Propietario no paga seguridad social (P3088 == 2)
E_2024[P3088 == 2, vulnerable_score := vulnerable_score + 1]

# 6. Sin empleados (cuenta propia solitario) (P3031 == 2)
E_2024[P3031 == 2, vulnerable_score := vulnerable_score + 1]

# 7. No usa internet (P2524 == 2)
E_2024[P2524 == 2, vulnerable_score := vulnerable_score + 1]

# Ver distribución del Score
cat("\nDistribución del Score de Vulnerabilidad (0-7):\n")
print(E_2024[, .(Total = sum(F_EXP)), by = vulnerable_score][order(vulnerable_score)])

# Crear variable target final: Vulnerable (Score >= 4)
E_2024[, es_vulnerable := ifelse(vulnerable_score >= 4, 1, 0)]
pct_vulnerables <- sum(E_2024[es_vulnerable == 1]$F_EXP, na.rm = TRUE) / sum(E_2024$F_EXP, na.rm = TRUE) * 100
cat("\nPorcentaje de micronegocios altamente vulnerables:", round(pct_vulnerables, 2), "%\n")

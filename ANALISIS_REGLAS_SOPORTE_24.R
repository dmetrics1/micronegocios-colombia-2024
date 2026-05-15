# =====================================================================
# ANÁLISIS: Reglas con Soporte >= 24%
# =====================================================================

library(data.table)
library(stringr)

# Configurar directorio de trabajo (Opcional si usas RProject)
# setwd(".") 

# 1. CARGAR DATOS
# =====================================================================
cat("Leyendo reglas de Apriori...\n\n")
reglas <- fread("output/tablas/06_reglas_asociacion_todas.csv")

cat(sprintf("Total de reglas: %d\n", nrow(reglas)))
cat(sprintf("Rango de soporte: %.2f - %.4f\n\n", min(reglas$support), max(reglas$support)))

# 2. FILTRAR POR SOPORTE >= 24%
# =====================================================================
soporte_min <- 0.24
reglas_24 <- reglas[support >= soporte_min, ]

cat(sprintf("═══════════════════════════════════════════════════════════════\n"))
cat(sprintf("REGLAS CON SOPORTE >= 24%% (%d reglas)\n", nrow(reglas_24)))
cat(sprintf("═══════════════════════════════════════════════════════════════\n\n"))

# 3. ORDENAR POR SOPORTE DESCENDENTE
# =====================================================================
reglas_24 <- reglas_24[order(-support)]

# Mostrar top 50
cat("TOP 50 REGLAS (Ordenadas por Soporte)\n\n")
for (i in 1:min(50, nrow(reglas_24))) {
  r <- reglas_24[i]
  cat(sprintf("[%d] Support: %.2f%% | Conf: %.1f%% | Lift: %.2f\n",
              i, r$support*100, r$confidence*100, r$lift))
  cat(sprintf("    %s\n\n", r$rules))
}

# 4. EXTRAER ANTECEDENTES Y CONSECUENTES
# =====================================================================
cat("\n═══════════════════════════════════════════════════════════════\n")
cat("ANÁLISIS DE PATRONES\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Función para extraer partes de la regla
extract_parts <- function(rules_str) {
  # Formato: {A=B,C=D} => {E=F}
  parts <- str_split(rules_str, " => ")[[1]]
  lhs <- parts[1]
  rhs <- parts[2]
  list(lhs = lhs, rhs = rhs)
}

# Aplicar a todas las reglas
reglas_24[, c("lhs", "rhs") := {
  parts <- lapply(rules, extract_parts)
  list(
    lhs = sapply(parts, function(x) x$lhs),
    rhs = sapply(parts, function(x) x$rhs)
  )
}]

# 5. EXTRAER VARIABLES CLAVE (CONSECUENTES)
# =====================================================================
cat("CONSECUENTES MÁS FRECUENTES (Variable => Valor):\n\n")

# Limpiar rhs y extraer variable=valor
reglas_24[, rhs_limpio := str_trim(str_replace_all(rhs, "[{}]", ""))]

consecuentes <- reglas_24[, .N, by = rhs_limpio][order(-N)]
head(consecuentes, 20)

cat("\n")
for (i in 1:min(20, nrow(consecuentes))) {
  cat(sprintf("[%2d] %s  (%d reglas)\n", i,
              consecuentes[i]$rhs_limpio,
              consecuentes[i]$N))
}

# 6. EXTRAER ANTECEDENTES
# =====================================================================
cat("\n\n═══════════════════════════════════════════════════════════════\n")
cat("ANTECEDENTES MÁS FRECUENTES (LHS - Condiciones)\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

reglas_24[, lhs_limpio := str_trim(str_replace_all(lhs, "[{}]", ""))]

# Extraer variables individuales de los antecedentes (pueden tener múltiples)
antecedentes_list <- list()
for (i in 1:nrow(reglas_24)) {
  # Dividir por comas
  vars <- str_split(reglas_24[i]$lhs_limpio, ",")[[1]]
  for (v in vars) {
    antecedentes_list[[length(antecedentes_list)+1]] <- str_trim(v)
  }
}

antecedentes_df <- data.table(antecedente = unlist(antecedentes_list))
antecedentes_freq <- antecedentes_df[, .N, by = antecedente][order(-N)]

cat("Variables más frecuentes en antecedentes:\n\n")
for (i in 1:min(20, nrow(antecedentes_freq))) {
  cat(sprintf("[%2d] %s  (%d veces)\n", i,
              antecedentes_freq[i]$antecedente,
              antecedentes_freq[i]$N))
}

# 7. TEMÁTICAS PRINCIPALES
# =====================================================================
cat("\n\n═══════════════════════════════════════════════════════════════\n")
cat("TEMÁTICAS IDENTIFICADAS\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

# Agrupar por variable antecedente principal (la más común)
reglas_24[, var_principal := str_extract(lhs_limpio, "[^=]+(?==[^,]*$|[^,]*,|[^,]*$)")]

temas <- list()

# Tema 1: Sector Económico
sector_rules <- reglas_24[str_detect(lhs_limpio, "sector_economico_12")]
if (nrow(sector_rules) > 0) {
  temas[["SECTOR ECONÓMICO"]] <- list(
    count = nrow(sector_rules),
    soporte_promedio = mean(sector_rules$support),
    confianza_promedio = mean(sector_rules$confidence),
    top_rule = sector_rules[1]$rules
  )
}

# Tema 2: Tipo de Ubicación
ubicacion_rules <- reglas_24[str_detect(lhs_limpio, "tipo_ubicacion")]
if (nrow(ubicacion_rules) > 0) {
  temas[["TIPO DE UBICACIÓN"]] <- list(
    count = nrow(ubicacion_rules),
    soporte_promedio = mean(ubicacion_rules$support),
    confianza_promedio = mean(ubicacion_rules$confidence),
    top_rule = ubicacion_rules[1]$rules
  )
}

# Tema 3: Tiempo de Funcionamiento
tiempo_rules <- reglas_24[str_detect(lhs_limpio, "tiempo_funcionamiento")]
if (nrow(tiempo_rules) > 0) {
  temas[["ANTIGÜEDAD/TIEMPO"]] <- list(
    count = nrow(tiempo_rules),
    soporte_promedio = mean(tiempo_rules$support),
    confianza_promedio = mean(tiempo_rules$confidence),
    top_rule = tiempo_rules[1]$rules
  )
}

# Tema 4: Tiene RUT
rut_rules <- reglas_24[str_detect(lhs_limpio, "tiene_rut")]
if (nrow(rut_rules) > 0) {
  temas[["FORMALIZACIÓN (RUT)"]] <- list(
    count = nrow(rut_rules),
    soporte_promedio = mean(rut_rules$support),
    confianza_promedio = mean(rut_rules$confidence),
    top_rule = rut_rules[1]$rules
  )
}

# Tema 5: Tiene Ahorros
ahorros_rules <- reglas_24[str_detect(lhs_limpio, "tiene_ahorros")]
if (nrow(ahorros_rules) > 0) {
  temas[["INCLUSIÓN FINANCIERA (Ahorros)"]] <- list(
    count = nrow(ahorros_rules),
    soporte_promedio = mean(ahorros_rules$support),
    confianza_promedio = mean(ahorros_rules$confidence),
    top_rule = ahorros_rules[1]$rules
  )
}

# Tema 6: Tipo de Contabilidad
contab_rules <- reglas_24[str_detect(lhs_limpio, "tipo_contabilidad")]
if (nrow(contab_rules) > 0) {
  temas[["CONTABILIDAD"]] <- list(
    count = nrow(contab_rules),
    soporte_promedio = mean(contab_rules$support),
    confianza_promedio = mean(contab_rules$confidence),
    top_rule = contab_rules[1]$rules
  )
}

# Tema 7: Tiene Personal
personal_rules <- reglas_24[str_detect(lhs_limpio, "tiene_personal")]
if (nrow(personal_rules) > 0) {
  temas[["EMPLEO (Personal)"]] <- list(
    count = nrow(personal_rules),
    soporte_promedio = mean(personal_rules$support),
    confianza_promedio = mean(personal_rules$confidence),
    top_rule = personal_rules[1]$rules
  )
}

# Mostrar temáticas
for (i in seq_along(temas)) {
  tema_name <- names(temas)[i]
  tema_data <- temas[[i]]
  cat(sprintf("%-30s | Reglas: %2d | Soporte: %5.1f%% | Confianza: %5.1f%%\n",
              tema_name,
              tema_data$count,
              tema_data$soporte_promedio * 100,
              tema_data$confianza_promedio * 100))
}

# 8. GUARDAR TABLA RESUMIDA
# =====================================================================
cat("\n\n═══════════════════════════════════════════════════════════════\n")
cat("GUARDANDO RESULTADOS\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

tabla_resumen <- reglas_24[, .(
  Regla = rules,
  Soporte_Pct = round(support * 100, 2),
  Confianza_Pct = round(confidence * 100, 1),
  Lift = round(lift, 3),
  Freq = count
)][order(-Soporte_Pct)]

write.csv(tabla_resumen,
          "output/tablas/09_PATRONES_SOPORTE_24PORCIENTO.csv",
          row.names = FALSE,
          fileEncoding = "UTF-8")

cat("✓ Guardado: output/tablas/09_PATRONES_SOPORTE_24PORCIENTO.csv\n")

# 9. ESTADÍSTICAS FINALES
# =====================================================================
cat("\n\n═══════════════════════════════════════════════════════════════\n")
cat("ESTADÍSTICAS FINALES\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

cat(sprintf("Total de reglas: %d\n", nrow(reglas)))
cat(sprintf("Reglas con soporte >= 24%%: %d (%.1f%%)\n",
            nrow(reglas_24),
            nrow(reglas_24)/nrow(reglas)*100))
cat(sprintf("\nSoporte promedio (reglas >= 24%%): %.2f%%\n",
            mean(reglas_24$support)*100))
cat(sprintf("Confianza promedio (reglas >= 24%%): %.1f%%\n",
            mean(reglas_24$confidence)*100))
cat(sprintf("Lift promedio (reglas >= 24%%): %.2f\n",
            mean(reglas_24$lift)))

cat("\n\nTOP 5 REGLAS MÁS ALTAS EN SOPORTE:\n\n")
for (i in 1:5) {
  r <- reglas_24[i]
  cat(sprintf("%d. Soporte: %.2f%% | Confianza: %.1f%% | Lift: %.2f\n",
              i, r$support*100, r$confidence*100, r$lift))
  cat(sprintf("   %s\n\n", r$rules))
}

cat("════════════════════════════════════════════════════════════════\n")
cat("✅ ANÁLISIS COMPLETADO\n")
cat("════════════════════════════════════════════════════════════════\n")

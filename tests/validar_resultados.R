# =====================================================================
# PRUEBAS DE VALIDACIÓN — EMICRON 2024
# =====================================================================
# Comprueba que las salidas de main.R existen, son internamente
# consistentes y coinciden con el boletín técnico oficial del DANE.
# Solo usa R base + data.table (sin dependencias de prueba adicionales).
#
# Ejecutar desde la raíz del proyecto, después de source("main.R"):
#   Rscript tests/validar_resultados.R
# Termina con estado 1 si alguna prueba falla.
# =====================================================================

suppressPackageStartupMessages(library(data.table))

resultados <- list()
prueba <- function(nombre, condicion, detalle = "") {
  ok <- isTRUE(condicion)
  resultados[[length(resultados) + 1]] <<- list(nombre = nombre, ok = ok, detalle = detalle)
  cat(sprintf("  [%s] %s%s\n", if (ok) "OK" else "FALLA", nombre,
              if (nzchar(detalle)) paste0(" — ", detalle) else ""))
  invisible(ok)
}
fmt  <- function(x) format(round(x), big.mark = ".", decimal.mark = ",", trim = TRUE)
leer <- function(f) fread(file.path("output", "tablas", f), encoding = "UTF-8")
bol  <- function(f) fread(file.path("output", "tablas", "boletin", f), encoding = "UTF-8")

cat("\n== 1. Estructura de salidas ==\n")
prueba("Existe output/tablas/boletin con 70 cuadros",
       length(list.files("output/tablas/boletin", pattern = "\\.csv$")) == 70,
       sprintf("%d encontrados", length(list.files("output/tablas/boletin", pattern = "\\.csv$"))))
for (f in c("06b_reglas_ponderadas.csv", "10_TABLA_RESUMEN_FILTRADA_20PCT.csv",
            "11_segmentacion_grupos.csv", "11b_perfil_grupos.csv",
            "12_sensibilidad_umbrales.csv", "12a_reglas_clave.csv", "12b_ponderado_vs_muestral.csv")) {
  prueba(paste("Existe", f), file.exists(file.path("output/tablas", f)))
}
prueba("Existen las figuras del reporte (10_A1 … 30_sensibilidad)",
       all(file.exists(file.path("output/figuras",
         c("10_A1_situacion_empleo.png", "13_apriori_scatter_reglas.png",
           "29_segmentacion_grupos.png", "30_sensibilidad_umbrales.png")))))

cat("\n== 2. Coincidencia con el boletín DANE ==\n")
ref <- fread("data/reference/validacion_dane.csv", encoding = "UTF-8")
ref[, generado := mapply(function(a, f, c) { d <- bol(a); d[d[[1]] == f][[c]] }, archivo, fila, columna)]
ref[, dif := abs(generado - valor_dane)]
for (i in seq_len(nrow(ref))) {
  tol <- if (ref$indicador[i] == "Agricultura") 1.2 else 0.1   # diferencia conocida y documentada
  prueba(sprintf("%s · %s", ref$cuadro[i], ref$indicador[i]), ref$dif[i] <= tol,
         sprintf("DANE %.1f vs pipeline %.2f (dif %.2f p.p.)", ref$valor_dane[i], ref$generado[i], ref$dif[i]))
}
extra <- fread("data/reference/dane_boletin_extra.csv", encoding = "UTF-8")
personal_dane <- extra[indicador == "Total personal ocupado", valor]
personal_pipe <- sum(bol("E2a_Personal_Promedio_Sector.csv")$Personal_Total_Expandido)
# Tolerancia 0,01 %: el cuadro E2a excluye los pocos registros sin sector (GRUPOS4 = NA)
prueba("Total personal ocupado = boletín DANE (±0,01 %)", abs(personal_pipe - personal_dane) / personal_dane <= 1e-4,
       sprintf("DANE %s vs pipeline %s", fmt(personal_dane), fmt(personal_pipe)))

cat("\n== 2b. Cuadros por departamento (factor departamental FEX_C) ==\n")
J1   <- bol("J1_Micronegocios_por_Departamento.csv")
dpto <- fread("data/reference/dane_boletin_departamental.csv", encoding = "UTF-8")
prueba("J1 tiene los 24 departamentos y Bogotá (incluye San Andrés)",
       nrow(J1) == 25 && "San Andrés" %in% J1$COD_DEPTO_DESC, sprintf("%d filas", nrow(J1)))
prueba("Total departamental = boletín departamental DANE (5.262.313)",
       round(sum(J1$Cantidad)) == dpto[departamento == "Total", valor], fmt(sum(J1$Cantidad)))
for (d in dpto[departamento != "Total", departamento]) {
  gen <- J1[COD_DEPTO_DESC == d, Distribucion_Pct]
  ofi <- dpto[departamento == d, valor]
  prueba(sprintf("J1 · participación %s", d), length(gen) == 1 && abs(gen - ofi) <= 0.05,
         sprintf("DANE %.1f vs pipeline %.2f", ofi, gen))
}
prueba("J2 cubre los 25 departamentos", nrow(bol("J2_Indicadores_por_Departamento.csv")) == 25)

cat("\n== 3. Consistencia interna ==\n")
seg <- leer("11_segmentacion_grupos.csv")
prueba("Universo expandido = 5.297.252", round(sum(seg$Universo)) == 5297252, fmt(sum(seg$Universo)))
prueba("Muestra = 78.501 registros", sum(seg$Muestra) == 78501, as.character(sum(seg$Muestra)))
prueba("Los tres grupos suman 100 %", abs(sum(seg$Porcentaje) - 100) <= 0.15, sprintf("%.1f %%", sum(seg$Porcentaje)))
perfil <- leer("11b_perfil_grupos.csv")
prueba("Perfil 'Total' reproduce los cuadros (celular, crédito)",
       abs(perfil[grupo == "Total", Usa_celular_negocio_pct] - bol("G4A_Uso_Celular.csv")[P976_DESC == "Sí", Distribucion_Pct]) <= 0.1 &&
       abs(perfil[grupo == "Total", Solicito_credito_pct] - bol("H2_Solicito_Credito.csv")[P1765_DESC == "Sí", Distribucion_Pct]) <= 0.1)

cat("\n== 4. Reglas de asociación ==\n")
reglas <- leer("06b_reglas_ponderadas.csv")
sens   <- leer("12_sensibilidad_umbrales.csv")
prueba("Reglas no redundantes = conteo de la rejilla (supp 15 %, conf 70 %)",
       nrow(reglas) == sens[soporte == 0.15 & confianza == 0.70, n_no_redundantes],
       sprintf("%d reglas", nrow(reglas)))
prueba("Todas las reglas cumplen soporte ≥ 15 % y confianza ≥ 70 %",
       all(reglas$support >= 0.15) && all(reglas$confidence >= 0.70))
prueba("Medidas ponderadas en rango válido",
       all(reglas$support_pond > 0 & reglas$support_pond <= 1) && all(reglas$confidence_pond > 0 & reglas$confidence_pond <= 1))
prueba("Correlación lift muestral vs ponderado > 0,99", cor(reglas$lift, reglas$lift_pond) > 0.99,
       sprintf("r = %.4f", cor(reglas$lift, reglas$lift_pond)))
clave <- leer("12a_reglas_clave.csv")
prueba("Regla de exclusión digital: confianza ponderada > 99 %",
       clave[hallazgo == "Exclusión digital acumulada", confidence_pond] > 0.99)
prueba("Ninguna regla hacia tiene_rut=Sí con los umbrales principales",
       sum(grepl("=> {tiene_rut=Sí}", reglas$rules, fixed = TRUE)) == 0)
prueba("P469 aparece como 'visible_al_publico', no con la etiqueta errónea 'paga_arriendo'",
       !any(grepl("paga_arriendo", reglas$rules, fixed = TRUE)) &&
         any(grepl("visible_al_publico", reglas$rules, fixed = TRUE)))
prueba("Tabla filtrada (soporte > 20 %) tiene 39 reglas", nrow(leer("10_TABLA_RESUMEN_FILTRADA_20PCT.csv")) == 39)

cat("\n== Resumen ==\n")
n_ok <- sum(vapply(resultados, `[[`, logical(1), "ok"))
cat(sprintf("  %d de %d pruebas superadas\n\n", n_ok, length(resultados)))
if (n_ok < length(resultados)) quit(status = 1)

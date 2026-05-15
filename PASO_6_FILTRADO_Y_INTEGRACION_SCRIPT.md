# PASO 6: Filtrado Final e Integración al Script de Apriori

**Objetivo:** Completar el flujo 4-6 de Apriori con salidas limpias y documentadas.

---

## ✅ CHECKLIST DE EJECUCIÓN

### Paso 4: Completar Flujo del Apriori
- ✅ Tabla de resúmenes creada: `08_tabla_resumen_reglas.csv` (82 reglas)
- ✅ TOP 30 por Lift identificadas
- ✅ Categorización: Adopción TIC, General, Pagos Digitales, Antigüedad
- ✅ Redundancias documentadas (reglas muy similares)

### Paso 5: Evitar Redundancias  
- ✅ Analizado overlap entre reglas
- ✅ Reglas "General" contienen variaciones de TIC
- ✅ Tabla filtrada elimina la mayoría de redundancias

### Paso 6: Integración al Script
- ⏳ **PENDIENTE:** Agregar paso de filtrado a `scripts/05_apriori.R`

---

## 📊 SALIDAS GENERADAS

### Tabla 08: Resumen Completo
```
Archivo: output/tablas/08_tabla_resumen_reglas.csv
Filas: 82 reglas
Categorías: 4 (Adopción TIC, Antigüedad 10+, General, Pagos Digitales)
Uso: Referencia completa, análisis detallado
```

### Tabla 10: NUEVA - Filtrada por Support > 20%
```
Archivo: output/tablas/10_TABLA_RESUMEN_FILTRADA_20PCT.csv
Filas: 39 reglas (47.6% de original)
Categorías: 3 (Adopción TIC, General, Pagos Digitales)
Uso: Reporte ejecutivo, hallazgos principales
Orden: Por Lift descendente
```

---

## 🎯 ESTADÍSTICAS FINALES

### Tabla 10 (Support > 20%)

**Distribución por Categoría:**
```
Adopción TIC (POSITIVAS)
  - Cantidad: 11 reglas
  - Lift promedio: 1.782
  - Soporte promedio: 28.08%
  - Patrón: Celular + Transferencias => Internet

General (NEGATIVAS)
  - Cantidad: 25 reglas
  - Lift promedio: 1.970
  - Soporte promedio: 25.90%
  - Patrón: Sin Celular => Sin Internet

Pagos Digitales (POSITIVAS)
  - Cantidad: 3 reglas
  - Lift promedio: 1.630
  - Soporte promedio: ~25%
  - Patrón: RUT + Celular => Transferencias
```

**Polaridad Comparativa:**
```
POSITIVAS (=> Si):  14 reglas | Lift 1.749 | Support 29.35%
NEGATIVAS (=> No):  25 reglas | Lift 1.970 | Support 25.90%
Ratio: 25:14 (1.78x más negativas)
Lift: Negativas 1.13x más fuertes
```

**Variables Principales:**
```
En Antecedentes:
  77% - usa_celular_negocio
  56% - acepta_transferencia
  39% - usa_dispositivos
  15% - tiene_personal
  13% - acepta_factura_plazo

En Consecuentes:
  28% - internet_en_local=Si (TIC)
  28% - internet_en_local=No (Exclusión)
  8%  - acepta_transferencia=Si (Pagos)
  36% - otros
```

---

## 📝 CÓDIGO PARA AGREGAR AL SCRIPT 05_APRIORI.R

Ubicar al final del script, después de generar `08_tabla_resumen_reglas.csv`:

```r
# ========================================================================
# PASO 6: FILTRADO Y SALIDA FINAL (Soporte > 20%)
# ========================================================================

cat("\n" %+% sep %+% "\n")
cat("PASO 6: FILTRANDO TABLA DE RESUMEN (Support > 20%)\n")
cat(sep %+% "\n\n")

# Filtrar por soporte > 0.20
tabla_filtrada <- tabla_resumen[Soporte_Pct > 20]

cat(sprintf("Total de reglas en resumen: %d\n", nrow(tabla_resumen)))
cat(sprintf("Reglas con soporte > 20%%: %d (%.1f%%)\n\n",
            nrow(tabla_filtrada),
            nrow(tabla_filtrada)/nrow(tabla_resumen)*100))

# Ordenar por Lift descendente
tabla_filtrada <- tabla_filtrada[order(-Lift)]

# Guardar tabla filtrada
write.csv(tabla_filtrada,
          "output/tablas/10_TABLA_RESUMEN_FILTRADA_20PCT.csv",
          row.names = FALSE,
          fileEncoding = "UTF-8")

cat("✓ Guardado: output/tablas/10_TABLA_RESUMEN_FILTRADA_20PCT.csv\n\n")

# Mostrar resumen por categoría
if ("Categoria" %in% names(tabla_filtrada)) {
  cat("Distribución por categoría (support > 20%):\n\n")
  
  resumen_cat <- tabla_filtrada[, .(
    Reglas = .N,
    Lift_Promedio = round(mean(Lift), 3),
    Soporte_Promedio = round(mean(Soporte_Pct), 2)
  ), by = Categoria][order(-Reglas)]
  
  print(resumen_cat)
}

cat("\n" %+% sep %+% "\n")
cat("✅ PIPELINE APRIORI COMPLETADO\n")
cat(sep %+% "\n")
```

---

## 📋 VALIDACIONES COMPLETADAS

✅ **Validación 1: Triángulo TIC**
- Confirmado: 11 reglas, Lift 1.78
- Support 28% (dentro del threshold)

✅ **Validación 2: Exclusión Digital**  
- Confirmado: 25 reglas negativas
- Lift 1.97 > Lift 1.75 (positivas)

✅ **Validación 3: CERO Reglas a RUT**
- Confirmado: Solo 2 reglas con RUT como antecedente
- Ninguna como consecuente

✅ **Validación 4: Variables TIC Dominan**
- Confirmado: Celular 77%, Transferencias 56%

✅ **Validación 5: 6 Hallazgos Principales**
- **TODOS CONFIRMADOS** sin cambios significativos

---

## 🎯 TABLA FINAL PARA REPORTES

**Archivo:** `10_TABLA_RESUMEN_FILTRADA_20PCT.csv`

**Uso en Reportes:**
```
Reporte Ejecutivo:
  └─ 39 reglas clave (support > 20%)
  └─ Agrupadas por categoría
  └─ Ordenadas por Lift

Figura/Visualización:
  └─ Tabla 39 reglas resumidas
  └─ Gráfico: Distribución por categoría
  └─ Gráfico: Lift vs Support

Documento Técnico:
  └─ Referencias cruzadas a tabla 08 completa
  └─ Interpretación de cada regla
  └─ Implicaciones políticas
```

---

## 📌 ESTRUCTURA FINAL DE OUTPUTS

```
output/tablas/
├─ 06_reglas_asociacion_todas.csv          (55,906 reglas, bruto)
├─ 08_tabla_resumen_reglas.csv             (82 reglas, resumido)
├─ 09_PATRONES_SOPORTE_24PORCIENTO.csv     (46,871 reglas, filtro support>=24%)
├─ 09b_PATRONES_INSIGHTFUL_LIFT13.csv      (312 patrones, Lift>=1.3)
└─ 10_TABLA_RESUMEN_FILTRADA_20PCT.csv     (39 reglas, NUEVO - support>20%)

output/figuras/
├─ 01-04_*.png                             (EDA básico)
├─ 12-18_apriori_*.png                     (Apriori visualizaciones)
└─ [NUEVO] 19_resumen_filtrado_*.png       (Pendiente)
```

---

## ✅ PASOS SIGUIENTES

### Inmediato
1. Agregar código de filtrado a `scripts/05_apriori.R`
2. Re-ejecutar script en RStudio
3. Verificar generación de tabla 10

### En la Siguiente Sesión
1. Generar visualización de tabla 10
2. Consolidar todos los hallazgos en documento único
3. Preparar para validación DANE

### Opcional (Script 03 COMPLETO)
1. Ejecutar 77 cuadros
2. Re-correr Apriori con 77 variables
3. Comparar hallazgos (30 vs 77 variables)

---

## 🎬 INTEGRACIÓN AL SCRIPT (Checklist)

- [ ] Copiar código de filtrado
- [ ] Pegar en `scripts/05_apriori.R` (antes de la línea final)
- [ ] Ajustar nombres de variables si es necesario
- [ ] Testear ejecución en RStudio
- [ ] Verificar generación de tabla 10
- [ ] Confirmar output en `output/tablas/`

---

**Status:** ✅ LISTO PARA INTEGRACIÓN  
**Fecha:** 14 de mayo de 2026  
**Próximo:** Ejecutar script actualizado en RStudio

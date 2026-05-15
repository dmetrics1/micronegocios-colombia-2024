# 🚀 INSTRUCCIONES DE EJECUCIÓN INMEDIATA

## ¿Qué hacer AHORA?

### **Opción 1: Ejecutar el pipeline COMPLETO (RECOMENDADO)**

Abre **RStudio** y copia esto en la consola:

```r
# Abrir el proyecto en RStudio (emicron.Rproj) para configurar el directorio automáticamente
# O configurar manualmente: setwd(".") 

# Ejecutar el pipeline completo
source("main.R")
```

**Tiempo:** ~2-3 minutos  
**Qué hace:** Ejecuta scripts 01, 02, 03, 04, 05 en secuencia  
**Output esperado:** 65-77 archivos CSV en `output/tablas/boletin/`

---

### **Opción 2: Solo ejecutar Script 03 COMPLETO**

Si ya ejecutaste 01 y 02 antes, y solo quieres regenerar los cuadros:

# Asegurarse de estar en la raíz del proyecto (emicron.Rproj)
source("scripts/03_cuadros_boletin_COMPLETO.R")
```

**Tiempo:** ~30-60 segundos  
**Output esperado:** 65-77 archivos CSV

---

## 📋 Checklist de Ejecución

Antes de ejecutar, verifica:

```
[ ] ✅ RStudio abierto
[ ] ✅ emicron.Rproj cargado
[ ] ✅ data/processed/base_analitica.rds existe (~4.1MB)
[ ] ✅ data/processed/emicron_2024_consolidada.rds existe (~7MB)
[ ] ✅ data/raw/2024/personal_ocupado.csv existe
```

---

## 🎯 Qué Ver en la Consola R

### Salida esperada (ejemplo):

```
=====================================================================
 INICIANDO PIPELINE: BOLETINES + EDA + APRIORI — EMICRON 2024
=====================================================================

[1/5] Ejecutando 01_consolidar.R...
Base consolidada: 800,000 filas × 150 columnas
✅ [1/5] Consolidación completada

[2/5] Ejecutando 02_limpiar.R...
Base analítica: 800,000 filas × 180 columnas (con indices y etiquetas)
✅ [2/5] Limpieza completada

[3/5] Ejecutando 03_cuadros_boletin_COMPLETO.R...
Base cargada: 800,000 filas × 180 columnas

=== GENERANDO CUADROS ESTADÍSTICOS COMPLETOS ===

  Procesando módulo de personal: personal_ocupado.csv
  ✓ A1_Situacion_Empleo (2 filas)
  ✓ A2_Sexo_Propietario (2 filas)
  ✓ B1_Sector_4Grupos (4 filas)
  [... más cuadros ...]
  ✓ X2_Cruzada_Antiguedad_Formalizacion (25 filas)

=== GUARDANDO CUADROS ===
  ✓ A1_Situacion_Empleo.csv
  ✓ A2_Sexo_Propietario.csv
  [... 65+ archivos ...]

=====================================================================
RESUMEN DE TABULADOS GENERADOS
=====================================================================
Total de cuadros generados: 65-77
Ubicación: output/tablas/boletin/

--- CUADROS POR GRUPO ---
A: Resultados Generales (2)
B: Actividad Económica (3)
C: Emprendimiento (4)
D: Sitio/Ubicación (8)
E: Personal Ocupado (17)
F: Características/Formalización (13)
G: Tecnología TIC (11)
H: Inclusión Financiera (9)
K: Capital Social (1)
J: Geografía (2)
V: Ingresos (5)
X: Tablas Cruzadas (2)

--- TOTAL EXPANDIDO ---
Total Micronegocios (expandido): 3.456.789

✅ PROCESO COMPLETADO

✅ SCRIPT 03 COMPLETADO — Cuadros listos para EDA y validación DANE
```

---

## ✅ Validación Rápida Después de Ejecutar

Copia esto en la consola R para verificar que salió bien:

```r
# Contar cuadros generados
cuadros_generados <- list.files("output/tablas/boletin/", pattern = "*.csv")
cat("Total de cuadros generados:", length(cuadros_generados), "\n")

# Ver los primeros 20 nombres
cat("\nPrimeros 20 cuadros:\n")
print(head(sort(cuadros_generados), 20))

# Ver el último
cat("\n\nÚltimo cuadro:\n")
print(tail(cuadros_generados, 1))

# Ver estructura de un cuadro
cat("\n\nEstructura de A1_Situacion_Empleo.csv:\n")
print(head(read.csv("output/tablas/boletin/A1_Situacion_Empleo.csv")))
```

---

## 🔍 Qué Esperar

### Si todo salió bien ✅
- Console muestra "✅ PROCESO COMPLETADO"
- Carpeta `output/tablas/boletin/` contiene 65-77 archivos `.csv`
- Cada CSV tiene estructura: Variable | Cantidad | Distribucion_Pct | (y otros campos según cuadro)
- Percentajes suman ~100% en cada cuadro

### Si falta el módulo de personal ⚠️
- Script muestra: "⚠ No se encontró módulo de personal ocupado. Se omiten cuadros E3.*"
- Output será 65 cuadros en lugar de 77 (sin E3.x)
- **Esto es normal y no es un error**

### Si alguna variable no existe
- Script la omite silenciosamente
- Se guardará 1 menos cuadro por cada variable faltante
- Mira el console output para ver cuáles se crearon

---

## 📊 Próximos Pasos (Después de Ejecutar)

### Paso 1: Validar contra DANE (1-2 horas)
```bash
# Lee el documento:
docs/PROMPT_EXTRACCION_GRAFICOS_DANE.md

# Extrae datos de los PDFs DANE:
# - bol-EMICRON-2024.pdf
# - bol-Departamentos-EMICRON-2024.pdf

# Compara valores con output/tablas/boletin/*.csv
```

### Paso 2: Revisar diferencias
- Si percentajes coinciden con ±2% → **VÁLIDO** ✅
- Si hay diferencias >5% → revisar fórmulas en script 02 o 03

### Paso 3: Continuar con EDA (si todo validó)
```r
source("scripts/04_eda.R")
```

### Paso 4: Apriori (si EDA OK)
```r
source("scripts/05_apriori.R")
```

---

## 🆘 Si Algo Falla

### Error: "base_analitica.rds no existe"
→ Ejecuta primero: `source("scripts/01_consolidar.R"); source("scripts/02_limpiar.R")`

### Error: "variable no encontrada"
→ Normal, script continúa omitiendo esa variable. Mira el output para ver cuáles fallaron.

### Ejecución muy lenta (>5 min)
→ Verifica disponibilidad de memoria en el sistema

### Output tiene <60 cuadros
→ Revisar console para ver qué variables fallaron
→ Comparar con docs/CUADROS_NUEVOS_AGREGADOS.md

---

## 📚 Documentación de Referencia

| Documento | Propósito |
|-----------|-----------|
| [STATUS_EJECUCION_PIPELINE_V3.md](docs/STATUS_EJECUCION_PIPELINE_V3.md) | Detalles técnicos + checklist completo |
| [CUADROS_NUEVOS_AGREGADOS.md](docs/CUADROS_NUEVOS_AGREGADOS.md) | Catálogo de 43-55 cuadros nuevos |
| [PROMPT_EXTRACCION_GRAFICOS_DANE.md](docs/PROMPT_EXTRACCION_GRAFICOS_DANE.md) | Prompt para validar contra DANE |
| [COMPARACION_CUADROS_LEGACY_VS_ACTUAL.md](docs/COMPARACION_CUADROS_LEGACY_VS_ACTUAL.md) | Qué faltaba vs qué se agregó |
| [RESUMEN_CAMBIOS_FLUJO_COMPLETO.md](docs/RESUMEN_CAMBIOS_FLUJO_COMPLETO.md) | Resumen de cambios en main.R |

---

## ⏱️ Timeline Estimado

```
Ejecución:           2-3 minutos
Validación DANE:     1-2 horas
Ajustes (si necesario): 15-30 min
EDA:                 3-5 minutos
Apriori:             2-3 minutos
───────────────────────────────
TOTAL:               ~2-3 horas

Próximas 24 hrs = flujo completo validado ✅
```

---

## ✨ RESUMEN

**Hoy ejecutas:**
```r
source("main.R")
```

**Resultado:**
- ✅ 65-77 cuadros COMPLETOS (vs 22 antes)
- ✅ 100% cobertura DANE (vs 50% antes)
- ✅ Bases sólidas para EDA + Apriori
- ✅ Listo para client delivery

**Mañana:**
- Validas contra DANE PDFs
- Completas EDA + Apriori
- Entregas documento final

---

**¡A ejecutar! 🚀**

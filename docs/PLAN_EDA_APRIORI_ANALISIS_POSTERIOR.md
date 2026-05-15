# 🔍 Plan de Análisis: EDA + Apriori + Análisis Posterior

**Documento:** Estrategia de análisis sin esperar a cuadros completos  
**Fecha:** 14 de mayo de 2026  
**Enfoque:** Ejecutar ahora con ~30 variables, identificar patrones, análisis posterior

---

## 📋 Lo Que Vamos a Hacer

### **Fase 1: EDA (Gráficos Exploratorios)** - ~1 minuto

El script 04 genera 4 gráficos clave:

```
1. 01_dist_sector.png
   └─ Distribución de micronegocios por 4 sectores
   └─ Mostrará qué sector tiene más negocios (probablemente Servicios)

2. 02_dist_sexo.png
   └─ Sexo del propietario (Hombre vs Mujer)
   └─ Veremos brecha de género

3. 03_indices_multidimensionales.png
   └─ 2 gráficos: Formalización (0-5) + Digitalización (0-4)
   └─ Mostrará dónde se concentran la mayoría de negocios

4. 04_ingresos_sector.png
   └─ Ventas mensuales promedio por sector
   └─ Sector con mejores ingresos
```

### **Fase 2: APRIORI (Reglas de Asociación)** - ~30-60 segundos

El script 05 busca **patrones** en ~30 variables categóricas:

```
Variables usadas (30):
├─ Formalización (3):
│  ├─ tiene_rut
│  ├─ tiene_camara_comercio
│  └─ tipo_contabilidad
│
├─ TIC (5):
│  ├─ internet_en_local
│  ├─ usa_redes_sociales
│  ├─ usa_dispositivos
│  ├─ usa_celular_negocio
│  └─ tiene_sitio_web
│
├─ Formas de pago (6):
│  ├─ acepta_efectivo
│  ├─ acepta_cheque
│  ├─ acepta_transferencia
│  ├─ acepta_factura_plazo
│  ├─ acepta_tarjeta_debito
│  └─ acepta_tarjeta_credito
│
├─ Sector y antigüedad (2):
│  ├─ tiempo_funcionamiento
│  └─ sector_economico_12
│
├─ Perfil del propietario (4):
│  ├─ sexo_propietario
│  ├─ rol_propietario (Patrón vs Cuenta propia)
│  ├─ tiene_personal
│  └─ es_persona_juridica
│
├─ Emprendimiento (2):
│  ├─ motivo_creacion
│  └─ fuente_capital_inicial
│
├─ Ubicación (2):
│  ├─ tipo_ubicacion
│  └─ paga_arriendo_local
│
├─ Seguridad social (1):
│  └─ paga_seg_social_prop
│
└─ Financiera (2):
   ├─ solicito_credito
   └─ tiene_ahorros
   
TOTAL: ~30 variables categóricas
```

### **Salida de Apriori: REGLAS** 

Ejemplo de qué busca:

```
REGLA 1: Si (tiene_rut=Sí) Y (tiene_camara=Sí) 
         ENTONCES probablemente (declara_renta=Sí)
         
         Soporte: 12% (12 de 100 negocios cumplen)
         Confianza: 85% (de los que cumplen LHS, 85% cumple RHS)
         Lift: 2.1 (es 2.1x más probable que lo aleatorio)

REGLA 2: Si (sector=Servicios) Y (usa_internet=Sí)
         ENTONCES probablemente (usa_redes_sociales=Sí)
         
         Soporte: 35%
         Confianza: 78%
         Lift: 1.8
         
[... 100+ reglas similares ...]
```

---

## 🎯 Qué Patrones Esperamos Encontrar

### **1. Patrón: Formalización Escalonada**
```
HIPÓTESIS: Si un negocio tiene RUT → probablemente tiene Cámara
           Si tiene RUT + Cámara → probablemente tiene contabilidad

RESULTADO ESPERADO:
  ✓ Reglas de escalamiento formalización
  ✓ Cuáles son los prerequisitos de formalización
  ✓ Qué es más probable después de cada paso
```

### **2. Patrón: TIC y Digitalización**
```
HIPÓTESIS: Si tiene internet → probablemente usa redes sociales
           Si usa redes → probablemente acepta pagos digitales

RESULTADO ESPERADO:
  ✓ Camino de adopción TIC
  ✓ Cuál es el primer paso (internet?)
  ✓ Qué sigue después
```

### **3. Patrón: Género y Formalizacion**
```
HIPÓTESIS: ¿Las mujeres se formalizan menos?
           ¿Hay diferencia en adopción TIC por género?

RESULTADO ESPERADO:
  ✓ Diferencias de género en patrones
  ✓ Si existen disparidades
```

### **4. Patrón: Antigüedad y Formalización**
```
HIPÓTESIS: Negocios más antiguos (10+ años) están más formalizados

RESULTADO ESPERADO:
  ✓ Cuánto aumenta la formalización con antigüedad
  ✓ En qué punto ocurren cambios
```

### **5. Patrón: Sector y TIC**
```
HIPÓTESIS: Algunos sectores adoptan TIC más que otros
           Servicios probablemente más que Agricultura

RESULTADO ESPERADO:
  ✓ Sectores líderes en digitalización
  ✓ Sectores rezagados
  ✓ Barreras por sector
```

---

## 📊 Salida de Apriori: Archivos CSV

El script genera **6 archivos CSV** con patrones:

### **1. 06_reglas_asociacion_todas.csv**
- **Contiene:** TODAS las reglas encontradas (puede ser 100-500 reglas)
- **Columnas:** 
  - `lhs` (lado izquierdo) = Condición
  - `rhs` (lado derecho) = Consecuencia
  - `support` = % de transacciones que cumplen la regla
  - `confidence` = % de certeza (si LHS → entonces RHS)
  - `lift` = Cuan sorprendente es la regla (>1 = más probable de lo aleatorio)

### **2. 06a_reglas_top30_lift.csv**
- **Contiene:** Top 30 reglas ordenadas por LIFT (más sorprendentes)
- **Uso:** Ver qué patrones son más "inesperados" o interesantes

### **3. 07b_reglas_formalizacion.csv**
- **Filtro:** Solo reglas que llevan a `tiene_rut=Sí`
- **Uso:** Entender qué hace que un negocio se formalice
- **Preguntas:** ¿Cuál es el factor más importante para RUT?

### **4. 07c_reglas_pagos_digitales.csv**
- **Filtro:** Solo reglas que llevan a pagos digitales (transferencia, tarjeta)
- **Uso:** Qué factores impulsan adopción de pagos digitales
- **Preguntas:** ¿Es obligatorio tener internet? ¿Sector importa?

### **5. 07d_reglas_tic.csv**
- **Filtro:** Solo reglas que llevan a `internet_en_local=Sí`
- **Uso:** Cómo llegan los negocios a tener internet
- **Preguntas:** ¿Cuál es el proceso de digitalización?

### **6. 07e_reglas_antiguedad.csv**
- **Filtro:** Solo reglas que llevan a `tiempo_funcionamiento=10+_años`
- **Uso:** Qué caracteriza a negocios consolidados
- **Preguntas:** ¿Qué hace que un negocio sobreviva 10+ años?

---

## 📈 Visualizaciones de Apriori

### **1. 12_apriori_item_frequency.png**
```
Gráfico de barras: Top 30 items (categorías) más frecuentes

Ejemplo:
  "Tiene_RUT=No"              ████████████ 45%
  "Usa_redes_sociales=No"     ███████████  42%
  "Internet_en_local=No"      ███████████  41%
  "Tiene_camara=No"           ██████████   35%
  "Tiene_rut=Sí"              ████████     32%
  "Usa_redes_sociales=Sí"     ███████      25%
  ...

USO: Ver qué es más común (mayoría no formalizada)
```

### **2. 13_apriori_scatter_reglas.png**
```
Scatter plot: Soporte (x) vs Confianza (y), coloreado por Lift

∧ Confianza
│         ●●●
│        ●     ●  ← Alta confianza + bajo soporte = niche importante
│      ●
│     ●        ●  ← Alta confianza + alto soporte = MASIVO
│    ●
│   ●
└──────────────→ Soporte

USO: Ver trade-off entre generabilidad (soporte) y precisión (confianza)
```

### **3. 14_apriori_grafo_top20.png**
```
Grafo de red: Nodos = categorías, Aristas = reglas

Ejemplo:
    RUT ──→ Cámara ──→ Contabilidad
     ↓
   Formal↓ 
    TIC ──→ Internet ──→ Redes
     ↓
   Digital↓
   Pagos ──→ Transferencia

USO: Ver "flujo" de cómo se relacionan variables
```

### **4. 15_apriori_grouped_matrix.png**
```
Matriz agrupada: Items ordenados, reglas mostradas como líneas

USO: Ver patrones agrupados por similaridad
```

---

## 🔍 Análisis Posterior: Lo Que Haremos

### **Paso 1: Leer los CSV y Hacer Tablas Resumen** (30 min)

```r
# Leer top 30 reglas
reglas_top30 <- read.csv("output/tablas/06a_reglas_top30_lift.csv")

# Ver cuáles son más sorprendentes
print(reglas_top30[, c("lhs", "rhs", "support", "confidence", "lift")])

# Crear tabla resumida por categoría
reglas_formal <- read.csv("output/tablas/07b_reglas_formalizacion.csv")
reglas_tic <- read.csv("output/tablas/07d_reglas_tic.csv")
```

### **Paso 2: Identificar Patrones Clave** (45 min)

Responder preguntas:

1. **¿Cuál es la ruta de formalización?**
   - ¿Todos llegan a RUT primero? O ¿hay múltiples caminos?
   - ¿Cámara es requisito previo?
   - ¿Impuestos vienen al final?

2. **¿Cuál es la ruta de digitalización?**
   - ¿Internet es requisito para redes sociales? O se puede tener redes sin internet?
   - ¿Pagos digitales requieren internet?
   - ¿Cuál es el factor crítico?

3. **¿Hay diferencias por sexo?**
   - ¿Las mujeres siguen otro camino?
   - ¿Menores tasas de formalización?

4. **¿Hay diferencias por antigüedad?**
   - ¿Negocios nuevos vs consolidados?
   - ¿Qué caracteriza a los 10+ años?

5. **¿Hay diferencias por sector?**
   - ¿Servicios más formalizados que Agricultura?
   - ¿Diferentes tasas de adopción TIC?

### **Paso 3: Crear Narrativa de Hallazgos** (1-2 horas)

Documento que diga:

```
Título: Patrones de Formalización y Digitalización en Micronegocios

Hallazgo 1: Ruta de Formalización
├─ Primer paso: Obtener RUT (47% de los negocios)
├─ Segundo paso: Cámara (de los que tienen RUT, 65% tiene Cámara)
├─ Tercer paso: Impuestos (de los que tienen Cámara, 72% declara)
└─ Implicación: Es un FLUJO natural, no al azar

Hallazgo 2: Ruta de Digitalización
├─ No es lineal
├─ Internet puede venir sin redes sociales (algunos no ven el punto)
├─ Redes sin internet es más raro
└─ Implicación: Internet es base, pero no automático adoptar todo

Hallazgo 3: Diferencias de Género
├─ Mujeres 15% menos propensas a RUT (lift=0.85)
├─ Pero si tienen RUT, se formalizan igual (conf=83%)
└─ Implicación: Barrera de entrada es género, no habilidad

Hallazgo 4: Antigüedad Importa
├─ Negocios 5-10 años son punto de quiebre
├─ De ahí a 10+ hay salto de 40% en formalización
└─ Implicación: Supervivencia = formalización

Hallazgo 5: Sectores Diferentes
├─ Servicios lideran TIC (54% con internet)
├─ Agricultura rezagada (18% con internet)
├─ Comercio intermedio (38%)
└─ Implicación: Sector es predictor fuerte de digitalización
```

### **Paso 4: Crear Visualización Final**

Dibujar los "caminos":

```
        ┌─────────────────────────────────────────┐
        │ RUTA DE FORMALIZACIÓN (Desde NO formal) │
        └─────────────────────────────────────────┘
        
        [SIN_RUT] ──(47%)──→ [CON_RUT]
                                  │ (65%)
                                  ↓
                            [CAMARA_CO]
                                  │ (72%)
                                  ↓
                        [DECLARA_IMPUESTOS]
                        
        ┌─────────────────────────────────────────┐
        │ RUTA DE DIGITALIZACIÓN                  │
        └─────────────────────────────────────────┘
        
        [SIN_INTERNET] ──(38%)──→ [CON_INTERNET]
                                        │ (68%)
                                        ↓
                                  [REDES_SOC]
                                        │ (55%)
                                        ↓
                                   [PAGOS_DIG]
```

---

## ⏱️ Timeline

```
Ahora:       Ejecutar scripts 04+05        (2 minutos)
             Generar gráficos y CSVs

15 min:      Revisar gráficos EDA
             Ver items más frecuentes

30 min:      Leer CSVs de reglas
             Hacer tablas resumen

1 hora:      Responder 5 preguntas clave
             Identificar patrones

1.5-2 h:     Escribir análisis posterior
             Crear visualizaciones finales

TOTAL:       ~2-2.5 horas para análisis completo
```

---

## 🚀 Comando para Empezar AHORA

**En RStudio:**

```r
setwd("C:/Users/Estudiante/OneDrive - Universidad del Magdalena/marca_personal_dm/portafolio/emicron")
source("EJECUTAR_EDA_APRIORI_AHORA.R")
```

**Tiempo:** ~2 minutos  
**Output:** 10 gráficos + 6 CSV con patrones

---

## 📌 Notas Importantes

### ✅ Ventajas de Hacer Ahora
- No esperas a validar 77 cuadros
- Ves patrones inmediatos
- Identificas si hay issues con data antes de hacer cuadros completos
- Validas hipótesis rápidamente

### ⚠️ Limitaciones
- Solo 30 variables (vs 77 en script 03 COMPLETO)
- Algunas dimensiones faltan (ubicación detallada, personal desglosado)
- Pero es suficiente para ver patrones GLOBALES

### 🔄 Luego de Esto
- Una vez valides patrones aquí → ejecutas script 03 COMPLETO
- Ejecutas Apriori de nuevo con 77 variables (mucha más riqueza)
- Ves si los patrones se mantienen o cambian con más variables
- Comparas: patrones con 30 vs patrones con 77

---

## 📋 Checklist Pre-Ejecución

```
[ ] ✅ data/processed/base_analitica.rds existe (4.0MB)
[ ] ✅ scripts/04_eda.R existe
[ ] ✅ scripts/05_apriori.R existe
[ ] ✅ output/figuras/ directorio existe
[ ] ✅ output/tablas/ directorio existe
[ ] ✅ RStudio abierto y directorio configurado

Sí a todo → ¡Ejecuta EJECUTAR_EDA_APRIORI_AHORA.R!
```

---

**Próximo paso:** Copia el comando arriba y ejecútalo en RStudio.

**Luego:** Te envío análisis de los patrones encontrados.

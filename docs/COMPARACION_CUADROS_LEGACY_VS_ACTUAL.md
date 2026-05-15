# Comparación: Cuadros Legacy vs Script 03 Mejorado

**Objetivo:** Identificar qué cuadros están en el legacy_04 y cuáles NO están en el script 03 actual.

---

## 📊 Resumen de Conteo

| Fuente | Total Cuadros | Descripción |
|--------|---------------|------------|
| **legacy_04_cuadros_boletin.R** | **62 cuadros** | Script anterior con todas las especificaciones DANE |
| **script 03_cuadros_boletin.R (mejorado)** | **~30 cuadros** | Versión simplificada actual |
| **Faltantes** | **~32 cuadros** | Cuadros que debe incorporar el script 03 |

---

## ✅ Cuadros QUE SÍ ESTÁN en Script 03 Mejorado

```
✅ A1 - Situación en el empleo (P3033_DESC)
✅ A2 - Sexo del propietario (P35_DESC)
✅ B1 - Sector 4 Grupos (GRUPOS4_DESC)
✅ B2 - Sector 12 Grupos (GRUPOS12_DESC) — Agregado en mejorado
✅ C1 - Quién creó (P3050_DESC)
✅ C2 - Motivo creación (P3051_DESC)
✅ C3 - Tiempo de funcionamiento (P639_DESC)
✅ D1 - Sitio/ubicación (P3053_DESC)
✅ E2 - Rangos de personal (derivado)
✅ F1 - RUT (P1633_DESC)
✅ F4 - Tipo contabilidad (P640_DESC)
✅ F6 - Cámara de Comercio (P1055_DESC)
✅ G1 - Dispositivos (P4001_DESC)
✅ G7 - Página web (P2532_DESC)
✅ G8 - Redes sociales (P1559_DESC)
✅ G9 - Internet (P2524_DESC)
✅ H1 - Solicitud crédito (P1765_DESC)
✅ H2 - Tiene ahorros (P3014_DESC)
✅ V1-V5 - Ingresos detallados (NUEVO)
✅ K1 - Indicadores por departamento (NUEVO)
✅ X1-X2 - Tablas cruzadas (NUEVO)
```

---

## ❌ Cuadros QUE FALTAN en Script 03 Actual

### **MÓDULO C — EMPRENDIMIENTO**
```
❌ C4 - Cantidad y distribución según FUENTE DE RECURSOS PARA LA CREACIÓN
    Variable: P3052_DESC
    Categorías esperadas: Ahorros, Préstamos familiares, Préstamos bancarios, 
                          Prestamistas, Capital semilla, Sin financiación, No sabe, Otro
```

---

### **MÓDULO D — SITIO O UBICACIÓN (FALTA DESGLOSE DETALLADO)**
```
❌ D2 - Espacio exclusivo para la actividad en vivienda
    Variable: P3095_DESC
    
❌ D3 - Emplazamiento físico del negocio  
    Variable: P3096_DESC
    
❌ D4 - Tipo de servicio puerta a puerta (a domicilio)
    Variable: P3097_DESC
    
❌ D5 - Ubicación en espacio público (ambulantes)
    Variable: P3098_DESC
    
❌ D6 - Número de puestos o establecimientos
    Variable: P3054_DESC
    
❌ D7 - Propiedad del emplazamiento
    Variable: P3055_DESC
    
❌ D8 - Visibilidad al público
    Variable: P469_DESC
```

---

### **MÓDULO E — PERSONAL OCUPADO (FALTA DESGLOSE DE TRABAJADORES)**
```
❌ E1.1 - Aporte a salud y pensión del PROPIETARIO
    Variable: P3088_DESC
    Nota: Diferente a lo que está en script 02
    
❌ E1.3 - Aporte a ARL del propietario
    Variable: P3090_DESC

❌ E3 - Cantidad y distribución del PERSONAL OCUPADO por tipo de vínculo
    Variable: TIPO_DESC (1=Remunerados, 2=Socios, 3=Familiares sin pago)
    Nota: Requiere leer módulo personal_ocupado.csv
    
❌ E3.1.1 - Tipo de contrato (TRABAJADORES REMUNERADOS)
    Variable: P3077_DESC
    Categorías: Indefinido, Temporal
    
❌ E3.1.2 - Sexo (TRABAJADORES REMUNERADOS)
    Variable: P3078_DESC
    
❌ E3.1.4 - Aporte salud/pensión (TRABAJADORES REMUNERADOS)
    Variable: P3080_DESC
    
❌ E3.1.6 - Pago de prestaciones (TRABAJADORES REMUNERADOS)
    Variable: P3082_DESC
    
❌ E3.1.8 - Aporte ARL (TRABAJADORES REMUNERADOS)
    Variable: P3084_DESC

❌ E3.2.1 - Sexo (SOCIOS)
    Variable: P3078_DESC
    
❌ E3.2.2 - Aporte salud/pensión (SOCIOS)
    Variable: P3080_DESC
    
❌ E3.2.4 - Aporte ARL (SOCIOS)
    Variable: P3084_DESC

❌ E3.3.1 - Sexo (FAMILIARES SIN REMUNERACIÓN)
    Variable: P3078_DESC
    
❌ E3.3.2 - Aporte salud/pensión (FAMILIARES)
    Variable: P3080_DESC
    
❌ E3.3.4 - Aporte ARL (FAMILIARES)
    Variable: P3084_DESC
```

**Nota importante:** Los cuadros E3.x requieren leer el módulo `personal_ocupado.csv` 
y aplicar el F_EXP correctamente (ver líneas 83-127 del legacy).

---

### **MÓDULO F — CARACTERÍSTICAS (FALTA DESGLOSE)**
```
❌ F3 - Régimen al cual pertenece (Común vs Simplificado)
    Variable: P986_DESC
    
❌ F5 - Razones para NO llevar registros contables
    Variable: P4000_DESC
    Categorías: No se necesita, No sabe, No aplica
    
❌ F7 - Tipo de persona inscrita en Cámara de Comercio
    Variable: P1056_DESC
    Categorías: Persona natural comerciante, Persona jurídica
    
❌ F8 - Obtención o renovación del registro en Cámara en 2024
    Variable: P661_DESC
    
❌ F9 - Tenencia de registro ante entidad diferente a Cámara
    Variable: P1057_DESC
    
❌ F10 - Entidad ante la cual realizó registro
    Variable: P4004_DESC
    Categorías: Alcaldía, ICA, Ministerio, Otro
    
❌ F11 - Declaración de impuesto a la renta
    Variable: P2991_DESC
    
❌ F12 - Declaración de IVA
    Variable: P2992_DESC
    
❌ F13 - Declaración de ICA
    Variable: P2993_DESC
```

---

### **MÓDULO G — TIC (FALTA DESGLOSE)**
```
❌ G2,3,4 - Cantidad y distribución según número de dispositivos electrónicos
    Variable: P1087_DESC
    
❌ G4A - Uso del teléfono móvil celular
    Variable: P976_DESC
    
❌ G5,5A - Tipo y número de teléfonos móviles en uso
    Variable: P978_DESC
    
❌ G6 - Razones para NO usar dispositivos electrónicos
    Variable: P994_DESC
    Categorías: Muy costoso, No se necesita, Personal no sabe
    
❌ G10 - Conexión a internet dentro del negocio
    Variable: P1093_DESC
    
❌ G11 - Tipo de conexión para acceso a internet
    Variable: P2528_DESC
    Categorías: Fijo, Móvil
    
❌ G12 - Razones para NO usar internet
    Variable: P1095_DESC
    Categorías: Costoso, No lo necesita, Personal no sabe, Sin dispositivo, 
                Mala calidad, Sin cobertura
```

---

### **MÓDULO H — INCLUSIÓN FINANCIERA (FALTA DESGLOSE)**
```
❌ H3 - Razones para NO solicitar crédito
    Variable: P1567_DESC
    Categorías: No lo necesita, Miedo a deudas, No cumple requisitos, 
                Intereses altos, Reportado negativamente, Otro
    
❌ H4 - Tipo de entidad a la cual se solicitó crédito
    Variable: P1569_DESC
    Categorías: Institución financiera, Proveedor, Casa de empeño, 
                Microcrédito, Prestamista, Familiares, Otro
    
❌ H5 - Resultado de la solicitud de crédito
    Variable: P1568_DESC
    Categorías: Sí obtuvo, No obtuvo
    
❌ H6 - Uso del crédito obtenido
    Variable: P1570_DESC
    Categorías: Invertir en negocio, Gastos personales, Ambas
    
❌ H7B - Razones para NO ahorrar
    Variable: P1574_DESC
    Categorías: No alcanzó, No necesita, No sabe, No le ofrecieron, 
                No confía en entidades
    
❌ H8 - Formas de ahorro
    Variable: P1771_DESC
    Categorías: Institución financiera, Cooperativas, Grupos de ahorro, 
                Familiares, Compra de activos, En vivienda, Otro
```

---

### **MÓDULO K — CAPITAL SOCIAL**
```
❌ K1.1 - Afiliación a diferentes tipos de organizaciones
    Variable: P3002_DESC
    Nota: El legacy solo tiene P3002, pero debería desglosarse más
```

---

## 🔄 CUADROS QUE TIENES EN MEJORADO PERO NO EN LEGACY

```
✅ V3, V4, V5 - Ingresos detallados (promedio, total mensual, total anual)
    → NUEVO: No estaban en legacy
    
✅ E2, E3 - Personal promedio por grupo
    → NUEVO: No estaban en legacy
    
✅ K1 - Indicadores multidimensionales por departamento
    → NUEVO: No estaban en legacy
    
✅ X1, X2 - Tablas cruzadas (Sexo×Sector, Antigüedad×Formalización)
    → NUEVO: No estaban en legacy
    
✅ H3 - Formas de pago
    → NUEVO: No estaban en legacy
    
✅ B3 - Sector 12G detallado
    → NUEVO: No estaban en legacy
```

---

## 📋 RECOMENDACIÓN: INTEGRAR LEGACY EN SCRIPT 03

El script `legacy_04_cuadros_boletin.R` tiene:
- ✅ **62 cuadros completos y bien documentados** con nombres exactos DANE
- ✅ **Manejo correcto del módulo personal_ocupado** (líneas 83-127)
- ✅ **Cálculos de distribuciones correctos**

**Propuesta:**
1. **FUSIONAR** ambos scripts:
   - Tomar la estructura general del legacy (62 cuadros base)
   - Agregar los nuevos cuadros (ingresos, cruzadas, multidimensionales)
   - Total: **~75-80 cuadros de salida**

2. **Mejoras a agregar:**
   - Los cálculos de ingresos detallados (V3-V5)
   - Los indicadores por departamento (K1)
   - Las tablas cruzadas (X1-X2)
   - Formas de pago desglosadas

3. **Ventajas:**
   - Réplica COMPLETA de boletines DANE
   - Validación exhaustiva
   - Datos para EDA más ricos
   - Mejor calidad de análisis Apriori

---

## 🎯 ACCIÓN INMEDIATA

¿Quieres que:

1. **INTEGRE el legacy_04 en script 03** (reemplazar completamente)?
2. **COMBINAR ambos** (legacy + mejoras nuevas)?
3. **USAR legacy como está** y solo agregar las nuevas funciones?

**Mi recomendación:** Opción 2 (Combinar) → Genera todos los cuadros DANE + nuevas métricas.

¿Cuál prefieres?

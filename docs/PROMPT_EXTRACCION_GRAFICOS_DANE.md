# Prompt para Extraer Indicadores de Gráficos del Boletín DANE EMICRON

> **Instrucción:** Usa este prompt con una IA con capacidades de visión (Claude, GPT-4V, etc.) que pueda leer e interpretar imágenes de PDFs para extraer datos numéricos de gráficos.

---

## 🎯 PROMPT PRINCIPAL

```
TAREA: Extraer Indicadores Numéricos de Boletines DANE EMICRON 2024

Tienes acceso a 3 boletines PDF del DANE con gráficos e indicadores sobre 
micronegocios en Colombia (EMICRON 2024).

Lee TODOS los gráficos, tablas y cuadros que encuentres en los PDFs y extrae 
la información en el formato especificado abajo.

---

## PARTE 1: IDENTIFICAR TODOS LOS GRÁFICOS Y CUADROS

Para CADA gráfico, tabla o cuadro que encuentres, proporciona:

### Formato:
[Nombre del Gráfico/Cuadro]
- Tipo: [Gráfico de barras | Tabla | Gráfico de pastel | Línea | Otro]
- Ubicación: [Página X del documento Y]
- Título exacto: [Cómo aparece en el boletín]
- Descripción: [Qué mide en una línea]

---

## PARTE 2: PARA CADA INDICADOR, EXTRAE:

### Formato de salida (usa esta estructura EXACTA):

**INDICADOR: [Nombre del indicador]**
```
FUENTE: [Documento y página]
DIMENSIÓN: [Qué se está midiendo]
CATEGORÍAS/VALORES:
  - [Categoría/Rango]: [Valor numérico o porcentaje]
  - [Categoría/Rango]: [Valor numérico o porcentaje]
  - [etc.]

MÉTRICAS CLAVE:
  - Total/Suma: [si aplica]
  - Mayor: [categoría con mayor valor]
  - Menor: [categoría con menor valor]
```

---

## PARTE 3: AGRUPA LOS INDICADORES POR CATEGORÍA

Después de extraer todos los datos, organiza así:

### DEMOGRAFÍA Y ESTRUCTURA
- Sexo del propietario (% Hombre, % Mujer)
- Situación en el empleo (% Patrón, % Cuenta propia)
- Edad del propietario (si hay rango o promedio)
- [Otros indicadores demográficos que encuentres]

### ACTIVIDAD ECONÓMICA Y SECTOR
- Distribución por 4 Grupos (Agricultura, Industria, Comercio, Servicios) — % cada uno
- Distribución por 12 Grupos si está desglosado
- [Otros indicadores sectoriales]

### EMPRENDIMIENTO Y ANTIGÜEDAD
- Tiempo de funcionamiento (% <1 año, 1-3 años, 3-5 años, 5-10 años, 10+ años)
- Motivo de creación si está disponible
- Fuente de financiación si está disponible
- [Otros indicadores de emprendimiento]

### FORMALIZACIÓN
- % Con RUT
- % Con Cámara de Comercio
- % Con registros contables
- % Que pagan seguridad social
- % Que declaran impuestos (Renta, IVA, ICA)
- Nivel de formalización promedio (si hay índice)
- [Otros indicadores de formalidad]

### TECNOLOGÍA E INCLUSIÓN DIGITAL
- % Que usa internet
- % Con redes sociales
- % Con página web
- % Que usa celular para el negocio
- Nivel de digitalización promedio (si hay índice)
- Formas de pago aceptadas (% Efectivo, % Transferencia, % Tarjeta, etc.)
- [Otros indicadores TIC]

### INCLUSIÓN FINANCIERA
- % Que solicitó crédito
- % Que obtuvo crédito
- % Que ahorró
- Razones de no acceso a crédito (si está desglosado)
- [Otros indicadores financieros]

### EMPLEO Y PERSONAL OCUPADO
- Promedio de personas ocupadas por negocio
- Total de personas ocupadas (expandido)
- Distribución por rango de personal (1 persona, 2-3, 4-5, 6+)
- % Con trabajadores remunerados vs. cuenta propia
- [Otros indicadores laborales]

### INGRESOS Y DESEMPEÑO FINANCIERO
- Ingresos promedio (mensual o anual)
- Ingresos totales por sector (si está desglosado)
- Ingresos por sexo del propietario (si está desglosado)
- Ganancia promedio si está reportada
- [Otros indicadores de desempeño]

### GEOGRAFÍA Y DEPARTAMENTOS
- Número de micronegocios por departamento (top 5-10 si aplica)
- % por región/departamento
- Ingresos promedio por departamento (si está desglosado)
- [Otros indicadores geográficos]

### UBICACIÓN Y SITIO
- % En vivienda
- % En local fijo
- % Ambulante
- % Otro tipo de ubicación
- Visibilidad al público (% Visible, % No visible)
- [Otros indicadores de ubicación]

---

## PARTE 4: PROPORCIONA UN RESUMEN COMPARATIVO

Al final, crea una tabla resumen así:

| Indicador | Valor | Unidad | Fuente (Página) |
|-----------|-------|--------|-----------------|
| Total Micronegocios | XXX.XXX | Cantidad | Pág. 1 |
| % Hombre | XX.X | % | Pág. 2 |
| % Mujer | XX.X | % | Pág. 2 |
| % Patrón | X.X | % | Pág. 3 |
| % Cuenta Propia | XX.X | % | Pág. 3 |
| [Continúa con todos los indicadores] | | | |

---

## PARTE 5: LISTA DE VALIDACIÓN

Al final, responde estas preguntas:

1. ¿Todos los porcentajes suman 100% dentro de cada dimensión?
2. ¿Hay valores que parezcan inconsistentes? (ej: % que suman >100%)
3. ¿Hay indicadores que se repitan en múltiples gráficos?
4. ¿Hay gráficos que muestren tendencias (series de tiempo)?
5. ¿Hay metodología explicada en los boletines?
6. ¿Hay factor de expansión mencionado?

---

## ARCHIVOS A PROCESAR

Los 3 boletines DANE EMICRON 2024 están en:
- bol-EMICRON-2024.pdf (boletín nacional)
- bol-Departamentos-EMICRON-2024.pdf (por departamentos)
- bol-EMICRONVendedoresAmbulantes-2024.pdf (vendedores ambulantes)

Procesa los 2 primeros como prioridad. El tercero es opcional pero bienvenido.

---

## FORMATO FINAL DE ENTREGA

Cuando hayas extraído todo, proporciona:

```markdown
# EXTRACCIÓN DE INDICADORES BOLETÍN DANE EMICRON 2024

## Resumen Ejecutivo
- Total de micronegocios: [X]
- Documentos procesados: 2 (Nacional + Departamentos)
- Indicadores extraídos: [N]
- Fecha de procesamiento: [Hoy]

## Indicadores por Categoría
[Aquí va la información organizada que extraíste]

## Tabla Resumen Comparativa
[Aquí va la tabla]

## Validación y Notas
[Aquí van las respuestas a la lista de validación]

## Gráficos/Cuadros Identificados
[Aquí va la lista de PARTE 1]
```

---

## NOTAS IMPORTANTES

1. **SÉ PRECISO:** Los números que extraigas se usarán para validar cálculos analíticos.
   Si no puedes leer un número claramente, indica [VALOR NO LEGIBLE] y describe qué ves.

2. **PROPORCIONES:** Si ves un gráfico de pastel, extrae los porcentajes exactos.
   Si ves un gráfico de barras, extrae la altura/valor de cada barra.

3. **UNIDADES:** Especifica siempre las unidades (%, cantidad, millones COP, etc.)

4. **INCONSISTENCIAS:** Si encuentras datos que no encajan (ej: % que no suman 100%),
   señálalo explícitamente.

5. **METODOLOGÍA:** Si hay notas sobre metodología, factor de expansión, o 
   definiciones en los PDFs, extrae también eso.

---

¿Listo? Procede a leer los 3 PDFs y extrae todos los indicadores según las instrucciones.
```

---

## 💡 CÓMO USAR ESTE PROMPT

### Opción 1: Claude con Visión
```bash
# 1. Copia el prompt arriba
# 2. En Claude.ai o Claude Code, sube los 3 PDFs
# 3. Pega el prompt completo
# 4. Espera a que procese (puede tardar 2-3 minutos)
# 5. Copia la salida en un archivo markdown
```

### Opción 2: GPT-4V (OpenAI)
```bash
# 1. Copia el prompt
# 2. En ChatGPT Plus, sube imágenes de cada página importante
# 2. Pega el prompt
# 4. Obtén la salida
```

### Opción 3: Gemini (Google)
```bash
# Similar a OpenAI, pero Gemini es más rápido con PDFs
```

---

## 📌 EJEMPLO DE SALIDA ESPERADA

Cuando la IA procese correctamente, verás algo como:

```markdown
# EXTRACCIÓN DE INDICADORES BOLETÍN DANE EMICRON 2024

## INDICADOR: Distribución por Sexo del Propietario
FUENTE: bol-EMICRON-2024.pdf, Página 3
DIMENSIÓN: Género del propietario del micronegocio

CATEGORÍAS/VALORES:
  - Hombre: 64.6%
  - Mujer: 35.4%

MÉTRICAS CLAVE:
  - Total: 100.0%
  - Mayor: Hombre (64.6%)
  - Menor: Mujer (35.4%)

---

## INDICADOR: Distribución por Sector (4 Grupos)
FUENTE: bol-EMICRON-2024.pdf, Página 4
DIMENSIÓN: Actividad económica (CIIU 4 grupos)

CATEGORÍAS/VALORES:
  - Agricultura: 22.5%
  - Industria: 10.0%
  - Comercio: 23.8%
  - Servicios: 43.6%

MÉTRICAS CLAVE:
  - Total: 99.9% (redondeo)
  - Mayor: Servicios (43.6%)
  - Menor: Industria (10.0%)
```

---

## 🔗 ENTREGA

Una vez que la IA extraiga los datos, envíame:

1. El archivo markdown con todos los indicadores
2. La tabla comparativa (copiar a CSV)
3. Cualquier nota sobre inconsistencias

Luego yo:
- Compararé con nuestros cálculos Script 03
- Identificaré diferencias
- Ajustaré fórmulas si es necesario
- Continuaré con EDA + Apriori

---

**¿Listo para ejecutar este prompt con una IA?**

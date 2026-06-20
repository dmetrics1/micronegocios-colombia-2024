# PROTOCOLO MAESTRO — Encuesta de Micronegocios (EMICRON)

> **Propósito.** Documento de referencia completo para trabajar con los microdatos de la Encuesta de Micronegocios del DANE. Cubre desde la consolidación de módulos hasta el cálculo de indicadores oficiales. Cualquier agente (humano o IA) que trabaje con la EMICRON debe leer este documento primero.
>
> **Fuentes oficiales de este protocolo:**
> - Metodología General EMICRON (DSO-EMICRON-MET-001, v1, septiembre 2023)
> - Diccionario de datos anonimizado EMICRON 2024
> - Código de consolidación de módulos (R, data.table)
---


## 1. ¿Qué es la EMICRON?

La Encuesta de Micronegocios es una operación estadística del DANE que proporciona información sobre la estructura y evolución de las principales variables económicas de los micronegocios en Colombia.

**Definición de micronegocio:** unidad económica con máximo 9 personas ocupadas, que desarrolla una actividad productiva de bienes o servicios, con el objeto de obtener un ingreso, actuando en calidad de propietario o arrendatario de los medios de producción.

**Técnica de identificación:** encuesta mixta modular en dos fases. En la primera fase, a partir de la GEIH, se identifican los empleadores y trabajadores por cuenta propia que satisfacen los criterios para ser propietarios potenciales de micronegocios. En la segunda fase, se visita a las personas identificadas y se aplica un cuestionario económico a profundidad.

**Cobertura:** 24 departamentos del país. Se excluyen Arauca, Casanare, Vichada, Guainía, Guaviare, Vaupés, Putumayo y Amazonas. Se recolecta en 24 ciudades principales con sus áreas metropolitanas.

**Frecuencia:** recolección mensual continua. Publicación trimestral y anual.

**Tamaño de muestra:** aproximadamente 85.000 unidades económicas al año.

**Factor de expansión:** `F_EXP` (presente en todos los módulos). Indispensable para cualquier estimación poblacional.

**Actividades excluidas:** suministro de electricidad/gas/agua, transporte aéreo, actividades financieras y de seguros, administración pública, hogares como empleadores.

---

## 2. Estructura de los datos (módulos)

La EMICRON tiene 11 módulos de datos, cada uno como un archivo CSV independiente. Todos comparten 3 variables llave para hacer merge y variables comunes de clasificación.

### 2.1 Variables llave para merge (presentes en todos los módulos)

| Variable | Descripción |
|---|---|
| `DIRECTORIO` | Identificador del hogar (continua) |
| `SECUENCIA_ENCUESTA` | Secuencia de la encuesta (discreta) |
| `SECUENCIA_P` | Secuencia de la persona (discreta) |

**Regla de merge:** `DIRECTORIO + SECUENCIA_P + SECUENCIA_ENCUESTA` conforman la llave primaria del micronegocio.

### 2.2 Variables comunes (presentes en todos los módulos, no duplicar)

| Variable | Tipo | Descripción | Tratamiento |
|---|---|---|---|
| `COD_DPTO` / `COD_DEPTO` | Discreta | Departamento (25 categorías) | **TEXTO** — ceros a la izquierda |
| `AREA` | Discreta | Ciudad o área metropolitana (25 categorías) | **TEXTO** — ceros a la izquierda |
| `CLASE_TE` | Discreta | 1=Cabeceras, 2=Centros poblados y rural | Categórica |
| `F_EXP` | Continua | Factor de expansión | Float64, nunca redondear |

### 2.3 Los 11 módulos

| # | Módulo | Archivo esperado | Variables propias clave | Qué captura |
|---|---|---|---|---|
| 1 | Identificación | `identificacion.csv` | P35, P241, P3031-P3035, GRUPOS4, GRUPOS12, MES_REF | Sexo/edad propietario, tamaño negocio, sector CIIU, antigüedad en meses |
| 2 | Emprendimiento | `emprendimiento.csv` | P3050, P3051, P639, P3052 | Quién creó, motivo, **tiempo de funcionamiento**, fuente de financiación |
| 3 | Sitio o ubicación | `sitio_ubicacion.csv` | P3053-P3055, P469 | Dónde opera, tipo de local, propiedad del emplazamiento, visibilidad |
| 4 | Personal ocupado (propietario) | `personal_propietario.csv` | P3088-P3091, SUELDOS, PRESTACIONES, REMUNERACION_TOTAL | Pagos seguridad social propietario, ARL, personal promedio anual |
| 5 | Personal ocupado (trabajadores) | `personal_ocupado.csv` | TIPO, P3077-P3085, P3099 | Tipo contrato, salario, seguridad social por trabajador, antigüedad, edad |
| 6 | Características del micronegocio | `caracteristicas.csv` | P1633, P640, P1055, P2991-P2993 | RUT, registros contables, Cámara de Comercio, declaraciones tributarias |
| 7 | TIC | `tic.csv` | P4001, P976-P994, P2524-P2532, P1006_1..13 | Dispositivos, internet, redes sociales, web, usos digitales |
| 8 | Costos, gastos y activos | `costos_gastos.csv` | P3056_A-D, P3057_A-D, P3017_A-L, P3018, COSTOS_*, GASTOS_*, CONSUMO_INTERMEDIO | Costos por tipo, gastos operativos, inversión en activos |
| 9 | Ventas o ingresos | `ventas_ingresos.csv` | P3057-P3072, VENTAS_*, VALOR_AGREGADO, INGRESO_MIXTO | Ingresos por fuente y periodo, meses de operación, ganancia mensual |
| 10 | Inclusión financiera | `inclusion_financiera.csv` | P1764, P1765, P1567-P1574, P3014 | Formas de pago, crédito, ahorro, razones de no acceso |
| 11 | Capital social | `capital_social.csv` | P3002-P3016, P4003 | Pertenencia a asociaciones/cooperativas, servicios recibidos |

**Nota sobre el módulo 5 (Personal ocupado - trabajadores):** tiene una variable adicional de llave `SECUENCIA_PH` que identifica a cada trabajador dentro del micronegocio. Este módulo tiene MÚLTIPLES filas por micronegocio (una por trabajador). Al hacer merge con el resto de módulos, se debe agregar primero a nivel de micronegocio o manejar la relación uno-a-muchos.

---

## 3. Consolidación de módulos (merge)

### 3.1 Principios del merge

1. **Llave primaria:** `DIRECTORIO + SECUENCIA_P + SECUENCIA_ENCUESTA`.
2. **Tipo de join:** `left join` tomando como base el módulo de identificación (el más completo).
3. **Variables duplicadas:** al mergear, las variables comunes (`COD_DPTO`, `AREA`, `CLASE_TE`, `F_EXP`) se duplican. Conservar solo la primera aparición y eliminar las copias `.y`.
4. **Módulo de personal ocupado (trabajadores):** requiere agregación previa o manejo separado. No mergearlo directamente con los demás módulos sin agregar primero.
5. **Encoding de CSVs:** el DANE publica en encoding `latin-1` (ISO-8859-1). Siempre especificar al leer.
6. **Separador:** verificar si es `;` o `,` (varía entre años).

### 3.2 Función 1: Consolidación de módulos — `merge_emicron()` (R)

Esta función mergea todos los módulos EXCEPTO el de personal ocupado (trabajadores), que tiene múltiples filas por micronegocio y se trata en la función siguiente.

```r
library(data.table)

merge_emicron <- function(año, base_dir = NULL) {
  
  if (is.null(base_dir)) {
    base_dir <- file.path(getwd(), "datos", "emicron", año)
  }
  
  key_variables <- c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")
  
  all_files <- list.files(
    path = base_dir, 
    pattern = "*.csv", 
    full.names = TRUE, 
    ignore.case = TRUE
  )
  
  if (length(all_files) == 0) {
    stop(paste("No se encontraron CSVs en:", base_dir))
  }
  
  message(sprintf("Encontrados %d archivos para año %s", length(all_files), año))
  
  # Leer primer archivo como base
  final_df <- fread(
    file = all_files[1], 
    encoding = "Latin-1",
    colClasses = list(character = c("COD_DPTO", "COD_DEPTO", "AREA"))
  )
  message(sprintf("  Base: %s (%d filas, %d cols)", basename(all_files[1]), nrow(final_df), ncol(final_df)))
  
  # Iterar sobre los archivos restantes
  for (file in all_files[-1]) {
    df <- fread(
      file = file, 
      encoding = "Latin-1",
      colClasses = list(character = c("COD_DPTO", "COD_DEPTO", "AREA"))
    )
    
    # EXCLUIR módulo de personal ocupado (trabajadores) si tiene SECUENCIA_PH
    # Este módulo tiene múltiples filas por micronegocio y debe tratarse aparte
    if ("SECUENCIA_PH" %in% colnames(df)) {
      message(sprintf("  OMITIDO (múltiples filas por micronegocio): %s", basename(file)))
      next
    }
    
    # Encontrar las claves comunes para el merge
    merge_keys <- intersect(colnames(df), key_variables)
    
    if (length(merge_keys) == 0) {
      message(sprintf("  OMITIDO (sin claves de merge): %s", basename(file)))
      next
    }
    
    # Merge
    final_df <- merge(final_df, df, by = merge_keys, all.x = TRUE)
    
    # Renombrar .x y eliminar .y
    cols_x <- grep("\\.x$", colnames(final_df), value = TRUE)
    if (length(cols_x) > 0) {
      setnames(final_df, old = cols_x, new = gsub("\\.x$", "", cols_x))
    }
    
    cols_y <- grep("\\.y$", colnames(final_df), value = TRUE)
    if (length(cols_y) > 0) {
      final_df[, (cols_y) := NULL]
    }
    
    message(sprintf("  Mergeado: %s → %d cols total", basename(file), ncol(final_df)))
  }
  
  message(sprintf("Base final: %d filas × %d columnas", nrow(final_df), ncol(final_df)))
  return(final_df)
}
```

### 3.3 Función 2: Agregar módulo de personal ocupado — `agregar_personal_ocupado()` (R)

**¿Por qué una función separada?** El módulo de personal ocupado (trabajadores, Módulo E3) tiene una variable de llave adicional `SECUENCIA_PH` que identifica a cada trabajador dentro del micronegocio. Esto significa que un micronegocio con 3 trabajadores tiene 3 filas en este módulo. Si se mergea directo con los demás módulos, multiplica las filas de la base completa y arruina cualquier cálculo posterior.

**Solución:** antes de mergear, esta función colapsa (agrega) el módulo de personal a nivel de micronegocio, creando 25+ features agregadas por categoría:

| Categoría | Features creadas |
|---|---|
| Conteos por vínculo | `n_trab_remunerados`, `n_socios`, `n_fam_sin_pago`, `n_total_personal_ocu` |
| Salarios (solo remunerados) | `salario_total_mes`, `salario_promedio`, `salario_max` |
| Seguridad social | `n_con_salud_pension`, `n_sin_salud_pension`, `n_solo_salud`, `n_solo_pension` |
| Prestaciones y ARL | `n_con_prestaciones`, `n_con_arl`, `n_con_caja_comp` |
| Contratos (solo remunerados) | `n_contrato_indefinido`, `n_contrato_temporal` |
| Antigüedad (meses) | `antiguedad_prom_meses`, `antiguedad_min_meses`, `antiguedad_max_meses` |
| Demografía | `edad_promedio_trab`, `edad_min_trab`, `edad_max_trab`, `n_hombres`, `n_mujeres` |
| Ratios derivados | `pct_con_salud_pension`, `pct_con_arl`, `pct_mujeres`, `pct_contrato_indef` |

Los micronegocios que son cuenta propia sin empleados (`P3031 = 2`) quedan con 0 en todos los conteos y `NA` en promedios/edades — que es correcto.

```r
agregar_personal_ocupado <- function(base, año, base_dir = NULL) {
  
  if (is.null(base_dir)) {
    base_dir <- file.path(getwd(), "datos", "emicron", año)
  }
  
  # Buscar el archivo que tiene SECUENCIA_PH (el que se omitió en merge_emicron)
  all_files <- list.files(base_dir, pattern = "*.csv", full.names = TRUE, ignore.case = TRUE)
  
  archivo_personal <- NULL
  for (file in all_files) {
    cols <- colnames(fread(file, nrows = 0))
    if ("SECUENCIA_PH" %in% cols) {
      archivo_personal <- file
      break
    }
  }
  
  if (is.null(archivo_personal)) {
    message("No se encontró módulo de personal ocupado (trabajadores). Se omite.")
    return(base)
  }
  
  message(sprintf("Agregando personal ocupado desde: %s", basename(archivo_personal)))
  
  personal <- fread(
    archivo_personal, 
    encoding = "Latin-1",
    colClasses = list(character = c("COD_DPTO", "COD_DEPTO", "AREA"))
  )
  
  keys <- c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")
  
  # ---------------------------------------------------------------
  # Agregar a nivel de micronegocio (una fila por negocio)
  # ---------------------------------------------------------------
  personal_agg <- personal[, .(
    
    # --- Conteos por tipo de vínculo ---
    # TIPO: 1=Trabajadores remunerados, 2=Socios, 3=Familiares sin pago
    n_trab_remunerados    = sum(TIPO == 1, na.rm = TRUE),
    n_socios              = sum(TIPO == 2, na.rm = TRUE),
    n_fam_sin_pago        = sum(TIPO == 3, na.rm = TRUE),
    n_total_personal_ocu  = .N,
    
    # --- Salarios (solo trabajadores remunerados, TIPO == 1) ---
    # P3079: ¿Cuánto le pagó el mes pasado?
    salario_total_mes     = sum(ifelse(TIPO == 1, P3079, 0), na.rm = TRUE),
    salario_promedio      = mean(ifelse(TIPO == 1, P3079, NA), na.rm = TRUE),
    salario_max           = max(ifelse(TIPO == 1, P3079, NA), na.rm = TRUE),
    
    # --- Seguridad social (todos los tipos de personal) ---
    # P3080: ¿Le pagó salud y/o pensión? 1=Sí, 2=No, 3=Solo salud, 4=Solo pensión
    n_con_salud_pension   = sum(P3080 == 1, na.rm = TRUE),
    n_sin_salud_pension   = sum(P3080 == 2, na.rm = TRUE),
    n_solo_salud          = sum(P3080 == 3, na.rm = TRUE),
    n_solo_pension        = sum(P3080 == 4, na.rm = TRUE),
    
    # --- Prestaciones sociales (solo remunerados, TIPO == 1) ---
    # P3082: ¿Le pagó prestaciones sociales? 1=Sí, 2=No
    n_con_prestaciones    = sum(P3082 == 1 & TIPO == 1, na.rm = TRUE),
    
    # --- ARL (todos los tipos de personal) ---
    # P3084: ¿Le pagó ARL? 1=Sí, 2=No
    n_con_arl             = sum(P3084 == 1, na.rm = TRUE),
    
    # --- Caja de compensación / SENA / ICBF ---
    # P2990: ¿Le pagó Caja de Compensación? 1=Sí, 2=No
    n_con_caja_comp       = sum(P2990 == 1, na.rm = TRUE),
    
    # --- Antigüedad del personal (meses) ---
    # P3085: ¿Cuántos meses lleva laborando este trabajador?
    antiguedad_prom_meses = mean(P3085, na.rm = TRUE),
    antiguedad_min_meses  = min(P3085, na.rm = TRUE),
    antiguedad_max_meses  = max(P3085, na.rm = TRUE),
    
    # --- Edad de los trabajadores ---
    # P3099: ¿Cuántos años cumplidos tiene?
    edad_promedio_trab    = mean(P3099, na.rm = TRUE),
    edad_min_trab         = min(P3099, na.rm = TRUE),
    edad_max_trab         = max(P3099, na.rm = TRUE),
    
    # --- Género ---
    # P3078: Sexo. 1=Hombre, 2=Mujer
    n_hombres             = sum(P3078 == 1, na.rm = TRUE),
    n_mujeres             = sum(P3078 == 2, na.rm = TRUE),
    
    # --- Tipo de contrato (solo remunerados, TIPO == 1) ---
    # P3077: 1=Contrato indefinido, 2=Temporal
    n_contrato_indefinido = sum(P3077 == 1 & TIPO == 1, na.rm = TRUE),
    n_contrato_temporal   = sum(P3077 == 2 & TIPO == 1, na.rm = TRUE)
    
  ), by = keys]
  
  # ---------------------------------------------------------------
  # Ratios derivados (proporciones)
  # ---------------------------------------------------------------
  personal_agg[, `:=`(
    pct_con_salud_pension = fifelse(n_total_personal_ocu > 0, 
                                    n_con_salud_pension / n_total_personal_ocu, 0),
    pct_con_arl           = fifelse(n_total_personal_ocu > 0, 
                                    n_con_arl / n_total_personal_ocu, 0),
    pct_mujeres           = fifelse(n_total_personal_ocu > 0, 
                                    n_mujeres / n_total_personal_ocu, 0),
    pct_contrato_indef    = fifelse(n_trab_remunerados > 0, 
                                    n_contrato_indefinido / n_trab_remunerados, 0)
  )]
  
  # ---------------------------------------------------------------
  # Limpiar Inf/-Inf que produce min/max sobre vectores vacíos
  # ---------------------------------------------------------------
  cols_numeric <- names(personal_agg)[sapply(personal_agg, is.numeric)]
  for (col in cols_numeric) {
    set(personal_agg, which(is.infinite(personal_agg[[col]])), col, NA_real_)
  }
  
  message(sprintf("  Agregado: %d micronegocios con personal, %d features creadas", 
                  nrow(personal_agg), ncol(personal_agg) - length(keys)))
  
  # ---------------------------------------------------------------
  # Merge con la base principal
  # ---------------------------------------------------------------
  resultado <- merge(base, personal_agg, by = keys, all.x = TRUE)
  
  # Rellenar NA con 0 en conteos y porcentajes
  # (micronegocios sin empleados = cuenta propia solos)
  cols_conteo <- grep("^n_", names(personal_agg), value = TRUE)
  cols_pct <- grep("^pct_", names(personal_agg), value = TRUE)
  for (col in c(cols_conteo, cols_pct)) {
    if (col %in% names(resultado)) {
      set(resultado, which(is.na(resultado[[col]])), col, 0)
    }
  }
  # Los promedios (salario_promedio, antiguedad_prom, edad_promedio, etc.)
  # quedan como NA para los que no tienen personal. Esto es correcto.
  
  message(sprintf("  Base final con personal: %d filas × %d columnas", 
                  nrow(resultado), ncol(resultado)))
  
  return(resultado)
}
```

### 3.4 Flujo completo de consolidación (R)

Las dos funciones se usan en secuencia. Primero se mergean los 10 módulos de relación uno-a-uno, luego se agrega el módulo de personal ocupado (trabajadores) y se une a la base.

```r
library(data.table)

# ============================================================
# PASO 1: Merge de todos los módulos EXCEPTO personal ocupado
#         (merge_emicron omite automáticamente el archivo
#          que contiene SECUENCIA_PH)
# ============================================================
E_2024 <- merge_emicron(2024)

# ============================================================
# PASO 2: Agregar módulo de personal ocupado (trabajadores)
#         como features agregadas a nivel de micronegocio
# ============================================================
E_2024 <- agregar_personal_ocupado(E_2024, 2024)

# ============================================================
# VERIFICAR
# ============================================================
message(sprintf("Dimensiones finales: %d filas × %d columnas", nrow(E_2024), ncol(E_2024)))

# Verificar que no se multiplicaron filas
# (debe ser igual al número de micronegocios, no de trabajadores)
stopifnot(uniqueN(E_2024, by = c("DIRECTORIO", "SECUENCIA_P", "SECUENCIA_ENCUESTA")) == nrow(E_2024))

# Para múltiples años:
# E_2022 <- agregar_personal_ocupado(merge_emicron(2022), 2022)
# E_2023 <- agregar_personal_ocupado(merge_emicron(2023), 2023)
# E_2024 <- agregar_personal_ocupado(merge_emicron(2024), 2024)
#
# Para unir todos los años en una sola base:
# emicron_panel <- rbindlist(list(
#   E_2022[, anio := 2022],
#   E_2023[, anio := 2023],
#   E_2024[, anio := 2024]
# ), fill = TRUE)
```

### 3.5 Explicación del manejo del módulo de personal ocupado (trabajadores)

**El problema.** El módulo de personal ocupado (Módulo E3) tiene una relación uno-a-muchos con el micronegocio. Cada trabajador del negocio es una fila separada, identificada por `SECUENCIA_PH`. Un micronegocio con 3 trabajadores genera 3 filas en este módulo.

Si se mergea directamente con los demás módulos (que tienen una fila por micronegocio), se multiplican todas las filas de la base. Un micronegocio con 3 trabajadores pasaría a tener 3 filas idénticas en todas las variables excepto las del módulo de personal. Esto genera errores graves en cualquier cálculo posterior (conteos, promedios, modelos).

**La solución.** La función `agregar_personal_ocupado()` colapsa el módulo de trabajadores a una sola fila por micronegocio antes de mergearlo. Para cada micronegocio calcula:

- **Cuántos** trabajadores tiene por tipo (remunerados, socios, familiares)
- **Cuánto** paga en total y en promedio de salarios
- **Cuántos** tienen seguridad social, prestaciones, ARL, caja de compensación
- **Qué tipo** de contratos tiene (indefinido vs temporal)
- **Qué tan antiguos** son sus trabajadores (promedio, mínimo, máximo de meses)
- **Qué edad** tienen y cómo es la distribución por género
- **Ratios** derivados: % con seguridad social, % mujeres, % contratos indefinidos

**Resultado.** Después de las dos funciones, la base final tiene exactamente una fila por micronegocio con todas las variables de los 11 módulos, donde las del módulo de personal vienen como features agregadas. Los micronegocios de cuenta propia sin empleados tienen 0 en los conteos y `NA` en los promedios.

---

## 4. Variables críticas y su tratamiento

### 4.1 Variables geográficas (SIEMPRE TEXTO)

| Variable | Tratamiento | Ejemplo |
|---|---|---|
| `COD_DPTO` / `COD_DEPTO` | `string` / `character` | `"05"` (Antioquia), `"08"` (Atlántico) |
| `AREA` | `string` / `character` | `"05"` (Medellín AM), `"47"` (Santa Marta) |

**Nunca convertir a entero.** Los ceros a la izquierda son significativos.

### 4.2 Valores de no respuesta (imputación)

El formulario permite responder `98` (no sabe) y `99` (no informa) en variables monetarias. Estos valores se imputan con los métodos oficiales del DANE antes de publicar los microdatos anonimizados.

**Verificación obligatoria:** al recibir los microdatos, comprobar si los valores 98, 99, 998, 999 ya fueron imputados o no. Si NO fueron imputados, tratarlos como `NA`, nunca como valores numéricos reales.

Variables que pueden contener estos valores:
- `P3089` (pago salud/pensión propietario)
- `P3079` (sueldos y salarios)
- `P3081` (pago salud/pensión trabajadores)
- `P3083` (prestaciones sociales)
- `P3056_A` a `P3056_D` (costos mes anterior)
- `P3057_A` a `P3057_D` (costos año anterior)
- `P3017_A` a `P3017_K` (gastos mensuales)
- Todas las variables de ventas/ingresos
- `P3072` (ganancias mensuales)

### 4.3 Clasificación económica (CIIU Rev. 4 A.C.)

La EMICRON clasifica los micronegocios según la CIIU en dos niveles de agrupación en los **microdatos públicos**:

**4 grupos (`GRUPOS4`):**
- `01` = Agricultura, ganadería, caza, silvicultura y pesca
- `02` = Industria manufacturera
- `03` = Comercio
- `04` = Servicios

**12 grupos (`GRUPOS12`):**
- `01` = Agricultura, ganadería, caza, silvicultura y pesca
- `02` = Minería
- `03` = Industria manufacturera
- `04` = Construcción
- `05` = Comercio y reparación de vehículos
- `06` = Transporte y almacenamiento
- `07` = Alojamiento y servicios de comida
- `08` = Información y comunicaciones
- `09` = Actividades inmobiliarias, profesionales y administrativas
- `10` = Educación
- `11` = Salud y asistencia social
- `12` = Arte, entretenimiento, recreación y otros servicios

> [!WARNING]
> **SECRETO ESTADÍSTICO:** El DANE **NO** publica los códigos CIIU a nivel de 4 dígitos (ej. 1081 para panaderías o 4711 para tiendas de barrio) en los archivos CSV anonimizados para evitar la identificación de empresas individuales. Es metodológicamente imposible replicar subconjuntos CIIU a 4 dígitos usando exclusivamente la base pública. Tampoco se debe confundir la variable `P3034` (antigüedad en meses) con códigos CIIU.

---

## 5. Cálculo de indicadores oficiales

Estas fórmulas son las que usa el DANE. Deben respetarse exactamente.

### 5.1 Ventas o ingresos anuales

```
V = (P3057 + P3058 + P3059 + P3060 + P3061 + P3062 + P4002 
     + P3063 + P3064 + P3065 + P3066 + P3067 + P3092 + P3093) × 12 × F_EXP
```

**O usando la variable pre-calculada:**
```
V = VENTAS_MES_ANTERIOR × 12 × F_EXP
```

Donde `VENTAS_MES_ANTERIOR = P3057 + P3058 + ... + P3093` (ya viene en los microdatos anonimizados).

### 5.2 Consumo intermedio anual

```
CI = (P3056_A + P3056_B + P3056_C + P3056_D + P3056_E
      + P3017_A + P3017_B + P3017_C + P3017_D + P3017_E 
      + P3017_F + P3017_G + P3017_H + P3017_K) × 12 × F_EXP
     + P3017_L × F_EXP
```

> [!IMPORTANT]
> **EXCLUSIÓN DE IMPUESTOS Y LICENCIAS:** Según el Sistema de Cuentas Nacionales, las variables anuales `P3017_I` (Licencias) y `P3017_J` (Impuestos) son "impuestos indirectos a la producción" y NO forman parte del Consumo Intermedio. Deben ser estrictamente excluidas de esta suma para cuadrar con el Valor Agregado e Ingreso Mixto de los boletines oficiales. La única variable anual que ingresa es `P3017_L` (Otros pagos, ej. INVIMA).

**O usando variables pre-calculadas:**
```
CI = (COSTOS_MES_ANTERIOR + GASTOS_MES) × 12 × F_EXP + gastos_anuales × F_EXP
```

Donde:
- `COSTOS_MES_ANTERIOR = P3056_A + P3056_B + P3056_C + P3056_D`
- `GASTOS_MES = P3017_A + P3017_B + ... + P3017_K`
- `CONSUMO_INTERMEDIO` ya viene pre-calculado como variable en el módulo

### 5.3 Valor agregado anual

```
VA = V - CI
```

**O usando la variable pre-calculada:**
```
VA = VALOR_AGREGADO × 12 × F_EXP
```

### 5.4 Personal ocupado total (Macroindicador)

> [!CAUTION]
> Para calcular el número total de personas ocupadas a nivel nacional **NUNCA** se deben contar las filas del módulo "personal_ocupado" (Módulo E3), ya que es una submuestra que generará una gran subestimación del agregado. Se deben usar las declaraciones iniciales del módulo de identificación:

```
Personal Ocupado = [ (P3032_1 + P3032_2 + P3032_3) × F_EXP ] + [ F_EXP ]
```
*(Nota: El último `F_EXP` representa al propietario del micronegocio).*

### 5.5 Sueldos y salarios anuales

```
SS = P3079 × 12 × F_EXP
```

Donde `P3079` son los sueldos y salarios mensuales. O usar la variable `SUELDOS` del módulo de personal ocupado (propietario), que ya viene precalculada.

### 5.6 Prestaciones sociales anuales

```
PS = (P3089 + P3081 + P3083) × 12 × F_EXP
```

O usar la variable `PRESTACIONES` del módulo de personal ocupado.

### 5.7 Remuneración total del personal ocupado

```
RT = SS + PS
```

> [!WARNING]
> **PROPAGACIÓN DE NAs EN R:** Los micronegocios "Cuenta Propia" que no tienen empleados registran un valor de `NA` en Sueldos y Prestaciones. Si no se manejan, al sumar `SS + PS` el resultado será `NA`, y al restarlo del Valor Agregado para sacar el Ingreso Mixto, se perderá la riqueza de los independientes. Siempre usar `fifelse(is.na(SUELDOS), 0, SUELDOS)` al programar en R.

### 5.8 Ingreso mixto anual

```
IM = VA - RT
```

Es una aproximación porque no considera impuestos indirectos ni subvenciones. O usar la variable `INGRESO_MIXTO` del módulo de ventas.

### 5.8 Variables pre-calculadas disponibles en los microdatos

El DANE incluye en los microdatos anonimizados varias variables ya calculadas que simplifican el trabajo:

| Variable pre-calculada | Módulo | Fórmula |
|---|---|---|
| `COSTOS_MES_ANTERIOR` | Costos | P3056_A + P3056_B + P3056_C + P3056_D |
| `COSTOS_ANIO_ANTERIOR` | Costos | P3057_A + P3057_B + P3057_C + P3057_D |
| `GASTOS_MES` | Costos | P3017_A + ... + P3017_K |
| `CONSUMO_INTERMEDIO` | Costos | Consumo intermedio mensual |
| `VENTAS_MES_ANTERIOR` | Ventas | Suma de todas las fuentes de ingreso del mes anterior |
| `VENTAS_MES_ANIO_ANTERIOR` | Ventas | Mismo mes del año anterior |
| `VENTAS_ANIO_ANTERIOR` | Ventas | Total ventas año anterior |
| `VALOR_AGREGADO` | Ventas | Valor agregado mensual |
| `INGRESO_MIXTO` | Ventas | Ingreso mixto mensual |
| `SUELDOS` | Personal (propietario) | Sueldos y salarios mensuales |
| `PRESTACIONES` | Personal (propietario) | Prestaciones sociales mensuales |
| `REMUNERACION_TOTAL` | Personal (propietario) | Remuneración total mensual |

**Recomendación:** usar las variables pre-calculadas cuando estén disponibles en los microdatos. Son calculadas por el DANE con las imputaciones ya aplicadas.

---

## 6. Uso del factor de expansión

**Regla absoluta:** todo cálculo poblacional debe usar `F_EXP`. Sin factor de expansión, los resultados representan solo la muestra, no la población de micronegocios.

### 6.1 Para contar micronegocios

```python
# Total de micronegocios en Colombia
total_micronegocios = df["F_EXP"].sum()

# Por sector
por_sector = df.groupby("GRUPOS4")["F_EXP"].sum()

# Por ciudad
por_ciudad = df.groupby("AREA")["F_EXP"].sum()
```

```r
# R
total_micronegocios <- sum(df$F_EXP)
por_sector <- df[, .(total = sum(F_EXP)), by = GRUPOS4]
```

### 6.2 Para calcular totales monetarios

```python
# Ventas totales expandidas (mensuales)
df["ventas_expandidas"] = df["VENTAS_MES_ANTERIOR"] * df["F_EXP"]
total_ventas_mes = df["ventas_expandidas"].sum()

# Anualizadas
total_ventas_anual = total_ventas_mes * 12
```

### 6.3 Para calcular promedios ponderados

```python
# Ingreso promedio por micronegocio (ponderado)
ingreso_promedio = (df["VENTAS_MES_ANTERIOR"] * df["F_EXP"]).sum() / df["F_EXP"].sum()
```

### 6.4 Para calcular proporciones

```python
# Porcentaje de micronegocios con RUT
con_rut = df[df["P1633"] == 1]["F_EXP"].sum()
total = df["F_EXP"].sum()
pct_rut = con_rut / total * 100
```

---

## 7. Variables clave para análisis de ML (Proyecto 2)

### 7.1 Variable target: tiempo de funcionamiento (`P639`)

| Código | Categoría | Uso sugerido para ML |
|---|---|---|
| `1` | Menos de un año | → clase 0 (frágil) |
| `2` | De 1 a menos de 3 años | → clase 0 (frágil) |
| `3` | De 3 a menos de 5 años | → clase 1 (sobreviviente) |
| `4` | De 5 a menos de 10 años | → clase 1 (sobreviviente) |
| `5` | 10 años y más | → clase 1 (sobreviviente) |

### 7.2 Variables target alternativas (scoring de vulnerabilidad)

Construir un índice compuesto sumando señales de vulnerabilidad:

| Señal | Variable | Condición vulnerable |
|---|---|---|
| Opera a pérdida | `VENTAS_MES_ANTERIOR` < `CONSUMO_INTERMEDIO` | Sí |
| Sin RUT | `P1633` = 2 | Sí |
| Sin Cámara de Comercio | `P1055` = 2 | Sí |
| Sin registros contables | `P640` = 5 | Sí |
| No paga seguridad social (propietario) | `P3088` = 2 | Sí |
| No tiene acceso a crédito formal | `P1765` = 2 y `P1567` ≠ 1 | Sí |
| No usa internet | `P2524` = 2 | Sí |
| Sin empleados (solo el dueño) | `P3031` = 2 | Sí |

**Score:** sumar condiciones cumplidas. Si score ≥ 4 → alto riesgo (vulnerable = 1).

### 7.3 Features sugeridas por módulo

**Identificación:**
- `P35` (sexo propietario)
- `P241` (edad propietario)
- `P3033` (patrón vs cuenta propia)
- `GRUPOS4` o `GRUPOS12` (sector CIIU)
- `AREA`, `COD_DPTO`, `CLASE_TE` (geografía)
- `P3032_1`, `P3032_2`, `P3032_3` (personal ocupado por tipo)

**Emprendimiento:**
- `P3050` (quién creó)
- `P3051` (motivo de creación — necesidad vs oportunidad)
- `P639` (tiempo de funcionamiento — target o feature)
- `P3052` (fuente de financiación)

**Sitio o ubicación:**
- `P3053` (dónde opera: vivienda, local, ambulante...)
- `P3055` (propiedad del emplazamiento)
- `P469` (visible al público)
- `P3054` (número de establecimientos)

**Personal ocupado (propietario):**
- `P3088` (paga seguridad social)
- `P3090` (paga ARL)
- `P3091` (personal promedio año anterior)
- `REMUNERACION_TOTAL` (cuánto paga en total)

**Formalidad:**
- `P1633` (tiene RUT)
- `P640` (tipo de registro contable)
- `P1055` (registrado en Cámara de Comercio)
- `P661` (renovó registro este año)
- `P2991`, `P2992`, `P2993` (declara renta, IVA, ICA)

**TIC:**
- `P4001` (usa dispositivos electrónicos)
- `P976` (usa celular para el negocio)
- `P2524` (usa internet)
- `P2532` (tiene página web)
- `P1559` (tiene redes sociales)
- `P1006_7` (vende por internet)

**Financiero (construir features derivadas):**
- `margen = VENTAS_MES_ANTERIOR - CONSUMO_INTERMEDIO`
- `ratio_costos = COSTOS_MES_ANTERIOR / VENTAS_MES_ANTERIOR`
- `ratio_gastos = GASTOS_MES / VENTAS_MES_ANTERIOR`
- `P3072` (ganancia mensual declarada)
- `VALOR_AGREGADO` (valor agregado mensual)

**Inclusión financiera:**
- `P1765` (solicitó crédito)
- `P1568` (obtuvo crédito)
- `P3014` (ahorró)
- `P1764_1..7` (formas de pago aceptadas — efectivo, tarjeta, transferencia)

**Capital social:**
- `P3002` (pertenece a asociación)
- `P3004` (pertenece a cooperativa)
- Crear feature: `n_organizaciones` = suma de pertenencias

---

## 8. Reglas de calidad estadística

### 8.1 Coeficiente de variación estimado (CVE)

El DANE define umbrales de calidad para los estimadores:

| CVE | Calidad |
|---|---|
| < 5% | Excelente |
| 5% - 10% | Buena |
| 10% - 15% | Aceptable |
| > 15% | No recomendable para publicar |

**Regla:** no usar desagregaciones cuyos indicadores tengan CVE > 15%.

### 8.2 Validación de resultados

Al calcular indicadores, contrastar siempre con:
- Boletines técnicos trimestrales y anuales del DANE
- Anexos estadísticos publicados en dane.gov.co
- Tolerancia aceptable: diferencia < 1% en cantidades totales, < 2 pp en proporciones

---

## 9. Errores metodológicos y técnicos críticos

1. **No usar F_EXP.** Todo cálculo poblacional sin factor de expansión es incorrecto.
2. **Convertir AREA/DPTO a entero.** Pierde ceros a la izquierda (`05` → `5`).
3. **Mala estimación de Personal Ocupado.** Usar el recuento del módulo de trabajadores (E3) en lugar de las variables de identificación (`P3032_1, P3032_2, P3032_3`). 
4. **Propagación de NAs.** Dejar que los valores vacíos (`NA`) en sueldos y prestaciones de los independientes dañen las sumas y eliminen su Valor Agregado del Ingreso Mixto. Siempre reemplazar por 0 matemáticamente.
5. **Incluir impuestos en Consumo Intermedio.** Sumar licencias (`P3017_I`) e impuestos (`P3017_J`) dentro del CI. La metodología de Cuentas Nacionales los excluye.
6. **Confundir P3034 con CIIU.** Buscar códigos CIIU a 4 dígitos en la variable `P3034`, la cual en realidad mide los meses de antigüedad. El código a 4 dígitos se oculta por el Secreto Estadístico.
7. **Incluir valores 98/99/998/999 como datos reales.** Son códigos de no respuesta.
8. **Anualizar variables que ya son anuales.** `COSTOS_ANIO_ANTERIOR`, `VENTAS_ANIO_ANTERIOR` y `P3017_I/J/L` ya son valores anuales.

---

## 10. Referencias

- Metodología General EMICRON (DSO-EMICRON-MET-001, v1, septiembre 2023) — DANE DIMPE
- Diccionario de datos anonimizado EMICRON 2024
- Boletines técnicos: https://www.dane.gov.co/index.php/estadisticas-por-tema/mercado-laboral/micronegocios
- Microdatos: https://microdatos.dane.gov.co
- CIIU Rev. 4 A.C.: https://www.dane.gov.co (clasificaciones)
- OIT (2013). La Medición de la Informalidad: Manual Estadístico sobre el sector informal y el empleo informal
- CONPES 3956 de 2019. Política de Formalización Empresarial

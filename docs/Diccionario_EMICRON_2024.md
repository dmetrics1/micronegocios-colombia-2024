# Diccionario de variables — EMICRON 2024

> Extraído de `Diccionario_datos-Anonimizado-EMICRON-2024.xlsx`.
> Fuente: DANE, Encuesta de Micronegocios 2024.
> Solo se muestran las variables propias de cada módulo. Las variables de identificación, geografía y factor de expansión son comunes a todos los módulos y se listan una sola vez al inicio.

---

## Variables comunes (presentes en todos los módulos)

| Variable | Tipo | Descripción |
|---|---|---|
| `DIRECTORIO` | Continua | Identificador del hogar |
| `SECUENCIA_ENCUESTA` | Discreta | Secuencia de encuesta |
| `SECUENCIA_P` | Discreta | Secuencia persona |
| `COD_DPTO` / `COD_DEPTO` | Discreta | Departamento (25 categorías, **TEXTO con ceros a la izquierda**) |
| `AREA` | Discreta | Ciudad o área metropolitana (25 categorías, **TEXTO**) |
| `CLASE_TE` | Discreta | 1=Cabeceras municipales, 2=Centros poblados y rural disperso |
| `F_EXP` | Continua | Factor de expansión |

---

## Módulo A — Identificación y clasificación económica

*Hoja original: `Módulo de identificación`* — 13 variables propias

### `P35` — Sexo del propietario del micronegocio
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Hombre
  - `2` → Mujer

### `P241` — Edad del propietario del micronegocio
- **Tipo:** Continua

### `MES_REF` — Mes de referencia
- **Tipo:** Discreta
- **Categorías (12):**
  - `ENERO` → ENERO
  - `FEBRERO` → FEBRERO
  - `MARZO` → MARZO
  - `ABRIL` → ABRIL
  - `MAYO` → MAYO
  - `JUNIO` → JUNIO
  - `JULIO` → JULIO
  - `AGOSTO` → AGOSTO
  - `SEPTIEMBRE` → SEPTIEMBRE
  - `OCTUBRE` → OCTUBRE
  - `NOVIEMBRE` → NOVIEMBRE
  - `DICIEMBRE` → DICIEMBRE

### `P3031` — [A1_8]. En su actividad o negocio, ¿tiene personas que le ayudan ?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3032_1` — [A1_9A]. Trabajadores(as) que reciben un pago?
- **Tipo:** Continua

### `P3032_2` — [A1_9B]. Socios(as)?
- **Tipo:** Continua

### `P3032_3` — [A1_9C]. Trabajadores(as) o familiares sin remuneración?
- **Tipo:** Continua

### `P3033` — [ENC]. RESPONDE EL ENCUESTADOR :  [A1_10]. En su negocio o actividad, usted es:
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Patrón o empleador(a)?
  - `2` → Trabajador(a) por cuenta propia?

### `P3034` — [A1_11]. ¿Cuántos meses lleva trabajando en su negocio o actividad ?
- **Tipo:** Continua

### `P3035` — [A1_12].  El negocio ¿Tiene nombre comercial?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3000` — [A1_16]. ¿Tiene correo electrónico?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `GRUPOS4` — Rama de actividad según CIIU Rev. 4 agrupado en 4 grupos
- **Tipo:** Discreta
- **Categorías (4):**
  - `01` → Agricultura, ganadería, caza, silvicultura y pesca
  - `02` → Industria manufacturera
  - `03` → Comercio
  - `04` → Servicios

### `GRUPOS12` — Rama de actividad según CIIU Rev. 4 agrupado en 12 grupos
- **Tipo:** Discreta
- **Categorías (12):**
  - `01` → Agricultura, ganadería, caza, silvicultura y pesca
  - `02` → Minería
  - `03` → Industria manufacturera
  - `04` → Construcción
  - `05` → Comercio y reparación de vehículos automotores y motocicletas
  - `06` → Transporte y almacenamiento
  - `07` → Alojamiento y servicios de comida
  - `08` → Información y comunicaciones
  - `09` → Actividades inmobiliarias, profesionales y servicios administrativos
  - `10` → Educación
  - `11` → Actividades de atención a la salud humana y de asistencia social
  - `12` → Actividades artísticas, de entretenimiento, de recreación y otras actividades de servicios

---

## Módulo C — Emprendimiento

*Hoja original: `Módulo de emprendimiento`* — 4 variables propias

### `P3050` — [C1]. ¿Quién creó o constituyó el negocio o actividad?
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → Usted solo
  - `2` → Usted y otro(s) familiares
  - `3` → Usted y otra(s) persona(s) no familiar(es)
  - `4` → Otras personas
  - `5` → Un familiar
  - `6` → Otro ¿Quién?

### `P3051` — [C2]. ¿Cuál fue el motivo principal por el que usted inició este negocio o actividad económica?
- **Tipo:** Discreta
- **Categorías (7):**
  - `1` → No tiene otra alternativa de ingresos
  - `2` → Lo identificó como una oportunidad de negocio en el mercado
  - `3` → Por tradición familiar o lo heredó
  - `4` → Para complementar el ingreso familiar o mejorar el ingreso
  - `5` → Para ejercer su oficio, carrera o profesión
  - `6` → No tenía la experiencia requerida, la escolaridad o capacitación para un empleo
  - `7` → Otro ¿cuál?

### `P639` — [C3]. ¿Cuánto tiempo lleva funcionado el negocio o actividad?
- **Tipo:** Discreta
- **Categorías (5):**
  - `1` → Menos de un año
  - `2` → De 1 a menos de 3 años
  - `3` → De 3 a menos de 5 años
  - `4` → De 5 a menos de 10 años
  - `5` → 10 años y más

### `P3052` — [C4]. ¿Cuál fue la mayor fuente de recursos para la creación o constitución de este negocio o actividad?
- **Tipo:** Discreta
- **Categorías (8):**
  - `1` → Ahorros personales
  - `2` → Préstamos familiares
  - `3` → Préstamos bancarios
  - `4` → Prestamistas
  - `5` → Capital semilla
  - `6` → No requirió financiación
  - `7` → No sabe
  - `8` → Otro ¿cuál?

---

## Módulo D — Sitio o ubicación

*Hoja original: `Módulo de sitio o ubicación`* — 8 variables propias

### `P3053` — [D1]. ¿El negocio o actividad se encuentra principalmente:
- **Tipo:** Discreta
- **Categorías (8):**
  - `1` → En su vivienda o en otra vivienda
  - `2` → Local, tienda, taller, fábrica, oficina,consultorio
  - `3` → De puerta en puerta (a domicilio)
  - `4` → Ambulante - sitio al descubierto
  - `5` → Vehículo con o sin motor?
  - `6` → Obra y construcción
  - `7` → Finca
  - `8` → Otra

### `P3095` — [D2]. La vivienda ¿
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Tiene un espacio exclusivo para la actividad
  - `2` → No tiene un  espacio exclusivo para la actividad

### `P3096` — [D3]. Especifique cuál ¿
- **Tipo:** Discreta
- **Categorías (4):**
  - `1` → Local - tienda
  - `2` → Taller -  fábrica
  - `3` → Oficina -consultorio
  - `4` → En kiosco - caseta

### `P3097` — [D4]. La actividad la desarrolla principalmente ...
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → En el domicilo de sus clientes
  - `2` → Visitando  locales o negocios de sus clientes

### `P3098` — [D5]. La actividad es ¿
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Móvil
  - `2` → Estacionaria

### `P3054` — [D6]. ¿Cuántos puestos, establecimientos, oficinas, talleres, vehículos tienen el negocio o actividad?
- **Tipo:** Continua

### `P3055` — [D7]. El puesto, local, oficina, consultorio, tienda, vehículo o lugar donde desarrolla su negocio o actividad es:
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → Propio, totalmente pagado ?
  - `2` → Propio, lo están pagando ?
  - `3` → En arriendo o subarriendo ?
  - `4` → En usufructo ?
  - `5` → Posesión sin titulo (Ocupante  de hecho) o propiedad colectiva ?
  - `6` → Otro ¿cuál?

### `P469` — [D8]. El negocio o actividad económica es visible al público?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

---

## Módulo E1 — Personal ocupado (propietario)

*Hoja original: `Módulo personal ocupado (propie`* — 8 variables propias

### `P3088` — [E1_1].¿Pagó su salud y/o pensión el mes anterior?
- **Tipo:** Discreta
- **Categorías (4):**
  - `1` → Si
  - `2` → No
  - `3` → Solo salud
  - `4` → Solo pensión

### `P3089` — [E1_2]. ¿Cuánto pagó el mes pasado en salud y pensión?
- **Tipo:** Continua

### `P3090` — [E1_3]. ¿Pagó su ARL ?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P2989` — [E1_4]. ¿Pagó Caja de Compensación o aportó al SENA o ICBF?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3091` — [E2]. ¿Cuántas personas en promedio trabajaron en su negocio o actividad económica en el año anterior o en los meses de operación?
- **Tipo:** Continua

### `SUELDOS` — Sueldos y salarios mensuales
- **Tipo:** Continua

### `PRESTACIONES` — Prestaciones sociales mensuales
- **Tipo:** Continua

### `REMUNERACION_TOTAL` — Remuneración total mensual del personal ocupado
- **Tipo:** Continua

---

## Módulo E3 — Personal ocupado (trabajadores)

*Hoja original: `Módulo de personal ocupado`* — 13 variables propias

### `SECUENCIA_PH`
- **Tipo:** Discreta

### `TIPO` — [E3]. Personal ocupado
- **Tipo:** Discreta
- **Categorías (3):**
  - `1` → Trabajadores que reciben un pago
  - `2` → Socios
  - `3` → Trabajadores o familiares sin remuneración

### `P3077` — [E3_1.1]. Tipo de personal
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Contrato a término indefinido
  - `2` → Temporal

### `P3078` — [E3_1.2]. Sexo
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → Hombre
  - `2` → Mujer
  - `1` → Hombre
  - `2` → Mujer
  - `1` → Hombre
  - `2` → Mujer

### `P3079` — [E3_1.3]. ¿Cuánto le pagó el mes pasado ?
- **Tipo:** Continua

### `P3080` — [E3_1.4]. ¿ Le pagó salud y/o pensión el mes pasado ?
- **Tipo:** Discreta
- **Categorías (12):**
  - `1` → Si
  - `2` → No
  - `3` → Solo salud
  - `4` → Solo pensión
  - `1` → Si
  - `2` → No
  - `3` → Solo salud
  - `4` → Solo pensión
  - `1` → Si
  - `2` → No
  - `3` → Solo salud
  - `4` → Solo pensión

### `P3081` — [E3_1.5]. ¿Cuánto le pagó el mes pasado en salud y pensión?
- **Tipo:** Continua

### `P3082` — [E3_1.6]. ¿ Le pagó prestaciones sociales ?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3083` — [E3_1.7]. ¿Cuánto le pagó  por prestaciones sociales?
- **Tipo:** Continua

### `P3084` — [E3_1.8]. ¿Le pagó ARL ?
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → Sí
  - `2` → No
  - `1` → Sí
  - `2` → No
  - `1` → Sí
  - `2` → No

### `P2990` — [E3_1.9]. ¿Le pagó Caja de Compensación o aportó al SENA o ICBF?
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → Sí
  - `2` → No
  - `1` → Sí
  - `2` → No
  - `1` → Sí
  - `2` → No

### `P3085` — [E3_1.10]. ¿Cuántos meses lleva laborando este trabajador en el negocio o actividad?
- **Tipo:** Continua

### `P3099` — [E3_1.11]. ¿ Cuántos años cumplidos tiene ?
- **Tipo:** Continua

---

## Módulo F — Características del micronegocio (formalidad)

*Hoja original: `Módulo de características del m`* — 12 variables propias

### `P1633` — [F1]. ¿El negocio o actividad  tiene Registro Único Tributario (RUT)?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P986` — [F3].  ¿A que regimen pertenece?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Común
  - `2` → Simplificado

### `P640` — [F4].  ¿Cuál es el principal registro que utiliza para llevar sus cuentas?
- **Tipo:** Discreta
- **Categorías (5):**
  - `1` → Balance general o P y G
  - `2` → Libro de registro diario de operaciones
  - `3` → Otro tipo de cuentas (libreta, cuaderno, excel, caja registradora)
  - `4` → Informes financieros/ laborales/tributarios
  - `5` → No lleva registros

### `P4000` — [F5].  ¿Cual es la razón principal por la cual no lleva algun tipo de registro?
- **Tipo:** Discreta
- **Categorías (3):**
  - `1` → No se necesita
  - `2` → No sabe como llevar registros
  - `3` → No aplica

### `P1055` — [F6].  ¿El negocio o actividad  se encuentra registrado en alguna Cámara de Comercio?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1056` — [F7]. ¿Cómo está registrado?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Como persona natural comerciante
  - `2` → Como persona jurídica

### `P661` — [F8]. Obtuvo o renovó ese registro este año?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1057` — [F9]. ¿Ha registrado el negocio o actividad ante alguna autoridad o entidad (alcaldía, ministerios u otros)
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P4004` — [F10]. Cuál?
- **Tipo:** Discreta
- **Categorías (4):**
  - `1` → Alcaldía
  - `2` → Instituto Colombiano Agropecuario  - ICA
  - `3` → Ministerio
  - `4` → Otro, cuál ?

### `P2991` — [F11]. En el último año, ¿realizó las(s) declaracion(es) de impuesto sobre la renta
- **Tipo:** Discreta
- **Categorías (4):**
  - `1` → Si
  - `2` → No
  - `3` → No es responsable de este impuesto
  - `9` → No Informa

### `P2992` — [F12]. En el último año, ¿realizó las(s) declaracion(es) de IVA (Impuesto al Valor Agregado)
- **Tipo:** Discreta
- **Categorías (4):**
  - `1` → Si
  - `2` → No
  - `3` → No es responsable de este impuesto
  - `9` → No Informa

### `P2993` — [F13]. En el último año, ¿realizó las(s) declaracion(es) de ICA (Impuesto de Industria y Comercio)
- **Tipo:** Discreta
- **Categorías (4):**
  - `1` → Si
  - `2` → No
  - `3` → No es responsable de este impuesto
  - `9` → No Informa

---

## Módulo G — Tecnologías de la información (TIC)

*Hoja original: `Módulo de TIC`* — 28 variables propias

### `P4001` — [G1]. ¿Para su negocio o actividad utiliza alguno(a) de los siguientes dispositivos electrónicos ?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1087` — [G2]. ¿Cuántos computadores de escritorio tiene en uso el negocio o actividad?
- **Tipo:** Continua

### `P1088` — [G3]. ¿Cuántos computadores portátiles tiene en uso el negocio o actividad?
- **Tipo:** Continua

### `P977` — [G4]. ¿Cuántas tabletas tiene en uso el negocio o actividad?
- **Tipo:** Continua

### `P976` — [G4_A]. ¿Para su negocio o actividad utiliza el teléfono celular?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P978` — [G5]. ¿Cuántos teléfonos celulares inteligentes (Smartphone) tiene en uso el negocio o actividad?
- **Tipo:** Continua

### `P979` — [G5_A]. ¿Cuántos teléfonos celular convencional tiene en uso el negocio o actividad?
- **Tipo:** Continua

### `P994` — [G6]. ¿Cuál es la principal razón por la cual el negocio o actividad no tiene en uso computador (PC, portátil), tableta, Smartphone?
- **Tipo:** Discreta
- **Categorías (3):**
  - `1` → Es muy costoso
  - `2` → No se necesita
  - `3` → El personal no sabe usarlo

### `P2532` — [G7]. El negocio o actividad tiene página web  o presencia en un sitio web?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1559` — [G8]. El negocio o actividad tiene presencia en redes sociales (Facebook, twitter, etc.)?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P2524` — [G9]. ¿Este negocio o actividad tiene acceso o utiliza el servicio de internet?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1093` — [G10]. ¿Utiliza internet con conexión dentro del negocio o donde desarrolla su  actividad?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P2528` — [G11]. ¿Qué tipo de conexión utiliza principalmente el negocio para acceder a internet?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Fijo
  - `2` → Móvil

### `P1095` — [G12]. ¿Cuál es la principal razón por la cual el negocio o actividad no utiliza internet?
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → Es muy costoso
  - `2` → No lo necesita
  - `3` → El personal no sabe usarlo
  - `4` → No tiene dispositivo para conectarse (computadores, tabletas, entre otros)
  - `5` → El servicio no es de buena calidad
  - `6` → No hay cobertura del servicio  en la zona

### `P980` — [G13]. Del total del personal ocupado del negocio o actividad, ¿cuántos utilizan internet para el desarrollo de sus actividades?
- **Tipo:** Continua

### `P1006_1` — Búsqueda de información de dependencias oficiales y autoridades
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_2` — Banca electrónica y otros servicios financieros
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_3` — Transacciones con organismos gubernamentales
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_4` — Servicio al cliente
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_5` — Entrega de productos en forma digitalizada (a través de internet)
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_6` — Comprar a proveedores por internet mediante una plataforma electrónica (comercio electrónico)
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_7` — Vender productos a clientes por internet mediante una plataforma electrónica (comercio electrónico)
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_8` — Uso de aplicaciones
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_9` — Enviar o recibir correo electrónico
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_10` — Búsqueda de información sobre bienes y servicios
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_11` — Llamadas telefónicas por internet/VoIP o uso de videoconferencias (Skype, etc)
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_12` — Capacitación del personal
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1006_13` — Mensajería instantánea o chat  (por ej. WhatsApp, Messenger, Line, etc.)
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

---

## Módulo I — Costos, gastos y activos

*Hoja original: `Módulo de costos, gastos y acti`* — 38 variables propias

### `P3056_A` — [I1_A]. Costo de mercancía vendida
- **Tipo:** Continua

### `P3056_B` — [I1_B]. Costo de los insumos para la prestación del servicio
- **Tipo:** Continua

### `P3056_C` — [I1_C]. Costo de las materias primas, materiales y empaques?
- **Tipo:** Continua

### `P3056_D` — [I1_D]. Costos de producción agricola, pecuaria, extractiva (semillas, fertilizantes, fungicidas, preparación terreno, redes, alimento para animales )
- **Tipo:** Continua

### `P3057_A` — [I2_A]. Costo de mercancía vendida
- **Tipo:** Continua

### `P3057_B` — [I2_B]. Costo de los insumos para la prestación del servicio
- **Tipo:** Continua

### `P3057_C` — [I2_C]. Costo de las materias primas, materiales y empaques?
- **Tipo:** Continua

### `P3057_D` — [I2_D]. Costos de producción agricola, pecuaria, extractiva (semillas, fertilizantes, fungicidas, preparación terreno, redes, alimento para animales )
- **Tipo:** Continua

### `P3017_A` — [I3_A]. Arrendamiento de bienes inmuebles y muebles (local, maquinaria, etc.)
- **Tipo:** Continua

### `P3017_B` — [I3_B]. Energía eléctrica comprada
- **Tipo:** Continua

### `P3017_C` — [I3_C]. Servicio de teléfono, internet, televisión, plan de datos, descargas, transacciones en línea
- **Tipo:** Continua

### `P3017_D` — [I3_D]. Servicio de agua, acueducto, alcantarillado.
- **Tipo:** Continua

### `P3017_E` — [I3_E]. Consumo de combustibles (gas natural, gas propano en pipeta, gasolina, carbón, leña)
- **Tipo:** Continua

### `P3017_F` — [I3_F]. Mantenimiento y reparación del local, vehículos, o maquinaria
- **Tipo:** Continua

### `P3017_G` — [I3_G]. Transporte fletes y acarreos (parqueadero)
- **Tipo:** Continua

### `P3017_H` — [I3_H]. Publicidad, propaganda, servicios profesionales (contador, abogado)
- **Tipo:** Continua

### `P3017_K` — [I3_K]. Otros gastos (aseo y vigilancia, administración, entre otros)
- **Tipo:** Continua

### `P3017_I` — [I3_I]. Licencias de funcionamiento, registro mercantil o tarifas de asociaciónes gremiales
- **Tipo:** Continua

### `P3017_J` — [I3_J]. Impuestos (predial, rodamiento, SOAT, sayco)
- **Tipo:** Continua

### `P3017_L` — [I3_L]. Otros pagos asociados al proceso productivo y de comercialización (INVIMA, carné manipulación de alimento, etc.)
- **Tipo:** Continua

### `P3018_1` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Terrenos o local

### `P3018_2` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Maquinaria o  herramientas

### `P3018_3` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Equipo de informática (hardware/software) y comunicación

### `P3018_4` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Muebles o equipos de oficina

### `P3018_5` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Vehículos

### `P3018_6` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Otros activos

### `P3018_7` — [I4]. En el año anterior en su negocio o actividad invirtió en la compra o adquisición de:
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → No invirtió

### `P3018_A` — [I4_A]. Terrenos o local
- **Tipo:** Continua

### `P3018_B` — [I4_B]. Maquinaria o herramientas
- **Tipo:** Continua

### `P3018_C` — [I4_C]. Equipo de informática (hardware/sotware) y comunicación
- **Tipo:** Continua

### `P3018_D` — [I4_D]. Muebles o equipos de oficina
- **Tipo:** Continua

### `P3018_E` — [I4_E]. Vehiculos
- **Tipo:** Continua

### `P3018_F` — [I4_F]. Otros activos
- **Tipo:** Continua

### `P3019` — [I5]. Si usted tuviera que comprar las herramientas, maquinaria, muebles, equipo de informática, terreno, local y vehículos que utiliza en su negocio, ¿Cuánto cree que costaría?
- **Tipo:** Continua

### `COSTOS_MES_ANTERIOR` — P3056_A + P3056_B + P3056_C + P3056_D
- **Tipo:** Continua

### `COSTOS_ANIO_ANTERIOR` — P3057_A + P3057_B + P3057_C + P3057_D
- **Tipo:** Continua

### `GASTOS_MES` — P3017_A + P3017_B + P3017_C + P3017_D + P3017_E + P3017_F + P3017_G + P3017_H + P3017_K
- **Tipo:** Continua

### `CONSUMO_INTERMEDIO` — Consumo intermedio mensual
- **Tipo:** Continua

---

## Módulo J — Ventas o ingresos

*Hoja original: `Módulo de ventas o ingresos`* — 75 variables propias

### `P3057` — [J1A_1A]. Ventas de productos elaborados
- **Tipo:** Continua

### `P3058` — [J1A_1B]. Servicio de maquila
- **Tipo:** Continua

### `P3059` — [J1A_1C]. Servicios de reparación y mantenimiento
- **Tipo:** Continua

### `P3060` — [J1A_1D]. Otros ingresos
- **Tipo:** Continua

### `P3061` — [J1A_2A]. Venta de mercancía
- **Tipo:** Continua

### `P3062` — [J1A_2B]. Por consignación o comisión
- **Tipo:** Continua

### `P4002` — [J1A_2C]. Servicios de reparación y mantenimiento
- **Tipo:** Continua

### `P3063` — [J1A_2D]. Otros ingresos
- **Tipo:** Continua

### `P3064` — [J1A_3A]. Ingresos por los servicios ofrecidos
- **Tipo:** Continua

### `P3065` — [J1A_3B]. Ingresos por Mantenimiento y reparación
- **Tipo:** Continua

### `P3066` — [J1A_3C]. Por ventas de mercancías
- **Tipo:** Continua

### `P3067` — [J1A_3D]. Otros ingresos
- **Tipo:** Continua

### `P3092` — [J1A_4A]. Ingresos por venta de productos agrícolas, ganaderos, pesqueros, o actividades mineras
- **Tipo:** Continua

### `P3093` — [J1A_4B]. Otros ingresos
- **Tipo:** Continua

### `P4005` — [J1B_1A]. Ventas de productos elaborados
- **Tipo:** Continua

### `P4006` — [J1B_1B]. Servicio de maquila
- **Tipo:** Continua

### `P4007` — [J1B_1C]. Servicios de reparación y mantenimiento
- **Tipo:** Continua

### `P4008` — [J1B_1D]. Otros ingresos
- **Tipo:** Continua

### `P4009` — [J1B_2A]. Venta de mercancía
- **Tipo:** Continua

### `P4010` — [J1B_2B]. Por consignación o comisión
- **Tipo:** Continua

### `P4011` — [J1B_2C]. Servicios de reparación y mantenimiento
- **Tipo:** Continua

### `P4012` — [J1B_2D]. Otros ingresos
- **Tipo:** Continua

### `P4013` — [J1B_3A]. Ingresos por los servicios ofrecidos
- **Tipo:** Continua

### `P4014` — [J1B_3B]. Ingresos por Mantenimiento y reparación
- **Tipo:** Continua

### `P4015` — [J1B_3C]. Por ventas de mercancías
- **Tipo:** Continua

### `P4016` — [J1B_3D]. Otros ingresos
- **Tipo:** Continua

### `P4017` — [J1B_4A]. Ingresos por venta de productos agrícolas, ganaderos, pesqueros, o actividades mineras
- **Tipo:** Continua

### `P4018` — [J1B_4B]. Otros ingresos
- **Tipo:** Continua

### `P3075` — [J2]. ¿A qué mes corresponde este valor?
- **Tipo:** Discreta
- **Categorías (12):**
  - `1` → Enero
  - `10` → Octubre
  - `11` → Noviembre
  - `12` → Diciembre
  - `2` → Febrero
  - `3` → Marzo
  - `4` → Abril
  - `5` → Mayo
  - `6` → Junio
  - `7` → Julio
  - `8` → Agosto
  - `9` → Septiembre

### `P3068_1` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Enero

### `P3068_ENE` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Enero

### `P3068_2` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Febrero

### `P3068_FEB` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Febrero

### `P3068_3` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Marzo

### `P3068_MAR` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Marzo

### `P3068_4` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Abril

### `P3068_ABR` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Abril

### `P3068_5` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Mayo

### `P3068_MAY` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Mayo

### `P3068_6` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Junio

### `P3068_JUN` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Junio

### `P3068_7` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Julio

### `P3068_JUL` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Julio

### `P3068_8` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Agosto

### `P3068_AGO` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Agosto

### `P3068_9` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `9` → Septiembre

### `P3068_SEP` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `9` → Septiembre

### `P3068_10` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `10` → Octubre

### `P3068_OCT` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `10` → Octubre

### `P3068_11` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `11` → Noviembre

### `P3068_NOV` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `11` → Noviembre

### `P3068_12` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `12` → Diciembre

### `P3068_DIC` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `12` → Diciembre

### `P3068_TOD` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `13` → Todos los 12 meses

### `P3068_NIN` — [J3]. ¿Cuáles meses funcionó el negocio, o trabajó en su actividad durante el año anterior?
- **Tipo:** Discreta
- **Categorías (1):**
  - `14` → Ninguno

### `P4019` — [J4_1A]. Ventas de productos elaborados
- **Tipo:** Continua

### `P4020` — [J4_1B]. Servicio de maquila
- **Tipo:** Continua

### `P4021` — [J4_1C]. Servicios de reparación y mantenimiento
- **Tipo:** Continua

### `P4022` — [J4_1D]. Otros ingresos
- **Tipo:** Continua

### `P4023` — [J4_2A]. Venta de mercancía
- **Tipo:** Continua

### `P4024` — [J4_2B]. Por consignación o comisión
- **Tipo:** Continua

### `P4025` — [J4_2C]. Servicios de reparación y mantenimiento
- **Tipo:** Continua

### `P4026` — [J4_2D]. Otros ingresos
- **Tipo:** Continua

### `P4027` — [J4_3A]. Ingresos por los servicios ofrecidos
- **Tipo:** Continua

### `P4028` — [J4_3B]. Ingresos por Mantenimiento y reparación
- **Tipo:** Continua

### `P4029` — [J4_3C]. Por ventas de mercancías
- **Tipo:** Continua

### `P4030` — [J4_3D]. Otros ingresos
- **Tipo:** Continua

### `P4031` — [J4_4A]. Ingresos por venta de productos agrícolas, ganaderos, pesqueros, o actividades mineras
- **Tipo:** Continua

### `P4032` — [J4_4B]. Otros ingresos
- **Tipo:** Continua

### `P3072` — [J5]. En promedio ¿cuánto le deja su negocio o actividad al mes?
- **Tipo:** Continua

### `VENTAS_MES_ANTERIOR` — P3057 + P3058 + P3059 + P3060 + P3061 + P3062 + P4002 + P3063 + P3064 + P3065 + P3066 + P3067 + P3092 + P3093
- **Tipo:** Continua

### `VENTAS_MES_ANIO_ANTERIOR` — P4005 + P4006 + P4007 + P4008 + P4009 + P4010 + P4011 + P4012 + P4013 + P4014 + P4015 + P4016 + P4017 + P4018
- **Tipo:** Continua

### `VENTAS_ANIO_ANTERIOR` — P4019 + P4020 + P4021 + P4022 + P4023 + P4024 + P4025 + P4026 + P4027 + P4028 + P4029 + P4030 + P4031 + P4032
- **Tipo:** Continua

### `VALOR_AGREGADO` — Valor agregado mensual
- **Tipo:** Continua

### `INGRESO_MIXTO` — Ingreso mixto mensual
- **Tipo:** Continua

---

## Módulo H — Inclusión financiera

*Hoja original: `Módulo de inclusión financiera`* — 35 variables propias

### `P1764_1` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Efectivo

### `P1764_2` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Cheque

### `P1764_3` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Transferencia bancaria, Pagos por internet

### `P1764_4` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Facturas, para ser pagadas por sus clientes a los 15, 30 o más días

### `P1764_5` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Tarjeta débito

### `P1764_6` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Tarjeta crédito

### `P1764_7` — [H1]. ¿Cuáles formas de pago acepta en su negocio?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Otro

### `P1765` — [H2]. En el año anterior ¿solicitó algún crédito o préstamo para la gestión de su negocio o actividad económica?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1567` — [H3]. ¿Por qué no ha solicitado algún crédito o préstamo?
- **Tipo:** Discreta
- **Categorías (6):**
  - `1` → No lo necesita
  - `2` → Miedo a las deudas - No le gusta endeudarse
  - `3` → No cumple los requisitos (garantías, codeudores, avales, fiadores)
  - `4` → Los intereses y comisiones son muy altos
  - `5` → Está reportado negativamente en Centrales de Riesgos
  - `6` → Otro, ¿cuál?

### `P1569` — [H4]. ¿A quién solicitó el préstamo?
- **Tipo:** Discreta
- **Categorías (7):**
  - `1` → Institución financiera regulada (bancos, cooperativas, compañías de financiamiento, etc.)
  - `2` → Crédito de proveedores
  - `3` → Casa de empeño
  - `4` → Entidades Micro crediticias (ONG)
  - `5` → Prestamista, gota a gota
  - `6` → Familiares o amigos
  - `7` → Otro, ¿cuál?

### `P1568` — [H5]. ¿Obtuvo el crédito o préstamo solicitado?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1571_1` — [H5_A]. ¿Por qué no lo obtuvo?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Falta de garantías (fiador o aval)

### `P1571_2` — [H5_A]. ¿Por qué no lo obtuvo?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Está reportado en centrales de riesgo

### `P1571_3` — [H5_A]. ¿Por qué no lo obtuvo?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → No tiene historial crediticio

### `P1571_4` — [H5_A]. ¿Por qué no lo obtuvo?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → No puede demostrar ingresos

### `P1571_5` — [H5_A]. ¿Por qué no lo obtuvo?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Tiene ingresos insuficientes

### `P1571_6` — [H5_A]. ¿Por qué no lo obtuvo?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Otro

### `P1570` — [H6]. ¿Para qué utilizó (o va utilizar) el crédito que solicitó?
- **Tipo:** Discreta
- **Categorías (3):**
  - `1` → Para invertir en el negocio
  - `2` → Para cubrir gastos personales u otros
  - `3` → Todas las Anteriores

### `P1570_1` — [H6_1]. Porcentaje invertido en el negocio
- **Tipo:** Continua

### `P1570_2` — [H6_2]. Porcentaje para cubrir gastos personales u otros
- **Tipo:** Continua

### `P1572_1` — [H6_A]. ¿El dinero destinado al negocio lo gastó en?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Compra de materia prima, insumos, inventarios y demás gastos operativos y de funcionamiento

### `P1572_2` — [H6_A]. ¿El dinero destinado al negocio lo gastó en?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Pagó de nómina

### `P1572_3` — [H6_A]. ¿El dinero destinado al negocio lo gastó en?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Mejora de las condiciones de plazo, tasa o amortización de créditos vigentes

### `P1572_4` — [H6_A]. ¿El dinero destinado al negocio lo gastó en?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Compra o arriendo de maquinaria y equipos

### `P1572_5` — [H6_A]. ¿El dinero destinado al negocio lo gastó en?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Remodelaciones o adecuaciones para ampliar o mejorar la capacidad productiva de comercialización o de servicios

### `P1572_6` — [H6_A]. ¿El dinero destinado al negocio lo gastó en?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Emergencias / imprevistos del negocio

### `P3014` — [H7]. En el año anterior ¿Ahorró dinero de su negocio o actividad ?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P1573_1` — [H7_A]. ¿En qué va a usar o usó el dinero que ahorró?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Cubrir gastos del negocio cuando los ingresos no sean suficientes

### `P1573_2` — [H7_A]. ¿En qué va a usar o usó el dinero que ahorró?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Surtir el negocio para temporadas altas

### `P1573_3` — [H7_A]. ¿En qué va a usar o usó el dinero que ahorró?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Ampliar el negocio (ampliar o abrir nuevas sucursales, comprar maquinaria)

### `P1573_4` — [H7_A]. ¿En qué va a usar o usó el dinero que ahorró?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Iniciar otro negocio con una actividad diferente

### `P1573_5` — [H7_A]. ¿En qué va a usar o usó el dinero que ahorró?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → Cubrir los gastos personales o del hogar (salud, educación, viajes, etc.

### `P1573_6` — [H7_A]. ¿En qué va a usar o usó el dinero que ahorró?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Pagar deudas del negocio

### `P1574` — [H7_B]. ¿Por qué no ahorró?
- **Tipo:** Discreta
- **Categorías (5):**
  - `1` → No le alcanzó
  - `2` → No necesita / No le interesa ahorrar
  - `3` → No sabe como ahorrar
  - `4` → No le han ofrecido productos para ahorrar
  - `5` → No confía en las entidades financieras

### `P1771` — [H8]. ¿En dónde ahorró?
- **Tipo:** Discreta
- **Categorías (7):**
  - `1` → En una institución financiera / a través de una cuenta de ahorro
  - `2` → A través de cooperativas o fondos de empleados
  - `3` → A través de un grupo de ahorro / cadena /natillera
  - `4` → A través de familiares o amigos
  - `5` → A través de compra de activos (inversión en joyas, casas, apartamentos, lotes, locales, bodegas, lotes, muebles, etc.)
  - `6` → En su vivienda
  - `7` → Otro, cuál?

---

## Módulo K — Capital social

*Hoja original: `Módulo de capital social`* — 73 variables propias

### `P3002` — [K1_A].  ¿El negocio o actividad económica pertenece a alguna asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3003_1` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3003_2` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3003_3` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3003_4` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3003_5` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3003_6` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3003_7` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3003_8` — [K1_B].  ¿Qué servicios recibe de esta asociación de productores y/o comerciantes?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3004` — [K1_C].  ¿El negocio o actividad económica pertenece a alguna Cooperativa?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3005_1` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3005_2` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3005_3` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3005_4` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3005_5` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3005_6` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3005_7` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3005_8` — [K1_D].  ¿Qué servicios recibe de esta Cooperativa?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3006` — [K1_E].  ¿El negocio o actividad económica pertenece a alguna junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3007_1` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3007_2` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3007_3` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3007_4` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3007_5` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3007_6` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3007_7` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3007_8` — [K1_F].  ¿Qué servicios recibe de esta junta de acción Comunal?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3008` — [K1_G].  ¿El negocio o actividad económica pertenece a alguna Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3009_1` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3009_2` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3009_3` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3009_4` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3009_5` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3009_6` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3009_7` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3009_8` — [K1_H].  ¿Qué servicios recibe de esta Organización de vigilancia o seguridad?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3010` — [K1_I].  ¿El negocio o actividad económica pertenece a alguna Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3011_1` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3011_2` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3011_3` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3011_4` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3011_5` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3011_6` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3011_7` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3011_8` — [K1_J].  ¿Qué servicios recibe de esta Veeduria ciudadana?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3012` — [K1_K].  ¿El negocio o actividad económica pertenece a algun Grupo ambientalista?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3013_1` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3013_2` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3013_3` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3013_4` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3013_5` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3013_6` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3013_7` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3013_8` — [K1_L].  ¿Qué servicios recibe de este Grupo ambientalidta?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3022` — [K1_M].  ¿El negocio o actividad económica pertenece a alguna Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3015_1` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3015_2` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3015_3` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3015_4` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3015_5` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3015_6` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3015_7` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3015_8` — [K1_N].  ¿Qué servicios recibe de esta Organización de población vulnerable?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P3016` — [K1_O].  ¿El negocio o actividad económica pertenece a alguna otra Organización?
- **Tipo:** Discreta
- **Categorías (2):**
  - `1` → Sí
  - `2` → No

### `P3021_1` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `1` → Comercialización

### `P3021_2` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `2` → Financiamiento

### `P3021_3` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `3` → Seguridad

### `P3021_4` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `4` → Capacitación / entrenamientos

### `P3021_5` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `5` → representación frente al estado

### `P3021_6` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `6` → Cobertura de riesgos

### `P3021_7` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `7` → Beneficios sociales

### `P3021_8` — [K1_P].  ¿Qué servicios recibe de ${P3020} ?
- **Tipo:** Discreta
- **Categorías (1):**
  - `8` → Actividades ambientales

### `P4003` — [K2]. Cuánto dinero invirtió el negocio o actividad en esta organización el mes pasado?
- **Tipo:** Discreta

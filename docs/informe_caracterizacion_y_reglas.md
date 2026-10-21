# Informe: Caracterización Multidimensional y Patrones de la Economía Popular (EMICRON 2024)

Este informe consolida los hallazgos de la caracterización descriptiva, la minería de reglas de asociación y la segmentación aplicadas sobre los microdatos de la **Encuesta de Micronegocios (EMICRON) 2024** del DANE (78.501 negocios encuestados que representan 5.297.252 micronegocios). Todas las cifras están ponderadas por el factor de expansión F_EXP y salen de `output/tablas/` (generadas por `main.R`) o del boletín técnico del DANE.

---

## 1. Caracterización Multidimensional (Hallazgos EDA)

### **A. Estructura de Propiedad y Género**
- **Predominancia Masculina:** El 64,6% de los micronegocios son liderados por hombres y el 35,4% por mujeres (38,0% en cabeceras y 29,5% en zonas rurales, según el boletín DANE).
- **Autoempleo:** El 90,5% de los propietarios trabaja por cuenta propia (solo el 9,5% son patrones) y el 82,3% de los negocios es unipersonal.

### **B. Madurez Digital y Formalización**
- **Brecha de Formalización:** El índice de formalización (0–5: RUT, Cámara de Comercio, registro contable, salud y pensión, declaración de renta) tiene un promedio de 0,81; el 60,7% de los negocios no cumple ningún criterio y solo el 2,2% cumple los cinco. El 77,6% no tiene RUT.
- **Adopción Digital:** El 70,9% usa el celular para el negocio, pero solo el 49,6% tiene internet y el 10,9% usa computador o tableta. El índice digital (0–4) tiene un promedio de 1,36. El 21,6% de los negocios (1,15 millones) usa celular pero no tiene internet.

Fuentes: `output/tablas/boletin/`, `output/tablas/03_indices_distribucion.csv`, `output/tablas/11c_celular_x_internet.csv`.

---

## 2. Minería de Reglas de Asociación (Apriori)

Apriori se ejecutó sobre 30 variables categóricas (77.202 registros completos) con **soporte ≥ 15%**, **confianza ≥ 70%** y antecedentes de hasta tres ítems. De 119.456 reglas quedaron 55.906 no redundantes. Las medidas se recalcularon ponderando cada registro por F_EXP; abajo se reportan las ponderadas.

### **Patrón 1: El Ecosistema de la Exclusión Digital**
`{Sin Dispositivos, Sin Celular de Negocio, Sin Transferencias} => {Sin Internet en el Local}`
- **Confianza:** 99,6% | **Soporte:** 27,6% | **Lift:** 1,90
- **Interpretación:** La exclusión digital es acumulada: en un núcleo de micronegocios que opera en un entorno totalmente analógico, la ausencia de una herramienta coincide con la ausencia de las demás. El patrón se mantiene en las 16 combinaciones de umbrales evaluadas.

### **Patrón 2: El Celular como Puerta de Entrada**
`{Internet en Local, Sin Computador/Tablet, Acepta Transferencias} => {Usa Celular de Negocio}`
- **Confianza:** 99,7% | **Soporte:** 24,3% | **Lift:** 1,40
- **Interpretación:** Para la economía popular, el celular es la herramienta digital central: los negocios conectados que aceptan transferencias sin usar computador lo hacen casi siempre a través del celular.

### **Patrón 3: La Informalidad y la Gestión Analógica**
`{Sin Registro Contable, Sin Celular de Negocio, No Responsable de IVA} => {Sin RUT}`
- **Confianza:** 96,8% | **Soporte:** 24,3% | **Lift:** 1,25
- **Interpretación:** La falta de RUT co-ocurre con la ausencia de registros contables y de herramientas móviles de trabajo.

### **Patrón 4: RUT y Pagos Digitales**
`{Tiene RUT, Usa Celular} => {Acepta Transferencias}`
- **Lift:** 2,01 (el más alto de todo el conjunto de reglas)
- **Interpretación:** La formalización fiscal está fuertemente asociada a los pagos digitales. Con soporte ≥ 5%, las combinaciones de internet, transferencias y local fijo se asocian con tener RUT (confianza ~77%, lift 3,4): el RUT **no** es independiente del resto del sistema, aunque esas combinaciones abarcan solo alrededor del 6% del universo.

Fuentes: `output/tablas/06b_reglas_ponderadas.csv`, `12a_reglas_clave.csv`, `12d_reglas_rut_sin_formalizacion.csv`.

---

## 3. Segmentación en Tres Grupos

Definida cruzando acceso a internet y tenencia de RUT (`scripts/06_segmentacion.R`):

| Grupo | Definición | % del universo | Acepta transferencias | Lleva registros | Ahorró |
|---|---|---|---|---|---|
| Excluidos | Sin internet y sin RUT | 46,2% | 5,7% | 12,6% | 11,6% |
| En transición | Solo uno de los dos | 35,7% | 57,6% | 34,5% | 19,8% |
| Integrados | Internet y RUT | 18,2% | 86,9% | 75,4% | 31,1% |

Fuentes: `output/tablas/11_segmentacion_grupos.csv`, `11b_perfil_grupos.csv`.

---

## 4. Conclusiones Estratégicas

1.  **Focalización en el Celular:** Los programas de fortalecimiento deberían centrarse en el celular como herramienta de productividad, no en software de escritorio (solo el 10,9% usa computador o tableta).
2.  **Conectividad como cuello de botella:** 1,15 millones de negocios tienen celular pero no internet; completar ese eslabón es presumiblemente más barato que empezar desde cero.
3.  **Formalización acompañada de herramientas:** Dado que el RUT co-ocurre con pagos digitales, registros contables y local fijo, la formalización podría promoverse junto con herramientas de gestión y pagos simplificadas, no solo mediante registros legales.

> Estos patrones son asociaciones en datos de corte transversal; no permiten afirmar relaciones causales.

---
**Generado por:** Pipeline Analítico EMICRON 2024
**Fecha:** Octubre 2026
**Fuentes:** Microdatos DANE 2024.

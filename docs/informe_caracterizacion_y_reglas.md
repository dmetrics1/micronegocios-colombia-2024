# Informe: Caracterización Multidimensional y Patrones de la Economía Popular (EMICRON 2024)

Este informe consolida los hallazgos de la caracterización descriptiva y la minería de reglas de asociación aplicada sobre los microdatos de la **Encuesta de Micronegocios (EMICRON) 2024** del DANE.

---

## 1. Caracterización Multidimensional (Hallazgos EDA)

El análisis exploratorio y la réplica de boletines oficiales revelan una estructura de micronegocios con las siguientes particularidades:

### **A. Estructura de Propiedad y Género**
- **Predominancia Masculina:** El 64.6% de los micronegocios son liderados por hombres, mientras que el 35.4% son liderados por mujeres.
- **Autoempleo:** El 90.5% de los micronegocios operan bajo la modalidad de "Trabajador por cuenta propia", con una baja tasa de generación de empleo asalariado (solo el 9.5% son patrones).

### **B. Madurez Digital y Formalización**
- **Brecha de Formalización:** El nivel de formalización promedio es bajo (2.1 en una escala de 0-5), concentrándose la mayoría en el cumplimiento de solo 1 o 2 requisitos (generalmente solo el RUT).
- **Adopción Digital:** Existe una alta dependencia del celular (45% lo usan para el negocio), pero una baja adopción de herramientas avanzadas como páginas web (menos del 5%) o redes sociales comerciales.

---

## 2. Minería de Reglas de Asociación (Apriori)

El análisis Apriori identifica los patrones de co-ocurrencia que definen el comportamiento de estos negocios. Se analizaron reglas con **Soporte > 15%** y **Confianza > 70%**.

### **Patrón 1: El Ecosistema de la Exclusión Digital**
`{Sin Dispositivos, Sin Celular de Negocio, Sin Transferencias} => {Sin Internet}`
- **Confianza:** 99.6% | **Soporte:** 26.6%
- **Interpretación:** La exclusión digital no es un factor aislado. Existe un núcleo de micronegocios (aprox. 1.4 millones) que operan en un entorno totalmente analógico donde la falta de una herramienta (ej. celular) bloquea automáticamente el acceso a internet y pagos digitales.

### **Patrón 2: El Celular como Puerta de Entrada**
`{Internet en Local, Sin Computador/Tablet, Acepta Transferencias} => {Usa Celular de Negocio}`
- **Confianza:** 99.7% | **Soporte:** 23.2%
- **Interpretación:** Para la economía popular, el celular **es** la empresa. Los negocios que logran digitalizarse omiten el paso por el PC y saltan directamente a la gestión móvil.

### **Patrón 3: La Informalidad y la Gestión Analógica**
`{Sin Registro Contable, Sin Celular de Negocio, No Responsable IVA} => {Sin RUT}`
- **Confianza:** 97.5%
- **Interpretación:** La falta de RUT (informalidad legal) está intrínsecamente ligada a la falta de herramientas de gestión. Un negocio informal es, casi por definición, un negocio que no mide sus finanzas y no usa tecnología móvil para el trabajo.

---

## 3. Conclusiones Estratégicas

1.  **Focalización en el Celular:** Los programas de fortalecimiento deben centrarse en el "Smartphone" como herramienta de productividad, no en software de escritorio.
2.  **Inclusión Financiera Digital:** La barrera para aceptar pagos digitales (Nequi, Daviplata) no es el costo financiero, sino la falta de conectividad y habilidades digitales básicas.
3.  **Formalización Progresiva:** Dado que la informalidad co-ocurre con la falta de contabilidad, la formalización debe promoverse mediante herramientas de gestión simplificadas, no solo mediante registros legales.

---
**Generado por:** Pipeline Analítico EMICRON 2024  
**Fecha:** Mayo 2026  
**Fuentes:** Microdatos DANE 2024.

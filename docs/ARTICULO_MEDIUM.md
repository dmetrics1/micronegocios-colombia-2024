# ¿Qué hace que un micronegocio sobreviva en Colombia? Un enfoque de Machine Learning

**Por Daniel Molina - Economista & Data Scientist**

En Colombia, los micronegocios son la columna vertebral de la economía popular. Sin embargo, su tasa de mortalidad es alta. Desde el Estado y las entidades financieras se lanzan constantemente programas de formalización y crédito, pero a menudo se comete un error crítico: **tratar a todos los micronegocios como si fueran iguales.**

Un vendedor ambulante que subsiste en el día a día no tiene las mismas necesidades que una panadería familiar de barrio o que una pequeña agencia de marketing digital operando desde casa. 

Para comprobar esto y entender qué factores realmente predicen la supervivencia en el mercado, tomé los microdatos de la **Encuesta de Micronegocios (EMICRON) 2024 del DANE** y apliqué técnicas de Machine Learning (Análisis de Correspondencias Múltiples y XGBoost). 

Aquí presento tres hallazgos clave que cambian la perspectiva sobre la economía popular.

---

### Hallazgo 1: No existe "El Micronegocio", existen Tipologías
Mediante un modelo no supervisado (MCA + Clustering K-Means) sobre más de 85.000 registros, logramos agrupar los micronegocios en cinco tipologías empresariales claras:

1. **Vulnerable / Subsistencia:** Alta informalidad, bajos ingresos, sin acceso a TIC. Viven al día.
2. **Cuenta Propia Precario:** Autoempleo informal, sin local fijo, capital social nulo.
3. **Familiar Tradicional:** Negocios de barrio (ej. tiendas). Tienen alguna trayectoria, pero con baja adopción tecnológica y formalización mixta.
4. **Digital Emergente:** Jóvenes, operan desde vivienda, usan internet intensivamente para ventas, pero aún con baja formalidad tributaria.
5. **Formal Consolidado:** Negocios estructurados con RUT, Cámara de Comercio, contabilidad y empleados formales. Altas ventas y supervivencia masiva.

Tratar de aplicar la misma política de crédito al grupo 1 y al grupo 4 es garantizar el fracaso del programa.

### Hallazgo 2: La Formalización no es la causa, es el reflejo
Al entrenar un modelo **XGBoost** para predecir si un negocio superará la barrera crítica de los 3 años de vida (sobreviviente vs. frágil) y analizar su explicabilidad mediante **Valores SHAP**, el Índice de Formalización apareció como una de las variables predictoras más fuertes.

Sin embargo, en economía sabemos que la relación no siempre es causal. Un negocio no sobrevive *mágicamente* por sacar el RUT o pagar Cámara de Comercio. Más bien, la formalización actúa como un **indicador de madurez y productividad**: los negocios que alcanzan cierto nivel de tracción y margen financiero terminan formalizándose para poder crecer, acceder a mercados corporativos o créditos grandes. 

*(Insertar aquí: `FINAL_03_mapa_sofisticacion.png` y `08_shap_dep_formalizacion.png`)*

### Hallazgo 3: La Digitalización y el Margen Operativo son los verdaderos escudos
Más allá del papel, las variables que el modelo XGBoost destacó para predecir la permanencia fueron el **Margen Operativo** (ventas frente a consumo intermedio) y el **Índice Digital** (uso de internet, redes sociales y celular para negocios).

Los micronegocios con altos márgenes iniciales tienen el "colchón" necesario para sobrevivir los primeros baches. Por su parte, la digitalización permite ampliar el embudo de clientes y reducir la dependencia de una ubicación física costosa.

*(Insertar aquí: `07_shap_beeswarm.png`)*

### ¿Qué significa esto para los tomadores de decisiones?
- **Para la banca (Bancóldex, Microfinancieras):** El modelo demuestra que variables no tradicionales (huella digital) pueden ser excelentes proxys de permanencia cuando no hay historial crediticio.
- **Para política pública (iNNpulsa, DNP):** La formalización obligada a un negocio "Vulnerable / Subsistencia" solo lo estrangulará. Las políticas deben orientarse primero al salto tecnológico y de productividad, dejando la formalidad tributaria como paso posterior.

Si quieres explorar el código en R (`data.table`, `tidymodels`, `FactoMineR`) y los detalles metodológicos para replicar este análisis oficial del DANE, puedes revisar el [repositorio completo en mi GitHub](#).

---
*Transformo datos en soluciones, productos y decisiones. Si tu organización busca exprimir el valor real de sus datos económicos, conectemos en LinkedIn.*

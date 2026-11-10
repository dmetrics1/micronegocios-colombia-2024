# Pendientes

Lista de seguimiento del proyecto. Las tareas marcadas con `[ ]` **no** están hechas.
Última actualización: 2026-11-10. Charla: viernes 13 de noviembre de 2026, Medellín.

## A. Acciones que requieren decisión del autor

- [x] Revisar el diff y hacer *commit* de los cambios del 2026-10-17 (análisis corregido, reporte, README, respuesta a revisores, presentación, pruebas, renv).
- [x] *Push* a GitHub (la rama `master` local coincide con `origin/master` al 2026-11-10).
- [ ] Comprobar en el navegador que GitHub Pages sirve el reporte y `presentacion/` con la última versión.
- [ ] Abrir `emicron.Rproj` y ejecutar `renv::restore()` (aún no se ha hecho; renv usa una biblioteca propia del proyecto; instala los paquetes del `renv.lock`).
- [ ] Enviar el resumen actualizado a LatinR cuando los organizadores manden las instrucciones (borrador en `paper/RESPUESTA_REVISORES.md`); actualizar el `.docx` de `paper/`.
- [ ] Marcar en Notion: README "aceptado" (19 oct) · post de LinkedIn (21 oct) · diapositivas (6 nov) · ensayo (10 nov).
- [x] Diapositivas de la charla (`presentacion/`) terminadas.
- [x] PDF de respaldo de las diapositivas generado (`presentacion/LatinR2026_Molina_respaldo.pdf`, 2026-11-10; no se versiona).
- [ ] Probar el PDF de respaldo en un proyector; decidir tema claro u oscuro según el salón.
- [ ] Ensayar la charla con cronómetro (15 min + 5 de preguntas) leyendo las notas del orador (tecla `N`).
- [ ] Verificar los términos de uso de los microdatos del DANE y enlazarlos en el README si corresponde.

## B. Revisión documental integral (aplazada)

Los documentos de `docs/` se escribieron en etapas distintas del proyecto y no se han contrastado con la implementación final.

- [x] Contrastar las cifras de `README.md`, `docs/informe_caracterizacion_y_reglas.md` y `docs/validacion/` con `output/tablas/` (2026-11-10); `docs/CUADROS_NUEVOS_AGREGADOS.md` y `docs/validacion/validacion_final_vs_dane.md` llevan una nota que los marca como históricos.
- [ ] Revisar integralmente la documentación histórica: `docs/PROTOCOLO_MAESTRO_EMICRON.md`, `docs/Diccionario_EMICRON_2024.md`, `docs/CUADROS_NUEVOS_AGREGADOS.md`.
- [ ] Recuperar y organizar los documentos locales no versionados en `reports/pdf/` (`PROGRESO_VALIDACION_70_CUADROS.md`, `VALIDACION_COMPARATIVA_CUADROS_VS_DANE.md`, `VALIDACION_FINAL_70_CUADROS.md`, boletines PDF del DANE): decidir cuáles se publican.
- [ ] Contrastar cada documento con los scripts finales (`scripts/01` a `07`).
- [ ] Identificar contradicciones, duplicidades y versiones antiguas (por ejemplo, referencias a "85 cuadros", a "legacy_04" o a 77.202 como tamaño de la muestra: 77.202 son los registros completos de Apriori; la muestra tiene 78.501).
- [ ] Consolidar la información dispersa en una estructura documental coherente (`docs/` con índice).
- [ ] Revisar la metodología, los supuestos, las decisiones técnicas y las referencias bibliográficas.
- [ ] Determinar qué documentos se conservan, se actualizan, se fusionan o se eliminan.
- [ ] Verificar que la documentación consolidada coincida con la versión pública definitiva.
- [x] Actualizar las capturas de `docs/screenshots/` con el reporte y las diapositivas actuales (hecho el 2026-10-21).

## C. Mejoras técnicas conocidas

- [ ] Errores estándar con el diseño muestral complejo (estratos y conglomerados) para las medidas ponderadas; hoy solo se ponderan puntualmente por `F_EXP`.
- [ ] Explorar una segmentación alternativa basada en los índices sintéticos y comparar con la de internet × RUT.
- [ ] `dm-design-system/dist/tokens.R` exporta colores en formato CSS `rgba()`, que R no interpreta; `scripts/tema_dm.R` los convierte con `rgba_a_hex()`. Corregir en `dm-design-system/build/build.py`.
- [ ] Reporte: las ~135 cifras del texto están escritas a mano (verificadas el 2026-10-17); convertirlas en código R en línea que lea `output/tablas/`, como ya hacen sus tablas y las diapositivas.
- [ ] Reporte: añadir el tema oscuro con selector (el sistema DM lo pide); hoy solo tiene el tema claro.
- [ ] Reporte: sus gráficos son imágenes estáticas; valorar versiones interactivas (`ggiraph`) para las figuras clave.
- [ ] Reducir las advertencias de estilo de `lintr` en `scripts/` (líneas largas, espacios finales); no afectan los resultados.
- [ ] `scripts/exploratorio/analisis_reglas_soporte_24.R` usa `stringr`, que no es dependencia del pipeline principal; valorar reescribirlo con R base o retirarlo.
- [ ] Actualizar `assets/dm/` cuando cambie el sistema de diseño (`dm-design-system/dist/tokens.R`, fuentes y logos son copias).
- [ ] Diapositiva de la red de reglas: reducir etiquetas para mejorar la legibilidad.
- [x] Diapositiva 13 (mapas): mapas más grandes con una sola escala de color (hecho el 2026-11-10).

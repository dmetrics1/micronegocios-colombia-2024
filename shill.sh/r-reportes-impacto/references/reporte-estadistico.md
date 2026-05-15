# Reportes Estadísticos Automáticos en R

## El Paquete `report` — Texto APA Automático

```r
library(report)
library(tidyverse)

# Modelo lineal → párrafo APA completo
modelo_lm <- lm(mpg ~ wt + cyl + hp, data = mtcars)
report(modelo_lm)
# Output: "We fitted a linear model (estimated using OLS) to predict mpg 
# with wt, cyl and hp (formula: mpg ~ wt + cyl + hp). The model explains a 
# statistically significant and substantial proportion of variance 
# (R2 = 0.84, F(3, 28) = 48.88, p < .001..."

# t-test → APA
t_result <- t.test(mpg ~ am, data = mtcars)
report(t_result)

# Correlación → APA
cor_result <- cor.test(mtcars$mpg, mtcars$wt)
report(cor_result)

# ANOVA → APA
anova_result <- aov(mpg ~ factor(cyl), data = mtcars)
report(anova_result)

# Modelo mixto → APA
library(lme4)
modelo_mixto <- lmer(mpg ~ wt + (1|cyl), data = mtcars)
report(modelo_mixto)
```

---

## modelsummary — Tablas de Regresión Publicación-Ready

```r
library(modelsummary)

# Múltiples modelos en paralelo
m1 <- lm(mpg ~ wt, data = mtcars)
m2 <- lm(mpg ~ wt + cyl, data = mtcars)
m3 <- lm(mpg ~ wt + cyl + hp, data = mtcars)

modelos <- list(
  "Modelo 1 (Simple)"  = m1,
  "Modelo 2 (Parcial)" = m2,
  "Modelo 3 (Completo)" = m3
)

modelsummary(
  modelos,
  
  # Estrellas de significancia
  stars = c("*" = .1, "**" = .05, "***" = .01),
  
  # Formato de coeficientes
  fmt = 3,
  
  # Estadísticos a incluir
  gof_map = tribble(
    ~raw,        ~clean,         ~fmt,
    "nobs",      "N",             0,
    "r.squared", "R²",            3,
    "adj.r.squared", "R² ajust.", 3,
    "AIC",       "AIC",           1,
    "BIC",       "BIC",           1
  ),
  
  # Renombrar coeficientes
  coef_rename = c(
    "(Intercept)" = "Intercepto",
    "wt"          = "Peso (1000 lbs)",
    "cyl"         = "Cilindros",
    "hp"          = "Potencia (hp)"
  ),
  
  # Notas al pie
  notes = list(
    "Errores estándar entre paréntesis.",
    "* p<0.1, ** p<0.05, *** p<0.01"
  ),
  
  # Título
  title = "Tabla 2. Determinantes del consumo de combustible",
  
  # Output a gt para más customización
  output = "gt"
) %>%
  gt_theme_guardian() %>%
  tab_options(table.width = pct(100))
```

---

## parameters — Coeficientes Limpios con IC

```r
library(parameters)
library(see)

modelo <- lm(mpg ~ wt + cyl + hp + am, data = mtcars)

# Tabla de parámetros limpia
params <- model_parameters(modelo, ci = 0.95)
print(params)

# Visualización de coeficientes (forest plot de regresión)
plot(params) +
  labs(title = "Coeficientes del modelo con IC 95%") +
  tema_reporte

# Standardized (para comparar magnitudes)
model_parameters(modelo, standardize = "refit")

# Para modelos mixtos
library(lme4)
modelo_mixto <- lmer(mpg ~ wt + (1|cyl), data = mtcars)
model_parameters(modelo_mixto, effects = "fixed")
```

---

## performance — Diagnóstico del Modelo

```r
library(performance)
library(see)

# Métricas de ajuste del modelo
model_performance(modelo)

# Verificación de supuestos — 4 gráficos en uno
check_model(modelo)
# Genera automáticamente: residuales vs fitted, QQ, 
# homogeneidad de varianza, outliers, multicolinealidad

# Tests específicos
check_normality(modelo)     # Test de normalidad de residuales
check_heteroscedasticity(modelo)  # Test de heterocedasticidad
check_collinearity(modelo)  # VIF para multicolinealidad
check_outliers(modelo)      # Puntos influyentes (Cook's D)

# Comparar modelos
compare_performance(m1, m2, m3, rank = TRUE) %>%
  print_html()
```

---

## gtsummary — Tablas Clínicas y Epidemiológicas

```r
library(gtsummary)

# Tabla 1 (características basales) — Estilo publicación médica
tabla1 <- datos %>%
  select(edad, sexo, imc, grupo_tratamiento, resultado_primario) %>%
  tbl_summary(
    by = grupo_tratamiento,
    statistic = list(
      all_continuous()  ~ "{mean} ± {sd}",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits  = list(all_continuous() ~ 1),
    missing = "no",
    label   = list(
      edad              ~ "Edad (años)",
      sexo              ~ "Sexo, n (%)",
      imc               ~ "IMC (kg/m²)",
      resultado_primario ~ "Resultado primario, n (%)"
    )
  ) %>%
  add_p(
    test = list(
      all_continuous()  ~ "t.test",
      all_categorical() ~ "chisq.test"
    ),
    pvalue_fun = ~ style_pvalue(.x, digits = 3)
  ) %>%
  add_overall(last = FALSE) %>%
  add_n() %>%
  modify_header(
    label     ~ "**Variable**",
    stat_0    ~ "**Total** (N={N})",
    stat_1    ~ "**Control** (N={N})",
    stat_2    ~ "**Tratamiento** (N={N})",
    p.value   ~ "**p**"
  ) %>%
  modify_spanning_header(c(stat_1, stat_2) ~ "**Grupo de tratamiento**") %>%
  bold_labels() %>%
  bold_p(t = 0.05) %>%
  modify_caption("**Tabla 1.** Características basales por grupo") %>%
  as_gt() %>%
  gt_theme_guardian() %>%
  tab_options(table.width = pct(100))
```

---

## skimr — Exploración de Datos para el Apéndice

```r
library(skimr)

# Resumen estadístico completo
skim(datos) %>%
  kable(
    caption = "Tabla A1. Estadísticas descriptivas completas",
    digits  = 2
  ) %>%
  kable_styling(bootstrap_options = c("striped", "hover"), full_width = TRUE)

# Versión para incluir en gt
skim(datos) %>%
  as_tibble() %>%
  select(skim_variable, n_missing, complete_rate,
         numeric.mean, numeric.sd, numeric.p0, numeric.p100) %>%
  gt() %>%
  fmt_percent(columns = complete_rate) %>%
  fmt_number(columns = where(is.numeric), decimals = 2) %>%
  gt_theme_guardian()
```

---

## Tablas de Correlación con corrplot

```r
library(corrplot)
library(ggcorrplot)

cor_matrix <- cor(select(datos, where(is.numeric)), use = "complete.obs")

# Versión ggplot (preferida para Quarto/RMarkdown)
ggcorrplot(
  cor_matrix,
  method  = "circle",     # circle, square
  type    = "lower",      # lower, upper, full
  lab     = TRUE,
  lab_size = 3,
  colors  = c("#F44336", "white", "#2196F3"),
  outline.color = "white",
  ggtheme = tema_reporte,
  title   = "Matriz de correlaciones (Pearson)",
  legend.title = "Corr."
)

# Versión base R (para PDF clásico)
corrplot(
  cor_matrix,
  method  = "color",
  type    = "upper",
  order   = "hclust",
  tl.col  = "black",
  tl.srt  = 45,
  addCoef.col = "black",
  number.cex  = 0.8,
  col = colorRampPalette(c("#F44336", "white", "#2196F3"))(200)
)
```

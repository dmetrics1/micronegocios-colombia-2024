# GENERADO por build/build.py — NO editar a mano. Edita tokens/tokens.json y regenera.
# Tokens del sistema de diseno DM para R (Shiny, Quarto, ggplot2).

DM_BRAND_GRAD <- "linear-gradient(135deg, #1E40AF 0%, #2563EB 50%, #06B6D4 100%)"

DM_THEME_DARK <- list(
  accent = "#2563EB",
  accent2 = "#06B6D4",
  accent3 = "#F59E0B",
  positive = "#10B981",
  negative = "#F43F5E",
  bgBody = "#0A0E1A",
  surface1 = "#0F1729",
  surface1Alt = "#131C31",
  surface2 = "#18233C",
  surface3 = "#202D4E",
  cardBg = "rgba(19,27,46,0.55)",
  cardBgHover = "rgba(26,37,64,0.80)",
  cardBorder = "rgba(255,255,255,0.06)",
  textTitle = "#F9FAFB",
  textBody = "#E5E7EB",
  textMuted = "#9CA3AF",
  line = "rgba(255,255,255,0.06)",
  kpi = "#06B6D4",
  eyebrowBg = "rgba(6,182,212,0.15)",
  eyebrowText = "#06B6D4",
  inputBg = "rgba(24,35,60,0.55)",
  chartGrid = "rgba(255,255,255,0.06)",
  chartBg = "rgba(0,0,0,0)",
  ink = list(navy = "#60A5FA", deep = "#38BDF8", blue = "#4F8DF9", teal = "#06B6D4", mint = "#22D3EE", pale = "#67E8F9")
)

DM_THEME_LIGHT <- list(
  accent = "#2563EB",
  accent2 = "#0891B2",
  accent3 = "#D97706",
  positive = "#059669",
  negative = "#E11D48",
  bgBody = "#F3F6FB",
  surface1 = "#FFFFFF",
  surface1Alt = "#F8FAFC",
  surface2 = "#FFFFFF",
  surface3 = "#F8FAFC",
  cardBg = "#FFFFFF",
  cardBgHover = "rgba(37,99,235,0.05)",
  cardBorder = "rgba(15,23,42,0.10)",
  textTitle = "#0B1220",
  textBody = "#1E293B",
  textMuted = "#64748B",
  line = "rgba(15,23,42,0.10)",
  kpi = "#1D4ED8",
  eyebrowBg = "rgba(37,99,235,0.08)",
  eyebrowText = "#1E40AF",
  inputBg = "rgba(37,99,235,0.05)",
  chartGrid = "rgba(15,23,42,0.08)",
  chartBg = "rgba(0,0,0,0)",
  ink = list(navy = "#1E40AF", deep = "#1D4ED8", blue = "#2563EB", teal = "#0891B2", mint = "#0E7490", pale = "#155E75")
)

DM_BLUE_TEAL_30 <- c("#EAFBFF", "#DBF9FE", "#CCF6FD", "#BDF4FC", "#AEF1FB", "#9FEFF9", "#90ECF8", "#81EAF7", "#71E4F3", "#60DDEF", "#50D6EA", "#3FCFE5", "#2FC8E0", "#1FC1DB", "#0EBAD6", "#08B0D6", "#0CA5D9", "#1199DC", "#158EDF", "#1982E2", "#1E77E5", "#226CE9", "#2562E9", "#245DE1", "#2358D8", "#2253D0", "#214EC8", "#204AC0", "#1F45B7", "#1E40AF")

DM_BLUE_TEAL_DISCRETE <- c("#1E40AF", "#1D4ED8", "#2563EB", "#06B6D4", "#22D3EE", "#67E8F9", "#A5F3FC")

DM_SEX_COLORS <- c(Hombre = "#2563EB", Mujer = "#06B6D4")

DM_FONT_HEADING <- "Space Grotesk"
DM_FONT_BODY <- "Inter"
DM_FONT_MONO <- "JetBrains Mono"

# Tema ggplot2 de marca
dm_theme_ggplot <- function(dark = TRUE) {
  t <- if (dark) DM_THEME_DARK else DM_THEME_LIGHT
  ggplot2::theme_minimal(base_family = DM_FONT_BODY) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = t$textBody),
      plot.title = ggplot2::element_text(family = DM_FONT_HEADING, colour = t$textTitle, face = "bold"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(colour = t$line),
      plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      panel.background = ggplot2::element_rect(fill = "transparent", colour = NA)
    )
}

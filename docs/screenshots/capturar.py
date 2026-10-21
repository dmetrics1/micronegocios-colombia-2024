"""Toma las capturas del README desde el sitio publicado (GitHub Pages)."""
import sys
from pathlib import Path
from playwright.sync_api import sync_playwright

BASE = "https://dmetrics1.github.io/micronegocios-colombia-2024"
SALIDA = Path(sys.argv[1])
SALIDA.mkdir(parents=True, exist_ok=True)

with sync_playwright() as p:
    nav = p.chromium.launch(channel="chrome", headless=True)

    # --- Reporte ---
    pag = nav.new_page(viewport={"width": 1440, "height": 900}, device_scale_factor=1.5)
    pag.goto(f"{BASE}/REPORTE_WIDE_PRO_2024.html", wait_until="networkidle")
    pag.wait_for_timeout(1500)

    pag.locator(".dm-hero").screenshot(path=str(SALIDA / "01-portada-reporte-2026.png"))

    def figura(texto, archivo):
        fig = pag.locator(".quarto-figure", has_text=texto).first
        fig.scroll_into_view_if_needed()
        pag.wait_for_timeout(400)
        fig.screenshot(path=str(SALIDA / archivo))

    figura("Figura 9C:", "02-apriori-red-reglas.png")
    figura("Figura 11A:", "03-segmentacion-grupos.png")

    # --- Diapositivas (1920×1080, la diapositiva llena la ventana) ---
    dia = nav.new_page(viewport={"width": 1920, "height": 1080}, device_scale_factor=1)
    dia.goto(f"{BASE}/presentacion/#9", wait_until="networkidle")
    dia.wait_for_timeout(1500)
    dia.evaluate("document.getElementById('help') && (document.getElementById('help').style.display='none')")
    dia.screenshot(path=str(SALIDA / "04-diapositiva-regla.png"))

    nav.close()

for f in sorted(SALIDA.glob("*.png")):
    print(f"{f.name}  {f.stat().st_size // 1024} KB")

#!/bin/bash
# Avant-Garde Partners - Publiceer in één klik.
# Haalt de nieuwste index.html uit je Downloads en zet de site online.
cd "$(dirname "$0")"

echo ""
echo "======================================================"
echo "   Avant-Garde Partners  -  publiceren in één klik"
echo "======================================================"
echo ""

DL="$HOME/Downloads"

# 1. Nieuwste index.html uit Downloads pakken (index.html of index (1).html enz.)
NIEUW=$(ls -t "$DL"/index*.html 2>/dev/null | head -n 1)

if [ -n "$NIEUW" ]; then
  cp "$NIEUW" ./index.html
  cp "$NIEUW" ./404.html
  echo "Nieuwe versie opgehaald uit Downloads:"
  echo "  $(basename "$NIEUW")"
  echo ""
else
  echo "Geen nieuwe index.html in je Downloads gevonden."
  echo "Ik zet de versie online die nu in deze map staat."
  echo ""
fi

# 2. Koppeling met GitHub controleren
if [ ! -d .git ]; then
  echo "Deze map is nog niet met GitHub verbonden."
  echo "Draai eerst een keer 'deploy-avantgardepartners.command'."
  echo ""
  read -p "Druk op Enter om te sluiten."; exit 1
fi

if ! command -v gh >/dev/null 2>&1 && ! command -v git >/dev/null 2>&1; then
  echo "Git ontbreekt. Installeer GitHub CLI via https://cli.github.com"
  read -p "Druk op Enter om te sluiten."; exit 1
fi

# 3. Alleen publiceren als er echt iets veranderd is
if git diff --quiet && git diff --cached --quiet; then
  echo "De site is al up-to-date. Er is niets nieuws om te publiceren."
  echo ""
  read -p "Druk op Enter om te sluiten."; exit 0
fi

STAMP=$(date "+%d-%m-%Y %H:%M")
git add -A
git -c user.email="deploy@avantgarde.nl" -c user.name="Avant-Garde" commit -q -m "Update $STAMP"
echo "Online zetten..."
if git push -q origin main; then
  echo ""
  echo "  Gelukt.  De nieuwe versie staat over ongeveer een minuut op:"
  echo "     https://avantgardepartners.nl"
  echo ""
  echo "  Tip: bekijk hem in een privé-venster, dan zie je zeker de nieuwe versie."
  # open de site automatisch
  (sleep 45; open "https://avantgardepartners.nl") >/dev/null 2>&1 &
else
  echo ""
  echo "  Er ging iets mis bij het versturen. Ben je met internet verbonden?"
  echo "  Lukt het niet, stuur dan de tekst hierboven naar Claude."
fi
echo ""
read -p "Druk op Enter om te sluiten."

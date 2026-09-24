#!/bin/bash
# Avant-Garde Partners - zet de site op GitHub en online via GitHub Pages.
# Dubbelklik dit bestand (Mac) of draai het in een terminal.
set -e
cd "$(dirname "$0")"

echo ""
echo "======================================================"
echo "  Avant-Garde Partners online zetten via GitHub Pages"
echo "======================================================"
echo ""

# 1. Controleer of GitHub CLI aanwezig is
if ! command -v gh >/dev/null 2>&1; then
  echo "Het hulpprogramma 'gh' (GitHub CLI) is nog niet geinstalleerd."
  echo ""
  if command -v brew >/dev/null 2>&1; then
    read -p "Nu installeren met Homebrew? (j/n) " a
    if [ "$a" = "j" ]; then brew install gh; else echo "Installeer gh eerst via https://cli.github.com en start opnieuw."; exit 1; fi
  else
    echo "Installeer eerst GitHub CLI via https://cli.github.com"
    echo "(op Windows: winget install --id GitHub.cli), en start dit script opnieuw."
    exit 1
  fi
fi

# 2. Inloggen bij GitHub (opent je browser; jij logt zelf veilig in)
if ! gh auth status >/dev/null 2>&1; then
  echo "Je wordt nu ingelogd bij GitHub. Er opent een venster in je browser."
  gh auth login -h github.com -p https -w
fi

GHUSER=$(gh api user -q .login)
REPO="avantgardepartners"
echo ""
echo "Ingelogd als: $GHUSER"
echo "Repository:   $GHUSER/$REPO"
echo ""

# 3. Repository aanmaken (of gebruiken als hij al bestaat) en de bestanden uploaden
git init -q
git add -A
git -c user.email="deploy@avantgarde.nl" -c user.name="Avant-Garde" commit -q -m "Avant-Garde Partners site" || true
git branch -M main

if gh repo view "$GHUSER/$REPO" >/dev/null 2>&1; then
  echo "Repository bestaat al, de nieuwste versie wordt geplaatst."
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/$GHUSER/$REPO.git"
  git push -f origin main
else
  gh repo create "$GHUSER/$REPO" --public --source=. --remote=origin --push
fi

# 4. GitHub Pages aanzetten op branch main / root
echo ""
echo "GitHub Pages aanzetten..."
gh api -X POST "repos/$GHUSER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || gh api -X PUT "repos/$GHUSER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true

# 5. Eigen domein koppelen
gh api -X PUT "repos/$GHUSER/$REPO/pages" -f "cname=avantgardepartners.nl" >/dev/null 2>&1 || true

echo ""
echo "======================================================"
echo "  Klaar. De site staat op GitHub."
echo "======================================================"
echo ""
echo "Nu nog twee dingen, in de browser:"
echo ""
echo "1. Bij Hostnet (DNS van avantgardepartners.nl):"
echo "   - verwijder bestaande A-records van het hoofddomein"
echo "   - voeg vier A-records toe (naam @ of leeg) naar:"
echo "       185.199.108.153"
echo "       185.199.109.153"
echo "       185.199.110.153"
echo "       185.199.111.153"
echo "   - voeg een CNAME toe: naam www  ->  $GHUSER.github.io"
echo ""
echo "2. In GitHub, Settings -> Pages, zet 'Enforce HTTPS' aan"
echo "   zodra het groene vinkje bij het domein verschijnt."
echo ""
echo "Test daarna: https://avantgardepartners.nl"
echo ""
read -p "Druk op Enter om te sluiten."

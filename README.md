# avantgardepartners.nl

Statische site, één bestand: `index.html` (alle stijl, script en foto's zitten erin).

## Live zetten via GitHub Pages
1. Maak een repository `avantgardepartners` en zet deze bestanden in de hoofdmap.
2. Settings → Pages → Source: "Deploy from a branch", branch `main`, map `/ (root)`.
3. Het bestand `CNAME` bevat `avantgardepartners.nl`. Zet bij de domeinregistrar een A-record naar de GitHub Pages-adressen (185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153) en een CNAME voor `www` naar `<gebruikersnaam>.github.io`.
4. Vink in Settings → Pages "Enforce HTTPS" aan zodra het certificaat is aangemaakt.

## Aanpassen
Alle teksten staan in `index.html`. De navigatie werkt via `data-view`-secties. Het aanmeldformulier verstuurt nog niet naar Teamleader; zie het werkdocument voor de koppeling via Tally en Make.

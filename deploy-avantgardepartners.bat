@echo off
REM Avant-Garde Partners - zet de site op GitHub en online via GitHub Pages.
cd /d "%~dp0"
echo.
echo   Avant-Garde Partners online zetten via GitHub Pages
echo.
where gh >nul 2>nul
if errorlevel 1 (
  echo GitHub CLI ^(gh^) is nog niet geinstalleerd.
  echo Installeer met:  winget install --id GitHub.cli
  echo en start dit bestand opnieuw.
  pause
  exit /b
)
gh auth status >nul 2>nul || gh auth login -h github.com -p https -w
for /f "delims=" %%i in ('gh api user -q .login') do set GHUSER=%%i
set REPO=avantgardepartners
git init
git add -A
git -c user.email="deploy@avantgarde.nl" -c user.name="Avant-Garde" commit -m "Avant-Garde Partners site"
git branch -M main
gh repo view %GHUSER%/%REPO% >nul 2>nul && (
  git remote remove origin 2>nul
  git remote add origin https://github.com/%GHUSER%/%REPO%.git
  git push -f origin main
) || (
  gh repo create %GHUSER%/%REPO% --public --source=. --remote=origin --push
)
gh api -X POST "repos/%GHUSER%/%REPO%/pages" -f "source[branch]=main" -f "source[path]=/" >nul 2>nul
gh api -X PUT "repos/%GHUSER%/%REPO%/pages" -f "cname=avantgardepartners.nl" >nul 2>nul
echo.
echo Klaar. Regel nu bij Hostnet de DNS (zie de uitleg in het gesprek),
echo en zet in GitHub Settings ^> Pages 'Enforce HTTPS' aan.
echo Test daarna: https://avantgardepartners.nl
pause

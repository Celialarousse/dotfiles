# Prompt moderne
Invoke-Expression (&starship init powershell)

# Suggestions automatiques basées sur votre historique
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# ===== Raccourcis personnels =====
# Aller dans le dossier des projets
function dev { Set-Location C:\dev }

# Tout mettre à jour (à lancer une fois par mois)
function maj {
  Write-Host "`n== Outils Scoop ==" -ForegroundColor Cyan
  scoop update; scoop update *; scoop cleanup *; scoop cache rm *
  Write-Host "`n== Python (uv) ==" -ForegroundColor Cyan
  uv python upgrade
  Write-Host "`n== Applications Windows (winget) ==" -ForegroundColor Cyan
  winget upgrade --all --accept-source-agreements
  Write-Host "`n== Terminé ! ==" -ForegroundColor Green
}

# Sauvegarder toutes les bases de données
function sauvegarde-bdd { & C:\dev\perso\dotfiles\sauvegarder-bdd.ps1 }

# Activer / désactiver Xdebug (à lancer dans le dossier d'un projet symfony-docker)
function xdebug-on  { $env:XDEBUG_MODE = 'debug'; docker compose up -d --wait --wait-timeout 300; Remove-Item Env:XDEBUG_MODE }
function xdebug-off { docker compose up -d --wait --wait-timeout 300 }

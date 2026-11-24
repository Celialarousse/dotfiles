# Exporte les bases de données de tous les projets dans OneDrive
$dossier = Join-Path $env:OneDrive "Sauvegardes-BDD\$(Get-Date -Format 'yyyy-MM-dd_HH-mm')"
New-Item -ItemType Directory -Force $dossier | Out-Null

$projets = @(
  @{ Nom = 'docker-main';        Chemin = 'C:\dev\bts\docker-main';        Service = 'mysql' }
  @{ Nom = 'Assiduo';            Chemin = 'C:\dev\bts\Assiduo';            Service = 'database' }
  @{ Nom = 'bts-symfony-docker'; Chemin = 'C:\dev\bts\bts-symfony-docker'; Service = 'database' }
)

# Commande exécutée DANS le conteneur MySQL : elle utilise les identifiants déjà connus du conteneur
$export = 'if [ -n "$MYSQL_USER" ]; then U="$MYSQL_USER"; P="$MYSQL_PASSWORD"; else U=root; P="$MYSQL_ROOT_PASSWORD"; fi; ' +
          'exec mysqldump -u"$U" -p"$P" --no-tablespaces --single-transaction --databases "$MYSQL_DATABASE" > /tmp/sauvegarde.sql'

foreach ($p in $projets) {
  Write-Host "`n== $($p.Nom) ==" -ForegroundColor Cyan
  Push-Location $p.Chemin
  docker compose up -d --wait $p.Service
  docker compose exec -T $p.Service sh -c $export
  docker compose cp "$($p.Service):/tmp/sauvegarde.sql" (Join-Path $dossier "$($p.Nom).sql")
  docker compose stop $p.Service
  Pop-Location
}

Copy-Item C:\dev\python\rankit\db.sqlite3 (Join-Path $dossier 'rankit.sqlite3')
Write-Host "`nSauvegardes enregistrées dans : $dossier" -ForegroundColor Green
Get-ChildItem $dossier | Select-Object Name, Length

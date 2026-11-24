# Copie les fichiers de configuration dans ce dossier, puis les envoie sur GitHub
$dest = $PSScriptRoot
$fichiers = @{
  "$PROFILE"                                           = "powershell\Microsoft.PowerShell_profile.ps1"
  "$HOME\.config\starship.toml"                        = "starship\starship.toml"
  "$HOME\.wslconfig"                                   = "wsl\.wslconfig"
  "$HOME\.gitconfig"                                   = "git\.gitconfig"
  "$HOME\.ssh\config"                                  = "ssh\config"
  "C:\scoop\apps\php85\current\cli\conf.d\symfony.ini" = "php\symfony.ini"
}
foreach ($source in $fichiers.Keys) {
  $cible = Join-Path $dest $fichiers[$source]
  New-Item -ItemType Directory -Force (Split-Path $cible) | Out-Null
  Copy-Item $source $cible -Force
}
New-Item -ItemType Directory -Force "$dest\scoop", "$dest\winget" | Out-Null
scoop export | Set-Content "$dest\scoop\scoop-apps.json"
winget export -o "$dest\winget\winget-apps.json" --accept-source-agreements | Out-Null
git -C $dest add -A
git -C $dest commit -m "Sauvegarde du $(Get-Date -Format 'yyyy-MM-dd')"
git -C $dest push

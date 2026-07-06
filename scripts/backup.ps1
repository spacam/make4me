$ErrorActionPreference = "Stop"

Write-Host "============================"
Write-Host "Make4Me Backup v2.1"
Write-Host "============================"

$projectDir = Split-Path -Parent $PSScriptRoot
Set-Location $projectDir

git status

$msg = Read-Host "Zadej popis zmeny"
if ([string]::IsNullOrWhiteSpace($msg)) {
    Write-Host "CHYBA: Musis zadat popis zmeny."
    exit 1
}

Write-Host "Pridavam zmeny..."
git add .

Write-Host "Vytvarim commit..."
git commit -m $msg

Write-Host "Odesilam na GitHub..."
git push

$backupDir = "G:\Můj disk\Make4Me\Backups"
if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$zipPath = Join-Path $backupDir "Make4Me_$timestamp.zip"

Write-Host "Vytvarim ZIP zalohu..."

$exclude = @(
    "node_modules",
    ".next",
    ".git",
    "Backups"
)

$tempDir = Join-Path $env:TEMP "make4me_backup_$timestamp"
New-Item -ItemType Directory -Path $tempDir | Out-Null

Get-ChildItem $projectDir -Force | Where-Object {
    $exclude -notcontains $_.Name
} | ForEach-Object {
    Copy-Item $_.FullName -Destination $tempDir -Recurse -Force
}

Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath -Force
Remove-Item $tempDir -Recurse -Force

Write-Host "============================"
Write-Host "HOTOVO"
Write-Host "GitHub: ulozeno"
Write-Host "ZIP: $zipPath"
Write-Host "============================"
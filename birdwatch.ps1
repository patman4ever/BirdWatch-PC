# ============================================================
# BirdWatch-PC — Windows Installer & Launcher
# Vereisten: Docker Desktop, Git, Windows 10/11
# ============================================================

param(
    [switch]$Install,
    [switch]$Start,
    [switch]$Stop,
    [switch]$Update,
    [switch]$Logs,
    [switch]$Status
)

$ErrorActionPreference = "Stop"
$REPO_URL = "https://github.com/patman4ever/BirdWatch-PC.git"
$INSTALL_DIR = "$env:USERPROFILE\BirdWatch-PC"
$COMPOSE_FILE = "$INSTALL_DIR\docker-compose.yml"

# ── Kleuren helpers ─────────────────────────────────────────
function Write-Header { param($msg) Write-Host "`n🐦 $msg" -ForegroundColor Cyan }
function Write-OK     { param($msg) Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "  ⚠️  $msg" -ForegroundColor Yellow }
function Write-Err    { param($msg) Write-Host "  ❌ $msg" -ForegroundColor Red }

# ── Check Docker ────────────────────────────────────────────
function Test-Docker {
    Write-Header "Docker controleren..."
    try {
        $version = docker --version 2>&1
        Write-OK "Docker gevonden: $version"
    } catch {
        Write-Err "Docker Desktop is niet geïnstalleerd of niet gestart."
        Write-Host "  Download Docker Desktop via: https://www.docker.com/products/docker-desktop" -ForegroundColor White
        exit 1
    }

    $running = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Docker Desktop draait niet. Start Docker Desktop eerst."
        exit 1
    }
    Write-OK "Docker Desktop is actief."
}

# ── Installeer ──────────────────────────────────────────────
function Install-BirdWatch {
    Write-Header "BirdWatch-PC installeren..."
    Test-Docker

    # Check Git
    try {
        git --version | Out-Null
    } catch {
        Write-Err "Git is niet geïnstalleerd. Download via: https://git-scm.com"
        exit 1
    }

    # Clone of update repo
    if (Test-Path $INSTALL_DIR) {
        Write-Warn "Map $INSTALL_DIR bestaat al. Updaten..."
        Set-Location $INSTALL_DIR
        git pull
    } else {
        Write-Host "  📥 Repo klonen naar $INSTALL_DIR..." -ForegroundColor White
        git clone $REPO_URL $INSTALL_DIR
    }

    # Maak data mappen aan
    $folders = @("$INSTALL_DIR\data\recordings", "$INSTALL_DIR\data\detections", "$INSTALL_DIR\config")
    foreach ($folder in $folders) {
        if (-not (Test-Path $folder)) {
            New-Item -ItemType Directory -Path $folder -Force | Out-Null
            Write-OK "Map aangemaakt: $folder"
        }
    }

    # Maak .env als die er niet is
    $envFile = "$INSTALL_DIR\.env"
    if (-not (Test-Path $envFile)) {
        @"
TZ=Europe/Amsterdam
LATITUDE=51.9
LONGITUDE=4.5
MIN_CONFIDENCE=0.7
SENSITIVITY=1.0
"@ | Out-File -FilePath $envFile -Encoding UTF8
        Write-OK ".env bestand aangemaakt. Pas aan naar wens in: $envFile"
    }

    # Docker image pullen
    Write-Host "  📦 Docker image ophalen..." -ForegroundColor White
    Set-Location $INSTALL_DIR
    docker compose pull

    Write-OK "Installatie voltooid!"
    Write-Host "`n  Start BirdWatch met: .\birdwatch.ps1 -Start" -ForegroundColor Cyan
}

# ── Start ───────────────────────────────────────────────────
function Start-BirdWatch {
    Write-Header "BirdWatch-PC starten..."
    Test-Docker

    if (-not (Test-Path $INSTALL_DIR)) {
        Write-Err "BirdWatch is niet geïnstalleerd. Voer eerst: .\birdwatch.ps1 -Install"
        exit 1
    }

    Set-Location $INSTALL_DIR
    docker compose up -d

    Write-OK "BirdWatch draait!"
    Write-Host ""
    Write-Host "  🌐 Dashboard: http://localhost:7766" -ForegroundColor Cyan
    Write-Host "  📋 Logs bekijken: .\birdwatch.ps1 -Logs" -ForegroundColor White
}

# ── Stop ────────────────────────────────────────────────────
function Stop-BirdWatch {
    Write-Header "BirdWatch-PC stoppen..."
    Set-Location $INSTALL_DIR
    docker compose down
    Write-OK "BirdWatch gestopt."
}

# ── Update ──────────────────────────────────────────────────
function Update-BirdWatch {
    Write-Header "BirdWatch-PC updaten..."
    Set-Location $INSTALL_DIR
    git pull
    docker compose pull
    docker compose up -d
    Write-OK "Update voltooid en herstart."
}

# ── Logs ────────────────────────────────────────────────────
function Show-Logs {
    Write-Header "BirdWatch logs (Ctrl+C om te stoppen)..."
    Set-Location $INSTALL_DIR
    docker compose logs -f
}

# ── Status ──────────────────────────────────────────────────
function Show-Status {
    Write-Header "BirdWatch status..."
    Set-Location $INSTALL_DIR
    docker compose ps
}

# ── Menu als geen parameter ─────────────────────────────────
function Show-Menu {
    Clear-Host
    Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       🐦  BirdWatch-PC Beheer        ║" -ForegroundColor Cyan
    Write-Host "╠══════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║  1. Installeren                      ║" -ForegroundColor White
    Write-Host "║  2. Starten                          ║" -ForegroundColor White
    Write-Host "║  3. Stoppen                          ║" -ForegroundColor White
    Write-Host "║  4. Updaten                          ║" -ForegroundColor White
    Write-Host "║  5. Logs bekijken                    ║" -ForegroundColor White
    Write-Host "║  6. Status                           ║" -ForegroundColor White
    Write-Host "║  Q. Afsluiten                        ║" -ForegroundColor White
    Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    $choice = Read-Host "Keuze"
    switch ($choice) {
        "1" { Install-BirdWatch }
        "2" { Start-BirdWatch }
        "3" { Stop-BirdWatch }
        "4" { Update-BirdWatch }
        "5" { Show-Logs }
        "6" { Show-Status }
        "Q" { exit 0 }
        "q" { exit 0 }
        default { Write-Warn "Ongeldige keuze." }
    }
}

# ── Main ────────────────────────────────────────────────────
if ($Install) { Install-BirdWatch }
elseif ($Start) { Start-BirdWatch }
elseif ($Stop) { Stop-BirdWatch }
elseif ($Update) { Update-BirdWatch }
elseif ($Logs) { Show-Logs }
elseif ($Status) { Show-Status }
else { Show-Menu }

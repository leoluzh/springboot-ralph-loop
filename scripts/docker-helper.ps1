#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Docker Diagnostic and Helper Script for Windows
.DESCRIPTION
    Verifica o status do Docker e oferece soluções para problemas comuns
.EXAMPLE
    ./docker-helper.ps1
#>

# ============================================================
# CORES PARA OUTPUT
# ============================================================
$colors = @{
    'cyan'    = [System.ConsoleColor]::Cyan
    'green'   = [System.ConsoleColor]::Green
    'yellow'  = [System.ConsoleColor]::Yellow
    'red'     = [System.ConsoleColor]::Red
    'white'   = [System.ConsoleColor]::White
}

function Write-Header {
    param([string]$text)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor $colors['cyan']
    Write-Host $text -ForegroundColor $colors['cyan']
    Write-Host "═══════════════════════════════════════════════" -ForegroundColor $colors['cyan']
    Write-Host ""
}

function Write-Success {
    param([string]$text)
    Write-Host "✓ $text" -ForegroundColor $colors['green']
}

function Write-Error-Custom {
    param([string]$text)
    Write-Host "✗ $text" -ForegroundColor $colors['red']
}

function Write-Warning-Custom {
    param([string]$text)
    Write-Host "⚠ $text" -ForegroundColor $colors['yellow']
}

function Write-Info {
    param([string]$text)
    Write-Host "ℹ $text" -ForegroundColor $colors['white']
}

# ============================================================
# VERIFICAÇÕES PRINCIPAIS
# ============================================================
Write-Header "🐳 Docker Diagnostic Tool"

# 1. Verificar Docker instalado
Write-Host "1. Verificando instalação do Docker..." -ForegroundColor $colors['cyan']
$dockerInstalled = $null
try {
    $dockerInstalled = docker --version 2>&1 | Select-String "Docker version"
    if ($dockerInstalled) {
        Write-Success "Docker está instalado"
        Write-Info "$dockerInstalled"
    } else {
        Write-Error-Custom "Docker não está instalado"
    }
} catch {
    Write-Error-Custom "Docker não está instalado"
    $dockerInstalled = $null
}

Write-Host ""

# 2. Verificar se Docker está rodando
Write-Host "2. Verificando se Docker Daemon está rodando..." -ForegroundColor $colors['cyan']
$dockerRunning = $false
try {
    $dockerPs = docker ps 2>&1
    if ($dockerPs -notmatch "error during connect") {
        Write-Success "Docker Daemon está rodando"
        $dockerRunning = $true
    } else {
        Write-Error-Custom "Docker Daemon não está rodando"
        Write-Warning-Custom "Erro: $($dockerPs[0])"
    }
} catch {
    Write-Error-Custom "Docker Daemon não está rodando"
}

Write-Host ""

# 3. Verificar Docker Compose
Write-Host "3. Verificando Docker Compose..." -ForegroundColor $colors['cyan']
try {
    $composeVersion = docker-compose --version 2>&1
    Write-Success "Docker Compose está instalado"
    Write-Info "$composeVersion"
} catch {
    Write-Error-Custom "Docker Compose não está instalado"
}

Write-Host ""

# 4. Verificar WSL 2
Write-Host "4. Verificando WSL 2..." -ForegroundColor $colors['cyan']
try {
    $wslVersion = wsl --version 2>&1
    if ($wslVersion -notmatch "error" -and $wslVersion -notmatch "not found") {
        Write-Success "WSL 2 está instalado"
        Write-Info "$wslVersion"
    } else {
        Write-Warning-Custom "WSL 2 não está instalado"
    }
} catch {
    Write-Warning-Custom "WSL 2 não está instalado"
}

Write-Host ""

# ============================================================
# RECOMENDAÇÕES
# ============================================================
Write-Header "📋 Recomendações"

if ($dockerInstalled -and $dockerRunning) {
    Write-Success "Seu sistema está pronto para usar Docker!"
    Write-Info "Execute: make compose-up"
} elseif ($dockerInstalled -and -not $dockerRunning) {
    Write-Warning-Custom "Docker está instalado mas não está rodando"
    Write-Host ""
    Write-Host "SOLUÇÕES RÁPIDAS:" -ForegroundColor $colors['yellow']
    Write-Host ""
    Write-Host "1. Inicie Docker Desktop manualmente:" -ForegroundColor $colors['white']
    Write-Info "   - Procure 'Docker Desktop' no Menu Iniciar"
    Write-Info "   - Aguarde até aparecer 'Docker is running'"
    Write-Host ""
    Write-Host "2. Ou inicie via PowerShell:" -ForegroundColor $colors['white']
    Write-Info "   & 'C:\Program Files\Docker\Docker\Docker.exe'"
    Write-Host ""
    Write-Host "3. Verifique o status com:" -ForegroundColor $colors['white']
    Write-Info "   docker ps"
} else {
    Write-Error-Custom "Docker não está instalado"
    Write-Host ""
    Write-Host "SOLUÇÕES:" -ForegroundColor $colors['yellow']
    Write-Host ""
    Write-Host "1. Instale Docker Desktop (Recomendado):" -ForegroundColor $colors['white']
    Write-Info "   https://www.docker.com/products/docker-desktop"
    Write-Host ""
    Write-Host "2. Ou use Devbox (Alternativa):" -ForegroundColor $colors['white']
    Write-Info "   curl -fsSL https://get.jetify.com/devbox | bash"
    Write-Info "   devbox shell"
    Write-Host ""
    Write-Host "3. Ou execute sem Docker (localmente):" -ForegroundColor $colors['white']
    Write-Info "   make clean-build && make test && make run"
}

Write-Host ""

# ============================================================
# PRÓXIMOS PASSOS
# ============================================================
Write-Header "🚀 Próximos Passos"

Write-Host "Após iniciar o Docker:" -ForegroundColor $colors['cyan']
Write-Host ""
Write-Info "1. make compose-up       # Iniciar serviços"
Write-Info "2. make compose-ps       # Verificar status"
Write-Info "3. make compose-logs     # Ver logs"
Write-Info "4. make compose-down     # Parar serviços"
Write-Host ""

Write-Host "Para mais informações:" -ForegroundColor $colors['cyan']
Write-Info "   Leia: DOCKER-TROUBLESHOOTING.md"
Write-Host ""


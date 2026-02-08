# PowerShell script to install Google Gemini CLI on Windows (official method)
# Follows: https://geminicli.com/docs/get-started/installation/#1-standard-installation-recommended-for-standard-users

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Google Gemini CLI - Instalador Windows" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Log file
$logFile = "$env:TEMP\gemini-npm-install.log"
if (Test-Path $logFile) { Remove-Item $logFile -ErrorAction SilentlyContinue }

# Helper for writing sections
function Write-Section($text) { Write-Host "`n$text`n" -ForegroundColor Yellow }

Write-Section "Verificando Node.js"
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if ($null -ne $nodeCmd) {
    $nodeVersion = (& node --version) -replace "\r|\n",""
    Write-Host "✓ Node.js encontrado: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js não encontrado" -ForegroundColor Red
    Write-Host "Por favor instale Node.js (inclui npm)." -ForegroundColor Yellow
    Write-Host "Download: https://nodejs.org/en/download/" -ForegroundColor Cyan
    exit 1
}

Write-Section "Verificando npm"
$npmCmd = Get-Command npm -ErrorAction SilentlyContinue
if ($null -ne $npmCmd) {
    $npmVersion = (& npm --version) -replace "\r|\n",""
    Write-Host "✓ npm encontrado: $npmVersion" -ForegroundColor Green
} else {
    Write-Host "✗ npm não encontrado" -ForegroundColor Red
    Write-Host "Instale npm (vem com Node.js) e tente novamente." -ForegroundColor Yellow
    exit 1
}

$package = "@google/gemini-cli"
Write-Section "Instalação oficial (global)"
Write-Host "Executando: npm install -g $package" -ForegroundColor Cyan
try {
    # Run npm install -g and capture output to log
    npm install -g $package *>&1 | Out-File -FilePath $logFile -Encoding utf8
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Pacote $package instalado globalmente" -ForegroundColor Green
    } else {
        throw "npm exit code $LASTEXITCODE"
    }
} catch {
    Write-Host "✗ Falha ao instalar globalmente via npm: $_" -ForegroundColor Red
    Write-Host "Últimas linhas do log:" -ForegroundColor Yellow
    if (Test-Path $logFile) { Get-Content $logFile -Tail 30 | ForEach-Object { Write-Host "    $_" } }

    # Try fallback with npx
    Write-Section "Ambiente: tentando fallback com npx"
    Write-Host "Executando: npx -y $package --version" -ForegroundColor Cyan
    try {
        npx -y $package --version *>&1 | Out-File -FilePath $logFile -Encoding utf8
        if ($LASTEXITCODE -eq 0) {
            $ver = Get-Content $logFile | Out-String
            Write-Host "✓ npx executou $package com sucesso: $ver" -ForegroundColor Green
            Write-Host "Você pode usar o Gemini CLI com: npx $package <args>" -ForegroundColor Green
            Remove-Item $logFile -ErrorAction SilentlyContinue
            exit 0
        } else {
            throw "npx exit code $LASTEXITCODE"
        }
    } catch {
        Write-Host "✗ npx também falhou: $_" -ForegroundColor Red
        Write-Host "Verifique o log em: $logFile" -ForegroundColor Yellow
        Write-Host "Consulte a documentação oficial: https://geminicli.com/docs/get-started/installation/" -ForegroundColor Cyan
        exit 1
    }
}

# If installed globally, check gemini command
Write-Section "Verificando binário gemini"
$geminiCmd = Get-Command gemini -ErrorAction SilentlyContinue
if ($null -ne $geminiCmd) {
    try {
        $gver = (& gemini --version) -replace "\r|\n",""
        Write-Host "✓ Gemini CLI instalado e disponível: $gver" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Pacote instalado, mas falha ao executar gemini: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠ Pacote instalado mas 'gemini' não está no PATH" -ForegroundColor Yellow
    # Suggest global npm bin path
    try {
        $globalBin = (& npm bin -g) -replace "\r|\n",""
        Write-Host "Diretório global do npm: $globalBin" -ForegroundColor Cyan
        Write-Host "Adicione ao PATH (PowerShell para sessão atual):" -ForegroundColor Yellow
        Write-Host "  $env:Path = \"$globalBin;$env:Path\"" -ForegroundColor Gray
        Write-Host "Ou persistente (run as admin):" -ForegroundColor Yellow
        Write-Host "  [Environment]::SetEnvironmentVariable('Path', $env:Path + ';' + '$globalBin', 'Machine')" -ForegroundColor Gray
    } catch {
        Write-Host "Não foi possível determinar npm global bin: $_" -ForegroundColor Yellow
    }
    Write-Host "Como alternativa, use: npx $package <args>" -ForegroundColor Cyan
}

# Clean up
if (Test-Path $logFile) { Remove-Item $logFile -ErrorAction SilentlyContinue }

# Next steps
Write-Section "Próximos passos"
Write-Host "1) Teste a instalação:" -ForegroundColor White
Write-Host "   gemini --version  # ou npx @google/gemini-cli --version" -ForegroundColor Gray
Write-Host "" -ForegroundColor White
Write-Host "2) Configure sua API Key (temporário para sessão atual):" -ForegroundColor White
Write-Host "   `$env:GEMINI_API_KEY = 'sua-api-key-aqui'" -ForegroundColor Gray
Write-Host "" -ForegroundColor White
Write-Host "3) Para definir permanentemente (usuário):" -ForegroundColor White
Write-Host "   [Environment]::SetEnvironmentVariable('GEMINI_API_KEY', 'sua-api-key-aqui', 'User')" -ForegroundColor Gray
Write-Host "   (Feche e reabra o terminal para aplicar)" -ForegroundColor Gray
Write-Host "" -ForegroundColor White
Write-Host "Documentação oficial: https://geminicli.com/docs/get-started/installation/" -ForegroundColor Cyan
Write-Host ""

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Instalação finalizada." -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

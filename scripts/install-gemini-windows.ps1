# Script de Instalação do Google Gemini CLI para Windows
# Este script instala e configura o Google Gemini CLI no Windows

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Google Gemini CLI - Instalador Windows" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Python está instalado
Write-Host "Verificando Python..." -ForegroundColor Yellow
$pythonVersion = python --version 2>$null
if ($pythonVersion) {
    Write-Host "✓ Python encontrado: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Python não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale Python 3.8+ em: https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Verificar se pip está instalado
Write-Host ""
Write-Host "Verificando pip..." -ForegroundColor Yellow
$pipVersion = pip --version 2>$null
if ($pipVersion) {
    Write-Host "✓ pip encontrado: $pipVersion" -ForegroundColor Green
} else {
    Write-Host "✗ pip não encontrado!" -ForegroundColor Red
    Write-Host "Por favor, atualize Python ou instale pip manualmente." -ForegroundColor Yellow
    exit 1
}

# Atualizar pip
Write-Host ""
Write-Host "Atualizando pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ pip atualizado com sucesso" -ForegroundColor Green
} else {
    Write-Host "✗ Erro ao atualizar pip" -ForegroundColor Red
    exit 1
}

# Instalar google-gemini-cli
Write-Host ""
Write-Host "Instalando google-gemini-cli..." -ForegroundColor Yellow
pip install google-generativeai

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ google-generativeai instalado com sucesso" -ForegroundColor Green
} else {
    Write-Host "✗ Erro ao instalar google-generativeai" -ForegroundColor Red
    exit 1
}

# Verificar instalação
Write-Host ""
Write-Host "Verificando instalação..." -ForegroundColor Yellow
$geminiVersion = pip show google-generativeai | Select-String "Version"
if ($geminiVersion) {
    Write-Host "✓ Instalação verificada: $geminiVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Erro ao verificar instalação" -ForegroundColor Red
    exit 1
}

# Próximos passos
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Instalação Concluída!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Configure sua API Key:" -ForegroundColor White
Write-Host "   `$env:GEMINI_API_KEY = 'sua-api-key-aqui'" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Obtenha sua API Key em:" -ForegroundColor White
Write-Host "   https://aistudio.google.com/app/apikey" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Teste a instalação com:" -ForegroundColor White
Write-Host "   python -c 'import google.generativeai as genai; print(genai.__version__)'" -ForegroundColor Gray
Write-Host ""

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Documentação:" -ForegroundColor Yellow
Write-Host "https://ai.google.dev/docs" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan


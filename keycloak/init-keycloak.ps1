# Script de inicialização do Keycloak para Windows (PowerShell)
# Este script importa o realm e configura o cliente para o projeto SpringBoot Ralph Loop

$ErrorActionPreference = "Stop"

$KEYCLOAK_URL = "http://localhost:8080"
$KEYCLOAK_ADMIN = "admin"
$KEYCLOAK_ADMIN_PASSWORD = "admin_password"
$REALM_FILE = "D:\ai-patterns\springboot-ralph-loop\keycloak\realm-springboot-ralph.json"

Write-Host "========================================"
Write-Host "Inicializando Keycloak" -ForegroundColor Green
Write-Host "========================================"

# Aguardar Keycloak estar pronto
Write-Host "Aguardando Keycloak ficar pronto..."
$maxAttempts = 30
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        $response = Invoke-WebRequest -Uri "$KEYCLOAK_URL/health/ready" -UseBasicParsing -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ Keycloak está pronto" -ForegroundColor Green
            break
        }
    }
    catch {
        # Continue tentando
    }

    $attempt++
    Write-Host "Tentativa $attempt/$maxAttempts..."
    Start-Sleep -Seconds 2
}

if ($attempt -eq $maxAttempts) {
    Write-Host "✗ Keycloak não ficou pronto a tempo" -ForegroundColor Red
    exit 1
}

# Obter token de admin
Write-Host ""
Write-Host "Obtendo token de administrador..."

$tokenBody = @{
    client_id     = "admin-cli"
    username      = $KEYCLOAK_ADMIN
    password      = $KEYCLOAK_ADMIN_PASSWORD
    grant_type    = "password"
} | ConvertTo-Json

try {
    $tokenResponse = Invoke-WebRequest -Uri "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" `
        -Method Post `
        -ContentType "application/x-www-form-urlencoded" `
        -Body "client_id=admin-cli&username=$KEYCLOAK_ADMIN&password=$KEYCLOAK_ADMIN_PASSWORD&grant_type=password" `
        -UseBasicParsing

    $token = ($tokenResponse.Content | ConvertFrom-Json).access_token

    if (-not $token) {
        Write-Host "✗ Falha ao obter token de administrador" -ForegroundColor Red
        exit 1
    }

    Write-Host "✓ Token obtido com sucesso" -ForegroundColor Green
}
catch {
    Write-Host "✗ Falha ao obter token: $_" -ForegroundColor Red
    exit 1
}

# Verificar se o realm já existe
Write-Host ""
Write-Host "Verificando se o realm 'springboot-ralph' já existe..."

try {
    $headers = @{ Authorization = "Bearer $token" }
    $realmCheck = Invoke-WebRequest -Uri "$KEYCLOAK_URL/admin/realms/springboot-ralph" `
        -Headers $headers `
        -UseBasicParsing `
        -ErrorAction SilentlyContinue

    Write-Host "✓ Realm 'springboot-ralph' já existe" -ForegroundColor Green
}
catch {
    Write-Host "Importando realm de $REALM_FILE..."

    if (-not (Test-Path $REALM_FILE)) {
        Write-Host "✗ Arquivo de realm não encontrado: $REALM_FILE" -ForegroundColor Red
        exit 1
    }

    try {
        $realmContent = Get-Content $REALM_FILE -Raw

        $headers = @{
            Authorization   = "Bearer $token"
            "Content-Type"  = "application/json"
        }

        $realmImport = Invoke-WebRequest -Uri "$KEYCLOAK_URL/admin/realms" `
            -Method Post `
            -Headers $headers `
            -Body $realmContent `
            -UseBasicParsing `
            -ErrorAction SilentlyContinue

        Write-Host "✓ Realm 'springboot-ralph' importado com sucesso" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Falha ao importar realm: $_" -ForegroundColor Red
        exit 1
    }
}

# Exibir informações do cliente
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Informações de Configuração" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Keycloak URL: $KEYCLOAK_URL"
Write-Host "Realm: springboot-ralph"
Write-Host "Client ID: springboot-ralph-app"
Write-Host "Client Secret: springboot-ralph-secret-key-change-in-production"
Write-Host "Admin URL: $KEYCLOAK_URL/admin/realms/springboot-ralph/clients"
Write-Host ""
Write-Host "Usuários padrão:"
Write-Host "  - Username: admin / Password: admin_password"
Write-Host "  - Username: user / Password: user_password"
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Inicialização concluída!" -ForegroundColor Green


# Script de testes para endpoints protegidos pelo Keycloak (PowerShell)
# Este script demonstra como obter tokens e acessar endpoints protegidos

# Variáveis de configuração
$KEYCLOAK_URL = "http://localhost:8080"
$APP_URL = "http://localhost:8081"
$REALM = "springboot-ralph"
$CLIENT_ID = "springboot-ralph-app"
$CLIENT_SECRET = "springboot-ralph-secret-key-change-in-production"

Write-Host "========================================" -ForegroundColor Blue
Write-Host "Teste de Endpoints com Keycloak" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Função para testar endpoint público
function Test-PublicEndpoint {
    Write-Host "1. Testando endpoint público (sem autenticação)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Comando:"
    Write-Host "  Invoke-WebRequest -Uri `"$APP_URL/api/public/hello`" -Method Get"
    Write-Host ""

    try {
        $response = Invoke-WebRequest -Uri "$APP_URL/api/public/hello" -Method Get -UseBasicParsing
        Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "Response: $($response.Content)" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Erro: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Função para obter token
function Get-Token {
    param(
        [string]$Username,
        [string]$Password
    )

    Write-Host "Obtendo token para usuário: $Username" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Comando:"
    Write-Host "  Invoke-WebRequest -Uri `"$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token`" "
    Write-Host "    -Method Post -Body @{ ... }"
    Write-Host ""

    try {
        $body = @{
            client_id     = $CLIENT_ID
            client_secret = $CLIENT_SECRET
            username      = $Username
            password      = $Password
            grant_type    = "password"
        }

        $response = Invoke-WebRequest -Uri "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" `
            -Method Post `
            -ContentType "application/x-www-form-urlencoded" `
            -Body $body `
            -UseBasicParsing

        $jsonResponse = $response.Content | ConvertFrom-Json
        $token = $jsonResponse.access_token

        if ($token) {
            Write-Host "✓ Token obtido com sucesso" -ForegroundColor Green
            Write-Host ""
            Write-Host "Token (primeiros 50 caracteres): $($token.Substring(0, [Math]::Min(50, $token.Length)))..."
            Write-Host ""
            return $token
        }
        else {
            Write-Host "✗ Falha ao obter token" -ForegroundColor Red
            Write-Host "Response: $($response.Content)" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "✗ Erro ao obter token: $_" -ForegroundColor Red
        return $null
    }
}

# Função para testar endpoint protegido
function Test-ProtectedEndpoint {
    param(
        [string]$Endpoint,
        [string]$Token,
        [string]$Description
    )

    Write-Host "Testando: $Description" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Comando:"
    Write-Host "  Invoke-WebRequest -Uri `"$APP_URL$Endpoint`" \"
    Write-Host "    -Headers @{ Authorization = `"Bearer `$token`" }"
    Write-Host ""

    try {
        $headers = @{
            Authorization = "Bearer $Token"
        }

        $response = Invoke-WebRequest -Uri "$APP_URL$Endpoint" `
            -Method Get `
            -Headers $headers `
            -UseBasicParsing

        Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "Response:" -ForegroundColor Green

        try {
            $response.Content | ConvertFrom-Json | ConvertTo-Json | Write-Host
        }
        catch {
            Write-Host $response.Content
        }
    }
    catch {
        Write-Host "✗ Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        Write-Host "Erro: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# Executar testes
Write-Host "=== TESTE 1: Endpoint Público ===" -ForegroundColor Cyan
Write-Host ""
Test-PublicEndpoint
Read-Host "Press enter para continuar..."

Write-Host "=== TESTE 2: Endpoint Protegido com Usuário Common ===" -ForegroundColor Cyan
Write-Host ""
$token = Get-Token "user" "user_password"

if ($token) {
    Test-ProtectedEndpoint "/api/protected/hello" $token "Hello endpoint (protegido)"
    Test-ProtectedEndpoint "/api/protected/user-info" $token "User info endpoint (protegido)"
    Read-Host "Press enter para continuar..."
}

Write-Host "=== TESTE 3: Endpoint de Admin ===" -ForegroundColor Cyan
Write-Host ""
$tokenAdmin = Get-Token "admin" "admin_password"

if ($tokenAdmin) {
    Test-ProtectedEndpoint "/api/admin/status" $tokenAdmin "Admin status endpoint"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Testes concluídos!" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""
Write-Host "Dicas úteis:"
Write-Host "  - Decodificar JWT: https://jwt.io"
Write-Host "  - Documentação Keycloak: https://www.keycloak.org"
Write-Host "  - Logs da aplicação: docker-compose logs -f app"
Write-Host ""


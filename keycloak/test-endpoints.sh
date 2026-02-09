#!/bin/bash

# Script de testes para endpoints protegidos pelo Keycloak
# Este script demonstra como obter tokens e acessar endpoints protegidos

set -e

# Variáveis de configuração
KEYCLOAK_URL="http://localhost:8080"
APP_URL="http://localhost:8081"
REALM="springboot-ralph"
CLIENT_ID="springboot-ralph-app"
CLIENT_SECRET="springboot-ralph-secret-key-change-in-production"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Teste de Endpoints com Keycloak${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Função para testar endpoint público
test_public_endpoint() {
    echo -e "${YELLOW}1. Testando endpoint público (sem autenticação)${NC}"
    echo ""
    echo "Comando:"
    echo "  curl -X GET $APP_URL/api/public/hello"
    echo ""

    RESPONSE=$(curl -s -X GET "$APP_URL/api/public/hello")
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$APP_URL/api/public/hello")

    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ Status: $HTTP_CODE${NC}"
        echo -e "${GREEN}Response: $RESPONSE${NC}"
    else
        echo -e "${RED}✗ Status: $HTTP_CODE${NC}"
        echo -e "${RED}Response: $RESPONSE${NC}"
    fi
    echo ""
}

# Função para obter token
get_token() {
    local USERNAME=$1
    local PASSWORD=$2

    echo -e "${YELLOW}Obtendo token para usuário: $USERNAME${NC}"
    echo ""
    echo "Comando:"
    echo "  curl -X POST $KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token \\"
    echo "    -d 'client_id=$CLIENT_ID' \\"
    echo "    -d 'client_secret=$CLIENT_SECRET' \\"
    echo "    -d 'username=$USERNAME' \\"
    echo "    -d 'password=$PASSWORD' \\"
    echo "    -d 'grant_type=password'"
    echo ""

    RESPONSE=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$CLIENT_ID" \
        -d "client_secret=$CLIENT_SECRET" \
        -d "username=$USERNAME" \
        -d "password=$PASSWORD" \
        -d "grant_type=password")

    TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')

    if [ -z "$TOKEN" ] || [ "$TOKEN" == "null" ]; then
        echo -e "${RED}✗ Falha ao obter token${NC}"
        echo "$RESPONSE" | jq '.'
        return 1
    fi

    echo -e "${GREEN}✓ Token obtido com sucesso${NC}"
    echo ""

    # Exibir informações do token (primeiros 50 caracteres)
    echo "Token (primeiros 50 caracteres): ${TOKEN:0:50}..."
    echo ""

    # Retornar o token
    echo "$TOKEN"
}

# Função para testar endpoint protegido
test_protected_endpoint() {
    local ENDPOINT=$1
    local TOKEN=$2
    local DESCRIPTION=$3

    echo -e "${YELLOW}Testando: $DESCRIPTION${NC}"
    echo ""
    echo "Comando:"
    echo "  curl -X GET $APP_URL$ENDPOINT \\"
    echo "    -H 'Authorization: Bearer \$TOKEN'"
    echo ""

    RESPONSE=$(curl -s -X GET "$APP_URL$ENDPOINT" \
        -H "Authorization: Bearer $TOKEN")
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$APP_URL$ENDPOINT" \
        -H "Authorization: Bearer $TOKEN")

    if [ "$HTTP_CODE" == "200" ]; then
        echo -e "${GREEN}✓ Status: $HTTP_CODE${NC}"
        echo -e "${GREEN}Response:${NC}"
        echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    else
        echo -e "${RED}✗ Status: $HTTP_CODE${NC}"
        echo -e "${RED}Response: $RESPONSE${NC}"
    fi
    echo ""
}

# Executar testes
echo "=== TESTE 1: Endpoint Público ==="
echo ""
test_public_endpoint
echo ""
echo "Press enter para continuar..."
read

echo "=== TESTE 2: Endpoint Protegido com Usuário Common ==="
echo ""
TOKEN=$(get_token "user" "user_password")

if [ -n "$TOKEN" ] && [ "$TOKEN" != "null" ]; then
    test_protected_endpoint "/api/protected/hello" "$TOKEN" "Hello endpoint (protegido)"
    test_protected_endpoint "/api/protected/user-info" "$TOKEN" "User info endpoint (protegido)"
    echo "Press enter para continuar..."
    read
fi

echo "=== TESTE 3: Endpoint de Admin ==="
echo ""
TOKEN_ADMIN=$(get_token "admin" "admin_password")

if [ -n "$TOKEN_ADMIN" ] && [ "$TOKEN_ADMIN" != "null" ]; then
    test_protected_endpoint "/api/admin/status" "$TOKEN_ADMIN" "Admin status endpoint"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Testes concluídos!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Dicas úteis:"
echo "  - Decodificar JWT: https://jwt.io"
echo "  - Documentação Keycloak: https://www.keycloak.org"
echo "  - Logs da aplicação: docker-compose logs -f app"
echo ""


#!/bin/bash

# Script de inicialização do Keycloak
# Este script importa o realm e configura o cliente para o projeto SpringBoot Ralph Loop

set -e

KEYCLOAK_URL="http://localhost:8080"
KEYCLOAK_ADMIN="admin"
KEYCLOAK_ADMIN_PASSWORD="admin_password"
REALM_FILE="/opt/keycloak/data/import/realm-springboot-ralph.json"

echo "========================================"
echo "Inicializando Keycloak"
echo "========================================"

# Aguardar Keycloak estar pronto
echo "Aguardando Keycloak ficar pronto..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -s -o /dev/null -w "%{http_code}" "$KEYCLOAK_URL/health/ready" | grep -q "200"; then
        echo "✓ Keycloak está pronto"
        break
    fi
    attempt=$((attempt + 1))
    echo "Tentativa $attempt/$max_attempts..."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "✗ Keycloak não ficou pronto a tempo"
    exit 1
fi

# Obter token de admin
echo ""
echo "Obtendo token de administrador..."
TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=admin-cli" \
  -d "username=$KEYCLOAK_ADMIN" \
  -d "password=$KEYCLOAK_ADMIN_PASSWORD" \
  -d "grant_type=password" | jq -r '.access_token')

if [ -z "$TOKEN" ] || [ "$TOKEN" == "null" ]; then
    echo "✗ Falha ao obter token de administrador"
    exit 1
fi

echo "✓ Token obtido com sucesso"

# Verificar se o realm já existe
echo ""
echo "Verificando se o realm 'springboot-ralph' já existe..."
REALM_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer $TOKEN" \
  "$KEYCLOAK_URL/admin/realms/springboot-ralph")

if [ "$REALM_EXISTS" == "200" ]; then
    echo "✓ Realm 'springboot-ralph' já existe"
else
    echo "Importando realm de $REALM_FILE..."

    if [ ! -f "$REALM_FILE" ]; then
        echo "✗ Arquivo de realm não encontrado: $REALM_FILE"
        exit 1
    fi

    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$KEYCLOAK_URL/admin/realms" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d @"$REALM_FILE")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" == "201" ] || [ "$HTTP_CODE" == "200" ]; then
        echo "✓ Realm 'springboot-ralph' importado com sucesso"
    else
        echo "✗ Falha ao importar realm"
        echo "HTTP Code: $HTTP_CODE"
        echo "Response: $BODY"
        exit 1
    fi
fi

# Exibir informações do cliente
echo ""
echo "========================================"
echo "Informações de Configuração"
echo "========================================"
echo "Keycloak URL: $KEYCLOAK_URL"
echo "Realm: springboot-ralph"
echo "Client ID: springboot-ralph-app"
echo "Client Secret: springboot-ralph-secret-key-change-in-production"
echo "Admin URL: $KEYCLOAK_URL/admin/realms/springboot-ralph/clients"
echo ""
echo "Usuários padrão:"
echo "  - Username: admin / Password: admin_password"
echo "  - Username: user / Password: user_password"
echo "========================================"
echo "✓ Inicialização concluída!"


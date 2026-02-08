#!/bin/bash

# Script de Instalação do Google Gemini CLI para Linux/macOS (segundo documentação oficial)
# Fonte: https://geminicli.com/docs/get-started/installation/#1-standard-installation-recommended-for-standard-users
# Instalação oficial (global):
#   npm install -g @google/gemini-cli
# Fallback (sem instalação global):
#   npx @google/gemini-cli

set -euo pipefail

echo "======================================"
echo "Google Gemini CLI - Instalador (oficial)"
echo "======================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Detectar OS (para mensagens apenas)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_LABEL="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_LABEL="macOS"
else
    OS_LABEL="Unknown"
fi

echo -e "${YELLOW}Instalador oficial do Gemini CLI - Sistema: ${OS_LABEL}${NC}"

# Detectar ambiente Nix/Devbox
IS_NIX=false
if [[ -d "/nix/store" ]]; then
    IS_NIX=true
    echo -e "${YELLOW}Ambiente detectado: Nix/Devbox (instalações globais via npm podem falhar)${NC}"
fi

echo ""
# Verificar Node.js
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ Node.js encontrado: $NODE_VERSION${NC}"
else
    echo -e "${RED}✗ Node.js não encontrado${NC}"
    echo -e "${YELLOW}Instale Node.js (inclui npm) antes de continuar.${NC}"
    echo "Exemplo (Debian/Ubuntu): sudo apt-get install -y nodejs npm"
    echo "Exemplo (macOS Homebrew): brew install node"
    exit 1
fi

# Verificar npm
if command -v npm >/dev/null 2>&1; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✓ npm encontrado: $NPM_VERSION${NC}"
else
    echo -e "${RED}✗ npm não encontrado${NC}"
    echo -e "${YELLOW}Instale npm (geralmente incluído com Node.js) e rode novamente.${NC}"
    exit 1
fi

PACKAGE="@google/gemini-cli"
LOG_FILE="/tmp/gemini-npm-install.log"

# Se estivermos em Nix/Devbox, NÃO tentar instalar globalmente
if [ "$IS_NIX" = true ]; then
    echo ""
    echo -e "${YELLOW}Em Nix/Devbox: pulando tentativa de instalação global via npm (restrição de filesystem).${NC}"
    echo -e "${YELLOW}Usando fallback recomendado: executar via npx (não requer instalação global).${NC}"
    echo "Tentando executar com npx: npx ${PACKAGE} --version"
    if npx -y "${PACKAGE}" --version >"${LOG_FILE}" 2>&1; then
        echo -e "${GREEN}✓ npx conseguiu executar ${PACKAGE}${NC}"
        echo -e "${GREEN}Você pode usar: npx ${PACKAGE} <args> ou adicionar um wrapper no projeto.${NC}"
        rm -f "${LOG_FILE}" || true
        exit 0
    else
        echo -e "${RED}✗ npx falhou em ambiente Nix/Devbox${NC}"
        echo "Verifique o log: ${LOG_FILE}"
        echo "Considere instalar o pacote via devbox (adicionar node/npm e gerir instalação global fora do /nix/store)"
        exit 1
    fi
fi

# Fora do Nix: tentar instalação global conforme doc oficial
echo ""
echo -e "${YELLOW}Executando instalação oficial: npm install -g ${PACKAGE}${NC}"
# Tentar instalar globalmente
if npm install -g "${PACKAGE}" >"${LOG_FILE}" 2>&1; then
    echo -e "${GREEN}✓ pacote ${PACKAGE} instalado globalmente${NC}"
else
    echo -e "${RED}✗ Falha ao instalar ${PACKAGE} globalmente${NC}"
    echo "Últimas linhas do log de instalação:"
    tail -n 30 "${LOG_FILE}" | sed 's/^/    /'
    echo ""

    echo "Tentando fallback com npx (executa sem instalar globalmente)..."
    if npx -y "${PACKAGE}" --version >"${LOG_FILE}" 2>&1; then
        echo -e "${GREEN}✓ npx conseguiu executar ${PACKAGE}${NC}"
        echo -e "${GREEN}Você pode usar o Gemini CLI com: npx ${PACKAGE} <args>${NC}"
        rm -f "${LOG_FILE}" || true
        exit 0
    else
        echo -e "${RED}✗ npx também falhou${NC}"
        echo "Verifique o log em: ${LOG_FILE} e a documentação oficial: https://geminicli.com/docs/get-started/installation/"
        exit 1
    fi
fi

# Se a instalação global aparentemente funcionou, verificar comando
if command -v gemini >/dev/null 2>&1; then
    GEMINI_VERSION=$(gemini --version 2>/dev/null || true)
    echo -e "${GREEN}✓ Gemini CLI instalado e disponível: ${GEMINI_VERSION}${NC}"
else
    echo -e "${YELLOW}Pacote instalado, mas o binário 'gemini' não está no PATH.${NC}"
    GLOBAL_NPM_BIN=$(npm bin -g 2>/dev/null || true)
    if [ -n "$GLOBAL_NPM_BIN" ]; then
        echo "Diretório global npm bin: $GLOBAL_NPM_BIN"
        echo "Adicione ao PATH: export PATH=\"$GLOBAL_NPM_BIN:$PATH\""
    fi
    echo "Como alternativa, use: npx ${PACKAGE} <args>"
fi

# Limpeza
rm -f "${LOG_FILE}" 2>/dev/null || true

# Próximos passos
echo ""
echo "======================================"
echo -e "${GREEN}Instalação concluída (ou fallback disponível)!${NC}"
echo "======================================"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "1. Teste a instalação:"
echo -e "   ${CYAN}gemini --version${NC}  # ou npx @google/gemini-cli --version${NC}"
echo "2. Configure sua API Key:"
echo -e "   ${CYAN}export GEMINI_API_KEY='sua-api-key-aqui'${NC}"
echo ""
echo "Documentação oficial: https://geminicli.com/docs/get-started/installation/"

echo ""

# Fim do script
exit 0

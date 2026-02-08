#!/bin/bash

fi
    echo ""
    echo "3. Salve e execute: source ~/.bashrc (ou ~/.zshrc)"
    echo -e "   ${CYAN}export GEMINI_API_KEY='sua-api-key-aqui'${NC}"
    echo "2. Adicione a linha:"
    echo "1. Abra seu arquivo ~/.bashrc ou ~/.zshrc"
    echo -e "${YELLOW}Para configurar a API Key permanentemente:${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
# Adicionar sugestão de configuração permanente

echo ""
echo "======================================"
echo -e "${CYAN}https://ai.google.dev/docs${NC}"
echo -e "${YELLOW}Documentação:${NC}"
echo "======================================"

echo ""
echo -e "   ${CYAN}python3 -c 'import google.generativeai as genai; print(genai.__version__)'${NC}"
echo "3. Teste a instalação com:"
echo ""
echo -e "   ${CYAN}https://aistudio.google.com/app/apikey${NC}"
echo "2. Obtenha sua API Key em:"
echo ""
echo -e "   ${CYAN}export GEMINI_API_KEY='sua-api-key-aqui'${NC}"
echo "1. Configure sua API Key:"
echo -e "${YELLOW}Próximos passos:${NC}"
echo ""
echo "======================================"
echo -e "${GREEN}Instalação Concluída!${NC}"
echo "======================================"
echo ""
# Próximos passos

fi
    exit 1
    echo -e "${RED}✗ Erro ao verificar instalação${NC}"
else
    echo -e "${GREEN}✓ Instalação verificada: $GEMINI_VERSION${NC}"
if [ ! -z "$GEMINI_VERSION" ]; then
GEMINI_VERSION=$($PIP_CMD show google-generativeai | grep Version)
echo -e "${YELLOW}Verificando instalação...${NC}"
echo ""
# Verificar instalação

fi
    exit 1
    echo -e "${RED}✗ Erro ao instalar google-generativeai${NC}"
else
    echo -e "${GREEN}✓ google-generativeai instalado com sucesso${NC}"
if [ $? -eq 0 ]; then

$PIP_CMD install google-generativeai
echo -e "${YELLOW}Instalando google-generativeai...${NC}"
echo ""
# Instalar google-generativeai

fi
    exit 1
    echo -e "${RED}✗ Erro ao atualizar pip${NC}"
else
    echo -e "${GREEN}✓ pip atualizado com sucesso${NC}"
if [ $? -eq 0 ]; then
$PYTHON_CMD -m pip install --upgrade pip
echo -e "${YELLOW}Atualizando pip...${NC}"
echo ""
# Atualizar pip

fi
    exit 1
    echo -e "${RED}✗ pip não encontrado!${NC}"
else
    PIP_CMD="pip"
    echo -e "${GREEN}✓ pip encontrado: $PIP_VERSION${NC}"
    PIP_VERSION=$(pip --version)
elif command -v pip &> /dev/null; then
    PIP_CMD="pip3"
    echo -e "${GREEN}✓ pip encontrado: $PIP_VERSION${NC}"
    PIP_VERSION=$(pip3 --version)
if command -v pip3 &> /dev/null; then
echo -e "${YELLOW}Verificando pip...${NC}"
echo ""
# Verificar se pip está instalado

fi
    exit 1
    fi
        echo "  brew install python3"
        echo -e "${CYAN}Para macOS (com Homebrew):${NC}"
        # macOS
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  sudo dnf install python3 python3-pip"
        echo -e "${CYAN}Para Fedora/RHEL:${NC}"
        echo ""
        echo "  sudo apt-get update && sudo apt-get install python3 python3-pip"
        echo -e "${CYAN}Para Ubuntu/Debian:${NC}"
        # Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Sugestões por sistema operacional

    echo -e "${YELLOW}Por favor, instale Python 3.8+ e tente novamente${NC}"
    echo -e "${RED}✗ Python não encontrado!${NC}"
else
    PYTHON_CMD="python"
    echo -e "${GREEN}✓ Python encontrado: $PYTHON_VERSION${NC}"
    PYTHON_VERSION=$(python --version)
elif command -v python &> /dev/null; then
    PYTHON_CMD="python3"
    echo -e "${GREEN}✓ Python encontrado: $PYTHON_VERSION${NC}"
    PYTHON_VERSION=$(python3 --version)
if command -v python3 &> /dev/null; then
echo -e "${YELLOW}Verificando Python...${NC}"
# Verificar se Python está instalado

NC='\033[0m' # No Color
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
# Cores para output

echo ""
echo "======================================"
echo "Google Gemini CLI - Instalador Linux/macOS"
echo "======================================"

# Este script instala e configura o Google Gemini CLI
# Script de Instalação do Google Gemini CLI para Linux/macOS


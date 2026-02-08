.PHONY: help install-gemini-windows install-gemini-linux install-gemini clean build test run run-docker

# Variáveis
PROJECT_NAME = springboot-ralph-loop
MAVEN_CMD = mvnw
PYTHON_CMD = python3
PIP_CMD = pip3

# Cores para output (funciona em bash/linux)
CYAN = \033[0;36m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# ============================================================
# HELP - Exibir ajuda
# ============================================================
# ============================================================
# HELP - Exibir ajuda
# ============================================================

## Ver guia rápido de início
quickstart:
	@echo "$(CYAN)=====================================$(NC)"
	@echo "$(CYAN)Quick Start - Guia Rápido$(NC)"
	@echo "$(CYAN)=====================================$(NC)"
	@echo ""
	@echo "$(YELLOW)Opção 1: Devbox (Recomendado)$(NC)"
	@echo "  1. Instalar: curl -fsSL https://get.jetify.com/devbox | bash"
	@echo "  2. Ativar:   devbox shell"
	@echo "  3. Instalar: make install-gemini-linux"
	@echo "  4. Executar: make clean-build && make test && make run"
	@echo ""
	@echo "$(YELLOW)Opção 2: Makefile (Mais Simples)$(NC)"
	@echo "  1. Instalar: make install-gemini-windows  (ou make install-gemini-linux)"
	@echo "  2. Compilar: make clean-build"
	@echo "  3. Testar:   make test"
	@echo "  4. Executar: make run"
	@echo ""
	@echo "$(YELLOW)Opção 3: Docker (Containerizado)$(NC)"
	@echo "  1. Build:    make docker-rebuild"
	@echo "  2. Iniciar:  make docker-up"
	@echo "  3. Logs:     make docker-logs"
	@echo "  4. Parar:    make docker-down"
	@echo ""
	@echo "$(GREEN)📖 Para mais detalhes, leia QUICKSTART.md$(NC)"
	@echo "$(CYAN)=====================================$(NC)"

help:
	@echo "$(CYAN)=====================================$(NC)"
	@echo "$(CYAN)$(PROJECT_NAME) - Makefile Help$(NC)"
	@echo "$(CYAN)=====================================$(NC)"
	@echo ""
	@echo "$(GREEN)🚀 Quick Start$(NC)"
	@echo "  $(YELLOW)make quickstart$(NC)               - Ver guia rápido de início"
	@echo ""
	@echo "$(GREEN)Google Gemini CLI - Instalação$(NC)"
	@echo "  $(YELLOW)make quickstart$(NC)               - Ver guia rápido de início"
	@echo ""
	@echo "$(GREEN)Google Gemini CLI - Instalação$(NC)"
	@echo "  $(YELLOW)make install-gemini-windows$(NC)   - Instalar Gemini CLI no Windows (PowerShell)"
	@echo "  $(YELLOW)make install-gemini-linux$(NC)     - Instalar Gemini CLI no Linux/macOS"
	@echo "  $(YELLOW)make install-gemini-manual$(NC)    - Instalação manual (pip install)"
	@echo ""
	@echo "$(GREEN)Compilação e Build$(NC)"
	@echo "  $(YELLOW)make build$(NC)                    - Compilar o projeto com Maven"
	@echo "  $(YELLOW)make clean$(NC)                    - Limpar arquivos compilados"
	@echo "  $(YELLOW)make clean-build$(NC)              - Limpar e compilar o projeto"
	@echo ""
	@echo "$(GREEN)Testes$(NC)"
	@echo "  $(YELLOW)make test$(NC)                     - Executar testes unitários"
	@echo "  $(YELLOW)make test-verbose$(NC)             - Executar testes com output detalhado"
	@echo ""
	@echo "$(GREEN)Execução da Aplicação$(NC)"
	@echo "  $(YELLOW)make run$(NC)                      - Executar a aplicação Spring Boot"
	@echo "  $(YELLOW)make run-docker$(NC)               - Executar com Docker Compose"
	@echo "  $(YELLOW)make docker-up$(NC)                - Iniciar serviços Docker"
	@echo "  $(YELLOW)make docker-down$(NC)              - Parar serviços Docker"
	@echo "  $(YELLOW)make docker-logs$(NC)              - Ver logs dos serviços Docker"
	@echo ""
	@echo "$(GREEN)Verificação$(NC)"
	@echo "  $(YELLOW)make verify$(NC)                   - Verificar instalações (Python, Maven, Java)"
	@echo "  $(YELLOW)make gemini-test$(NC)              - Testar instalação do Google Gemini"
	@echo ""
	@echo "$(GREEN)Desenvolvimento$(NC)"
	@echo "  $(YELLOW)make install-deps$(NC)             - Instalar dependências do Maven"
	@echo "  $(YELLOW)make help$(NC)                     - Exibir esta mensagem de ajuda"
	@echo ""
	@echo "$(CYAN)=====================================$(NC)"

# ============================================================
# GOOGLE GEMINI CLI - Instalação
# ============================================================

## Windows - Instalar via PowerShell
install-gemini-windows:
	@echo "$(CYAN)Instalando Google Gemini CLI para Windows...$(NC)"
	@powershell -Command "if ($$PSVersionTable.PSVersion.Major -lt 5) { Write-Host '$(RED)PowerShell 5.0+ é necessário$(NC)'; exit 1 }"
	@powershell -ExecutionPolicy Bypass -File scripts\install-gemini-windows.ps1

## Linux/macOS - Instalar via Bash
install-gemini-linux:
	@echo "$(CYAN)Instalando Google Gemini CLI para Linux/macOS...$(NC)"
	@bash scripts/install-gemini-linux.sh

## Instalação Manual
install-gemini-manual:
	@echo "$(YELLOW)Instalação manual do Google Generative AI...$(NC)"
	$(PYTHON_CMD) -m pip install --upgrade pip
	$(PIP_CMD) install google-generativeai
	@echo "$(GREEN)✓ Instalação concluída!$(NC)"

## Testar instalação do Gemini
gemini-test:
	@echo "$(YELLOW)Testando instalação do Google Generative AI...$(NC)"
	$(PYTHON_CMD) -c "import google.generativeai as genai; print('$(GREEN)✓ google-generativeai versão:$(NC) ' + genai.__version__)" 2>/dev/null || echo "$(RED)✗ google-generativeai não encontrado. Execute: make install-gemini-manual$(NC)"

# ============================================================
# COMPILAÇÃO E BUILD
# ============================================================

## Compilar o projeto
build:
	@echo "$(CYAN)Compilando o projeto...$(NC)"
	./$(MAVEN_CMD) clean package

## Limpar arquivos compilados
clean:
	@echo "$(YELLOW)Limpando arquivos compilados...$(NC)"
	./$(MAVEN_CMD) clean

## Limpar e compilar
clean-build: clean build
	@echo "$(GREEN)✓ Build completo concluído!$(NC)"

## Instalar dependências Maven
install-deps:
	@echo "$(YELLOW)Instalando dependências Maven...$(NC)"
	./$(MAVEN_CMD) install

# ============================================================
# TESTES
# ============================================================

## Executar testes unitários
test:
	@echo "$(CYAN)Executando testes unitários...$(NC)"
	./$(MAVEN_CMD) test

## Executar testes com output detalhado
test-verbose:
	@echo "$(CYAN)Executando testes com output detalhado...$(NC)"
	./$(MAVEN_CMD) test -X

# ============================================================
# EXECUÇÃO DA APLICAÇÃO
# ============================================================

## Executar a aplicação Spring Boot
run:
	@echo "$(CYAN)Iniciando a aplicação Spring Boot...$(NC)"
	./$(MAVEN_CMD) spring-boot:run

## Executar com Docker Compose
run-docker: docker-up
	@echo "$(GREEN)✓ Aplicação rodando com Docker Compose$(NC)"
	@echo "$(YELLOW)Acesse: http://localhost:8080$(NC)"

## Iniciar serviços Docker
docker-up:
	@echo "$(CYAN)Iniciando Docker Compose...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Serviços Docker iniciados$(NC)"

## Parar serviços Docker
docker-down:
	@echo "$(YELLOW)Parando Docker Compose...$(NC)"
	docker-compose down
	@echo "$(GREEN)✓ Serviços Docker parados$(NC)"

## Ver logs dos serviços Docker
docker-logs:
	@echo "$(CYAN)Exibindo logs dos serviços Docker...$(NC)"
	docker-compose logs -f

## Recompilar Docker image
docker-rebuild:
	@echo "$(CYAN)Reconstruindo imagem Docker...$(NC)"
	docker-compose up --build

# ============================================================
# VERIFICAÇÃO
# ============================================================

## Verificar instalações
verify:
	@echo "$(CYAN)Verificando instalações...$(NC)"
	@echo ""
	@echo "$(YELLOW)Java:$(NC)"
	@java -version 2>&1 || echo "$(RED)Java não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Maven:$(NC)"
	@./$(MAVEN_CMD) --version 2>&1 || echo "$(RED)Maven não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Python:$(NC)"
	@$(PYTHON_CMD) --version 2>&1 || echo "$(RED)Python não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Docker:$(NC)"
	@docker --version 2>&1 || echo "$(RED)Docker não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Docker Compose:$(NC)"
	@docker-compose --version 2>&1 || echo "$(RED)Docker Compose não encontrado$(NC)"

# ============================================================
# ALIASES E ATALHOS
# ============================================================

## Compilar e testar
ct: clean test
	@echo "$(GREEN)✓ Compilação e testes concluídos$(NC)"

## Compilar, testar e executar
ctr: clean test run
	@echo "$(GREEN)✓ Compilação, testes e execução concluídos$(NC)"

## Instalar Gemini e testar
ig: install-gemini-manual gemini-test
	@echo "$(GREEN)✓ Gemini instalado e testado com sucesso$(NC)"

# ============================================================
# Padrão Make (deve ser o último)
# ============================================================
.DEFAULT_GOAL := help


.PHONY: help install-gemini-windows install-gemini-linux install-gemini clean build test run run-docker compose-up compose-down compose-logs compose-ps compose-restart compose-rebuild docker-status docker-start pwd infra-up infra-down infra-logs

# Variáveis
PROJECT_NAME = springboot-ralph-loop
MAVEN_CMD = mvnw
PYTHON_CMD = python3
PIP_CMD = pip3

# ============================================================
# DETECÇÃO AUTOMÁTICA - Docker ou Podman
# ============================================================
# Verifica se Docker está instalado
DOCKER_EXISTS := $(shell command -v docker 2> /dev/null)
# Verifica se o daemon do docker está respondendo (ativo)
DOCKER_ACTIVE := $(shell docker info > /dev/null 2>&1 && echo "yes" || echo "no")

# Verifica se Podman está instalado
PODMAN_EXISTS := $(shell command -v podman 2> /dev/null)
# Podman geralmente não tem daemon, mas verificamos se o comando info funciona
PODMAN_ACTIVE := $(shell podman info > /dev/null 2>&1 && echo "yes" || echo "no")

# Lógica de decisão:
# 1. Se Docker estiver ativo, usa Docker.
# 2. Se Docker não estiver ativo, mas Podman estiver ativo, usa Podman.
# 3. Se nenhum estiver ativo, mas Docker existir, define como Docker (mas avisa que está inativo).
# 4. Se nem Docker existir, mas Podman existir, define como Podman.
# 5. Fallback para Docker.

ifeq ($(DOCKER_ACTIVE),yes)
    CONTAINER_CMD := docker
    # Tenta detectar docker compose (plugin) vs docker-compose (standalone)
    ifeq ($(shell docker compose version > /dev/null 2>&1 && echo yes || echo no),yes)
        COMPOSE_CMD := docker compose
    else
        COMPOSE_CMD := docker-compose
    endif
    RUNTIME_NAME := Docker
    IS_ACTIVE := true
else ifeq ($(PODMAN_ACTIVE),yes)
    CONTAINER_CMD := podman
    # Podman 3.0+ suporta "podman compose" se o docker-compose estiver instalado ou via podman-compose wrapper
    # Mas o comando nativo mais seguro é "podman-compose" se instalado, ou "podman compose"
    # Vamos verificar se podman-compose existe
    ifeq ($(shell command -v podman-compose 2> /dev/null),)
        COMPOSE_CMD := podman compose
    else
        COMPOSE_CMD := podman-compose
    endif
    RUNTIME_NAME := Podman
    IS_ACTIVE := true
else ifneq ($(DOCKER_EXISTS),)
    CONTAINER_CMD := docker
    COMPOSE_CMD := docker-compose
    RUNTIME_NAME := Docker (Inativo)
    IS_ACTIVE := false
else ifneq ($(PODMAN_EXISTS),)
    CONTAINER_CMD := podman
    COMPOSE_CMD := podman-compose
    RUNTIME_NAME := Podman (Inativo)
    IS_ACTIVE := false
else
    CONTAINER_CMD := docker
    COMPOSE_CMD := docker-compose
    RUNTIME_NAME := Nenhum
    IS_ACTIVE := false
endif

# Cores para output (funciona em bash/linux)
CYAN = \033[0;36m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

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
	@echo "$(YELLOW)Runtime Detectado: $(RUNTIME_NAME)$(NC)"
	@echo ""
	@echo "$(GREEN)🚀 Quick Start$(NC)"
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
	@echo ""
	@echo "$(GREEN)Infraestrutura (Keycloak)$(NC)"
	@echo "  $(YELLOW)make infra-up$(NC)                 - Iniciar infraestrutura (Keycloak)"
	@echo "  $(YELLOW)make infra-down$(NC)               - Parar infraestrutura"
	@echo "  $(YELLOW)make infra-logs$(NC)               - Ver logs da infraestrutura"
	@echo ""
	@echo "$(GREEN)Docker Compose - Gerenciamento$(NC)"
	@echo "  $(YELLOW)make compose-up$(NC)               - Iniciar serviços Docker Compose"
	@echo "  $(YELLOW)make compose-down$(NC)             - Parar serviços Docker Compose"
	@echo "  $(YELLOW)make compose-logs$(NC)             - Ver logs dos serviços"
	@echo "  $(YELLOW)make compose-ps$(NC)               - Exibir status dos serviços"
	@echo "  $(YELLOW)make compose-restart$(NC)          - Reiniciar serviços"
	@echo "  $(YELLOW)make compose-rebuild$(NC)          - Recompilar e iniciar serviços"
	@echo ""
	@echo "$(GREEN)Verificação$(NC)"
	@echo "  $(YELLOW)make verify$(NC)                   - Verificar instalações (Python, Maven, Java)"
	@echo "  $(YELLOW)make gemini-test$(NC)              - Testar instalação do Google Gemini"
	@echo "  $(YELLOW)make pwd$(NC)                      - Mostrar diretório corrente"
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
	@echo "$(GREEN)✓ Aplicação rodando com Docker Compose ($(RUNTIME_NAME))$(NC)"
	@echo "$(YELLOW)Acesse: http://localhost:8080$(NC)"

## Iniciar serviços Docker
docker-up:
	@echo "$(CYAN)Iniciando Docker Compose usando $(RUNTIME_NAME)...$(NC)"
	$(COMPOSE_CMD) up -d
	@echo "$(GREEN)✓ Serviços iniciados$(NC)"

## Parar serviços Docker
docker-down:
	@echo "$(YELLOW)Parando Docker Compose...$(NC)"
	$(COMPOSE_CMD) down
	@echo "$(GREEN)✓ Serviços parados$(NC)"

## Ver logs dos serviços Docker
docker-logs:
	@echo "$(CYAN)Exibindo logs dos serviços...$(NC)"
	$(COMPOSE_CMD) logs -f

## Recompilar Docker image
docker-rebuild:
	@echo "$(CYAN)Reconstruindo imagem Docker...$(NC)"
	$(COMPOSE_CMD) up --build

## Verificar status do Docker
docker-status:
	@echo "$(CYAN)Verificando status do Runtime ($(RUNTIME_NAME))...$(NC)"
	@echo ""
	@echo "$(YELLOW)$(RUNTIME_NAME) versão:$(NC)"
	@$(CONTAINER_CMD) --version 2>&1 || echo "$(RED)$(CONTAINER_CMD) não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Compose versão:$(NC)"
	@$(COMPOSE_CMD) version 2>&1 || echo "$(RED)$(COMPOSE_CMD) não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Containers rodando:$(NC)"
	@$(CONTAINER_CMD) ps

## Iniciar Docker Desktop no Windows
docker-start:
	@echo "$(CYAN)Tentando iniciar Docker Desktop...$(NC)"
	@powershell -Command "Get-Process Docker -ErrorAction SilentlyContinue | Select-Object -First 1 | ForEach-Object { if ($$_) { Write-Host '$(GREEN)✓ Docker já está rodando$(NC)' } else { Write-Host '$(YELLOW)Iniciando Docker Desktop...$(NC)'; & '$$Env:ProgramFiles\Docker\Docker\Docker.exe'; Start-Sleep -Seconds 3; Write-Host '$(YELLOW)Docker iniciado. Aguarde alguns segundos...$(NC)' } }" 2>/dev/null || echo "$(RED)Não foi possível iniciar Docker. Inicie manualmente.$(NC)"
	@echo ""
	@echo "$(YELLOW)Aguarde 10-30 segundos para o Docker iniciar completamente...$(NC)"
	@echo "$(YELLOW)Verifique a bandeja de sistema (canto inferior direito) para 'Docker is running'$(NC)"
	@echo ""
	@echo "$(YELLOW)Quando pronto, execute:$(NC)"
	@echo "  make docker-status"
	@echo "  make compose-up"
	@echo ""

# ============================================================
# INFRAESTRUTURA (Keycloak)
# ============================================================

## Iniciar infraestrutura (Keycloak)
infra-up:
	@echo "$(CYAN)Iniciando infraestrutura (Keycloak) com $(RUNTIME_NAME)...$(NC)"
	$(COMPOSE_CMD) -f docker-compose.keycloak.yaml up -d
	@echo "$(GREEN)✓ Infraestrutura iniciada$(NC)"
	@echo "$(YELLOW)Keycloak acessível em: http://localhost:8081$(NC)"

## Parar infraestrutura
infra-down:
	@echo "$(YELLOW)Parando infraestrutura...$(NC)"
	$(COMPOSE_CMD) -f docker-compose.keycloak.yaml down
	@echo "$(GREEN)✓ Infraestrutura parada$(NC)"

## Ver logs da infraestrutura
infra-logs:
	@echo "$(CYAN)Exibindo logs da infraestrutura...$(NC)"
	$(COMPOSE_CMD) -f docker-compose.keycloak.yaml logs -f

# ============================================================
# DOCKER COMPOSE - Comandos específicos
# ============================================================

## Iniciar serviços do Docker Compose
compose-up:
	@echo "$(CYAN)Iniciando serviços Docker Compose...$(NC)"
	$(COMPOSE_CMD) up -d
	@echo "$(GREEN)✓ Serviços iniciados com sucesso$(NC)"
	@echo "$(YELLOW)Use 'make compose-logs' para ver logs$(NC)"

## Parar serviços do Docker Compose
compose-down:
	@echo "$(YELLOW)Parando serviços Docker Compose...$(NC)"
	$(COMPOSE_CMD) down
	@echo "$(GREEN)✓ Serviços parados com sucesso$(NC)"

## Ver logs dos serviços Docker Compose
compose-logs:
	@echo "$(CYAN)Exibindo logs Docker Compose (Ctrl+C para sair)...$(NC)"
	$(COMPOSE_CMD) logs -f

## Exibir status dos serviços Docker Compose
compose-ps:
	@echo "$(CYAN)Status dos serviços Docker Compose:$(NC)"
	@$(COMPOSE_CMD) ps

## Reiniciar serviços Docker Compose
compose-restart:
	@echo "$(YELLOW)Reiniciando serviços Docker Compose...$(NC)"
	$(COMPOSE_CMD) restart
	@echo "$(GREEN)✓ Serviços reiniciados com sucesso$(NC)"

## Recompilar e iniciar serviços Docker Compose
compose-rebuild:
	@echo "$(CYAN)Reconstruindo e iniciando serviços Docker Compose...$(NC)"
	$(COMPOSE_CMD) up -d --build
	@echo "$(GREEN)✓ Serviços reconstruídos e iniciados$(NC)"
	@echo "$(YELLOW)Use 'make compose-logs' para ver logs$(NC)"

# ============================================================
# VERIFICAÇÃO
# ============================================================

## Mostrar diretório corrente
pwd:
	@echo "$(CYAN)Diretório corrente:$(NC)"
	@pwd

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
	@echo "$(YELLOW)Container Runtime ($(RUNTIME_NAME)):$(NC)"
	@$(CONTAINER_CMD) --version 2>&1 || echo "$(RED)$(CONTAINER_CMD) não encontrado$(NC)"
	@echo ""
	@echo "$(YELLOW)Compose:$(NC)"
	@$(COMPOSE_CMD) version 2>&1 || echo "$(RED)$(COMPOSE_CMD) não encontrado$(NC)"

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

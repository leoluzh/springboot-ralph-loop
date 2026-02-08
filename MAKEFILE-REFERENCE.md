# Makefile - Referência Rápida

## 🚀 Comandos Principais

### Instalação do Google Gemini CLI

```bash
# Windows (PowerShell)
make install-gemini-windows

# Linux/macOS
make install-gemini-linux

# Instalação Manual (qualquer SO)
make install-gemini-manual

# Testar instalação
make gemini-test
```

### Compilação e Build

```bash
# Compilar o projeto
make build

# Limpar arquivos compilados
make clean

# Limpar e compilar (full build)
make clean-build

# Instalar dependências Maven
make install-deps
```

### Testes

```bash
# Executar testes unitários
make test

# Executar testes com output detalhado
make test-verbose
```

### Execução

```bash
# Executar aplicação Spring Boot
make run

# Executar com Docker Compose
make run-docker

# Docker - Iniciar serviços
make docker-up

# Docker - Parar serviços
make docker-down

# Docker - Ver logs
make docker-logs

# Docker - Reconstruir image
make docker-rebuild
```

### Verificação e Ajuda

```bash
# Exibir ajuda completa
make help

# Verificar instalações (Java, Maven, Python, Docker)
make verify
```

## ⚡ Aliases (Atalhos)

```bash
# Compilar e testar
make ct

# Compilar, testar e executar
make ctr

# Instalar Gemini e testar
make ig
```

---

## 📋 Exemplo de Fluxo Completo

1. **Instalar dependências do Gemini:**
   ```bash
   make install-gemini-windows    # ou make install-gemini-linux
   ```

2. **Verificar instalação:**
   ```bash
   make gemini-test
   ```

3. **Compilar o projeto:**
   ```bash
   make clean-build
   ```

4. **Executar testes:**
   ```bash
   make test
   ```

5. **Iniciar a aplicação:**
   ```bash
   make run
   ```

---

## 🎯 Fluxo de Desenvolvimento

```bash
# Desenvolvimento local
make clean-build && make test && make run

# Com Docker
make clean-build && make test && make run-docker

# Verificar tudo antes de fazer commit
make verify && make clean-build && make test
```

---

## 📝 Notas Importantes

- **Windows**: Use `make install-gemini-windows` - requer PowerShell 5.0+
- **Linux/macOS**: Use `make install-gemini-linux` - requer bash
- **Docker**: Certifique-se que Docker e Docker Compose estão instalados
- **Maven**: O projeto usa Maven wrapper (mvnw), não é necessário instalar Maven globalmente

---

**Última atualização**: Fevereiro 2026


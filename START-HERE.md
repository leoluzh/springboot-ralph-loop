
# 🎯 INÍCIO RÁPIDO - Escolha Sua Abordagem

## ⚡ 3 Opções Para Começar

### 1️⃣ DEVBOX (RECOMENDADO) ⭐
**Ambiente isolado, reproduzível, sem poluição do sistema**

```bash
# Instalar (primeira vez)
curl -fsSL https://get.jetify.com/devbox | bash

# Usar
devbox shell                      # Ativa o ambiente
make install-gemini-linux         # Instala Gemini
make clean-build && make test     # Compila e testa
make run                          # Executa a app
exit                              # Sai do ambiente
```
📖 Documentação: [DEVBOX-GUIDE.md](DEVBOX-GUIDE.md)

---

### 2️⃣ MAKEFILE (SIMPLES)
**Instalação global, integração com IDE, mais direto**

```bash
# Instalar Gemini
make install-gemini-windows       # Windows
make install-gemini-linux         # Linux/macOS

# Usar
make clean-build                  # Compila
make test                         # Testa
make run                          # Executa
```
📖 Documentação: [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md)

---

### 3️⃣ DOCKER (PROFISSIONAL)
**Containerizado, pronto para produção**

```bash
# Setup
make docker-rebuild               # Cria imagem

# Usar
make docker-up                    # Inicia
make docker-logs                  # Vê logs
make docker-down                  # Para
```
📖 Documentação: [README.md](README.md)

---

## 📋 Todos os Documentos

| Documento | Propósito | Leia se |
|-----------|-----------|---------|
| [**QUICKSTART.md**](QUICKSTART.md) | 🚀 Início em 5 min | Quer começar agora |
| [**README.md**](README.md) | 📖 Documentação completa | Quer entender tudo |
| [**DEVBOX-GUIDE.md**](DEVBOX-GUIDE.md) | 🔧 Guia Devbox | Escolheu Devbox |
| [**MAKEFILE-REFERENCE.md**](MAKEFILE-REFERENCE.md) | 🔨 Referência Make | Escolheu Makefile |
| [**PROJECT-SETUP.md**](PROJECT-SETUP.md) | 📦 Setup Completo | Quer visão geral |
| [**DOCUMENTATION.md**](DOCUMENTATION.md) | 📚 Índice de Docs | Procura alguma coisa |
| [**scripts/README-SCRIPTS.md**](scripts/README-SCRIPTS.md) | 📜 Scripts Install | Quer detalhes dos scripts |

---

## 🔑 Variáveis de Ambiente

```bash
# Google Gemini API Key (OBRIGATÓRIO)
export GEMINI_API_KEY="sua-chave-aqui"

# Obter em: https://aistudio.google.com/app/apikey
```

Configure em `.env.local` (copie de `.env.example`)

---

## 🛠️ Comandos Principais

```bash
# Ajuda
make help                 # Ver todos os comandos
make quickstart           # Ver este resumo

# Instalação
make install-gemini-windows    # Windows
make install-gemini-linux      # Linux/macOS
make gemini-test               # Testar

# Build & Test
make build                # Compilar
make test                 # Testar
make clean-build          # Full rebuild

# Execução
make run                  # Executar
make run-docker           # Com Docker

# Docker
make docker-up            # Iniciar
make docker-down          # Parar
make docker-logs          # Logs

# Atalhos
make ct                   # compile + test
make ctr                  # compile + test + run
make ig                   # install + gemini-test
```

---

## ✅ Checklist de Setup

### Pré-Requisitos
- [ ] Git instalado
- [ ] Uma das opções escolhida (Devbox/Makefile/Docker)
- [ ] Internet (para downloads)

### Instalação (30 minutos)
- [ ] Devbox instalado (se usar Devbox)
- [ ] Google Gemini CLI instalado
- [ ] API Key do Google obtida
- [ ] Variável `GEMINI_API_KEY` configurada

### Verificação
- [ ] `make verify` executado com sucesso
- [ ] `make gemini-test` executado com sucesso
- [ ] `make clean-build` executado com sucesso
- [ ] `make test` executado com sucesso

### Pronto Para Desenvolvimento
- [ ] `make run` executado com sucesso
- [ ] Browser: http://localhost:8080 acessível
- [ ] Logs não mostram erros

---

## 🚀 Próximos Passos

1. **Escolha uma opção acima** (recomendado: Devbox)
2. **Execute o setup** (10-30 minutos)
3. **Leia a documentação apropriada**
4. **Obtenha API Key**: https://aistudio.google.com/app/apikey
5. **Configure variável**: `export GEMINI_API_KEY="..."`
6. **Comece a desenvolver!**

---

## 🆘 Problema?

1. Execute: `make verify`
2. Leia [README.md - Troubleshooting](README.md#-troubleshooting)
3. Procure pela abordagem escolhida (Devbox/Makefile/Docker)

---

## 📞 Recursos

- [Google Gemini API](https://ai.google.dev/)
- [Devbox](https://www.jetify.com/devbox)
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Maven](https://maven.apache.org/)
- [Docker](https://docs.docker.com/)

---

**Última atualização**: Fevereiro 2026

**Status**: ✅ Pronto para usar!

---

> 💡 **Dica**: Execute `make help` para ver todos os comandos disponíveis


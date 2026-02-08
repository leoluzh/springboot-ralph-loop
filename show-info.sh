#!/usr/bin/env bash

# ============================================================
# 🚀 RALPH LOOP PATTERN - QUICK REFERENCE
# ============================================================

cat << "EOF"

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🎯 RALPH LOOP PATTERN - SPRING BOOT + GOOGLE GEMINI      ║
║                                                              ║
║     Seu ambiente de desenvolvimento está pronto! 🚀          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝


📚 DOCUMENTAÇÃO PRINCIPAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  👉 START-HERE.md              ← Comece aqui!
  📖 README.md                  ← Documentação completa
  🚀 QUICKSTART.md              ← Guia rápido (5 min)
  📚 DOCUMENTATION.md           ← Índice de documentos


⚡ 3 FORMAS DE COMEÇAR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1️⃣  DEVBOX (Recomendado)
  ──────────────────────────────────────────────────────────
  curl -fsSL https://get.jetify.com/devbox | bash
  devbox shell
  make quickstart

  📖 Veja: DEVBOX-GUIDE.md

  ──────────────────────────────────────────────────────────

  2️⃣  MAKEFILE
  ──────────────────────────────────────────────────────────
  make install-gemini-windows    # ou make install-gemini-linux
  make clean-build && make test && make run

  📖 Veja: MAKEFILE-REFERENCE.md

  ──────────────────────────────────────────────────────────

  3️⃣  DOCKER
  ──────────────────────────────────────────────────────────
  make docker-up
  make docker-logs
  make docker-down

  📖 Veja: README.md


🔨 COMANDOS MAIS USADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  make help           Ver todos os comandos
  make quickstart     Ver guia rápido
  make verify         Verificar instalações
  make build          Compilar projeto
  make test           Executar testes
  make run            Executar aplicação
  make gemini-test    Testar Google Gemini


🔑 CONFIGURAÇÃO NECESSÁRIA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Obtenha API Key em: https://aistudio.google.com/app/apikey

  2. Configure em seu sistema:

     Windows (PowerShell):
     $env:GEMINI_API_KEY = "sua-api-key-aqui"

     Linux/macOS (Bash):
     export GEMINI_API_KEY="sua-api-key-aqui"

  3. Ou copie .env.example para .env.local


📋 CHECKLIST RÁPIDO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ☐ Git instalado
  ☐ Escolheu uma abordagem (Devbox/Makefile/Docker)
  ☐ Gemini CLI instalado
  ☐ API Key obtida
  ☐ GEMINI_API_KEY configurado
  ☐ make verify passou
  ☐ make build passou
  ☐ make test passou
  ☐ make run passou


🌐 LINKS ÚTEIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  🔗 Devbox:              https://www.jetify.com/devbox
  🔗 Google Gemini:       https://ai.google.dev/
  🔗 Google AI Studio:    https://aistudio.google.com/
  🔗 Spring Boot:         https://spring.io/projects/spring-boot
  🔗 Maven:               https://maven.apache.org/
  🔗 Docker:              https://docs.docker.com/


🎯 PRÓXIMOS PASSOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. Leia START-HERE.md ou QUICKSTART.md
  2. Escolha uma abordagem (Devbox recomendado)
  3. Execute o setup (10-30 minutos)
  4. Obtenha API Key
  5. Comece a desenvolver!


🚀 DESENVOLVIMENTO COM RALPH LOOP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  R - Reasoning      → Analisa o problema
  A - Analysis       → Avalia resultados
  L - Learning       → Incorpora lições
  F - Feedback       → Ajusta estratégia

  Use Google Gemini para implementar esse padrão!


📧 SUPORTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ❓ Problema?

  1. Execute: make verify
  2. Leia o Troubleshooting do seu guia
  3. Consulte DOCUMENTATION.md para encontrar informações


═══════════════════════════════════════════════════════════════

  ✨ Bom desenvolvimento! Happy coding! 🚀

═══════════════════════════════════════════════════════════════

EOF

echo ""
echo "💡 Dica: Execute 'make help' para ver todos os comandos"
echo ""


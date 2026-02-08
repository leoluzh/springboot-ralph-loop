# 📚 Documentação do Projeto - Índice

Este arquivo serve como um índice de toda a documentação do projeto Ralph Loop Pattern com Google Gemini CLI.

## 🎯 Início Rápido

**👉 Comece aqui:** [QUICKSTART.md](QUICKSTART.md)

Um guia rápido com 3 opções para começar em minutos:
- ⚡ **Devbox** (Recomendado)
- ⚡ **Makefile + Scripts**
- ⚡ **Docker Compose**

---

## 📖 Documentação Completa

### 1. **[README.md](README.md)** - Documentação Principal
   - Sobre o padrão Ralph Loop
   - Pré-requisitos do projeto
   - Instalação do Google Gemini CLI
   - Estrutura do projeto
   - Principais dependências
   - Troubleshooting

### 2. **[DEVBOX-GUIDE.md](DEVBOX-GUIDE.md)** - Guia Completo do Devbox
   - O que é Devbox
   - Instalação do Devbox
   - Como usar o Devbox
   - Variáveis de ambiente
   - Scripts personalizados
   - Troubleshooting específico do Devbox
   - Boas práticas

### 3. **[MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md)** - Referência do Makefile
   - Todos os comandos do Makefile
   - Exemplos de uso
   - Fluxos de desenvolvimento
   - Atalhos úteis
   - Notas importantes

### 4. **[scripts/README-SCRIPTS.md](scripts/README-SCRIPTS.md)** - Guia dos Scripts de Instalação
   - Como usar os scripts
   - Instalação no Windows
   - Instalação no Linux/macOS
   - Verificação de instalação
   - Troubleshooting dos scripts

---

## 🛠️ Arquivos de Configuração

### **Makefile**
Automação de tarefas do projeto. Execute:
```bash
make help        # Ver todos os comandos
make quickstart  # Ver guia rápido
```

### **devbox.json**
Configuração do ambiente Devbox com:
- Java Development Kit
- Apache Maven
- Python 3.11
- Docker
- Git

Use com:
```bash
devbox shell
```

### **compose.yaml**
Configuração do Docker Compose para serviços (PostgreSQL, etc.)

### **pom.xml**
Configuração Maven do projeto Spring Boot

---

## 📁 Scripts de Instalação

### **scripts/install-gemini-windows.ps1**
Script PowerShell para instalar Google Gemini CLI no Windows
```powershell
.\scripts\install-gemini-windows.ps1
```

### **scripts/install-gemini-linux.sh**
Script Bash para instalar Google Gemini CLI no Linux/macOS
```bash
chmod +x scripts/install-gemini-linux.sh
./scripts/install-gemini-linux.sh
```

---

## 🎯 Fluxos de Desenvolvimento

### Fluxo 1: Com Devbox (Recomendado)
```bash
devbox shell
make install-gemini-linux
make clean-build && make test && make run
exit
```

### Fluxo 2: Com Makefile
```bash
make install-gemini-windows    # ou make install-gemini-linux
make clean-build
make test
make run
```

### Fluxo 3: Com Docker
```bash
make docker-rebuild
make docker-up
make docker-logs
make docker-down
```

---

## 🔍 Procurando por...?

### Quero instalar o Google Gemini CLI
→ [QUICKSTART.md - Opção 1, 2 ou 3](QUICKSTART.md)
→ [scripts/README-SCRIPTS.md](scripts/README-SCRIPTS.md)
→ [README.md - Google Gemini CLI](README.md#-google-gemini-cli---instalação)

### Quero usar Devbox
→ [DEVBOX-GUIDE.md](DEVBOX-GUIDE.md)
→ [devbox.json](devbox.json)

### Quero conhecer todos os comandos do Makefile
→ [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md)
→ Ou execute: `make help`

### Tenho um problema de instalação
→ [README.md - Troubleshooting](README.md#-troubleshooting)
→ [scripts/README-SCRIPTS.md - Troubleshooting](scripts/README-SCRIPTS.md#-troubleshooting)
→ [DEVBOX-GUIDE.md - Troubleshooting](DEVBOX-GUIDE.md#-troubleshooting)

### Quero compilar e executar o projeto
→ [QUICKSTART.md](QUICKSTART.md)
→ [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md)
→ [README.md - Compilação e Execução](README.md#-compilação-e-execução)

### Quero entender o padrão Ralph Loop
→ [README.md - Sobre Ralph Loop](README.md#-sobre-ralph-loop)

---

## 📊 Mapa de Documentação

```
springboot-ralph-loop/
│
├── 📖 README.md                    ← Documentação principal
├── 🚀 QUICKSTART.md                ← Guia rápido (COMECE AQUI!)
├── 📚 DOCUMENTATION.md             ← Este arquivo
│
├── ⚙️ devbox.json                  ← Configuração Devbox
├── 📗 DEVBOX-GUIDE.md              ← Guia completo do Devbox
│
├── 🔨 Makefile                     ← Automação de tarefas
├── 📘 MAKEFILE-REFERENCE.md        ← Referência dos comandos
│
├── 📂 scripts/
│   ├── install-gemini-windows.ps1  ← Instalador Windows
│   ├── install-gemini-linux.sh     ← Instalador Linux/macOS
│   └── 📙 README-SCRIPTS.md        ← Guia dos scripts
│
└── (outros arquivos do projeto)
```

---

## 🎓 Fluxo de Aprendizado Recomendado

1. **Leia** [QUICKSTART.md](QUICKSTART.md) - Comece em 5 minutos
2. **Escolha** um dos 3 fluxos:
   - Devbox → Leia [DEVBOX-GUIDE.md](DEVBOX-GUIDE.md)
   - Makefile → Leia [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md)
   - Docker → Use `make docker-up`
3. **Execute** os comandos do seu fluxo escolhido
4. **Refira-se** aos guias específicos conforme necessário
5. **Integre** Google Gemini CLI no seu código
6. **Implemente** o padrão Ralph Loop

---

## 🚀 Comandos Mais Usados

```bash
# Primeiro uso (escolha um)
devbox shell                          # Opção 1: Devbox
make install-gemini-linux             # Opção 2: Makefile
make docker-rebuild                   # Opção 3: Docker

# Desenvolvimento
make clean-build                       # Compilar
make test                             # Testar
make run                              # Executar

# Utilitários
make help                             # Ver ajuda
make quickstart                       # Ver guia rápido
make verify                           # Verificar instalações
make gemini-test                      # Testar Gemini
```

---

## 📞 Suporte

Se encontrar problemas:

1. **Verifique** a seção de Troubleshooting do guia relevante
2. **Execute** `make verify` para diagnosticar
3. **Consulte** [README.md - Troubleshooting](README.md#-troubleshooting)
4. **Procure** na documentação específica da sua abordagem

---

## 🤝 Contribuindo

Melhorias são bem-vindas! Se encontrar erros na documentação ou tiver sugestões:

1. Faça suas alterações
2. Teste os comandos descritos
3. Atualize a documentação
4. Faça um commit com descrição clara

---

## 📝 Histórico de Versão

| Versão | Data | Alterações |
|--------|------|-----------|
| 1.0 | Fevereiro 2026 | Versão inicial com Devbox, Makefile e scripts |

---

**Última atualização**: Fevereiro 2026

**Próximos passos**: Execute `make quickstart` para começar! 🚀


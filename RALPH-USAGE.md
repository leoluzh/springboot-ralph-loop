# Ralph Loop - Guia de Uso

Ralph é um sistema de desenvolvimento iterativo assistido por IA que automatiza a implementação de requisitos de produto de forma incremental. Este documento descreve como usar os scripts ralph para executar ciclos de desenvolvimento.

## 📋 Visão Geral

Ralph lê seus requisitos no arquivo `PRD.md`, implementa uma tarefa por iteração, executa testes e rastreia progresso em `progress.txt`. Existem versões para diferentes ambientes e ferramentas de IA.

## 🚀 Início Rápido

### Prerequisitos

Você precisa ter uma das seguintes ferramentas de IA instaladas:
- **Google Gemini CLI** (recomendado)
- **Claude CLI** (alternativa)

Para instalar o Gemini CLI:

**Linux/macOS:**
```bash
./scripts/install-gemini-linux.sh
```

**Windows:**
```powershell
.\scripts\install-gemini-windows.ps1
```

### Uso Básico

#### 1. Com Gemini CLI

**Linux/macOS:**
```bash
chmod +x ralph-gemini.sh
./ralph-gemini.sh 5
```

**Windows PowerShell:**
```powershell
.\ralph-gemini.ps1 -Iterations 5
```

#### 2. Com Claude CLI

```bash
chmod +x ralph.sh
./ralph.sh 5
```

#### 3. Com Aprovação e Controle

```bash
./ralph.sh 5 --approval-mode yolo
```

## 🎛️ Modos de Aprovação

O script ralph suporta diferentes modos de aprovação para controlar como as mudanças são aplicadas:

### Modo: `yolo` (padrão)
```bash
./ralph.sh 10 --approval-mode yolo
```
- **Comportamento**: Todas as ferramentas são auto-aprovadas
- **Melhor para**: Desenvolvimento rápido e experimental
- **Risco**: Mudanças podem ser aplicadas sem revisão

### Modo: `auto_edit`
```bash
./ralph.sh 10 --approval-mode auto_edit
```
- **Comportamento**: Apenas ferramentas de edição são auto-aprovadas
- **Melhor para**: Equilíbrio entre produtividade e segurança
- **Risco**: Mínimo - análises e buscas requerem aprovação

### Modo: `default`
```bash
./ralph.sh 10 --approval-mode default
```
- **Comportamento**: Todas as ações requerem aprovação manual
- **Melhor para**: Desenvolvimento cuidadoso e aprendizado
- **Risco**: Processo mais lento mas controlado

### Modo: `plan`
```bash
./ralph.sh 10 --approval-mode plan
```
- **Comportamento**: Modo somente leitura, sem execução de ferramentas
- **Melhor para**: Planejamento e análise sem ação
- **Risco**: Nenhum - nenhuma mudança é feita

## 📁 Arquivos de Contexto Necessários

Ralph requer os seguintes arquivos no diretório raiz do projeto:

### 1. **PRD.md** (Product Requirements Document)
Contém as tarefas que devem ser implementadas.

Exemplo:
```markdown
# Product Requirements

## Tasks

- [ ] Implementar endpoint GET /api/users
- [ ] Adicionar testes para UserController
- [ ] Documentar API REST
- [x] Configurar banco de dados (completado)
```

**Importante**: Use `[ ]` para tarefas incompletas e `[x]` para tarefas completas.

### 2. **progress.txt** (Histórico de Progresso)
Registra o que foi implementado em cada iteração.

Exemplo:
```
=== Iteration 1 ===
Task: Implementar endpoint GET /api/users
Status: COMPLETED
Changes: Created UserController.java with GET endpoint
Tests: UserControllerTest.java - 4 tests passing
Commit: feat: add GET /api/users endpoint

=== Iteration 2 ===
Task: Adicionar testes para UserController
Status: COMPLETED
Changes: Enhanced UserControllerTest.java
Tests: 8 tests passing
Commit: test: improve user controller test coverage
```

### 3. **CLAUDE.md** (Guidelines e Contexto)
Define diretrizes, padrões e contexto do projeto.

Exemplo:
```markdown
# Project Guidelines

## Technology Stack
- Java 17
- Spring Boot 3.x
- Maven
- JUnit 5
- PostgreSQL

## Code Standards
- Follow Google Java Style Guide
- Use Lombok for boilerplate reduction
- Add JavaDoc for public APIs

## Testing Requirements
- Minimum 80% code coverage
- Unit tests for all business logic
- Integration tests for APIs
```

## 🔄 Fluxo de Execução

Cada iteração do Ralph segue este fluxo:

```
┌─────────────────────────────────────────┐
│ 1. Ler PRD.md e progress.txt             │
└─────────────────┬───────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│ 2. Encontrar tarefa de maior prioridade  │
│    (primeira [ ] não concluída)          │
└─────────────────┬───────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│ 3. Implementar a tarefa                  │
│    (editar código, adicionar arquivos)   │
└─────────────────┬───────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│ 4. Escrever testes unitários             │
│    (quando houver lógica)                │
└─────────────────┬───────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│ 5. Executar compilação e testes          │
│    ./mvnw compile && ./mvnw test         │
└─────────────────┬───────────────────────┘
                  ↓
        ┌─────────┴─────────┐
        │                   │
    ✅ PASSA            ❌ FALHA
        │                   │
        ↓                   ↓
┌──────────────┐  ┌────────────────────┐
│ 6. Git commit│  │ Corrigir erros e   │
│ com msg      │  │ tentar novamente   │
│ convencional │  │                    │
└──────┬───────┘  └────────────────────┘
       ↓
┌─────────────────────────────────────────┐
│ 7. Marcar tarefa como completa [x]      │
│    em PRD.md                            │
└─────────────────┬───────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│ 8. Atualizar progress.txt                │
│    com resultado da iteração             │
└─────────────────┬───────────────────────┘
                  ↓
        ┌─────────┴────────────┐
        │                      │
   Todas        Não todas
   completas    completas
        │                      │
        ↓                      ↓
    ✅ EXIT           Próxima Iteração
       OK              (volta ao passo 1)
```

## 💡 Exemplos de Uso

### Exemplo 1: Executar 5 iterações com Gemini (rápido)
```bash
./ralph-gemini.sh 5
```
Perfeito para começar um novo projeto ou completar um ciclo pequeno.

### Exemplo 2: Desenvolvimento controlado com aprovação
```bash
./ralph.sh 20 --approval-mode auto_edit
```
Aprova apenas edições automáticas, requerendo revisão de análises e buscas.

### Exemplo 3: Planejamento sem ação
```bash
./ralph.sh 5 --approval-mode plan
```
Analisa o próximo passo sem executar nada - bom para revisão.

### Exemplo 4: Desenvolvimento passo a passo
```bash
./ralph.sh 1 --approval-mode default
```
Executa uma iteração com aprovação manual para cada ação.

## 📊 Interpretando a Saída

A saída de Ralph mostra:

```
****************************************
Iteration 1 of 5 (mode: yolo)
****************************************

[Aqui você verá a saída da IA mostrando:]
- Qual tarefa foi selecionada
- Quais arquivos foram modificados
- Resultados dos testes
- Mensagem de commit
- Status de conclusão
```

Se você vir:
```
✅ PRD complete after 3 iterations!
```
Significa que todas as tarefas foram completadas com sucesso!

Se você vir:
```
⚠️  Reached maximum iterations (5) without completing all tasks.
```
Significa que há mais tarefas a fazer. Execute novamente com mais iterações:
```bash
./ralph.sh 10 --approval-mode yolo
```

## 🛠️ Troubleshooting

### Erro: "gemini CLI is not installed"
```bash
# Instale o Gemini CLI
./scripts/install-gemini-linux.sh    # Linux/macOS
.\scripts\install-gemini-windows.ps1 # Windows
```

### Erro: "PRD.md not found"
Crie um arquivo `PRD.md` no diretório raiz com suas tarefas:
```markdown
# Product Requirements

## Tasks

- [ ] Tarefa 1
- [ ] Tarefa 2
```

### Erro: Testes falhando
Ralph tentará corrigir automaticamente. Se persistir:
1. Examine a saída de erro
2. Revise CLAUDE.md para diretrizes
3. Execute manualmente: `./mvnw test` para detalhes

### Iterações tomando muito tempo
Use `--approval-mode plan` para revisar o que será feito antes de executar:
```bash
./ralph.sh 1 --approval-mode plan
```

## 🎯 Boas Práticas

### 1. Comece com PRD bem estruturado
```markdown
- [ ] Implementar validação de email
- [ ] Adicionar testes
- [ ] Documentar endpoint
```

### 2. Mantenha CLAUDE.md atualizado
Inclua padrões de código, tecnologias e requisitos específicos do projeto.

### 3. Use modes apropriados
- Desenvolvimento rápido: `yolo`
- Com revisão: `auto_edit`
- Cuidadoso: `default`
- Planejamento: `plan`

### 4. Comece pequeno
```bash
# Primeira execução
./ralph.sh 3 --approval-mode plan

# Revise o resultado
./ralph.sh 5 --approval-mode yolo
```

### 5. Monitore o progresso.txt
Verifique regularmente o histórico para validar qualidade.

## 🔐 Segurança

- **Modo `plan`**: Use para revisar mudanças propostas sem risco
- **Modo `auto_edit`**: Balanceado entre produtividade e segurança
- **Modo `default`**: Máxima segurança, requer aprovação manual
- **Modo `yolo`**: Apenas em ambientes de desenvolvimento pessoal

Sempre revise o arquivo `PRD.md` e `progress.txt` após cada execução!

## 📚 Referências

- [CLAUDE.md](./CLAUDE.md) - Diretrizes do projeto
- [PRD.md](./PRD.md) - Requisitos do produto
- [progress.txt](./progress.txt) - Histórico de progresso
- [QUICKSTART.md](./QUICKSTART.md) - Início rápido do projeto

## 🤝 Suporte

Para mais informações sobre o projeto, consulte:
- [README.md](./README.md) - Visão geral do projeto
- [DOCUMENTATION.md](./DOCUMENTATION.md) - Documentação completa
- [PROJECT-SETUP.md](./PROJECT-SETUP.md) - Configuração do ambiente


# Ralph Loop Pattern - Spring Boot

Implementação de um projeto Spring Boot utilizando o padrão **Ralph Loop** para desenvolvimento iterativo e adaptativo de funcionalidades com inteligência artificial.

## 📋 Sobre Ralph Loop

O **Ralph Loop** é um padrão de desenvolvimento inovador que implementa um ciclo contínuo de **Reasoning** (Raciocínio), **Analysis** (Análise), **Learning** (Aprendizado) e **Feedback** (Feedback). Este padrão permite que sistemas de IA trabalhem de forma mais eficaz ao:

1. **Reasoning (R)**: Analisa o problema e planeja a solução
2. **Analysis (A)**: Avalia resultados e identifica pontos de melhoria
3. **Learning (L)**: Incorpora lições aprendidas ao processo
4. **Feedback (F)**: Ajusta a estratégia baseado em feedback

Este projeto integra o padrão Ralph Loop com **Google Gemini CLI** para automação inteligente.

## 🚀 Pré-requisitos

Antes de começar, você precisará ter instalado:

- **Java 25+**
- **Apache Maven 3.6+**
- **Docker e Docker Compose** (para execução dos serviços)
- **Python 3.8+** (para Google Gemini CLI)
- **Google Gemini CLI**

## 📦 Google Gemini CLI - Instalação

O **Google Gemini CLI** é uma ferramenta de linha de comando para interagir com o Google Gemini. Veja: https://geminicli.com/docs/

### 1. Pré-requisitos

- Linux ou macOS
- curl instalado
- Acesso à internet

### 2. Instalação do Google Gemini CLI

#### Opção 1: Via Script Automático (Recomendado)

```bash
# Dentro do Devbox shell ou seu ambiente
make install-gemini-linux
```

Ou manualmente:
```bash
bash scripts/install-gemini-linux.sh
```

#### Opção 2: Instalação Manual

O script automático faz o download da versão mais recente de:
```
https://github.com/google/geminicli/releases
```

Se preferir fazer manualmente:
1. Acesse https://geminicli.com/docs/install
2. Baixe o binário para sua arquitetura (Linux x86_64, Linux ARM64, macOS, etc)
3. Extraia: `tar -xzf gemini_*.tar.gz`
4. Instale: `sudo mv gemini /usr/local/bin/`
5. Verifique: `gemini --version`

### 3. Configuração de API Key

```bash
# Exportar API Key (temporário para sessão atual)
export GEMINI_API_KEY='sua-api-key-aqui'

# Ou configurar permanentemente em ~/.bashrc ou ~/.zshrc
echo 'export GEMINI_API_KEY="sua-api-key-aqui"' >> ~/.bashrc
source ~/.bashrc
```

Obtenha sua API Key em: [Google AI Studio](https://aistudio.google.com/app/apikey)

### 4. Verificar Instalação

```bash
gemini --version
gemini --help
```

### 5. Usar o Google Gemini CLI

```bash
# Prompt simples
gemini "Olá, quem é você?"

# Com instruções
gemini "Explique o padrão Ralph Loop em 3 linhas"

# Ver ajuda
gemini --help
```

**Documentação oficial**: https://geminicli.com/docs/

## 🖥️ Ambientes de Desenvolvimento Recomendados

### Opção 1: Devbox (Mais Fácil e Reproduzível)

Use Devbox para um ambiente completamente isolado e reproduzível:

```bash
# Instalar Devbox
curl -fsSL https://get.jetify.com/devbox | bash

# Ativar o ambiente
devbox shell

# Executar comandos
make build && make test && make run
```

**Vantagens:**
- ✅ Ambiente completamente isolado
- ✅ Reproduzível entre máquinas
- ✅ Sem poluição do sistema
- ✅ Fácil compartilhamento com o time

Veja [DEVBOX-GUIDE.md](DEVBOX-GUIDE.md) para mais detalhes.

### Opção 2: Makefile + Scripts Instaladores

Use Makefile combinado com os scripts de instalação:

```bash
# Instalar Google Gemini CLI
make install-gemini-windows    # ou make install-gemini-linux

# Compilar e executar
make clean-build && make test && make run
```

**Vantagens:**
- ✅ Mais simples
- ✅ Ferramentas instaladas globalmente
- ✅ Melhor integração com IDE

Veja [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md) para mais detalhes.

### Opção 3: Docker Compose

Use Docker Compose para containerizar toda a aplicação:

```bash
# Iniciar serviços
make docker-up

# Ou direto
docker-compose up
```

## 🏗️ Estrutura do Projeto

```
springboot-ralph-loop/
├── scripts/
│   ├── install-gemini-windows.ps1      # Script de instalação Windows
│   ├── install-gemini-linux.sh         # Script de instalação Linux/macOS
│   └── README-SCRIPTS.md                # Documentação dos scripts
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/lambdasys/ai/springbootralphloop/
│   │   │       └── SpringbootRalphLoopApplication.java
│   │   └── resources/
│   │       └── application.yaml
│   └── test/
│       └── java/
│           └── com/lambdasys/ai/springbootralphloop/
│               ├── SpringbootRalphLoopApplicationTests.java
│               ├── TestSpringbootRalphLoopApplication.java
│               └── TestcontainersConfiguration.java
├── Makefile                     # Comandos de automação
├── MAKEFILE-REFERENCE.md        # Referência rápida do Makefile
├── devbox.json                  # Configuração do Devbox (ambiente reproduzível)
├── DEVBOX-GUIDE.md              # Guia de uso do Devbox
├── pom.xml
├── compose.yaml
└── README.md
```

## 🛠️ Compilação e Execução

### Usando Devbox (Recomendado para Ambiente Reproduzível)

[Devbox](https://www.jetify.com/devbox) fornece um ambiente de desenvolvimento isolado e reproduzível:

```bash
# 1. Instalar Devbox (uma única vez)
curl -fsSL https://get.jetify.com/devbox | bash

# 2. Entrar no ambiente
devbox shell

# 3. Executar comandos dentro do devbox
make help
make install-gemini-linux
make clean-build
make test
make run

# 4. Sair
exit
```

Veja [DEVBOX-GUIDE.md](DEVBOX-GUIDE.md) para documentação completa sobre Devbox.

### Usando Makefile (Recomendado)

```bash
# Ver todos os comandos disponíveis
make help

# Instalar Google Gemini CLI
make install-gemini-windows    # Windows
make install-gemini-linux      # Linux/macOS

# Compilar o projeto
make build

# Executar testes
make test

# Executar a aplicação
make run

# Com Docker Compose
make run-docker
```

### Compilar o Projeto Manualmente

```bash
# Windows
mvnw.cmd clean package

# macOS/Linux
./mvnw clean package
```

### Executar a Aplicação Manualmente

```bash
# Windows
mvnw.cmd spring-boot:run

# macOS/Linux
./mvnw spring-boot:run
```

### Executar com Docker Compose

```bash
docker-compose up
```

Para mais informações sobre os comandos do Makefile, veja [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md).

## 🧪 Testes

Executar os testes unitários:

```bash
# Windows
mvnw.cmd test

# macOS/Linux
./mvnw test
```

## 📚 Principais Dependências

- **Spring Boot 4.0.2** - Framework web
- **Spring Data JPA** - Persistência de dados
- **Spring Security** - Autenticação e autorização
- **Spring HATEOAS** - REST hypermedia
- **PostgreSQL** - Banco de dados
- **Testcontainers** - Testes com containers

Veja `pom.xml` para a lista completa de dependências.

## 🔗 Integrando Ralph Loop com Google Gemini CLI

### Exemplo Básico

```bash
# Usar Gemini CLI para analisar código
gemini analyze --file src/main/java/com/lambdasys/ai/springbootralphloop/

# Gerar código com base em descrição
gemini generate --prompt "Criar um serviço que implementa o padrão Ralph Loop"

# Chat interativo
gemini chat --context "Ralph Loop Pattern"
```

### Integrando com Spring Boot

Crie um serviço que chame o Gemini CLI para análise e feedback:

```java
import java.io.IOException;

public class RalphLoopService {
    
    public String analyzeWithGemini(String codeSnippet) throws IOException {
        ProcessBuilder pb = new ProcessBuilder(
            "gemini", "analyze", 
            "--input", codeSnippet
        );
        Process process = pb.start();
        // Processar resultado...
        return "Analysis result";
    }
}
```

## 📖 Documentação Adicional

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [Google Gemini CLI Repository](https://github.com/google/generative-ai-python)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Ralph Loop Pattern Documentation](https://en.wikipedia.org/wiki/Reasoning_Learning_Analysis_Feedback)

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se livre para abrir issues e pull requests.

## 📄 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo LICENSE para detalhes.

## 👨‍💻 Autor

Desenvolvido com ❤️ utilizando o padrão Ralph Loop e Google Gemini.

## 🆘 Troubleshooting

### Erro: "gemini command not found"

Certifique-se de que:
1. O pip instalou o google-gemini-cli corretamente
2. O diretório de instalação do pip está no PATH
3. Reinstale: `pip uninstall google-gemini-cli && pip install google-gemini-cli`

### Erro de Autenticação

1. Verifique se as credenciais foram salvas: `gemini auth status`
2. Faça login novamente: `gemini auth login`
3. Ou use a API Key via variável de ambiente

### Erro de Conexão

1. Verifique sua conexão com a internet
2. Verifique se sua conta Google tem acesso ao Gemini API
3. Tente novamente com `--verbose` para mais detalhes

---

**Última atualização**: Fevereiro 2026


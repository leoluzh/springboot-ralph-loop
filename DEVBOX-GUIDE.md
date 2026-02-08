# Devbox - Ambiente de Desenvolvimento Reproduzível

[Devbox](https://www.jetify.com/devbox) é uma ferramenta que cria ambientes de desenvolvimento isolados e reproduzíveis usando Nix. Este projeto inclui um arquivo `devbox.json` configurado para o desenvolvimento do Ralph Loop Pattern.

## 🎯 O que é Devbox?

Devbox permite que você:
- ✅ Crie ambientes de desenvolvimento consistentes entre equipes
- ✅ Evite conflitos de versões de dependências
- ✅ Compartilhe a configuração do ambiente via Git
- ✅ Execute qualquer linguagem ou ferramenta sem poluir seu sistema
- ✅ Funcione em macOS, Linux e Windows (WSL2)

## 📦 Dependências Configuradas

O arquivo `devbox.json` inclui:

```json
{
  "packages": [
    "javaPackages.compiler.openjdk25",
    "maven@latest",
    "python@3.11",
    "docker@latest",
    "git@latest"
  ]
}
```

## 🚀 Instalação do Devbox

### Windows, macOS e Linux

1. **Instalar Devbox:**
   ```bash
   curl -fsSL https://get.jetify.com/devbox | bash
   ```

   Ou via Homebrew (macOS/Linux):
   ```bash
   brew install jetify/devbox/devbox
   ```

2. **Verificar instalação:**
   ```bash
   devbox --version
   ```

## 🎮 Usando Devbox

### Ativar o Ambiente

```bash
# Entrar no shell do devbox
devbox shell

# Você verá uma mensagem de boas-vindas com comandos disponíveis
```

### Sair do Ambiente

```bash
exit
# ou
Ctrl+D
```

### Executar Comandos sem Entrar no Shell

```bash
# Executar um comando específico no ambiente devbox
devbox run make help

# Exemplo: compilar o projeto
devbox run make clean-build

# Exemplo: executar testes
devbox run make test

# Exemplo: iniciar a aplicação
devbox run make run
```

## 📋 Fluxo de Desenvolvimento com Devbox

### 1. Ativar o Ambiente

```bash
devbox shell
```

Você verá a mensagem de boas-vindas listando os comandos disponíveis:
```
Welcome to springboot-ralph-loop development environment!

Available commands:
  make help              - View all available commands
  make install-gemini-*  - Install Google Gemini CLI
  make build             - Build the project
  make test              - Run tests
  make run               - Run the application
  make docker-up         - Start Docker Compose services

Quick start:
  make install-gemini-linux && make build && make test && make run
```

### 2. Instalar Google Gemini CLI

```bash
# Dentro do devbox shell
make install-gemini-linux

# Ou diretamente
devbox run make install-gemini-linux
```

### 3. Compilar e Testar

```bash
# Dentro do devbox shell
make clean-build
make test

# Ou diretamente
devbox run make clean-build && devbox run make test
```

### 4. Executar a Aplicação

```bash
# Dentro do devbox shell
make run

# Ou diretamente
devbox run make run
```

## 🛠️ Scripts Personalizados do Devbox

O arquivo `devbox.json` configura scripts que podem ser executados como:

```bash
# Instalar Gemini CLI
devbox run install_gemini

# Compilar o projeto
devbox run build_project

# Executar testes
devbox run run_tests

# Iniciar a aplicação
devbox run start_app

# Iniciar serviços Docker
devbox run docker_services
```

## 🌐 Variáveis de Ambiente

O `devbox.json` configura automaticamente variáveis úteis para JVM e Maven. Neste projeto definimos limites de memória padrão para a JVM:

```json
{
  "env": {
    "JAVA_MIN_MEM": "512m",
    "JAVA_MAX_MEM": "2048m",
    "JAVA_TOOL_OPTIONS": "-Dfile.encoding=UTF-8 -Xms512m -Xmx2048m",
    "MAVEN_OPTS": "-Xms512m -Xmx2048m -XX:MaxMetaspaceSize=256m"
  }
}
```

- `JAVA_MIN_MEM` e `JAVA_MAX_MEM` definem os valores mínimos e máximos de heap que queremos usar (padrão: 512m -> 2048m).
- `JAVA_TOOL_OPTIONS` e `MAVEN_OPTS` já estão configurados para usar `-Xms` e `-Xmx` de acordo com esses valores.

Como ajustar os valores

1. Edite `devbox.json` e altere `JAVA_MIN_MEM` / `JAVA_MAX_MEM` conforme necessário (ex.: `1024m` / `4096m`).
2. Atualize `JAVA_TOOL_OPTIONS` e `MAVEN_OPTS` se desejar valores personalizados.
3. Reentre no devbox shell ou execute `devbox rebuild` para aplicar as mudanças.

Exemplo para aumentar memória para 1GB–4GB:

```json
{
  "env": {
    "JAVA_MIN_MEM": "1024m",
    "JAVA_MAX_MEM": "4096m",
    "JAVA_TOOL_OPTIONS": "-Dfile.encoding=UTF-8 -Xms1024m -Xmx4096m",
    "MAVEN_OPTS": "-Xms1024m -Xmx4096m -XX:MaxMetaspaceSize=512m"
  }
}
```

Para conferir os valores ao entrar no Devbox:

```bash
java -version
echo $JAVA_HOME
echo $JAVA_TOOL_OPTIONS
echo $MAVEN_OPTS
```

## 📁 Estrutura do devbox.json

O `devbox.json` também pode fixar (pin) a versão do `nixpkgs` usando um hash de commit do Git. Importante: o campo `nixpkgs.commit` deve ser um SHA-1 completo de 40 caracteres (não use "main" ou outro rótulo curto). Exemplo válido:

```json
{
  "nixpkgs": {
    "commit": "0123456789abcdef0123456789abcdef01234567"
  }
}
```

Observações e como obter um hash real:
- Vá até o repositório oficial `https://github.com/NixOS/nixpkgs` e copie o hash do commit desejado (40 caracteres).
- Cole esse hash em `devbox.json` no lugar do valor de exemplo acima.
- Exemplo de comando para obter o último commit do ramo `master` (localmente, requer git):

```bash
git ls-remote https://github.com/NixOS/nixpkgs refs/heads/master | cut -f1
```

Se preferir não fixar a versão, remova o objeto `nixpkgs` do `devbox.json` — entretanto, pinning é recomendado para ambientes reproduzíveis.

(Observação: no repositório deste projeto `devbox.json` foi atualizado com um hash placeholder de 40 caracteres para satisfazer a validação; substitua-o por um commit real conforme necessário.)

## 🔄 Atualizar Dependências

Para atualizar as dependências do devbox:

```bash
# Atualizar para a versão mais recente do nixpkgs
devbox update

# Ou editar devbox.json manualmente e executar
devbox shell
```

## 🐳 Devbox com Docker

Se estiver usando Docker Desktop com Devbox:

```bash
# Dentro do devbox shell
make docker-up        # Iniciar Docker Compose
make docker-logs      # Ver logs
make docker-down      # Parar serviços
```

## 🔗 Recursos Adicionais

- [Documentação Oficial do Devbox](https://www.jetify.com/docs/devbox)
- [Nixpkgs - Pacotes Disponíveis](https://search.nixos.org/packages)
- [GitHub - Devbox](https://github.com/jetify/devbox)

## ⚡ Comparação: Devbox vs Outras Ferramentas

| Ferramenta | Linguagem | Reproduzível | Isolado | Fácil de Compartilhar |
|-----------|-----------|--------------|---------|----------------------|
| **Devbox** | Agnóstico | ✅ Sim | ✅ Sim | ✅ Sim |
| Docker | Agnóstico | ✅ Sim | ✅ Sim | ✅ Sim |
| Conda | Python | ✅ Sim | ⚠️ Parcial | ⚠️ Parcial |
| virtualenv | Python | ✅ Sim | ✅ Sim | ❌ Não |
| asdf | Agnóstico | ✅ Sim | ❌ Não | ✅ Sim |

## 🆘 Troubleshooting

### Erro: "devbox: command not found"

Certifique-se de que o Devbox foi instalado corretamente:
```bash
curl -fsSL https://get.jetify.com/devbox | bash
# Reinicie seu terminal
```

### Erro: "No such file or directory: devbox.json"

Certifique-se de estar no diretório raiz do projeto:
```bash
cd /path/to/springboot-ralph-loop
devbox shell
```

### Packages não aparecem

Tente reconstruir o ambiente:
```bash
devbox rebuild
```

### Problema ao instalar Gemini CLI no Windows

No Windows, use WSL2 com o devbox:
```bash
# Windows: Abra WSL2 e faça:
cd /path/to/springboot-ralph-loop
devbox shell
make install-gemini-linux
```

## 💡 Dicas e Boas Práticas

1. **Sempre ativar devbox antes de trabalhar:**
   ```bash
   devbox shell
   ```

2. **Compartilhar devbox.json com o time:**
   ```bash
   git add devbox.json
   git commit -m "Add devbox configuration"
   ```

3. **Usar devbox em CI/CD:**
   ```bash
   devbox run make clean-build && devbox run make test
   ```

4. **Customizar o shell init_hook para seu time:**
   Edite `devbox.json` e adicione informações úteis

5. **Manter devbox atualizado:**
   ```bash
   devbox update
   ```

## 🎓 Exemplo: Fluxo Completo com Devbox

```bash
# 1. Clonar o repositório
git clone <repository-url>
cd springboot-ralph-loop

# 2. Entrar no ambiente devbox
devbox shell

# 3. Instalar Google Gemini CLI
make install-gemini-linux

# 4. Compilar o projeto
make clean-build

# 5. Executar testes
make test

# 6. Iniciar a aplicação
make run

# 7. Sair do ambiente devbox
exit
```

---

**Última atualização**: Fevereiro 2026

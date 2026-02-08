# Scripts de Instalação - Google Gemini CLI

Este diretório contém scripts automatizados para instalar o Google Gemini CLI em diferentes sistemas operacionais.

## 📋 Conteúdo

- **install-gemini-windows.ps1** - Script para Windows (PowerShell)
- **install-gemini-linux.sh** - Script para Linux/macOS (Bash)
- **README-SCRIPTS.md** - Este arquivo

## 🚀 Instalação Rápida

### Windows

#### Método 1: Usando PowerShell

```powershell
# 1. Abra o PowerShell como Administrador
# 2. Execute:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Navegue até o diretório do projeto
cd D:\ai-patterns\springboot-ralph-loop

# 4. Execute o script de instalação
.\scripts\install-gemini-windows.ps1
```

#### Método 2: Instalação Manual

```powershell
# Atualizar pip
python -m pip install --upgrade pip

# Instalar google-generativeai
pip install google-generativeai
```

### Linux / macOS

#### Método 1: Usando o Script Automatizado

```bash
# 1. Navegue até o diretório do projeto
cd /path/to/springboot-ralph-loop

# 2. Torne o script executável
chmod +x scripts/install-gemini-linux.sh

# 3. Execute o script
./scripts/install-gemini-linux.sh
```

#### Método 2: Instalação Manual

```bash
# Atualizar pip
python3 -m pip install --upgrade pip

# Instalar google-generativeai
pip3 install google-generativeai
```

## 🔑 Configuração de Credenciais

Depois de instalar, você precisa configurar sua API Key:

### Windows (PowerShell)

```powershell
# Definir variável de ambiente (temporária - para esta sessão)
$env:GEMINI_API_KEY = "sua-api-key-aqui"

# Para permanente, adicionar ao perfil do PowerShell:
# 1. Abra o Notepad e adicione a linha acima
# 2. Salve em: $PROFILE
# 3. Ou use:
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "sua-api-key-aqui", "User")
```

### Linux / macOS

```bash
# Definir variável de ambiente (temporária - para esta sessão)
export GEMINI_API_KEY="sua-api-key-aqui"

# Para permanente, adicionar ao arquivo de shell:
# ~/.bashrc (Linux/WSL) ou ~/.zshrc (macOS)
echo 'export GEMINI_API_KEY="sua-api-key-aqui"' >> ~/.bashrc
source ~/.bashrc
```

## 🔐 Obtendo sua API Key

1. Acesse: [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Faça login com sua conta Google
3. Clique em "Create API Key"
4. Copie a chave gerada
5. Configure em seu sistema seguindo os passos acima

## ✅ Verificando a Instalação

### Windows

```powershell
# Verificar versão do Python
python --version

# Verificar versão do google-generativeai
pip show google-generativeai

# Testar import
python -c "import google.generativeai as genai; print(f'Version: {genai.__version__}')"
```

### Linux / macOS

```bash
# Verificar versão do Python
python3 --version

# Verificar versão do google-generativeai
pip3 show google-generativeai

# Testar import
python3 -c "import google.generativeai as genai; print(f'Version: {genai.__version__}')"
```

## 🐛 Troubleshooting

### Erro: "Python não encontrado"

**Windows:**
- Reinstale Python de: https://www.python.org/downloads/
- Certifique-se de marcar "Add Python to PATH" durante a instalação

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install python3 python3-pip

# Fedora/RHEL
sudo dnf install python3 python3-pip
```

**macOS:**
```bash
brew install python3
```

### Erro: "pip command not found"

```powershell
# Windows
python -m pip install --upgrade pip

# Linux/macOS
python3 -m pip install --upgrade pip
```

### Erro: "Permission denied" (Linux/macOS)

```bash
# Torne o script executável
chmod +x scripts/install-gemini-linux.sh

# Se ainda houver problemas, use:
bash scripts/install-gemini-linux.sh
```

### Erro: "ExecutionPolicy" (Windows PowerShell)

```powershell
# Permita execução de scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Se isso não funcionar, use:
powershell -ExecutionPolicy Bypass -File .\scripts\install-gemini-windows.ps1
```

### Erro de Autenticação do Google

1. Verifique se sua API Key está correta
2. Confirme se tem acesso ao Gemini API
3. Teste a autenticação:

```python
import google.generativeai as genai
import os

api_key = os.environ.get('GEMINI_API_KEY')
genai.configure(api_key=api_key)

# Teste uma chamada simples
model = genai.GenerativeModel('gemini-pro')
response = model.generate_content("Hello!")
print(response.text)
```

## 📦 Dependências

O script de instalação irá instalar:

- **google-generativeai** - SDK Python para Google Gemini API
- **python-dotenv** (opcional) - Para gerenciar variáveis de ambiente

## 📚 Recursos Adicionais

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [Python SDK GitHub Repository](https://github.com/google/generative-ai-python)
- [Google AI Studio](https://aistudio.google.com/)

## 🤝 Suporte

Se encontrar problemas durante a instalação:

1. Verifique os requisitos mínimos (Python 3.8+)
2. Consulte a seção de Troubleshooting acima
3. Verifique a documentação oficial do Google AI
4. Abra uma issue no repositório do projeto

---

**Última atualização**: Fevereiro 2026


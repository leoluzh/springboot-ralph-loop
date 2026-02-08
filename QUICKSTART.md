# 🚀 Quick Start - Guia Rápido

Comece a desenvolver com o Ralph Loop Pattern em minutos!

## ⚡ Opção 1: Devbox (Recomendado)

A forma **mais fácil** e **mais reproduzível** de começar:

```bash
# 1. Instalar Devbox (primeira vez apenas)
curl -fsSL https://get.jetify.com/devbox | bash

# 2. Entrar no ambiente isolado
devbox shell

# 3. Instalar Google Gemini CLI
make install-gemini-linux

# 4. Compilar, testar e executar
make clean-build
make test
make run

# 5. Sair quando terminar
exit
```

**Pronto!** Seu ambiente está totalmente configurado e isolado.

📖 Leia [DEVBOX-GUIDE.md](DEVBOX-GUIDE.md) para mais detalhes.

---

## ⚡ Opção 2: Makefile + Scripts (Mais Simples)

Se preferir instalar globalmente:

```bash
# 1. Instalar Google Gemini CLI
make install-gemini-windows    # Windows
make install-gemini-linux      # Linux/macOS

# 2. Compilar, testar e executar
make clean-build
make test
make run
```

**Pronto!** A aplicação está rodando em http://localhost:8080

📖 Leia [MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md) para mais comandos.

---

## ⚡ Opção 3: Docker (Tudo Containerizado)

Se estiver usando Docker:

```bash
# 1. Compilar a imagem Docker
make docker-rebuild

# 2. Iniciar todos os serviços
make docker-up

# 3. Ver logs
make docker-logs

# 4. Parar quando terminar
make docker-down
```

---

## 📚 Documentação

- **[README.md](README.md)** - Documentação completa
- **[DEVBOX-GUIDE.md](DEVBOX-GUIDE.md)** - Guia completo do Devbox
- **[MAKEFILE-REFERENCE.md](MAKEFILE-REFERENCE.md)** - Referência do Makefile
- **[scripts/README-SCRIPTS.md](scripts/README-SCRIPTS.md)** - Guia dos scripts

---

## 🆘 Problemas?

### "Command not found" para make

- **Windows**: Use `make` via WSL2 ou instale `choco install make`
- **Linux**: Use `sudo apt-get install build-essential`
- **macOS**: Use `brew install make`

### "Python not found"

```bash
# Windows
python --version    # Instale de https://python.org

# Linux
sudo apt-get install python3

# macOS
brew install python3
```

### Mais problemas?

1. Verifique o [Troubleshooting do README](README.md#-troubleshooting)
2. Verifique o [Troubleshooting dos Scripts](scripts/README-SCRIPTS.md#-troubleshooting)
3. Verifique o [Troubleshooting do Devbox](DEVBOX-GUIDE.md#-troubleshooting)

---

## 🎯 Fluxo Recomendado de Desenvolvimento

1. **Começar**: Use Devbox ou Makefile para setup
2. **Desenvolver**: Faça suas alterações no código
3. **Testar**: Execute `make test`
4. **Compilar**: Execute `make build`
5. **Executar**: Execute `make run`
6. **Integrar com Gemini**: Use `make gemini-test` e integre no seu código

---

## 🔧 Primeiros Passos com Ralph Loop + Gemini

Depois que a aplicação estiver rodando:

1. **Acesse a aplicação**: http://localhost:8080

2. **Verifique Gemini está funcionando**:
   ```bash
   make gemini-test
   ```

3. **Crie um serviço que use Gemini** para implementar Ralph Loop:
   ```java
   // Exemplo: src/main/java/com/lambdasys/ai/springbootralphloop/RalphLoopService.java
   import com.google.generativeai.client.GenerativeAIClient;
   
   public class RalphLoopService {
       // Implementar o padrão Ralph Loop aqui
   }
   ```

4. **Integre no seu projeto** e use os comandos do Makefile para testar

---

## 📝 Próximos Passos

- [ ] Configurar API Key do Google Gemini
- [ ] Instalar Google Gemini CLI
- [ ] Compilar o projeto com sucesso
- [ ] Executar testes com sucesso
- [ ] Iniciar a aplicação
- [ ] Criar seu primeiro serviço com Ralph Loop
- [ ] Integrar com Gemini API

---

**Última atualização**: Fevereiro 2026

Boa sorte! 🚀


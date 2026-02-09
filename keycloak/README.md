# Configuração Keycloak - SpringBoot Ralph Loop

Este diretório contém os arquivos de configuração do Keycloak para o projeto SpringBoot Ralph Loop.

## Arquivos

### `realm-springboot-ralph.json`
Arquivo de configuração do realm (espaço de trabalho) do Keycloak. Contém:

- **Realm**: `springboot-ralph`
- **Usuários**:
  - `admin` / `admin_password` (com role de administrador)
  - `user` / `user_password` (com role de usuário comum)
  
- **Roles** (Papéis):
  - `admin` - Administrador
  - `user` - Usuário padrão
  - `developer` - Desenvolvedor
  - `viewer` - Apenas leitura
  
- **Clientes**:
  - `springboot-ralph-app` - Aplicação web (porta 8081)
    - Client ID: `springboot-ralph-app`
    - Client Secret: `springboot-ralph-secret-key-change-in-production`
    - Redirect URIs: `http://localhost:8081/*`
    
  - `springboot-ralph-cli` - Interface de linha de comando
    - Client ID: `springboot-ralph-cli`

### `init-keycloak.sh`
Script de inicialização para Linux/Mac que:
- Aguarda o Keycloak estar pronto
- Obtém token de administrador
- Importa o realm automaticamente
- Exibe informações de configuração

### `init-keycloak.ps1`
Script de inicialização para Windows (PowerShell) com as mesmas funcionalidades do script Bash.

## Como usar

### Opção 1: Docker Compose (Automático)

```bash
# Iniciar os serviços (MySQL + Keycloak)
docker-compose -f docker-compose.keycloak.yaml up -d

# Acompanhar logs
docker-compose -f docker-compose.keycloak.yaml logs -f keycloak

# Parar os serviços
docker-compose -f docker-compose.keycloak.yaml down
```

O realm será importado automaticamente na inicialização.

### Opção 2: Script de Inicialização (Após containers iniciarem)

**Linux/Mac:**
```bash
chmod +x keycloak/init-keycloak.sh
./keycloak/init-keycloak.sh
```

**Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\keycloak\init-keycloak.ps1
```

## Acessar o Keycloak

- **URL**: http://localhost:8080
- **Admin Console**: http://localhost:8080/admin
- **Realm Console**: http://localhost:8080/realms/springboot-ralph
- **Username**: `admin`
- **Password**: `admin_password`

## Configuração da Aplicação Spring Boot

Para integrar o Keycloak com a aplicação Spring Boot, adicione ao `application.yaml`:

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:8080/realms/springboot-ralph
          jwk-set-uri: http://localhost:8080/realms/springboot-ralph/protocol/openid-connect/certs
  
keycloak:
  realm: springboot-ralph
  auth-server-url: http://localhost:8080
  ssl-required: external
  resource: springboot-ralph-app
  credentials:
    secret: springboot-ralph-secret-key-change-in-production
```

## Alterações para Produção

### ⚠️ IMPORTANTE - Segurança

Antes de usar em produção, altere:

1. **Senhas de Admin**: Altere `admin_password` em `realm-springboot-ralph.json`
2. **Senhas de Banco de Dados**: Altere as senhas do MySQL
3. **Client Secret**: Altere `springboot-ralph-secret-key-change-in-production`
4. **KC_HOSTNAME_STRICT**: Altere para `true`
5. **KC_HTTP_ENABLED**: Altere para `false` e configure SSL/TLS

### Exemplo para produção

```yaml
environment:
  KEYCLOAK_ADMIN: seu-admin
  KEYCLOAK_ADMIN_PASSWORD: sua-senha-segura
  KC_HOSTNAME: seu-dominio.com
  KC_HOSTNAME_STRICT: "true"
  KC_HTTP_ENABLED: "false"
  KC_HTTPS_PORT: 443
  KC_PROXY: reencrypt
```

## Persistência de Dados

Os dados do MySQL são armazenados em um volume Docker nomeado `mysql_data`. Para remover permanentemente:

```bash
docker volume rm mysql_data
```

## Troubleshooting

### Keycloak não inicia
```bash
# Verificar logs
docker-compose -f docker-compose.keycloak.yaml logs keycloak

# Remover containers e volumes e começar novamente
docker-compose -f docker-compose.keycloak.yaml down -v
docker-compose -f docker-compose.keycloak.yaml up -d
```

### Porta 3306 já em uso
Altere a porta do MySQL no `docker-compose.keycloak.yaml`:
```yaml
ports:
  - "3307:3306"  # Mapear para porta diferente
```

### Realm não foi importado
Execute o script de inicialização manualmente:
```bash
# Linux/Mac
./keycloak/init-keycloak.sh

# Windows
.\keycloak\init-keycloak.ps1
```

## Recursos Adicionais

- [Documentação oficial Keycloak](https://www.keycloak.org/documentation)
- [Spring Boot Keycloak Adapter](https://www.keycloak.org/securing-apps/spring-boot-adapter)
- [OpenID Connect Spec](https://openid.net/connect/)

## Próximos Passos

1. ✅ Iniciar containers Docker
2. ✅ Verificar se Keycloak está acessível
3. ⬜ Configurar aplicação Spring Boot para usar Keycloak
4. ⬜ Testar fluxo de autenticação
5. ⬜ Personalizar realm conforme necessidades do projeto


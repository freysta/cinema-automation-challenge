# 🎬 Cinema App — Projeto de Automação de Testes (Challenge Final)

## 👨‍💻 Autor

Nome: Gabriel Lucena Ferreira
Idade: 20
Curso: Análise e Desenvolvimento de Sistemas — IFRO
Semestre: 4º Período
Cidade: Ji-Paraná

## 🌟 Visão Geral do Projeto

Este repositório contém a suíte de testes automatizados para a aplicação Cinema App, desenvolvida como parte do Challenge Final PB AWS & AI for QE.
O objetivo é garantir a qualidade da aplicação com uma suíte de testes full-stack (API + Frontend) utilizando Robot Framework, aplicando os padrões:

- Service Objects (API)
- Page Objects (Web)

## 🛠️ Tecnologias Utilizadas

| Componente             | Tecnologia                     | Uso                            |
| ---------------------- | ------------------------------ | ------------------------------ |
| Framework de Automação | Robot Framework                | Base da automação              |
| Testes API             | RequestsLibrary                | Chamadas HTTP e validações     |
| Testes Web             | SeleniumLibrary / Browser      | Automação UI & E2E             |
| Padrões Arquiteturais  | Service Objects / Page Objects | Organização e reuso            |
| Dados de Teste         | FakerLibrary                   | Geração de dados dinâmicos     |
| Gestão de Defeitos     | GitHub Issues                  | Controle de bugs               |
| CI/CD                  | GitHub Actions                 | Execução automática dos testes |

## 📐 Estrutura do Projeto

```
cinema-automation-challenge
├── docs/                             # Documentação e artefatos
├── robot/
│   ├── tests/                        # Test suites
│   │   ├── api/
│   │   ├── web/
│   │   └── e2e/
│   ├── resources/                    # Keywords reutilizáveis
│   │   ├── api/                      # Service Objects
│   │   └── web/                      # Page Objects
│   ├── data/                         # Massa de dados
│   └── requirements.txt              # Dependências
├── .github/workflows/                # CI/CD
│   └── run_tests.yml
└── README.md
```

- **Service Objects**: encapsulam requisições e validações de API
- **Page Objects**: isolam seletores e ações de páginas

## 🚀 Configuração e Execução

### Requisitos

- Python 3.x
- Pip
- Git
- Chrome/Firefox + WebDriver
- Node.js e MongoDB (para rodar a aplicação)

### Iniciar Aplicação (Obrigatório)

#### Backend

```bash
git clone cinema-challenge-back
npm install
npm start
# API em http://localhost:3000/api/v1
```

#### Frontend

```bash
git clone cinema-challenge-front
npm install
npm start
# Web em http://localhost:5173
```

### Instalar Automação

```bash
git clone https://github.com/freysta/cinema-automation-challenge.git
cd cinema-automation-challenge/robot

python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
rfbrowser init  # se usando BrowserLibrary
```

Verifique as URLs base em `robot/resources/api/main_api.robot`.

### Executar Testes

```bash
# Suite completa
robot -d results .

# Apenas API
robot -d results tests/api/

# Apenas Web
robot -d results tests/web/
```

## 📝 Planejamento e Abrangência

### Estratégia API-First

- 60 cenários cobrindo:
  - Autenticação (11 testes), Usuários (6 testes), Filmes (8 testes), Salas (8 testes), Sessões (7 testes), Reservas (12 testes)
  - Happy path, negativos, validações, concorrência, idempotência
  - Testes E2E híbridos com criação/limpeza de dados pela API (3 testes)
  - Testes Web (5 testes) para login e cadastro de filmes

## 📊 Resultados dos Testes

Resumo Geral

Testes de API

Total de Testes: 52

Aprovados: 36 (69.2%)

Falhados: 16 (30.8%)

Testes de Web

Total de Testes: 5

Aprovados: 5 (100%)

Falhados: 0 (0%)

Testes de E2E

Total de Testes: 3

Aprovados: 3 (100%)

Falhados: 0 (0%)

Detalhamento por Módulo

🔐 Autenticação (11/11)

ID Teste Status

AUTH001 Login Bem-Sucedido ✅ PASS

AUTH002 Login Com Senha Inválida ❌ FAIL

AUTH003 Login Com Usuário Inexistente ❌ FAIL

AUTH004 Tentar Registrar Usuario Com Email Existente ❌ FAIL

AUTH005 Tentar Registrar Usuario Com Email Invalido ❌ FAIL

AUTH006 Obter Perfil Do Usuario Logado ✅ PASS

AUTH007 Obter Perfil Sem Autenticacao ❌ FAIL

AUTH008 Obter Perfil Com Token Invalido ❌ FAIL

AUTH009 Atualizar Perfil Do Usuario ✅ PASS

AUTH010 Atualizar Perfil Sem Senha Atual ❌ FAIL

AUTH011 Atualizar Perfil Com Email Existente ❌ FAIL

🎬 Filmes (8/8)

ID Teste Status

MOV001 Cadastrar Filme Com Sucesso ✅ PASS

MOV002 Listar Filmes ✅ PASS

MOV003 Tentar Cadastrar Filme Sem Titulo ❌ FAIL

MOV004 Tentar Cadastrar Filme Com Duracao Invalida ❌ FAIL

MOV005 Tentar Cadastrar Filme Com Titulo Muito Longo ❌ FAIL

MOV006 Obter Filme Por ID ✅ PASS

MOV007 Atualizar Filme Por ID ✅ PASS

MOV008 Deletar Filme Por ID ✅ PASS

🎫 Reservas (13/13)

ID Teste Status

RES001 Comprar Ingresso Para Sessao Lotada ❌ FAIL

RES002 Tentar Compra Concorrente Para Ultimo Assento ❌ FAIL

RES003 Comprar Ingresso Com Multiplos Assentos ✅ PASS

RES004 Listar Reservas ✅ PASS

RES005 Obter Reserva Por ID ✅ PASS

RES006 Deletar Reserva Por ID ✅ PASS

RES007 Obter Minhas Reservas ✅ PASS

RES008 Obter Minhas Reservas Sem Autenticacao ❌ FAIL

RES009 Obter Minhas Reservas Com Usuario Sem Reservas ✅ PASS

RES010 Atualizar Status Da Reserva ✅ PASS

RES011 Atualizar Status Da Reserva Sem Permissao Admin ❌ FAIL

RES012 Atualizar Status Da Reserva Com Transicao Invalida ❌ FAIL

🎭 Sessões (7/7)

ID Teste Status

SES001 Listar Sessoes ✅ PASS

SES002 Obter Sessao Por ID ✅ PASS

SES003 Atualizar Sessao Por ID ✅ PASS

SES004 Deletar Sessao Por ID ✅ PASS

SES005 Resetar Assentos Da Sessao ✅ PASS

SES006 Resetar Assentos Sem Permissao Admin ❌ FAIL

SES007 Resetar Assentos De Sessao Inexistente ❌ FAIL

🏛️ Salas (8/8)

ID Teste Status

THE001 Cadastrar Teatro Com Token Admin ✅ PASS

THE002 Listar Teatros ✅ PASS

THE003 Tentar Cadastrar Teatro Com Token User ❌ FAIL

THE004 Tentar Cadastrar Teatro Sem Nome ❌ FAIL

THE005 Tentar Cadastrar Teatro Com Tipo Invalido ❌ FAIL

THE006 Obter Teatro Por ID ✅ PASS

THE007 Atualizar Teatro Por ID ✅ PASS

THE008 Deletar Teatro Por ID ✅ PASS

👥 Usuários (6/6)

ID Teste Status

USR001 Listar Usuarios ✅ PASS

USR002 Obter Usuario Por ID ✅ PASS

USR003 Atualizar Usuario Por ID ✅ PASS

USR004 Deletar Usuario Por ID ✅ PASS

USR005 Obter Usuario Por ID Comum Acessando Outro Usuario ❌ FAIL

USR006 Obter Usuario Por ID Comum Acessando Seus Proprios Dados ✅ PASS

🌐 Web (5/5 ✅)

ID Teste Status

WEB001 Login Web Bem-Sucedido ✅ PASS

WEB002 Login Web Com Senha Inválida ✅ PASS

WEB003 Login Web Com Usuário Inexistente ✅ PASS

WEB004 Cadastro Filme Admin ✅ PASS

WEB005 Verificar Filme Na Vitrine ✅ PASS

🔄 E2E (3/3 ✅)

ID Teste Status

E2E001 Fluxo Compra Ingresso E2E - Sessao Lotada ✅ PASS

E2E002 Fluxo Compra Ingresso E2E - Compra Bem Sucedida ✅ PASS

E2E003 Fluxo Compra Ingresso E2E - Concorrencia ✅ PASS

## 🐛 Bugs Identificados

🔴 Crítico

BUG-001: API não valida login com senha inválida

Teste: AUTH002

Severidade: Alta

Descrição: A API não está retornando erro adequado para tentativas de login com senha inválida

Comportamento Esperado: Retornar 401 Unauthorized com mensagem "Invalid email or password"

Comportamento Atual: Teste falhando, indicando que a validação não está funcionando

Impacto: Segurança comprometida - usuários podem tentar logins indefinidamente

BUG-002: API não valida login com usuário inexistente

Teste: AUTH003

Severidade: Alta

Descrição: A API não está retornando erro adequado para tentativas de login com email inexistente

Comportamento Esperado: Retornar 401 Unauthorized com mensagem "Invalid email or password"

Comportamento Atual: Teste falhando, indicando que a validação não está funcionando

Impacto: Segurança comprometida - vazamento de informações sobre existência de usuários

BUG-003: API permite registro com email duplicado

Teste: AUTH004

Severidade: Alta

Descrição: A API permite registrar usuários com emails já existentes

Comportamento Esperado: Retornar 400 Bad Request com mensagem "User already exists"

Comportamento Atual: Teste falhando, indicando que a validação de unicidade não está funcionando

Impacto: Dados inconsistentes e possível conflito de contas

BUG-004: API não valida formato de email no registro

Teste: AUTH005

Severidade: Média

Descrição: A API aceita emails com formato inválido durante o registro

Comportamento Esperado: Retornar 400 Bad Request com mensagem "Validation failed"

Comportamento Atual: Teste falhando, indicando que a validação de formato não está funcionando

Impacto: Dados inválidos no sistema

BUG-005: API não valida acesso ao perfil sem autenticação

Teste: AUTH007

Severidade: Alta

Descrição: A API permite acesso ao endpoint de perfil sem token de autenticação

Comportamento Esperado: Retornar 401 Unauthorized com mensagem "Not authorized, no token"

Comportamento Atual: Teste falhando, indicando que a autenticação obrigatória não está funcionando

Impacto: Exposição de dados sensíveis

BUG-006: API não valida token inválido no perfil

Teste: AUTH008

Severidade: Alta

Descrição: A API permite acesso ao endpoint de perfil com token inválido

Comportamento Esperado: Retornar 401 Unauthorized com mensagem "Not authorized, invalid token"

Comportamento Atual: Teste falhando, indicando que a validação de token não está funcionando

Impacto: Exposição de dados sensíveis

BUG-007: API não valida atualização de perfil sem senha atual

Teste: AUTH010

Severidade: Média

Descrição: A API permite atualizar senha sem fornecer a senha atual

Comportamento Esperado: Retornar 401 Unauthorized com mensagem "Current password is incorrect"

Comportamento Atual: Teste falhando, indicando que a validação de senha atual não está funcionando

Impacto: Segurança comprometida - alteração de senha sem verificação

BUG-008: API permite atualização de perfil com email existente

Teste: AUTH011

Severidade: Média

Descrição: A API permite atualizar o email do perfil para um email já usado por outro usuário

Comportamento Esperado: Retornar 409 Conflict com mensagem "Email already in use"

Comportamento Atual: Teste falhando, indicando que a validação de unicidade não está funcionando

Impacto: Dados inconsistentes e possível conflito de contas

🟡 Médio

BUG-009: API não valida cadastro de filme sem título

Teste: MOV003

Severidade: Média

Descrição: A API permite cadastrar filmes sem título obrigatório

Comportamento Esperado: Retornar 400 Bad Request

Comportamento Atual: Teste falhando, indicando que a validação de campo obrigatório não está funcionando

Impacto: Dados inconsistentes no catálogo de filmes

BUG-010: API não valida duração inválida de filme

Teste: MOV004

Severidade: Média

Descrição: A API aceita durações inválidas (negativas ou zero) para filmes

Comportamento Esperado: Retornar 400 Bad Request

Comportamento Atual: Teste falhando, indicando que a validação de duração não está funcionando

Impacto: Dados inconsistentes no catálogo de filmes

BUG-011: API não valida título muito longo de filme

Teste: MOV005

Severidade: Baixa

Descrição: A API aceita títulos de filmes com comprimento excessivo

Comportamento Esperado: Retornar 400 Bad Request

Comportamento Atual: Teste falhando, indicando que a validação de tamanho não está funcionando

Impacto: Possível problema de exibição na interface

BUG-012: API não valida compra de ingresso para sessão lotada

Teste: RES001

Severidade: Alta

Descrição: A API permite comprar ingressos para sessões que já estão lotadas

Comportamento Esperado: Retornar erro apropriado (400 ou 409)

Comportamento Atual: Teste falhando, indicando que a validação de disponibilidade não está funcionando

Impacto: Overbooking e conflitos de assentos

BUG-013: API não valida concorrência na compra de ingressos

Teste: RES002

Severidade: Alta

Descrição: A API permite que múltiplos usuários comprem o mesmo assento simultaneamente

Comportamento Esperado: Apenas um usuário deve conseguir comprar o último assento

Comportamento Atual: Teste falhando, indicando que não há controle de concorrência

Impacto: Overbooking e conflitos de assentos

BUG-014: API não valida acesso às reservas sem autenticação

Teste: RES008

Severidade: Alta

Descrição: A API permite acesso ao endpoint de reservas sem token de autenticação

Comportamento Esperado: Retornar 401 Unauthorized

Comportamento Atual: Teste falhando, indicando que a autenticação obrigatória não está funcionando

Impacto: Exposição de dados sensíveis de reservas

BUG-015: API não valida permissões para atualizar status de reserva

Teste: RES011

Severidade: Alta

Descrição: Usuários comuns podem atualizar status de reservas, que deveria ser privilégio de admin

Comportamento Esperado: Retornar 403 Forbidden com mensagem "User role user is not authorized to access this route"

Comportamento Atual: Teste falhando, indicando que as permissões não estão funcionando

Impacto: Violação de controle de acesso

BUG-016: API não valida transição de status de reserva

Teste: RES012

Severidade: Média

Descrição: A API aceita transições de status inválidas para reservas

Comportamento Esperado: Retornar 400 Bad Request com mensagem "Invalid status transition"

Comportamento Atual: Teste falhando, indicando que a validação de transição não está funcionando

Impacto: Estados inconsistentes de reservas

BUG-017: API não valida permissões para resetar assentos

Teste: SES006

Severidade: Alta

Descrição: Usuários comuns podem resetar assentos de sessões, que deveria ser privilégio de admin

Comportamento Esperado: Retornar 403 Forbidden

Comportamento Atual: Teste falhando, indicando que as permissões não estão funcionando

Impacto: Violação de controle de acesso e possível manipulação indevida

BUG-018: API não valida sessão inexistente para reset de assentos

Teste: SES007

Severidade: Média

Descrição: A API não retorna erro adequado quando tenta resetar assentos de sessão inexistente

Comportamento Esperado: Retornar 404 Not Found com mensagem "Session not found"

Comportamento Atual: Teste falhando, indicando que a validação de existência não está funcionando

Impacto: Comportamento inesperado para sessões inexistentes

BUG-019: API não valida permissões para cadastrar teatro

Teste: THE003

Severidade: Alta

Descrição: Usuários comuns podem cadastrar teatros, que deveria ser privilégio de admin

Comportamento Esperado: Retornar 403 Forbidden

Comportamento Atual: Teste falhando, indicando que as permissões não estão funcionando

Impacto: Violação de controle de acesso

BUG-020: API não valida campo obrigatório nome do teatro

Teste: THE004

Severidade: Média

Descrição: A API permite cadastrar teatros sem nome obrigatório

Comportamento Esperado: Retornar 400 Bad Request

Comportamento Atual: Teste falhando, indicando que a validação de campo obrigatório não está funcionando

Impacto: Dados inconsistentes no cadastro de teatros

BUG-021: API não valida tipo inválido de teatro

Teste: THE005

Severidade: Média

Descrição: A API aceita tipos inválidos para teatros

Comportamento Esperado: Retornar 400 Bad Request

Comportamento Atual: Teste falhando, indicando que a validação de tipo não está funcionando

Impacto: Dados inconsistentes no cadastro de teatros

BUG-022: API não valida permissões de acesso a dados de outros usuários

Teste: USR005

Severidade: Alta

Descrição: Usuários comuns podem acessar dados de outros usuários

Comportamento Esperado: Retornar 403 Forbidden com mensagem "User role user is not authorized to access this route"

Comportamento Atual: Teste falhando, indicando que as permissões não estão funcionando

Impacto: Violação de privacidade e exposição de dados sensíveis

## 🧠 Inovação

### CI/CD

- Workflow GitHub Actions executando testes de API a cada push/PR.

### GenAI

- Prompt documentado em `docs/prompt_genai.md` para expansão de cenários.

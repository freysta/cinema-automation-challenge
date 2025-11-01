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

| Componente             | Tecnologia                     | Uso                        |
| ---------------------- | ------------------------------ | -------------------------- |
| Framework de Automação | Robot Framework                | Base da automação          |
| Testes API             | RequestsLibrary                | Chamadas HTTP e validações |
| Testes Web             | SeleniumLibrary / Browser      | Automação UI & E2E         |
| Padrões Arquiteturais  | Service Objects / Page Objects | Organização e reuso        |
| Dados de Teste         | FakerLibrary                   | Geração de dados dinâmicos |
| Gestão de Defeitos     | GitHub Issues                  | Controle de bugs           |

<<<<<<< HEAD
| CI/CD | GitHub Actions | Execução automática dos testes |
=======

> > > > > > > b81bf46c61982f77d6254a2c0083229fd05468ad

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

<<<<<<< HEAD

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

| ID     | Severidade | Descrição                                                                  | Teste Relacionado                                        | Status  |
| ------ | ---------- | -------------------------------------------------------------------------- | -------------------------------------------------------- | ------- |
| BUG-01 | Alta       | API permite cadastrar filme sem título obrigatório                         | Teste Tentar Cadastrar Filme Sem Titulo                  | ❌ FAIL |
| BUG-02 | Média      | API aceita durações inválidas (negativas) para filmes                      | Teste Tentar Cadastrar Filme Com Duracao Invalida        | ❌ FAIL |
| BUG-03 | Baixa      | API permite títulos de filmes excessivamente longos                        | Teste Tentar Cadastrar Filme Com Titulo Muito Longo      | ❌ FAIL |
| BUG-04 | Alta       | API permite comprar ingressos para sessões completamente lotadas           | Teste Comprar Ingresso Para Sessao Lotada                | ❌ FAIL |
| BUG-05 | Alta       | API não valida concorrência na compra de assentos                          | Teste Tentar Compra Concorrente Para Ultimo Assento      | ❌ FAIL |
| BUG-06 | Alta       | API permite acesso às reservas sem autenticação                            | Teste Obter Minhas Reservas Sem Autenticacao             | ❌ FAIL |
| BUG-07 | Alta       | Usuários comuns podem atualizar status de reservas                         | Teste Atualizar Status Da Reserva Sem Permissao Admin    | ❌ FAIL |
| BUG-08 | Média      | API aceita transições de status inválidas para reservas                    | Teste Atualizar Status Da Reserva Com Transicao Invalida | ❌ FAIL |
| BUG-09 | Alta       | Usuários comuns podem resetar assentos de sessões                          | Teste Resetar Assentos Sem Permissao Admin               | ❌ FAIL |
| BUG-10 | Média      | API não retorna erro adequado para reset de assentos em sessão inexistente | Teste Resetar Assentos De Sessao Inexistente             | ❌ FAIL |
| BUG-11 | Alta       | Usuários comuns podem cadastrar teatros                                    | Teste Tentar Cadastrar Teatro Com Token User             | ❌ FAIL |
| BUG-12 | Média      | API permite cadastrar teatros sem nome obrigatório                         | Teste Tentar Cadastrar Teatro Sem Nome                   | ❌ FAIL |
| BUG-13 | Média      | API aceita tipos inválidos para teatros                                    | Teste Tentar Cadastrar Teatro Com Tipo Invalido          | ❌ FAIL |
| BUG-14 | Alta       | Usuários comuns podem acessar dados de outros usuários                     | Teste Obter Usuario Por ID Comum Acessando Outro Usuario | ❌ FAIL |
| BUG-15 | Alta       | Usuários comuns podem atualizar dados de outros usuários                   | Teste Atualizar Usuario Por ID (com token user)          | ❌ FAIL |
| BUG-16 | Alta       | Usuários comuns podem deletar outros usuários                              | Teste Deletar Usuario Por ID (com token user)            | ❌ FAIL |
| BUG-17 | Média      | API permite cadastrar usuários sem nome obrigatório                        | Teste Registrar Usuario Sem Nome                         | ❌ FAIL |
| BUG-18 | Média      | API aceita emails com formato inválido                                     | Teste Registrar Usuario Com Email Invalido               | ❌ FAIL |
| BUG-19 | Média      | API aceita senhas muito curtas                                             | Teste Registrar Usuario Com Senha Curta                  | ❌ FAIL |
| BUG-20 | Alta       | API permite emails duplicados no cadastro                                  | Teste Registrar Usuario Com Email Duplicado              | ❌ FAIL |
| BUG-21 | Alta       | Usuários comuns podem listar todos os usuários                             | Teste Listar Usuarios (com token user)                   | ❌ FAIL |
| BUG-22 | Alta       | API permite atualizar perfil sem senha atual                               | Teste Atualizar Perfil Sem Senha Atual                   | ❌ FAIL |
| BUG-23 | Alta       | API permite atualizar perfil com email existente                           | Teste Atualizar Perfil Com Email Existente               | ❌ FAIL |
| BUG-24 | Alta       | Usuários comuns podem atualizar perfil de outros usuários                  | Teste Atualizar Perfil De Outro Usuario                  | ❌ FAIL |
| BUG-25 | Alta       | Usuários comuns podem deletar perfil de outros usuários                    | Teste Deletar Perfil De Outro Usuario                    | ❌ FAIL |

=======

- 72 cenários cobrindo:
  - Autenticação, Usuários, Filmes, Salas, Sessões, Reservas
  - Happy path, negativos, validações, concorrência, idempotência
- Testes E2E híbridos com criação/limpeza de dados pela API

## 🐞 Issues Identificadas

| ID     | Severidade | Resumo                                                |
| ------ | ---------- | ----------------------------------------------------- |
| BUG-01 | Crítico    | JWT não validado corretamente (401 bloqueando E2E)    |
| BUG-02 | Alta       | Mensagens inconsistentes de autenticação              |
| BUG-03 | Alta       | Falha na validação da senha atual (PUT /auth/profile) |
| BUG-04 | Alta       | Falha na validação de e-mail duplicado                |
| BUG-05 | Média      | 500 em validações ao invés de 4xx                     |
| BUG-06 | Média      | Registro com e-mail existente retornando 400          |

> > > > > > > b81bf46c61982f77d6254a2c0083229fd05468ad

## 🧠 Inovação

### GenAI

- Prompt documentado em `docs/prompt_genai.md` para expansão de cenários.

### CI/CD

- Workflow GitHub Actions executando testes de API a cada push/PR.

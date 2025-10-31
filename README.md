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

## 🧠 Inovação

### CI/CD

- Workflow GitHub Actions executando testes de API a cada push/PR.

### GenAI

- Prompt documentado em `docs/prompt_genai.md` para expansão de cenários.

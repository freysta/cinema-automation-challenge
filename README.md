# Cinema Automation Challenge

Este repositório contém a suíte de testes automatizados para a aplicação Cinema App, desenvolvida como parte do Challenge Final do curso.

## 🚀 Visão Geral
O projeto visa garantir a qualidade da aplicação Cinema App através de testes automatizados de API (backend) e Web (frontend), utilizando o Robot Framework e Python. A suíte de testes segue as melhores práticas de automação, incluindo padrões como Page Objects e Service Objects, e implementa testes End-to-End (E2E) híbridos.

## ✨ Funcionalidades Testadas
- Autenticação de Usuários (Registro, Login, Logout, Gerenciamento de Perfil)
- Gerenciamento e Visualização de Filmes
- Gerenciamento e Visualização de Sessões
- Processo de Reserva de Ingressos (Seleção de Assentos, Checkout)
- Visualização de Histórico de Reservas
- Navegação e Experiência do Usuário

## 🐛 Known Bugs

This section details identified bugs in the Cinema App backend API, discovered during the automation testing phase. These issues prevent certain API tests from passing and highlight areas for backend improvement.

### 1. Reservation Creation Fails Due to `totalPrice` Mismatch

-   **Description:** The `Reservation.js` Mongoose model defines `totalPrice` as a required field. However, the `createReservation` function in `reservationController.js` calculates this value internally and adds it to the reservation object *after* receiving the request body. Consequently, when a reservation creation request is sent without `totalPrice` in the payload, Mongoose's schema validation fails, resulting in a `400 Bad Request` error. This prevents any reservation-related API tests from successfully creating reservations.
-   **Impact:** Core reservation functionality is broken at the API level, making it impossible to create reservations. This directly impacts user experience for booking tickets.
-   **Suggested Backend Fix:**
    -   **Option A (Recommended):** Modify the `Reservation.js` model to make `totalPrice` an optional field (`required: false`), as its value is derived and set by the controller.
    -   **Option B:** Adjust the `createReservation` function in `reservationController.js` to explicitly construct the reservation object with the calculated `totalPrice` before passing it to `Reservation.create()`, ensuring the schema validation passes.

### 2. Generic Validation Messages for Movie Creation

-   **Description:** When attempting to create a movie with invalid or missing data (e.g., a movie without a title or with an invalid duration), the backend's `errorHandler` middleware returns a generic "Validation failed" message. This occurs despite specific error messages being defined in the `Movie.js` Mongoose model (e.g., "Title is required", "Duração deve ser um número positivo").
-   **Impact:** Frontend applications cannot provide precise, user-friendly feedback regarding validation errors during movie creation, leading to a poor user experience. Developers must infer the exact validation failure from the generic message.
-   **Suggested Backend Fix:** Modify the `errorHandler` middleware (`src/middleware/error.js`) to extract and return the specific validation error messages from Mongoose's `err.errors` object when a `ValidationError` occurs, instead of a generic message.

## 🛠️ Tecnologias Utilizadas
- **Framework de Automação:** Robot Framework
- **Linguagem:** Python
- **Bibliotecas Robot:** `RequestsLibrary`, `SeleniumLibrary` (ou `Browser`), `FakerLibrary`, `JSONLibrary`
- **Controle de Versão:** Git
- **Integração Contínua:** GitHub Actions

## 📂 Estrutura do Projeto
```
cinema-automation-challenge/
├── docs/                       # Documentação do projeto (Plano de Testes, etc.)
├── robot/                      # Contém todos os arquivos de automação do Robot Framework
│   ├── data/                   # Dados de teste (JSON, Python)
│   ├── resources/              # Keywords reutilizáveis (Service Objects, Page Objects)
│   │   ├── api/                # Service Objects para testes de API
│   │   └── web/                # Page Objects para testes Web
│   └── tests/                  # Casos de teste
│       ├── api/                # Testes de API
│       ├── web/                # Testes Web
│       └── e2e/                # Testes End-to-End híbridos
├── .github/                    # Configurações do GitHub (workflows de CI/CD)
│   └── workflows/
│       └── run_tests.yml       # Workflow para execução de testes no GitHub Actions
├── .gitignore                  # Arquivos e pastas a serem ignorados pelo Git
├── README.md                   # Este arquivo
└── requirements.txt            # Dependências Python do projeto Robot
```

## ⚙️ Configuração do Ambiente

### Pré-requisitos
- Python 3.x
- pip (gerenciador de pacotes Python)
- Git

### Instalação
1. Clone o repositório:
   ```bash
   git clone <URL_DO_SEU_REPOSITORIO>
   cd cinema-automation-challenge
   ```
2. Crie e ative um ambiente virtual (recomendado):
   ```bash
   python -m venv venv
   source venv/bin/activate  # No Linux/macOS
   # venv\Scripts\activate    # No Windows
   ```
3. Instale as dependências do Robot Framework:
   ```bash
   pip install -r robot/requirements.txt
   ```

## ▶️ Como Executar os Testes

### Executar todos os testes
```bash
robot robot/tests/
```

### Executar testes de API
```bash
robot robot/tests/api/
```

### Executar testes Web
```bash
robot robot/tests/web/
```

### Executar testes E2E
```bash
robot robot/tests/e2e/
```

### Gerar Relatórios
Após a execução, os relatórios HTML e XML serão gerados na pasta `results/` (configurado no `.gitignore`).

## 🤝 Contribuição
Siga o padrão Gitflow para contribuições. Crie branches de feature a partir de `develop`, faça commits descritivos e abra Pull Requests para `develop`.

## 📄 Licença
Este projeto está licenciado sob a [Nome da Licença, ex: MIT License].

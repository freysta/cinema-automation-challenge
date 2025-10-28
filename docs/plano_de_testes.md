# Plano de Testes v2.0 - Aplicação Cinema (Challenge Final)

## 1. Introdução

### 1.1. Propósito

Este documento detalha a estratégia de testes e o escopo de automação para a aplicação "Cinema", como parte do challenge final. O objetivo é validar a funcionalidade, integração, segurança e robustez dos sistemas de Back-end (API) e Front-end (Web) utilizando Robot Framework, aplicando padrões de projeto e boas práticas de engenharia de qualidade.

### 1.2. Aplicação Alvo

- **Back-end (API):** `https://github.com/freysta/cinema-challenge-back` (Rodando localmente ou em ambiente de teste)
- **Front-end (Web):** `https://github.com/juniorschmitz/cinema-challenge-front` (Rodando localmente ou em ambiente de teste)

## 2. Escopo da Validação

### 2.1. Em Escopo

A validação cobrirá as seguintes plataformas e módulos de negócio, com foco funcional e de segurança:

- **Plataformas:** Testes de API (Back-end) e Testes de UI (Front-end).
- **Módulos de Negócio (Baseado na API):**
  - Autenticação (`/auth/register`, `/auth/login`)
  - Usuários (`/users`)
  - Filmes (`/movies`)
  - Sessões (`/sessions`)
  - Ingressos (`/tickets`)

### 2.2. Fora de Escopo

Conforme diretrizes do challenge, os seguintes tipos de teste não fazem parte do escopo principal:

- Testes de Performance em larga escala (Carga, Estresse, Volume).
- Testes aprofundados de Usabilidade e Acessibilidade.

## 3. Estratégia de Automação

Seguindo as boas práticas e a pirâmide de testes, a automação será dividida em níveis para otimizar a velocidade de feedback e a manutenibilidade:

### 3.1. Nível 1: Testes de API (Back-end) - Foco Principal (~70%)

Esta camada formará a base da automação, responsável pela validação da lógica de negócio, segurança e integridade dos dados diretamente na API.

- **Foco:**
  - **Regras de Negócio:** Validação de e-mail duplicado, lógica de compra de ingressos (validação de `availableSeats`, concorrência), regras de permissão (Admin vs User), validações de dados de entrada (campos obrigatórios, tipos, formatos).
  - **Segurança:** Autenticação (validação de token JWT - válido/inválido/ausente), Autorização (controle de acesso baseado em roles - Admin/User).
  - **Contrato da API:** Validação de `status codes` HTTP e estrutura/conteúdo das mensagens de erro.
  - **Robustez:** Testes de idempotência (ex: `DELETE`), validação de tipos de dados inesperados.
- **Padrão de Projeto:** A interação com a API será encapsulada em `Keywords` de serviço (semelhante ao padrão `ServiceObjects` ou `API Client`), organizadas por módulo de negócio (ex: `auth_service.robot`, `movie_service.robot`) na pasta `resources/api/`. Isso promove a reutilização e isola os detalhes da `RequestsLibrary` dos casos de teste.

### 3.2. Nível 2: Testes de UI (Front-end) - Validação da Interface (~20%)

Focada na validação da interface do usuário e interações de componentes.

- **Foco:** Validação de elementos visuais, funcionalidade de formulários (cadastro, login, adição de filme), feedback visual para o usuário (mensagens de erro/sucesso), navegação entre páginas.
- **Padrão de Projeto:** `PageObjects`. Cada página ou componente reutilizável da interface terá seu próprio arquivo em `resources/web/` (ex: `login_page.robot`, `admin_movies_page.robot`). Estes arquivos conterão os localizadores (seletores CSS/XPath) e as `Keywords` que representam as ações do usuário naquela página específica, utilizando a biblioteca de automação web (`SeleniumLibrary` ou `Browser`).

### 3.3. Nível 3: Testes End-to-End (E2E) - Validação dos Fluxos Críticos (~10%)

Validará os fluxos de negócio mais importantes do ponto de vista do usuário, integrando Front-end e Back-end.

- **Foco:** Simulação da jornada completa do usuário em cenários críticos (ex: Compra de Ingresso, Cadastro de Filme por Admin).
- **Estratégia de Independência:** Para garantir **testes independentes**, será utilizada uma **abordagem híbrida**:
  - **`Suite Setup` (API):** Criação de dados de pré-condição (usuários Admin/Comum, filme, sessão) via chamadas diretas à API. Isso torna o setup rápido e confiável.
  - **`Test Case` (UI):** Execução do fluxo do usuário na interface web, utilizando os dados criados no setup.
  - **`Suite Teardown` (API):** Limpeza dos dados de teste criados (exclusão de usuários, filmes, etc.) via chamadas diretas à API. Isso garante que o ambiente retorne a um estado limpo.

## 4. Ferramentas e Artefatos

- **Framework:** Robot Framework
- **Bibliotecas:** `RequestsLibrary`, `SeleniumLibrary` (ou `Browser`), `FakerLibrary` (para dados dinâmicos).
- **Gestão:** Git, GitHub (com Issues para bugs).
- **Artefatos:** Plano de Testes (este doc), Mapa Mental, Prompt GenAI, Código de Automação.
- **Inovação:** Pipeline de CI/CD no GitHub Actions para execução automática dos testes de API.

## 5. Cenários de Teste Prioritários (Foco Back-end Inicial)

Esta lista detalha os cenários chave a serem implementados, começando pela camada de API.

### P0 - Críticos (Segurança Core e Lógica de Compra)

- **[API-AuthN-01]** Tentar acessar rota protegida (ex: `POST /tickets`) sem token. (Esperado: 401 Unauthorized).
- **[API-AuthN-02]** Tentar acessar rota protegida com token inválido/expirado. (Esperado: 401).
- **[API-AuthZ-01]** Tentar acessar rota de Admin (ex: `POST /movies`) com token de usuário comum. (Esperado: 403 Forbidden).
- **[API-Tickets-BUY]** Compra de ingresso bem-sucedida para sessão com assentos disponíveis. (Esperado: 201 Created; `availableSeats` decrementado).
- **[API-Tickets-LOT]** Tentar comprar ingresso para sessão com `availableSeats` = 0. (Esperado: 400 Bad Request + msg erro "Sem assentos disponíveis").
- **[API-Tickets-CONC] Teste de Concorrência:** Simular duas chamadas `POST /tickets` para o último assento disponível. (Esperado: Uma 201, a outra 400/409 + msg erro).

### P1 - Alta (Regras de Negócio e Validação de Dados API)

- **[API-Users-REG-OK]** Cadastro de usuário comum bem-sucedido. (Esperado: 201).
- **[API-Users-REG-ADMIN-OK]** Cadastro de usuário Admin bem-sucedido. (Esperado: 201).
- **[API-Users-DUP]** Tentar `POST /auth/register` com e-mail já existente. (Esperado: 400 + msg erro "E-mail já cadastrado").
- **[API-Login-OK]** Login bem-sucedido com credenciais válidas. (Esperado: 200 + token JWT).
- **[API-Login-FAIL]** Login com senha incorreta. (Esperado: 401 + msg erro).
- **[API-Movies-CRUD-Admin]** Fluxo CRUD completo para `/movies` com token de Admin. (Esperado: 201, 200, 200).
- **[API-Sessions-CRUD-Admin]** Fluxo CRUD completo para `/sessions` com token de Admin. (Esperado: 201, 200, 200).
- **[API-Tickets-MY]** Listar "Meus Ingressos" (`GET /tickets/my-tickets`) com token de usuário comum. (Esperado: 200).
- **[API-Users-REQ]** Tentar `POST /auth/register` sem campo obrigatório (ex: `email`). (Esperado: 400 + msg erro).
- **[API-Movies-REQ]** Tentar `POST /movies` sem campo obrigatório (ex: `title`). (Esperado: 400 + msg erro).
- **[API-Tickets-INV-SESS]** Tentar `POST /tickets` com `sessionId` inexistente. (Esperado: 404/400 + msg erro).

### P2 - Média (Outras Validações API e Preparação E2E)

- **[API-Movies-GET-Public]** Listar filmes (`GET /movies`) sem token. (Esperado: 200).
- **[API-Sessions-GET-Public]** Listar sessões (`GET /sessions`) sem token. (Esperado: 200).
- **[API-Users-AUTHZ-Other]** Usuário comum tentar deletar (`DELETE /users/{id}`) outro usuário. (Esperado: 403).
- **[API-IDEMPOTENCE-DEL]** Validar idempotência do `DELETE /users/{id}` (chamar duas vezes). (Esperado: 1ª chamada 200, 2ª chamada 404 ou 200 com msg "não encontrado").

## 6. Gestão de Defeitos (Bugs)

Defeitos encontrados serão registrados como **Issues** no GitHub, com: Título claro, Passos para Reprodução, Resultado Esperado vs Obtido, Impacto/Prioridade e Evidências (logs, prints).

## 7. Critérios de Aceite da Automação

- Cobertura dos cenários P0 e P1 definidos neste plano.
- Código seguindo os padrões definidos (ServiceObjects, PageObjects, E2E Híbrido).
- Testes independentes através de Setup/Teardown via API.
- Documentação (`README.md`) completa para setup e execução.
- Integração com CI (GitHub Actions) para testes de API.

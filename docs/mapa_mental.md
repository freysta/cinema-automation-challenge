# Mapa Mental da Estratégia de Testes

## 1. Visão Geral
- **Objetivo:** Garantir a qualidade e robustez da aplicação Cinema através de uma suíte de testes automatizados.
- **Abordagem:** API-First, complementada por testes de UI e E2E híbridos.
- **Ferramentas:** Robot Framework, RequestsLibrary, SeleniumLibrary, Faker.
- **Padrões:** Service Objects (API), Page Objects (UI), Hybrid E2E.

## 2. Camadas de Teste

### 2.1. Testes de API (Service Objects)
- **Foco:** Validação da lógica de negócio, contratos de API, e tratamento de erros no backend.
- **Módulos Principais:**
    - **Autenticação (`auth_service.robot`):** Registro, Login, Geração e Validação de Tokens.
    - **Usuários (`user_service.robot`):** Criação, Leitura, Atualização, Deleção de usuários.
    - **Filmes (`filmes_service.robot`):** Criação, Leitura, Atualização, Deleção de filmes.
    - **Sessões (`session_service.robot`):** Criação, Leitura, Atualização, Deleção de sessões (com atenção ao BUG-07).
    - **Teatros (`theaters_service.robot`):** Criação, Leitura, Atualização, Deleção de teatros (com atenção ao BUG-06).
    - **Reservas (`reservations_service.robot`):** Criação, Leitura, Deleção de reservas (com atenção ao BUG-01).
    - **Admin Setup (`admin_setup_service.robot`):** Criação de usuários admin para testes.
- **Características:**
    - Testes rápidos e estáveis.
    - Cobertura abrangente de cenários de sucesso e falha.
    - Utilização de dados dinâmicos (Faker) e payloads JSON.

### 2.2. Testes de UI (Page Objects)
- **Foco:** Validação da interface do usuário, interações e fluxo de navegação.
- **Módulos Principais:**
    - **Página de Login (`login_page.robot`):** Abertura da página, preenchimento de credenciais, cliques, verificação de mensagens de erro/sucesso.
    - **Página Inicial (`home_page.robot`):** Navegação, exibição de filmes em cartaz, interação com elementos da vitrine.
    - **Página Admin (`admin_page.robot`):** Acesso a funcionalidades administrativas (ex: cadastro de filmes), preenchimento de formulários, verificação de dados em tabelas.
- **Características:**
    - Reutilização de componentes de página (locators e keywords).
    - Testes mais lentos, focados na experiência do usuário.

### 2.3. Testes E2E (Híbridos)
- **Foco:** Validação de fluxos de negócio completos, integrando API e UI.
- **Módulos Principais:**
    - **Fluxo de Cadastro de Filme por Admin (`fluxo_cadastro_filme_admin.robot`):**
        - **Setup (API):** Criação de usuário admin.
        - **Ação (UI):** Login como admin, navegação para a página admin, cadastro de filme via formulário.
        - **Verificação (UI/API):** Confirmação do filme na UI e, opcionalmente, via API.
        - **Teardown (API):** Deleção do usuário admin.
    - **Fluxo de Compra de Ingresso (Bloqueado pelo BUG-01):**
        - **Setup (API):** Criação de usuário, filme, sessão.
        - **Ação (UI):** Login, seleção de filme/sessão, escolha de assentos, finalização da compra.
        - **Verificação (UI/API):** Confirmação da reserva.
        - **Teardown (API):** Deleção de dados criados.
- **Características:**
    - Cenários de ponta a ponta, refletindo o uso real da aplicação.
    - Redução da complexidade e tempo de execução de E2E puros, utilizando a API para setup/teardown.

## 3. Tratamento de Bugs Conhecidos
- **BUG-01 (Criação de Reserva):** Testes de reserva marcados como bloqueados/esperados para falhar.
- **BUG-02 (Mensagens de Validação Genéricas):** Workaround implementado nos testes de API de filmes para esperar a mensagem genérica.
- **Outros Bugs (BUG-03, BUG-04, BUG-05, BUG-06, BUG-07):** Identificados e seus impactos nos testes são considerados, com testes específicos falhando conforme esperado ou com lacunas de cobertura a serem endereçadas no backend.

## 4. Próximos Passos
- Implementação do pipeline de CI/CD para testes de API.
- Geração de prompts para GenAI para cenários de teste complexos.
- Finalização da documentação do projeto.
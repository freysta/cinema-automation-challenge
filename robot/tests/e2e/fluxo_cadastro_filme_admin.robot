*** Settings ***
Library           SeleniumLibrary
Resource          ../../resources/api/auth_service.robot
Resource          ../../resources/api/user_service.robot
Resource          ../../resources/web/login_page.robot
Resource          ../../resources/web/admin_page.robot
Resource          ../../resources/web/home_page.robot
Resource          ../../resources/web/common_web.robot
Resource          ../../resources/web/common_variables.robot
Resource          ../../resources/web/common_web_keywords.robot

Suite Setup       Setup E2E Admin Movie Flow
Suite Teardown    Teardown E2E Admin Movie Flow

*** Variables ***
${E2E_ADMIN_EMAIL}      e2e_admin_${RANDOM_INT}@example.com
${E2E_ADMIN_PASSWORD}   e2e_password123
${E2E_MOVIE_TITLE}      Filme E2E Admin ${RANDOM_INT}
${E2E_MOVIE_SYNOPSIS}   Sinopse do filme criado via E2E Admin
${E2E_MOVIE_DIRECTOR}   Diretor E2E

*** Test Cases ***
Fluxo E2E Cadastro de Filme por Admin
    [Tags]    E2E    Admin    MovieCreation
    # 1. Login as the newly created admin user via UI
    login_page.Abrir Pagina de Login
    login_page.Realizar Login    ${E2E_ADMIN_EMAIL}    ${E2E_ADMIN_PASSWORD}
    login_page.Verificar Login Bem Sucedido

    # 2. Navigate to Admin page and create a movie via UI
    admin_page.Acessar Pagina Admin
    admin_page.Clicar Adicionar Filme
    admin_page.Preencher Titulo Filme    ${E2E_MOVIE_TITLE}
    admin_page.Preencher Descricao Filme    ${E2E_MOVIE_SYNOPSIS}
    admin_page.Preencher Duracao Filme    150
    admin_page.Clicar Salvar Filme
    admin_page.Verificar Mensagem Sucesso    Filme criado com sucesso

    # 3. Verify the movie appears in the Admin table
    admin_page.Verificar Filme Na Tabela Admin    ${E2E_MOVIE_TITLE}

    # 4. Verify the movie appears on the Home page (vitrine)
    home_page.Navegar Para    ${HOME_URL}
    home_page.Verificar Filme Na Lista    ${E2E_MOVIE_TITLE}

*** Keywords ***
Setup E2E Admin Movie Flow
    common_web.Abrir Navegador
    # Create admin user via API
    ${admin_token}=    auth_service.Registrar E Fazer Login Como Admin    ${E2E_ADMIN_EMAIL}    ${E2E_ADMIN_PASSWORD}
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}

Teardown E2E Admin Movie Flow
    # Delete admin user via API
    user_service.Deletar Usuario Por Email    ${ADMIN_TOKEN}    ${E2E_ADMIN_EMAIL}
    common_web.Fechar Navegador

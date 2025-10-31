*** Settings ***
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/web/base_web.resource

Suite Setup       Setup Testes Frontend
Suite Teardown    Teardown Testes Frontend
Test Setup        New Page    ${FRONTEND_BASE_URL}

*** Variables ***
${VALID_EMAIL}          admin@example.com
${VALID_PASSWORD}       password123
${INVALID_PASSWORD}     wrongpassword
${NON_EXISTENT_EMAIL}   nonexistent@example.com

*** Test Cases ***
Login Web Bem-Sucedido
    [Tags]    Web    Positive
    Realizar Login    ${VALID_EMAIL}    ${VALID_PASSWORD}
    # Verify successful login by checking for an element on the home page after login
    Wait Until Page Contains Element    xpath=//h1[contains(text(),'Filmes em Cartaz')]    timeout=10s

Login Web Com Senha Inválida
    [Tags]    Web    Negative
    Realizar Login    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    Verificar Mensagem de Erro Exibida    Invalid credentials

Login Web Com Usuário Inexistente
    [Tags]    Web    Negative
    Realizar Login    ${NON_EXISTENT_EMAIL}    ${VALID_PASSWORD}
    Verificar Mensagem de Erro Exibida    Invalid credentials
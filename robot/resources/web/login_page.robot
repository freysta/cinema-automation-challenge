*** Settings ***
Library    Browser
Resource    home_page.robot
Resource    ../base_web.resource

*** Variables ***
${LOGIN_URL}        ${FRONTEND_BASE_URL}/login
${EMAIL_INPUT}      id=email
${PASSWORD_INPUT}   id=password
${LOGIN_BUTTON}     xpath=//button[contains(text(), "Entrar")]
${ERROR_MESSAGE}    css=.alert-error

*** Keywords ***
Navegar Para Login
    [Documentation]    Navega para a página de login.
    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    ${EMAIL_INPUT}

Preencher Campo Email
    [Arguments]    ${email}
    Fill Text    ${EMAIL_INPUT}    ${email}

Preencher Campo Senha
    [Arguments]    ${password}
    Fill Text    ${PASSWORD_INPUT}    ${password}

Clicar Botao Entrar
    Click    ${LOGIN_BUTTON}

Verificar Mensagem de Erro
    [Arguments]    ${expected_message}
    Wait Until Page Contains    ${expected_message}
    Get Text    ${ERROR_MESSAGE}    ==    ${expected_message}

Verificar Login Bem Sucedido
    Wait Until Page Contains Element    xpath=//h1[contains(text(),'Filmes em Cartaz')]
    Location Should Contain    /
    # Assuming / is the home page after successful login

Realizar Login
    [Arguments]    ${email}    ${password}
    Navegar Para Login
    Preencher Campo Email    ${email}
    Preencher Campo Senha    ${password}
    Clicar Botao Entrar
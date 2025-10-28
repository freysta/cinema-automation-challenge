*** Settings ***
Resource    common_web.robot

*** Variables ***
${LOGIN_EMAIL_FIELD}    //input[@type='email' or @name='email']
${LOGIN_PASSWORD_FIELD}    //input[@type='password' or @name='password']
${LOGIN_BUTTON}    //button[contains(text(),'Entrar') or contains(text(),'Login')]
${REGISTER_LINK}    //a[contains(text(),'Cadastrar') or contains(text(),'Registrar')]
${LOGOUT_BUTTON}    //button[contains(text(),'Sair') or contains(text(),'Logout')]
${ERROR_MESSAGE}    //div[contains(@class,'error') or contains(@class,'alert')] | //p[contains(@class,'error')]

*** Keywords ***
Preencher Email Login
    [Arguments]    ${email}
    Preencher Campo    ${LOGIN_EMAIL_FIELD}    ${email}

Preencher Senha Login
    [Arguments]    ${password}
    Preencher Campo    ${LOGIN_PASSWORD_FIELD}    ${password}

Clicar Botao Entrar
    Clicar Elemento    ${LOGIN_BUTTON}

Fazer Login
    [Arguments]    ${email}    ${password}
    Preencher Email Login    ${email}
    Preencher Senha Login    ${password}
    Clicar Botao Entrar
    Esperar Pagina Carregar

Clicar Link Cadastrar
    Clicar Elemento    ${REGISTER_LINK}

Verificar Mensagem Erro Login
    [Arguments]    ${expected_message}
    Esperar Elemento Visivel    ${ERROR_MESSAGE}
    ${actual_message}=    Get Text    ${ERROR_MESSAGE}
    Should Contain    ${actual_message}    ${expected_message}

Verificar Login Bem Sucedido
    Verificar Elemento Presente    ${LOGOUT_BUTTON}

Fazer Logout
    Clicar Elemento    ${LOGOUT_BUTTON}
    Esperar Pagina Carregar

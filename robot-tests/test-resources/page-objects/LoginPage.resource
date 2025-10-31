*** Settings ***
Library    Browser  
Resource    ../../base.resource

*** Variables ***
${LOGIN_PAGE_URL}             ${FRONTEND_BASE_URL}/login
${INPUT_EMAIL}                css=#email
${INPUT_PASSWORD}             css=#password
${BTN_ENTRAR}                 css=button.btn
${LINK_PARA_CADASTRO}         css=.login-footer > p:nth-child(1) > a:nth-child(1)     

*** Keywords ***
Navegar Para Login
    [Documentation]    Navega diretamente para a URL da página de Login.
    Go To    ${LOGIN_PAGE_URL}
    Wait For Elements State    ${BTN_ENTRAR}    visible

Preencher Formulario De Login
    [Arguments]    ${email}    ${password}
    [Documentation]    Preenche os campos de e-mail e senha.
    Fill Text    ${INPUT_EMAIL}    ${email}
    Fill Text    ${INPUT_PASSWORD}    ${password}

Clicar Botao Entrar
    [Documentation]    Clica no botão principal de Login.
    Click    ${BTN_ENTRAR}

Realizar Login
    [Arguments]    ${email}    ${password}
    [Documentation]    Ação completa: Preenche e clica em Entrar.
    Preencher Formulario De Login    ${email}    ${password}
    Clicar Botao Entrar

Validar Login Bem Sucedido
    [Documentation]    Verifica se o login foi bem-sucedido (Redirecionamento para Home).
    Sleep    2s
    ${current_url}=    Get Url
    Should Not Contain    ${current_url}    /login

Clicar Link Para Cadastro
    [Documentation]    Clica no link "Cadastre-se" na página de login.
    Click    ${LINK_PARA_CADASTRO}

Validar Redirecionamento Para Cadastro
    [Documentation]    Verifica se foi redirecionado para a página de cadastro.
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /register

Validar Mensagem De Erro Login
    [Documentation]    Verifica se aparece mensagem de erro para credenciais inválidas.
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /login
    ${page_text}=    Get Text    body
    Should Contain Any    ${page_text}    Credenciais Inválidas    credenciais inválidas    erro    invalid

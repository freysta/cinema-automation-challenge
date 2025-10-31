*** Settings ***
Library    Browser
Resource    ../../base.resource

*** Variables ***
${SIGNUP_PAGE_URL}            ${FRONTEND_BASE_URL}/register
${PAGE_TITLE_SIGNUP}          css=.register-container > h1:nth-child(1)

${INPUT_NAME}                 css=#name
${INPUT_EMAIL}                css=#email
${INPUT_PASSWORD}             css=#password
${INPUT_CONFIRM_PASSWORD}     css=#confirmPassword
${BTN_CADASTRAR}              css=button.btn

${LINK_PARA_LOGIN}            css=.register-footer > p:nth-child(1) > a:nth-child(1)

*** Keywords ***
Navegar Para Cadastro
    [Documentation]    Navega diretamente para a URL da página de Cadastro.
    Go To    ${SIGNUP_PAGE_URL}
    Wait For Elements State    ${BTN_CADASTRAR}    visible

Preencher Formulario De Registro
    [Arguments]    ${name}    ${email}    ${password}    ${confirm_password}=${password}
    [Documentation]    Preenche todos os campos do formulário de registro.
    Fill Text    ${INPUT_NAME}         ${name}
    Fill Text    ${INPUT_EMAIL}        ${email}
    Fill Text    ${INPUT_PASSWORD}     ${password}
    Fill Text    ${INPUT_CONFIRM_PASSWORD}     ${confirm_password}

Clicar Botao Cadastrar
    [Documentation]    Clica no botão principal de Cadastro.
    Click    ${BTN_CADASTRAR}

Realizar Registro
    [Arguments]    ${name}    ${email}    ${password}    ${confirm_password}=${password}
    [Documentation]    Ação completa: Preenche e clica em Cadastrar.
    Preencher Formulario De Registro    ${name}    ${email}    ${password}    ${confirm_password}
    Clicar Botao Cadastrar

Validar Registro Bem Sucedido
    [Documentation]    Verifica se o registro foi bem-sucedido.
    Sleep    3s
    ${page_text}=    Get Text    body
    Should Contain Any    ${page_text}    sucesso    cadastrado    registrado    criado
    Log    ${page_text}

Gerar Email Aleatorio
    [Documentation]    Gera um email aleatório para cada execução
    ${timestamp}=    Get Time    epoch
    ${random_string}=    Generate Random String    5    [LETTERS]
    ${email}=    Set Variable    usuario${timestamp}${random_string}@teste.com
    RETURN    ${email}

Validar Mensagem Erro Senha Diferente
    [Documentation]    Verifica mensagem de erro quando senhas são diferentes.
    Sleep    2s
    ${page_text}=    Get Text    body
    Should Contain Any    ${page_text}    senhas não coincidem    senhas diferentes    passwords do not match    As senhas não coincidem

Clicar Link Para Login
    [Documentation]    Clica no link para ir para a página de login.
    Click    ${LINK_PARA_LOGIN}

Validar Redirecionamento Para Login
    [Documentation]    Verifica se foi redirecionado para a página de login.
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /login
*** Settings ***
Resource    ../test-resources/page-objects/LoginPage.resource
Library     Browser

Suite Setup       New Browser    firefox    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173

*** Variables ***
${EMAIL_INVALIDO}     usuario@invalido.com
${SENHA_INVALIDA}     senhaerrada

*** Test Cases ***
Login Bem Sucedido
    [Documentation]    Testa o login com credenciais válidas
    [Tags]    login    smoke
    
    Navegar Para Login
    Realizar Login    ${EMAIL_USER}    ${SENHA_USER}
    Validar Login Bem Sucedido

Navegar Para Cadastro
    [Documentation]    Testa o redirecionamento para a página de cadastro
    [Tags]    cadastro    smoke
    
    Navegar Para Login
    Clicar Link Para Cadastro
    Validar Redirecionamento Para Cadastro

Login Com Credenciais Incorretas
    [Documentation]    Testa login com credenciais inválidas e verifica mensagem de erro
    [Tags]    login    negativo
    
    Navegar Para Login
    Realizar Login    ${EMAIL_INVALIDO}    ${SENHA_INVALIDA}
    Validar Mensagem De Erro Login
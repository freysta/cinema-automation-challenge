*** Settings ***
Resource    ../test-resources/page-objects/ProfilePage.resource
Resource    ../test-resources/page-objects/LoginPage.resource
Resource    ../test-resources/page-objects/SignupPage.resource
Library     Browser

Suite Setup       New Browser    firefox    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173

*** Test Cases ***
Alterar nome
    Navegar Para Login
    Realizar Login    ${EMAIL_USER}    ${SENHA_USER}
    Validar Login Bem Sucedido
    Navegar Para Pagina Perfil
    Atualizar Nome Do Perfil    Nome Novo
    Validar Mensagem De Sucesso Update    
    Validar Nome Atualizado    Nome Novo
    Atualizar Nome Do Perfil    Test User
    Validar Mensagem De Sucesso Update  

Tentar alterar email
    Navegar Para Login
    Realizar Login    ${EMAIL_USER}    ${SENHA_USER}
    Validar Login Bem Sucedido
    Navegar Para Pagina Perfil
    Validar Campos Nao Editaveis

Tentar acessar apos ser Registrado
    [Documentation]    Registrar um usuario e ir para Meu Perfil
    ${email_aleatorio}=    Gerar Email Aleatorio
    Navegar Para Cadastro
    Realizar Registro    ${NOME_USER}    ${email_aleatorio}    ${SENHA_USER}
    Validar Registro Bem Sucedido
    Navegar Para Pagina Perfil

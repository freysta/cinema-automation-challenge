*** Settings ***
Resource    ../test-resources/page-objects/SignupPage.resource
Library     Browser
Library     String

Suite Setup       New Browser    chromium    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173


*** Test Cases ***
Cadastro Bem Sucedido
    [Documentation]    Testa o cadastro com dados válidos
    [Tags]    cadastro    smoke
    
    ${email_aleatorio}=    Gerar Email Aleatorio
    Navegar Para Cadastro
    Realizar Registro    ${NOME_USER}    ${email_aleatorio}    ${SENHA_USER}
    Validar Registro Bem Sucedido

Cadastro Com Senhas Diferentes
    [Documentation]    Testa cadastro com senha e confirmar senha diferentes
    [Tags]    cadastro    negativo
    
    ${email_aleatorio}=    Gerar Email Aleatorio
    Navegar Para Cadastro
    Realizar Registro    ${NOME_USER}    ${email_aleatorio}    ${SENHA_USER}    senha_diferente
    Validar Mensagem Erro Senha Diferente

Navegar Para Login Do Cadastro
    [Documentation]    Testa o redirecionamento do cadastro para login
    [Tags]    cadastro    navegacao
    
    Navegar Para Cadastro
    Clicar Link Para Login
    Validar Redirecionamento Para Login


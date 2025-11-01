*** Settings ***
Resource    ../../resources/web/admin_page.robot
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/web/home_page.robot
Resource    ../../resources/web/base_web.resource

Suite Setup       Setup Testes Frontend
Suite Teardown    Teardown Testes Frontend
Test Setup        New Page    ${FRONTEND_BASE_URL}

*** Variables ***
${VALID_EMAIL}          admin@example.com
${VALID_PASSWORD}       admin123

*** Test Cases ***
Teste Cadastro Filme Admin
    Login Admin Web
    Acessar Pagina Admin
    Clicar Adicionar Filme
    Preencher Titulo Filme    Filme Teste Automacao
    Preencher Descricao Filme    Descricao do filme de teste
    Preencher Duracao Filme    120
    Clicar Salvar Filme
    Verificar Mensagem Sucesso    Filme criado com sucesso

Teste Verificar Filme Na Vitrine
    Go To Home Page
    Verificar Filme Na Lista    Filme Teste Automacao

*** Keywords ***
Login Admin Web
    Navegar Para Login
    Realizar Login    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Validar Login Bem Sucedido
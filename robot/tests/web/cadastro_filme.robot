*** Settings ***
Resource    ../../resources/web/admin_page.robot
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/web/home_page.robot
Resource    ../../resources/web/common_web.robot
Resource    ../../resources/web/common_variables.robot
Resource    ../../resources/web/common_web_keywords.robot
Suite Setup    Setup Test Environment
Suite Teardown    common_web.Fechar Navegador

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
    Navegar Para    ${URL}
    Verificar Filme Na Lista    Filme Teste Automacao

*** Keywords ***
Setup Test Environment
    common_web.Abrir Navegador
    # Aqui poderia criar dados via API se necessário

Login Admin Web
    Navegar Para    ${FRONTEND_URL}/login
    login_page.Realizar Login    admin@example.com    password123
    login_page.Verificar Login Bem Sucedido



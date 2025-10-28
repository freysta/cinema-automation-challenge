*** Settings ***
Resource    ../../resources/web/admin_page.robot
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/web/home_page.robot
Resource    ../../resources/web/common_web.robot
Suite Setup    Setup Test Environment
Suite Teardown    Fechar Navegador

*** Test Cases ***
Teste Cadastro Filme Admin
    Fazer Login Admin
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
    Abrir Navegador
    # Aqui poderia criar dados via API se necessário

Fazer Login Admin
    Navegar Para    ${URL}/login
    Fazer Login    admin@test.com    admin123
    Verificar Login Bem Sucedido

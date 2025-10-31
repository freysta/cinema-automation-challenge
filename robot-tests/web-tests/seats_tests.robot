*** Settings ***
Resource    ../test-resources/page-objects/MoviesListPage.resource
Resource    ../test-resources/page-objects/MoviePage.resource
Resource    ../test-resources/page-objects/SeatsPage.resource
Library     Browser

Suite Setup       New Browser    chromium    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173

*** Test Cases ***
Selecionar E Validar Assento
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    Selecionar Primeiro Assento Disponivel
    Validar Assento Selecionado
    Validar Lista De Assentos Selecionados
    Validar Valor Total Atualizado

Tentar Selecionar Assento Ocupado
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    Tentar Selecionar Assento Ocupado
    Validar Assento Nao Selecionado

Liberar Assentos Selecionados
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    ${occupied_count_before}=    Get Element Count    ${SEAT_OCCUPIED}
    Selecionar Primeiro Assento Disponivel
    Validar Assento Selecionado
    Clicar Botao Liberar Assentos
    Validar Bug Liberacao Assentos    ${occupied_count_before}

Tentar Continuar Sem Selecionar Assentos
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    Tentar Clicar Botao Continuar Sem Assentos
    Validar Permanencia Na Pagina De Assentos

Continuar para a compra do ticket
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    Selecionar Primeiro Assento Disponivel
    Validar Assento Selecionado
    Clicar Botao Continuar
    Validar redirecionamento para a próxima página    ${FRONTEND_BASE_URL}/login
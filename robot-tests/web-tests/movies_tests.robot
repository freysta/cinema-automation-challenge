*** Settings ***
Resource    ../test-resources/page-objects/MoviesListPage.resource
Resource    ../test-resources/page-objects/MoviePage.resource
Resource    ../test-resources/page-objects/SeatsPage.resource
Library     Browser

Suite Setup       New Browser    chromium    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173

*** Variables ***
${TERMO_BUSCA}        Inception
${GENERO_FILTRO}      Drama

*** Test Cases ***
Buscar Filme Na Lista
    [Documentation]    Testa a busca por um filme específico
    [Tags]    movies    busca
    
    Navegar Para Lista De Filmes
    Aplicar Filtro De Busca    ${TERMO_BUSCA}
    Validar Resultado Da Busca    ${TERMO_BUSCA}

Filtrar Filmes Por Genero
    [Documentation]    Testa o filtro por gênero de filme
    [Tags]    movies    filtro
    
    Navegar Para Lista De Filmes
    Aplicar Filtro Por Genero    ${GENERO_FILTRO}
    Validar Resultado Do Filtro    ${GENERO_FILTRO}

Navegar Para Detalhes Do Filme
    [Documentation]    Testa navegação para página de detalhes do filme
    [Tags]    movies    detalhes
    
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Validar Redirecionamento Para Detalhes

Validar Detalhes Do Filme
    [Documentation]    Verifica se todos os detalhes do filme estão visíveis
    [Tags]    movie    detalhes
    
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Validar Detalhes Completos Do Filme

Validar Sessoes Do Filme
    [Documentation]    Verifica se as sessões estão corretas ou se há mensagem de ausência
    [Tags]    movie    sessoes
    
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Validar Presenca Horarios De Sessao

Selecionar Assentos Da Primeira Sessao
    [Documentation]    Testa clique em selecionar assentos da primeira sessão
    [Tags]    movie    assentos
    
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    Validar Redirecionamento Para Assentos



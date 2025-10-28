*** Settings ***
Resource    common_web.robot

*** Variables ***
${MOVIE_LIST}    //div[contains(@class,'movie') or contains(@class,'card')] | //ul[contains(@class,'movies')]
${MOVIE_CARD}    //div[contains(@class,'movie') or contains(@class,'card')][1]
${MOVIE_TITLE}    //h3 | //h2 | //div[contains(@class,'title')]
${SEARCH_FIELD}    //input[@type='text' and (@placeholder='Buscar' or @placeholder='Search')]
${SEARCH_BUTTON}    //button[contains(text(),'Buscar') or contains(text(),'Search')]

*** Keywords ***
Verificar Lista Filmes Carregada
    Esperar Elemento Visivel    ${MOVIE_LIST}
    Verificar Elemento Presente    ${MOVIE_CARD}

Clicar Primeiro Filme
    Clicar Elemento    ${MOVIE_CARD}

Buscar Filme
    [Arguments]    ${query}
    Preencher Campo    ${SEARCH_FIELD}    ${query}
    Clicar Elemento    ${SEARCH_BUTTON}
    Esperar Pagina Carregar

Verificar Filme Na Lista
    [Arguments]    ${movie_title}
    Verificar Texto Presente    ${movie_title}

Verificar Numero Filmes
    [Arguments]    ${expected_count}
    ${count}=    Get Element Count    ${MOVIE_CARD}
    Should Be Equal As Integers    ${count}    ${expected_count}

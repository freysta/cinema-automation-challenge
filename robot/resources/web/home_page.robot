*** Settings ***
Library    Browser
Resource    ../base_web.resource

*** Variables ***
${HOME_URL}                 ${FRONTEND_BASE_URL}/
${WELCOME_HEADING}          xpath=//h1[contains(text(), 'Welcome to Cinema App')]
${ALL_MOVIES_BUTTON}        css=.btn-primary.btn-lg
${FEATURED_MOVIES_HEADING}  xpath=//h2[contains(text(), 'Filmes em Cartaz')]
${MOVIE_CARD}               css=.movie-card

*** Keywords ***
Navegar Para Pagina Inicial
    [Documentation]    Navega para a página inicial.
    Go To    ${HOME_URL}
    Wait Until Page Contains Element    ${FEATURED_MOVIES_HEADING}

Verificar Titulo Pagina Inicial
    [Documentation]    Verifica o título da página inicial.
    Wait For Text    Welcome to Cinema App

Clicar Botao Ver Todos Os Filmes
    [Documentation]    Clica no botão 'Ver Todos Os Filmes'.
    Click    ${ALL_MOVIES_BUTTON}

Verificar Filmes Em Cartaz Visiveis
    [Documentation]    Verifica se os filmes em cartaz estão visíveis.
    Wait Until Page Contains Element    ${FEATURED_MOVIES_HEADING}
    Wait Until Page Contains Element    ${MOVIE_CARD}

Verificar Filme Na Lista
    [Arguments]    ${movie_title}
    [Documentation]    Verifica se um filme específico está na lista.
    Wait For Text    ${movie_title}

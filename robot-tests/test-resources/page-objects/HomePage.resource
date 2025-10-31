*** Settings ***
Library    Browser   

*** Variables ***
${HEADER_LINK_HOME}                  css=.nav > ul:nth-child(1) > li:nth-child(2) > a:nth-child(1)
${HEADER_LINK_FILMES}                css=.nav > ul:nth-child(1) > li:nth-child(1) > a:nth-child(1)
${HEADER_LINK_LOGIN}                 css=.nav > ul:nth-child(1) > li:nth-child(3) > a:nth-child(1)
${HEADER_LINK_CADASTRO}              css=.nav > ul:nth-child(1) > li:nth-child(4) > a:nth-child(1)
${HEADER_LINK_CINEMAAPP}             css=.logo > a:nth-child(1) > h1:nth-child(1)
${SECTION_TITLE_FILMES_EM_CARTAZ}    xpath=/html/body/div/main/div/div[2]/div
${BTN_VER_TODOS_FILMES}              css=a.btn-primary:nth-child(1)
${FIRST_MOVIE_CARD}                  css=div.movie-card:nth-child(1)
${BTN_VER_DETALHES_FIRST_MOVIE}      css=div.movie-card:nth-child(1) > div:nth-child(2) > a:nth-child(5)
${SECTION_TITLE_HOME_PAGE}           css=.home-container > h1:nth-child(1)

*** Keywords ***
Navegar Para Cadastro
    [Documentation]    Clica no link 'Cadastrar' no cabeçalho.
    Click    ${HEADER_LINK_CADASTRO}
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /register

Navegar Para Login
    [Documentation]    Clica no link 'Login' ou 'Perfil' no cabeçalho.
    Click    ${HEADER_LINK_LOGIN}
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /login

Navegar Para Lista De Filmes da Página Inicial
    [Documentation]    Clica no link 'Filmes' no cabeçalho.
    Click    ${HEADER_LINK_FILMES}
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies

Navegar Para Inicio
    [Documentation]    Clica no link 'Inicio' no cabeçalho.
    Click    ${HEADER_LINK_HOME}
    Sleep    2s
    Wait For Elements State    ${SECTION_TITLE_HOME_PAGE}    visible    timeout=5s
    Get Text    ${SECTION_TITLE_HOME_PAGE}    ==    Welcome to Cinema App

Clicar na logo
    [Documentation]    Clica na logo e deve ir para a HomePage
    Click    ${HEADER_LINK_CINEMAAPP}
    Sleep    2s
    Wait For Elements State    ${SECTION_TITLE_HOME_PAGE}    visible    timeout=5s
    Get Text    ${SECTION_TITLE_HOME_PAGE}    ==    Welcome to Cinema App

Clicar Ver Todos Filmes Em Cartaz
    [Documentation]    Clica no botão/link "Ver Todos" na seção principal.
    Click    ${BTN_VER_TODOS_FILMES}
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies

Clicar No Detalhe Do Primeiro Filme
    [Documentation]    Clica no botão ou link de detalhes do primeiro card de filme.
    Click    ${BTN_VER_DETALHES_FIRST_MOVIE}

    
*** Settings ***
Library    Browser
Resource    ../../base.resource

*** Variables ***
${MOVIES_PAGE_URL}            ${FRONTEND_BASE_URL}/movies

${PAGE_TITLE_MOVIES}          css=.movies-container > h1:nth-child(1)
${MOVIES_GRID_CONTAINER}      xpath=/html/body/div/main/div/div[2] 

${MOVIE_CARD_ITEM}            css=div.movie-card:nth-child(1)
${MOVIE_CARD_TITLE}           css=div.movie-card:nth-child(1) > div:nth-child(2) > h3:nth-child(1)
${MOVIE_CARD_POSTER}          css=div.movie-card:nth-child(1) > div:nth-child(1) > img:nth-child(1)
${MOVIE_CARD_INFO_DETAILS}    css=div.movie-card:nth-child(1) > div:nth-child(2) > a:nth-child(5)
${MOVIE_CARD_SINOPSE}         css=div.movie-card:nth-child(1) > div:nth-child(2) > p:nth-child(4)

${INPUT_BUSCA_FILTRO}         css=.search-box > input:nth-child(1)
${BTN_APLICAR_FILTRO}         css=.genre-filter > select:nth-child(2)

*** Keywords ***
Navegar Para Lista De Filmes
    [Documentation]    Navega diretamente para a URL da página de listagem.
    Go To    ${MOVIES_PAGE_URL}
    Wait For Elements State    ${MOVIES_GRID_CONTAINER}    visible

Validar Presenca Filmes Na Lista
    [Documentation]    Verifica se a lista de filmes contém pelo menos um item.
    Wait For Elements State    ${MOVIE_CARD_ITEM}    visible    timeout=10s
    Get Element Count    ${MOVIE_CARD_ITEM}    >=    1

Validar Detalhes Essenciais Do Filme
    [Documentation]    Verifica se elementos essenciais (Pôster, Título) estão presentes no primeiro filme.
    # O seletor é baseado no primeiro card da lista.
    Wait For Elements State    ${MOVIE_CARD_TITLE}:nth-child(1)    visible
    Wait For Elements State    ${MOVIE_CARD_POSTER}:nth-child(1)    visible
    
    # Exemplo de extração do título (Para usar em um teste de detalhes posterior)
    ${Titulo}    Get Text    ${MOVIE_CARD_TITLE}:nth-child(1)
    Log    Título do primeiro filme: ${Titulo}

Clicar No Card Do Primeiro Filme
    [Documentation]    Clica no primeiro card de filme para ir para a página de Detalhes.
    Click    ${MOVIE_CARD_ITEM}:nth-child(1)

Aplicar Filtro De Busca
    [Arguments]    ${termo_busca}
    [Documentation]    Digita um termo e aplica o filtro.
    Fill Text    ${INPUT_BUSCA_FILTRO}    ${termo_busca}
    Press Keys    ${INPUT_BUSCA_FILTRO}    Enter

Validar Resultado Da Busca
    [Arguments]    ${termo_busca}
    [Documentation]    Verifica se os resultados contêm o termo buscado.
    Sleep    2s
    ${page_text}=    Get Text    ${MOVIES_GRID_CONTAINER}
    Should Contain    ${page_text}    ${termo_busca}    ignore_case=True

Validar Layout Responsivo (Móvel)
    [Documentation]    Redimensiona a tela para simular um dispositivo móvel (CT-MOVIE-019).
    ${MOBILE_WIDTH}    Set Variable    412    # Largura de um smartphone comum
    ${MOBILE_HEIGHT}    Set Variable    800
    Set ViewPort Size    ${MOBILE_WIDTH}    ${MOBILE_HEIGHT}

Aplicar Filtro Por Genero
    [Arguments]    ${genero}
    [Documentation]    Seleciona um gênero no filtro dropdown.
    Click    ${BTN_APLICAR_FILTRO}
    Select Options By    ${BTN_APLICAR_FILTRO}    text    ${genero}

Validar Resultado Do Filtro
    [Arguments]    ${genero}
    [Documentation]    Verifica se os filmes exibidos são do gênero selecionado.
    Sleep    2s
    ${movies_count}=    Get Element Count    ${MOVIE_CARD_ITEM}
    Should Be True    ${movies_count} > 0    msg=Nenhum filme encontrado para o gênero ${genero}

Clicar Ver Detalhes Do Filme
    [Documentation]    Clica no botão "Ver Detalhes" do primeiro filme.
    Click    ${MOVIE_CARD_INFO_DETAILS}

Validar Redirecionamento Para Detalhes
    [Documentation]    Verifica se foi redirecionado para a página de detalhes do filme.
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies/
    Should Not Contain    ${current_url}    /movies$
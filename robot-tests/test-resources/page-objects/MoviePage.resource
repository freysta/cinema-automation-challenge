*** Settings ***
Library    Browser
Resource    ../../base.resource

*** Variables ***
${DETAIL_PAGE_MOVIE_URL}      ${FRONTEND_BASE_URL}/movies

${MOVIE_TITLE}                css=.movie-info > h1:nth-child(1)
${MOVIE_POSTER}               xpath=/html/body/div/main/div/div/div/div[1]
${MOVIE_SYNOPSIS}             css=.movie-synopsis > p:nth-child(2)
${MOVIE_GENRE}                xpath=/html/body/div/main/div/div/div/div[2]/div[2]/span
${MOVIE_DIRETOR}              xpath=/html/body/div/main/div/div/div/div[2]/div[3]

${MOVIE_DURACAO}              css=.movie-meta > span:nth-child(2)
${MOVIE_DATA}                 css=.movie-meta > span:nth-child(3)
${MOVIE_SESSÕES}              css=.sessions-container > h2:nth-child(1)

${NO_SESSION}                 xpath=/html/body/div/main/div/div/div/div[2]/div[5]/p

${BTN_SELECIONAR_ASSENTOS}    css=div.session-card:nth-child(1) > a:nth-child(2)
${BTN_VOLTAR_FILMES}          css=a.btn:nth-child(7)

${SESSION_ITEM}               xpath=/html/body/div/main/div/div/div/div[2]/div[5]/div/div/div

*** Keywords ***
Clicar Em Selecionar Assentos Da Primeira Sessao
    [Documentation]    Clica no botão de reserva da primeira sessão listada.
    Wait For Elements State    ${BTN_SELECIONAR_ASSENTOS}    visible
    Click    ${BTN_SELECIONAR_ASSENTOS}

Validar Redirecionamento Para Assentos
    [Documentation]    Verifica se foi redirecionado para a página de seleção de assentos.
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /sessions/

Validar Detalhes Completos Do Filme
    [Documentation]    Verifica se todos os detalhes do filme estão presentes.
    Wait For Elements State    ${MOVIE_TITLE}        visible
    Wait For Elements State    ${MOVIE_POSTER}       visible
    Wait For Elements State    ${MOVIE_SYNOPSIS}     visible
    Wait For Elements State    ${MOVIE_GENRE}        visible
    Wait For Elements State    ${MOVIE_DIRETOR}      visible
    Wait For Elements State    ${MOVIE_DURACAO}      visible
    Wait For Elements State    ${MOVIE_DATA}         visible
    Validar Presenca Horarios De Sessao

Validar Presenca Horarios De Sessao
    [Documentation]    Verifica se há sessões disponíveis ou mensagem de ausência.
    Sleep    3s
    ${session_count}=    Get Element Count    ${SESSION_ITEM}
    IF    ${session_count} == 0
        ${no_session_text}=    Get Text    ${NO_SESSION}
        Should Contain Any    ${no_session_text}    Não há sessões disponíveis    Nenhuma sessão encontrada
    ELSE
        Validar Dados Da Primeira Sessao
    END
    
Validar Dados Da Primeira Sessao
    [Documentation]    Verifica formato do teatro e horário na primeira sessão.
    ${session_text}=    Get Text    ${SESSION_ITEM}
    Should Match Regexp    ${session_text}    \\d{2}:\\d{2}
    Should Contain    ${session_text}    Theater
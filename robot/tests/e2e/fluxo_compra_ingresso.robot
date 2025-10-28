*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/main_api.robot
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/web/home_page.robot
Resource    ../../resources/web/common_web.robot
Library    JSONLibrary

Suite Setup    Setup E2E Environment
Suite Teardown    Teardown E2E Environment

*** Test Cases ***
Teste Fluxo Compra Ingresso E2E - Sessao Lotada
    # Setup via API já feito no Suite Setup
    Navegar Para    ${URL}
    Fazer Login    user@test.com    user123
    Verificar Login Bem Sucedido
    # Tentar comprar ingresso para sessão lotada (via API, pois UI pode não mostrar sessões lotadas)
    ${token_user}=    Login And Get Token    user@test.com    user123
    Comprar Ingresso Para Sessao Lotada    ${token_user}    ${SESSION_FULL_ID}
    # Verificar na UI que não há sessões lotadas disponíveis ou mensagem de erro

Teste Fluxo Compra Ingresso E2E - Compra Bem Sucedida
    Navegar Para    ${URL}
    Fazer Login    user@test.com    user123
    Verificar Login Bem Sucedido
    Verificar Lista Filmes Carregada
    Clicar Primeiro Filme
    # Assumindo que há botão para comprar ingresso na página do filme
    # Clicar Botao Comprar Ingresso  # Placeholder - implementar se existir
    # Verificar Pagina Sessao
    # Selecionar Sessao Disponivel
    # Clicar Confirmar Compra
    # Verificar Mensagem Sucesso Compra
    # Validar via API que estoque decrementou
    ${token_user}=    Login And Get Token    user@test.com    user123
    ${ticket_id}=    Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${SESSION_ID}
    Should Not Be Empty    ${ticket_id}

Teste Fluxo Compra Ingresso E2E - Concorrencia
    # Simular concorrência via API (UI não suporta concorrência real)
    ${token_user1}=    Login And Get Token    user1@test.com    user123
    ${token_user2}=    Login And Get Token    user2@test.com    user123
    Tentar Compra Concorrente Para Ultimo Assento    ${token_user1}    ${token_user2}    ${SESSION_ONE_SEAT_ID}

*** Keywords ***
Login And Get Token
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${BASE_URL}/auth/login    json=${payload}    expected_status=200
    [Return]    ${response.json()}[token]

Setup E2E Environment
    # Criar usuários de teste via API
    ${token_admin}=    Login And Get Token    admin@test.com    admin123
    ${user1_id}=    Create User And Get Id    ${token_admin}    user1@test.com    user123    user
    ${user2_id}=    Create User And Get Id    ${token_admin}    user2@test.com    user123    user
    # Criar filme via API
    ${movie_id}=    Cadastrar Filme Com Token Admin    ${token_admin}
    # Criar sessões via API
    ${session_full_id}=    Create Session Full And Get Id    ${token_admin}
    ${session_id}=    Create Session And Get Id    ${token_admin}
    ${session_one_seat_id}=    Create Session One Seat And Get Id    ${token_admin}
    # Definir variáveis globais para os testes
    Set Suite Variable    ${TOKEN_ADMIN}    ${token_admin}
    Set Suite Variable    ${MOVIE_ID}    ${movie_id}
    Set Suite Variable    ${SESSION_FULL_ID}    ${session_full_id}
    Set Suite Variable    ${SESSION_ID}    ${session_id}
    Set Suite Variable    ${SESSION_ONE_SEAT_ID}    ${session_one_seat_id}
    Set Suite Variable    ${USER1_ID}    ${user1_id}
    Set Suite Variable    ${USER2_ID}    ${user2_id}

Teardown E2E Environment
    # Limpar dados criados
    ${token_admin}=    Set Variable    ${TOKEN_ADMIN}
    Run Keyword If    '${MOVIE_ID}' != ''    Delete Movie    ${token_admin}    ${MOVIE_ID}
    Run Keyword If    '${SESSION_FULL_ID}' != ''    Delete Session    ${token_admin}    ${SESSION_FULL_ID}
    Run Keyword If    '${SESSION_ID}' != ''    Delete Session    ${token_admin}    ${SESSION_ID}
    Run Keyword If    '${SESSION_ONE_SEAT_ID}' != ''    Delete Session    ${token_admin}    ${SESSION_ONE_SEAT_ID}
    Run Keyword If    '${USER1_ID}' != ''    Delete User    ${token_admin}    ${USER1_ID}
    Run Keyword If    '${USER2_ID}' != ''    Delete User    ${token_admin}    ${USER2_ID}

Create Session Full And Get Id
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Load JSON From File    ../../data/payloads.json
    ${session_payload}=    Get Value From JSON    ${payload}    $.session_full
    ${response}=    POST    ${BASE_URL}/sessions    headers=${headers}    json=${session_payload}    expected_status=201
    [Return]    ${response.json()}[id]

Create Session And Get Id
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Load JSON From File    ../../data/payloads.json
    ${session_payload}=    Get Value From JSON    ${payload}    $.session
    ${response}=    POST    ${BASE_URL}/sessions    headers=${headers}    json=${session_payload}    expected_status=201
    [Return]    ${response.json()}[id]

Create Session One Seat And Get Id
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    movieId=${MOVIE_ID}    room=Sala 3    date=2023-12-01T20:00:00Z    availableSeats=1
    ${response}=    POST    ${BASE_URL}/sessions    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[id]

Create User And Get Id
    [Arguments]    ${token_admin}    ${email}    ${password}    ${role}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    email=${email}    password=${password}    role=${role}
    ${response}=    POST    ${BASE_URL}/users    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[id]

Delete Movie
    [Arguments]    ${token_admin}    ${movie_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}
    DELETE    ${BASE_URL}/movies/${movie_id}    headers=${headers}

Delete Session
    [Arguments]    ${token_admin}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}
    DELETE    ${BASE_URL}/sessions/${session_id}    headers=${headers}

Delete User
    [Arguments]    ${token_admin}    ${user_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}
    DELETE    ${BASE_URL}/users/${user_id}    headers=${headers}

*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/main_api.robot
Library    JSONLibrary

*** Test Cases ***
Teste Comprar Ingresso Para Sessao Lotada
    ${token_user}=    Login And Get Token    user@test.com    user123
    ${session_id}=    Create Session Full And Get Id    ${token_admin}
    Comprar Ingresso Para Sessao Lotada    ${token_user}    ${session_id}

Teste Comprar Ingresso Com Sucesso e Validar Estoque
    ${token_user}=    Login And Get Token    user@test.com    user123
    ${session_id}=    Create Session And Get Id    ${token_admin}
    ${ticket_id}=    Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    Should Not Be Empty    ${ticket_id}

Teste Tentar Compra Concorrente Para Ultimo Assento
    ${token_user1}=    Login And Get Token    user1@test.com    user123
    ${token_user2}=    Login And Get Token    user2@test.com    user123
    ${session_id}=    Create Session One Seat And Get Id    ${token_admin}
    Tentar Compra Concorrente Para Ultimo Assento    ${token_user1}    ${token_user2}    ${session_id}

*** Keywords ***
Login And Get Token
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${BASE_URL}/auth/login    json=${payload}    expected_status=200
    [Return]    ${response.json()}[token]

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
    ${payload}=    Create Dictionary    movieId=1    room=Sala 3    date=2023-12-01T20:00:00Z    availableSeats=1
    ${response}=    POST    ${BASE_URL}/sessions    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[id]

*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Criar Sessao Com Token Admin
    [Arguments]    ${token_admin}    ${movie_id}    ${theater_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    movieId=${movie_id}    theaterId=${theater_id}    time=2025-12-31T19:00:00Z    fullPrice=25.00    halfPrice=12.50
    ${response}=    POST    ${BASE_URL}/sessions    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[data][_id]

Listar Sessoes
    ${response}=    GET    ${BASE_URL}/sessions    expected_status=200
    [Return]    ${response.json()}[data]

Obter Sessao Por ID
    [Arguments]    ${session_id}
    ${response}=    GET    ${BASE_URL}/sessions/${session_id}    expected_status=200
    [Return]    ${response.json()}[data]

Atualizar Sessao Por ID
    [Arguments]    ${token_admin}    ${session_id}    ${updated_payload}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/sessions/${session_id}    headers=${headers}    json=${updated_payload}    expected_status=200
    [Return]    ${response.json()}[data]

Deletar Sessao Por ID
    [Arguments]    ${token_admin}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    DELETE    ${BASE_URL}/sessions/${session_id}    headers=${headers}    expected_status=200

Reset Seats In Session
    [Arguments]    ${token_admin}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/sessions/${session_id}/reset-seats    headers=${headers}    expected_status=200
    [Return]    ${response.json()}[data]

Reset Seats In Session And Expect Failure
    [Arguments]    ${token_admin}    ${session_id}    ${expected_status_code}    ${expected_message}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/sessions/${session_id}/reset-seats    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

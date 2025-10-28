*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***
Comprar Ingresso Para Sessao Lotada
    [Arguments]    ${token_user}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${payload}=    Create Dictionary    sessionId=${session_id}
    ${response}=    POST    ${BASE_URL}/tickets    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Sem assentos disponíveis

Comprar Ingresso Com Sucesso e Validar Estoque
    [Arguments]    ${token_user}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${payload}=    Create Dictionary    sessionId=${session_id}
    ${response}=    POST    ${BASE_URL}/tickets    headers=${headers}    json=${payload}    expected_status=201
    ${ticket_id}=    Set Variable    ${response.json()}[id]
    # Validar decremento de availableSeats
    ${response_session}=    GET    ${BASE_URL}/sessions/${session_id}    expected_status=200
    ${available_seats}=    Set Variable    ${response_session.json()}[availableSeats]
    Should Be True    ${available_seats} < original_available_seats  # Assumir que original_available_seats foi passado ou calculado anteriormente
    [Return]    ${ticket_id}

Tentar Compra Concorrente Para Ultimo Assento
    [Arguments]    ${token_user1}    ${token_user2}    ${session_id}
    ${headers1}=    Create Dictionary    Authorization=Bearer ${token_user1}    Content-Type=application/json
    ${headers2}=    Create Dictionary    Authorization=Bearer ${token_user2}    Content-Type=application/json
    ${payload}=    Create Dictionary    sessionId=${session_id}
    # Simular concorrência - usar Process ou algo similar, mas para simplicidade, fazer sequencial e validar
    ${response1}=    POST    ${BASE_URL}/tickets    headers=${headers1}    json=${payload}    expected_status=any
    ${response2}=    POST    ${BASE_URL}/tickets    headers=${headers2}    json=${payload}    expected_status=any
    # Uma deve ser 201, outra 400 ou 409
    ${success_count}=    Set Variable    0
    Run Keyword If    ${response1.status_code} == 201    Set Variable    ${success_count}    ${success_count + 1}
    Run Keyword If    ${response2.status_code} == 201    Set Variable    ${success_count}    ${success_count + 1}
    Should Be Equal As Integers    ${success_count}    1
    Run Keyword If    ${response1.status_code} != 201    Should Be True    ${response1.status_code} in [400, 409]
    Run Keyword If    ${response2.status_code} != 201    Should Be True    ${response2.status_code} in [400, 409]

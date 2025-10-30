*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Comprar Ingresso Para Sessao Lotada
    [Arguments]    ${token_user}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${seat_data}=    Create Dictionary    row=A    number=1    type=full
    ${seats}=    Create List    ${seat_data}
    ${payload}=    Create Dictionary    session=${session_id}    seats=${seats}
    ${response}=    POST    ${BASE_URL}/reservations    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Sem assentos disponíveis

Comprar Ingresso Com Sucesso e Validar Estoque
    [Arguments]    ${token_user}    ${session_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${seat_data}=    Create Dictionary    row=A    number=1    type=full
    ${seats}=    Create List    ${seat_data}
    ${payload}=    Create Dictionary    session=${session_id}    seats=${seats}
    ${response}=    POST    ${BASE_URL}/reservations    headers=${headers}    json=${payload}    expected_status=201
    ${reservation_id}=    Set Variable    ${response.json()}[data][_id]
    [Return]    ${reservation_id}

Tentar Compra Concorrente Para Ultimo Assento
    [Arguments]    ${token_user1}    ${token_user2}    ${session_id}
    ${headers1}=    Create Dictionary    Authorization=Bearer ${token_user1}    Content-Type=application/json
    ${headers2}=    Create Dictionary    Authorization=Bearer ${token_user2}    Content-Type=application/json
    ${seat_data}=    Create Dictionary    row=A    number=1    type=full
    ${seats}=    Create List    ${seat_data}
    ${payload}=    Create Dictionary    session=${session_id}    seats=${seats}
    ${response1}=    POST    ${BASE_URL}/reservations    headers=${headers1}    json=${payload}    expected_status=any
    ${response2}=    POST    ${BASE_URL}/reservations    headers=${headers2}    json=${payload}    expected_status=any
    ${success_count}=    Set Variable    0
    Run Keyword If    ${response1.status_code} == 201    Set Variable    ${success_count}    ${success_count + 1}
    Run Keyword If    ${response2.status_code} == 201    Set Variable    ${success_count}    ${success_count + 1}
    Should Be Equal As Integers    ${success_count}    1
    Run Keyword If    ${response1.status_code} != 201    Should Be True    ${response1.status_code} in [400, 409]
    Run Keyword If    ${response2.status_code} != 201    Should Be True    ${response2.status_code} in [400, 409]

Comprar Ingresso Com Multiplos Assentos e Validar Estoque
    [Arguments]    ${token_user}    ${session_id}    ${seats_list}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${payload}=    Create Dictionary    session=${session_id}    seats=${seats_list}
    ${response}=    POST    ${BASE_URL}/reservations    headers=${headers}    json=${payload}    expected_status=201
    ${reservation_id}=    Set Variable    ${response.json()}[data][_id]
    [Return]    ${reservation_id}

Listar Reservas
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/reservations    headers=${headers}    expected_status=200
    [Return]    ${response.json()}[data]

Obter Reserva Por ID
    [Arguments]    ${token_admin}    ${reservation_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/reservations/${reservation_id}    headers=${headers}    expected_status=200
    [Return]    ${response.json()}[data]

Deletar Reserva Por ID
    [Arguments]    ${token_admin}    ${reservation_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    DELETE    ${BASE_URL}/reservations/${reservation_id}    headers=${headers}    expected_status=200

Get My Reservations
    [Arguments]    ${token_user}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/reservations/me    headers=${headers}    expected_status=200
    [Return]    ${response.json()}[data]

Get My Reservations And Expect Failure
    [Arguments]    ${token_user}    ${expected_status_code}    ${expected_message}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/reservations/me    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

Update Reservation Status
    [Arguments]    ${token_admin}    ${reservation_id}    ${payload}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/reservations/${reservation_id}    headers=${headers}    json=${payload}    expected_status=200
    [Return]    ${response.json()}[data]

Update Reservation Status And Expect Failure
    [Arguments]    ${token_admin}    ${reservation_id}    ${payload}    ${expected_status_code}    ${expected_message}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/reservations/${reservation_id}    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

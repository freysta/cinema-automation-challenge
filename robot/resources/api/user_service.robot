*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Get JSON Headers
    ${headers}=    Create Dictionary    Content-Type=application/json
    [Return]    ${headers}

Listar Usuarios
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/users    headers=${headers}    expected_status=200
    [Return]    ${response.json()}[data]

Obter Usuario Por ID
    [Arguments]    ${token_admin}    ${user_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/users/${user_id}    headers=${headers}    expected_status=200
    [Return]    ${response.json()}[data]

Atualizar Usuario Por ID
    [Arguments]    ${token_admin}    ${user_id}    ${updated_payload}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/users/${user_id}    headers=${headers}    json=${updated_payload}    expected_status=200
    [Return]    ${response.json()}[data]

Deletar Usuario Por ID
    [Arguments]    ${token_admin}    ${user_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    DELETE    ${BASE_URL}/users/${user_id}    headers=${headers}    expected_status=200

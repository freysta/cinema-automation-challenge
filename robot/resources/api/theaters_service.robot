*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    FakerLibrary

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Cadastrar Teatro Com Token Admin
    [Arguments]    ${token_admin}
    ${theater_name}=    FakerLibrary.Word
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    name=${theater_name}    capacity=100    type=standard
    ${response}=    POST    ${BASE_URL}/theaters    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[data][_id]

Listar Teatros
    ${response}=    GET    ${BASE_URL}/theaters    expected_status=200
    [Return]    ${response.json()}[data]

Tentar Cadastrar Teatro Com Token User
    [Arguments]    ${token_user}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${payload}=    Create Dictionary    name=Sala Teste    capacity=100    location=Cinema Central
    ${response}=    POST    ${BASE_URL}/theaters    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    403
    Should Be Equal As Strings    ${response.json()}[message]    User role user is not authorized to access this route

Tentar Cadastrar Teatro Sem Nome
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    capacity=100    type=standard
    ${response}=    POST    ${BASE_URL}/theaters    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Validation failed

Tentar Cadastrar Teatro Com Tipo Invalido
    [Arguments]    ${token_admin}
    ${theater_name}=    FakerLibrary.Word
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    name=${theater_name}    capacity=100    type=INVALID_TYPE
    ${response}=    POST    ${BASE_URL}/theaters    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Validation failed

Obter Teatro Por ID
    [Arguments]    ${theater_id}
    ${response}=    GET    ${BASE_URL}/theaters/${theater_id}    expected_status=200
    [Return]    ${response.json()}[data]

Atualizar Teatro Por ID
    [Arguments]    ${token_admin}    ${theater_id}    ${updated_payload}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    Log    Updating theater with ID: ${theater_id} with payload: ${updated_payload}
    ${response}=    PUT    ${BASE_URL}/theaters/${theater_id}    headers=${headers}    json=${updated_payload}    expected_status=200
    [Return]    ${response.json()}[data]

Deletar Teatro Por ID
    [Arguments]    ${token_admin}    ${theater_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    DELETE    ${BASE_URL}/theaters/${theater_id}    headers=${headers}    expected_status=200

*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***
Tentar Cadastrar Filme Sem Titulo
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    description=Descrição    duration=120
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Título é obrigatório

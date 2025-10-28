*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***
Tentar Acessar Rota Sem Token
    [Arguments]    ${url}    ${method}=GET
    ${headers}=    Create Dictionary
    Run Keyword And Expect Error    *401*    ${method}    ${BASE_URL}${url}    headers=${headers}
    ${response}=    ${method}    ${BASE_URL}${url}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[message]    Token ausente ou inválido

Tentar Acessar Rota Com Token Inválido
    [Arguments]    ${url}    ${method}=GET
    ${headers}=    Create Dictionary    Authorization=Bearer invalid_token
    ${response}=    ${method}    ${BASE_URL}${url}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[message]    Token inválido

Tentar Cadastrar Filme Com Token User
    [Arguments]    ${token_user}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${payload}=    Create Dictionary    title=Filme Teste    description=Descrição    duration=120
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    403
    Should Be Equal As Strings    ${response.json()}[message]    Permissão negada

Tentar Listar Todos Usuarios Com Token User
    [Arguments]    ${token_user}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}
    ${response}=    GET    ${BASE_URL}/users    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    403
    Should Be Equal As Strings    ${response.json()}[message]    Permissão negada

Cadastrar Filme Com Token Admin
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    title=Filme Teste    description=Descrição    duration=120
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[id]

Tentar Cadastrar Usuario Sem Email
    ${payload}=    Create Dictionary    password=123456    role=user
    ${response}=    POST    ${BASE_URL}/auth/register    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Email é obrigatório

Validar Idempotencia Delete Usuario
    [Arguments]    ${token_admin}    ${user_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}
    ${response1}=    DELETE    ${BASE_URL}/users/${user_id}    headers=${headers}    expected_status=200
    ${response2}=    DELETE    ${BASE_URL}/users/${user_id}    headers=${headers}    expected_status=any
    Should Be True    ${response2.status_code} in [404, 200]
    Run Keyword If    ${response2.status_code} == 200    Should Be Equal As Strings    ${response2.json()}[message]    Usuário não encontrado

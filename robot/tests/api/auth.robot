*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/main_api.robot
Library    JSONLibrary

*** Test Cases ***
Teste Tentar Acessar Rota Sem Token
    Tentar Acessar Rota Sem Token    /tickets    POST

Teste Tentar Acessar Rota Com Token Inválido
    Tentar Acessar Rota Com Token Inválido    /tickets    POST

Teste Tentar Cadastrar Filme Com Token User
    ${token_user}=    Login And Get Token    user@test.com    user123
    Tentar Cadastrar Filme Com Token User    ${token_user}

Teste Tentar Listar Todos Usuarios Com Token User
    ${token_user}=    Login And Get Token    user@test.com    user123
    Tentar Listar Todos Usuarios Com Token User    ${token_user}

Teste Cadastrar Filme Com Token Admin
    ${token_admin}=    Login And Get Token    admin@test.com    admin123
    ${movie_id}=    Cadastrar Filme Com Token Admin    ${token_admin}
    Should Not Be Empty    ${movie_id}

Teste Tentar Cadastrar Usuario Sem Email
    Tentar Cadastrar Usuario Sem Email

Teste Validar Idempotencia Delete Usuario
    ${token_admin}=    Login And Get Token    admin@test.com    admin123
    ${user_id}=    Create User And Get Id    ${token_admin}    testuser@test.com    testpass    user
    Validar Idempotencia Delete Usuario    ${token_admin}    ${user_id}

*** Keywords ***
Login And Get Token
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${BASE_URL}/auth/login    json=${payload}    expected_status=200
    [Return]    ${response.json()}[token]

Create User And Get Id
    [Arguments]    ${token_admin}    ${email}    ${password}    ${role}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    email=${email}    password=${password}    role=${role}
    ${response}=    POST    ${BASE_URL}/users    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[id]

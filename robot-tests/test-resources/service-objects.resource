# Keywords da API
*** Settings ***
Resource    ../base.resource 

*** Variables ***
${AUTH_ENDPOINT}        /auth

*** Keywords ***
Conectar à API
    [Documentation]    Cria uma sessão HTTP persistente chamada 'cinema_api' com o URL Base.
    Create Session    cinema_api    ${BASE_URL_API}

Registrar Novo Usuário
    [Arguments]    ${nome}    ${email}    ${senha}
    
    ${body}=    Create Dictionary    name=${nome}    email=${email}    password=${senha}
    
    ${response}=    POST On Session    cinema_api    ${AUTH_ENDPOINT}/register    json=${body}    headers=${HEADERS_NO_AUTH}  
    
    RETURN    ${response}

Verificar Registro Bem Sucedido e Token
    [Arguments]    ${response}

    Should Be Equal As Integers    ${response.status_code}    201    Status code do registro não é 201 (Created)

    ${response_json}=    Set Variable    ${response.json()}
    
    Dictionary Should Contain Key    ${response_json['data']}    token

    Should Be True    ${response_json['success']}    A chave 'success' não é True

    ${auth_token}=    Set Variable    ${response_json['data']['token']}
    Set Suite Variable    ${AUTH_TOKEN}    ${auth_token}

Garantir Que Usuário Existe
    [Arguments]    ${nome}    ${email}    ${senha}
    [Documentation]    Registra um usuário se ele não existir ainda
    
    ${response}=    Tentar Registrar Usuário    ${nome}    ${email}    ${senha}
    Should Be True    ${response.status_code} == 201 or ${response.status_code} == 400

Tentar Registrar Usuário
    [Arguments]    ${nome}    ${email}    ${senha}
    [Documentation]    Tenta registrar usuário aceitando tanto sucesso quanto erro
    
    ${body}=    Create Dictionary    name=${nome}    email=${email}    password=${senha}
    ${response}=    POST On Session    cinema_api    ${AUTH_ENDPOINT}/register    
    ...    json=${body}    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Fazer Login
    [Arguments]    ${email}    ${senha}
    [Documentation]    Realiza login com email e senha
    
    ${body}=    Create Dictionary    email=${email}    password=${senha}
    ${response}=    POST On Session    cinema_api    ${AUTH_ENDPOINT}/login    
    ...    json=${body}    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Buscar Perfil Sem Token
    [Documentation]    Tenta acessar perfil sem token de autenticação
    
    ${response}=    GET On Session    cinema_api    ${AUTH_ENDPOINT}/me    
    ...    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Atualizar Perfil Com Token
    [Arguments]    ${token}    ${dados}
    [Documentation]    Atualiza perfil do usuário com token de autenticação
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    PUT On Session    cinema_api    ${AUTH_ENDPOINT}/profile 
    ...    json=${dados}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Buscar Lista de Filmes
    [Arguments]    ${token}
    [Documentation]    Busca lista de filmes com token de autenticação
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET On Session    cinema_api    /movies    
    ...    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Buscar Filme Por ID
    [Arguments]    ${token}    ${movie_id}
    [Documentation]    Busca filme específico por ID
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET On Session    cinema_api    /movies/${movie_id}    
    ...    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Tentar Criar Filme
    [Arguments]    ${token}
    [Documentation]    Tenta criar um filme e retorna a resposta completa
    
    &{movie_data}=    Create Dictionary
    ...    title=Filme Teste
    ...    genre=Action
    ...    duration=120
    ...    rating=PG-13
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST On Session    cinema_api    /movies
    ...    json=${movie_data}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Criar Sessão
    [Arguments]    ${token}    ${movie_id}
    [Documentation]    Cria uma sessão real e retorna o ID
    
    &{session_data}=    Create Dictionary
    ...    movie=${movie_id}
    ...    date=2024-12-31
    ...    time=20:00
    ...    room=1
    ...    price=25.00
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST On Session    cinema_api    /sessions
    ...    json=${session_data}    headers=${headers_auth}    expected_status=any
    
    ${session_id}=    Set Variable    ${response.json()['data']['_id']}
    RETURN    ${session_id}

Buscar Lista de Teatros
    [Documentation]    Busca lista de teatros sem autenticação
    
    ${response}=    GET On Session    cinema_api    /theaters    
    ...    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Buscar Teatro Por ID
    [Arguments]    ${theater_id}
    [Documentation]    Busca teatro específico por ID sem autenticação
    
    ${response}=    GET On Session    cinema_api    /theaters/${theater_id}    
    ...    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Buscar Lista de Sessões
    [Documentation]    Busca lista de sessões sem autenticação
    
    ${response}=    GET On Session    cinema_api    /sessions    
    ...    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Tentar Criar Reserva Sem Autenticação
    [Arguments]    ${reservation_data}
    [Documentation]    Tenta criar reserva sem token de autenticação
    
    ${response}=    POST On Session    cinema_api    /reservations    
    ...    json=${reservation_data}    headers=${HEADERS_NO_AUTH}    expected_status=any
    
    RETURN    ${response}

Criar Filme Como Admin
    [Arguments]    ${token}    ${movie_data}
    [Documentation]    Cria um filme como admin e retorna a resposta completa
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST On Session    cinema_api    /movies
    ...    json=${movie_data}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Atualizar Filme Como Admin
    [Arguments]    ${token}    ${movie_id}    ${movie_data}
    [Documentation]    Atualiza um filme como admin
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    PUT On Session    cinema_api    /movies/${movie_id}
    ...    json=${movie_data}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Deletar Filme Como Admin
    [Arguments]    ${token}    ${movie_id}
    [Documentation]    Deleta um filme como admin
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    DELETE On Session    cinema_api    /movies/${movie_id}
    ...    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Criar Sessão Como Admin
    [Arguments]    ${token}    ${session_data}
    [Documentation]    Cria uma sessão como admin
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST On Session    cinema_api    /sessions
    ...    json=${session_data}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Listar Usuários Como Admin
    [Arguments]    ${token}
    [Documentation]    Lista usuários como admin
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET On Session    cinema_api    /users
    ...    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Criar Teatro Como Admin
    [Arguments]    ${token}    ${theater_data}
    [Documentation]    Cria um teatro como admin
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST On Session    cinema_api    /theaters
    ...    json=${theater_data}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}

Criar Nova Reserva
    [Arguments]    ${token}    ${reservation_data}
    [Documentation]    Cria nova reserva com token de autenticação
    
    &{headers_auth}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST On Session    cinema_api    /reservations    
    ...    json=${reservation_data}    headers=${headers_auth}    expected_status=any
    
    RETURN    ${response}
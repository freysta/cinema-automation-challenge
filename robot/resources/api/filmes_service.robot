*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Cadastrar Filme Com Sucesso
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    title=Filme Teste    synopsis=Sinopse do filme teste    director=Diretor Teste    genres=${{"Action", "Comedy"}}    duration=120    classification=PG-13    releaseDate=2024-01-01
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=201
    [Return]    ${response.json()}[data][_id]

Listar Filmes
    ${response}=    GET    ${BASE_URL}/movies    expected_status=200
    [Return]    ${response.json()}[data]

Tentar Cadastrar Filme Sem Titulo
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    description=Descrição    duration=120
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Validation failed

Tentar Cadastrar Filme Com Duracao Invalida
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${payload}=    Create Dictionary    title=Filme Teste    description=Descrição    duration=-10
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Validation failed

Tentar Cadastrar Filme Com Titulo Muito Longo
    [Arguments]    ${token_admin}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${long_title}=    Generate Random String    1000    [ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ]
    ${payload}=    Create Dictionary    title=${long_title}    synopsis=Sinopse do filme teste    director=Diretor Teste    genres=${{"Action", "Comedy"}}    duration=120    classification=PG-13    releaseDate=2024-01-01
    ${response}=    POST    ${BASE_URL}/movies    headers=${headers}    json=${payload}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[message]    Validation failed

Obter Filme Por ID
    [Arguments]    ${movie_id}
    ${response}=    GET    ${BASE_URL}/movies/${movie_id}    expected_status=200
    [Return]    ${response.json()}[data]

Atualizar Filme Por ID
    [Arguments]    ${token_admin}    ${movie_id}    ${updated_payload}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    PUT    ${BASE_URL}/movies/${movie_id}    headers=${headers}    json=${updated_payload}    expected_status=200
    [Return]    ${response.json()}[data]

Deletar Filme Por ID
    [Arguments]    ${token_admin}    ${movie_id}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    DELETE    ${BASE_URL}/movies/${movie_id}    headers=${headers}    expected_status=200

*** Settings ***
Resource         ../base.resource
Resource         ../test-resources/service-objects.resource
Test Setup       Conectar à API

*** Test Cases ***
Listar Teatros como Visitante
    [Documentation]    Valida que a lista de teatros é retornada com paginação (Status 200 OK)
    
    ${response}=    Buscar Lista de Teatros

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    Dictionary Should Contain Key    ${response_json}    count
    
    ${theaters}=    Set Variable    ${response_json['data']}
    Should Be True    isinstance($theaters, list)
    Should Be True    ${response_json['count']} > 0
    
    Log    Listagem de teatros como visitante: SUCESSO

Buscar Teatro por ID como Visitante
    [Documentation]    Valida que os detalhes do teatro são retornados (Status 200 OK)
    
    ${theaters_response}=    Buscar Lista de Teatros
    Should Be Equal As Integers    ${theaters_response.status_code}    200
    
    ${theaters}=    Set Variable    ${theaters_response.json()['data']}
    Should Be True    len($theaters) > 0    msg=Nenhum teatro disponível para teste
    
    ${theater_id}=    Set Variable    ${theaters[0]['_id']}
    
    ${response}=    Buscar Teatro Por ID    ${theater_id}

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    
    ${theater}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${theater}    _id
    Dictionary Should Contain Key    ${theater}    name
    Dictionary Should Contain Key    ${theater}    capacity
    Should Be Equal    ${theater['_id']}    ${theater_id}
    
    Log    Busca de teatro por ID como visitante: SUCESSO

Buscar Teatro Inexistente por ID
    [Documentation]    Valida retorno 404 ao buscar teatro com ID inexistente
    
    ${id_inexistente}=    Set Variable    507f1f77bcf86cd799439011
    ${response}=    Buscar Teatro Por ID    ${id_inexistente}

    Should Be Equal As Integers    ${response.status_code}    404
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de teatro inexistente: SUCESSO

Listar Sessoes como Visitante
    [Documentation]    Valida o retorno da lista de sessões com paginação e estrutura de dados esperada
    
    ${response}=    Buscar Lista de Sessões

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    Dictionary Should Contain Key    ${response_json}    count
    Dictionary Should Contain Key    ${response_json}    pagination
    
    ${sessions}=    Set Variable    ${response_json['data']}
    Should Be True    isinstance($sessions, list)
    Should Be True    ${response_json['count']} > 0
    
    IF    len($sessions) > 0
        ${primeira_sessao}=    Set Variable    ${sessions[0]}
        Dictionary Should Contain Key    ${primeira_sessao}    _id
        Dictionary Should Contain Key    ${primeira_sessao}    movie
        Dictionary Should Contain Key    ${primeira_sessao}    theater
        Dictionary Should Contain Key    ${primeira_sessao}    datetime
        Dictionary Should Contain Key    ${primeira_sessao}    fullPrice
        Log    Estrutura da sessão validada
    ELSE
        Log    Lista de sessões está vazia
    END
    
    Log    Listagem de sessões como visitante: SUCESSO
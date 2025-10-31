*** Settings ***
Resource         ../base.resource
Resource         ../test-resources/service-objects.resource
Test Setup       Conectar à API

*** Test Cases ***
Listar Filmes
    [Documentation]    Valida estrutura do JSON ao listar filmes disponíveis
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${response}=    Buscar Lista de Filmes     ${token}

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    
    ${movies}=    Set Variable    ${response_json['data']}
    Should Be True    isinstance($movies, list)
    
    IF    len($movies) > 0
        ${primeiro_filme}=    Set Variable    ${movies[0]}
        Log    ESTRUTURA DO FILME: ${primeiro_filme}
        Dictionary Should Contain Key    ${primeiro_filme}    _id
        Dictionary Should Contain Key    ${primeiro_filme}    title
        Log    Estrutura do filme validada: ${primeiro_filme['title']}
    ELSE
        Log    Lista de filmes está vazia
    END
    
    Log    Listagem de filmes: SUCESSO

Buscar Filme Inexistente por ID
    [Documentation]    Valida retorno 404 ao buscar filme com ID inexistente
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${id_inexistente}=    Set Variable    507f1f77bcf86cd799439011
    ${response}=    Buscar Filme Por ID    ${token}    ${id_inexistente}

    Should Be Equal As Integers    ${response.status_code}    404
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de filme inexistente: SUCESSO

Buscar Filme Existente por ID
    [Documentation]    Valida retorno OK ao buscar filme com ID existente
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${movies_response}=    Buscar Lista de Filmes    ${token}
    Should Be Equal As Integers    ${movies_response.status_code}    200
    
    ${movies}=    Set Variable    ${movies_response.json()['data']}
    Should Be True    len($movies) > 0    msg=Nenhum filme disponível para teste
    
    ${movie_id}=    Set Variable    ${movies[0]['_id']}
    
    ${response}=    Buscar Filme Por ID    ${token}    ${movie_id}

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    
    ${filme}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${filme}    _id
    Dictionary Should Contain Key    ${filme}    title
    Should Be Equal    ${filme['_id']}    ${movie_id}
    
    Log    Busca de filme existente: SUCESSO

Tentar Criar Filme como Usuario Comum
    [Documentation]    Valida erro 403 ao tentar criar filme como usuário comum
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${response}=    Tentar Criar Filme    ${token}

    Should Be Equal As Integers    ${response.status_code}    403
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de segurança - usuário comum: SUCESSO
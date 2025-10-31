# Suíte de testes de Admin Security API
*** Settings ***
Resource         ../base.resource
Resource         ../test-resources/service-objects.resource
Test Setup       Conectar à API

*** Test Cases ***
Criar Novo Filme como Admin
    [Documentation]    CRUD Create: Criar um novo Filme (POST /movies) como Admin
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    &{movie_data}=    Create Dictionary
    ...    title=Filme Admin Teste 10
    ...    synopsis=Sinopse do filme criado pelo admin
    ...    director=Diretor Teste
    ...    genres=["Action", "Adventure"]
    ...    duration=120
    ...    classification=PG-13
    ...    poster=admin_test_movie.jpg
    ...    releaseDate=2024-12-31

    ${response}=    Criar Filme Como Admin    ${token}    ${movie_data}

    Should Be Equal As Integers    ${response.status_code}    201
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    
    ${movie}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${movie}    _id
    Dictionary Should Contain Key    ${movie}    title
    Dictionary Should Contain Key    ${movie}    director
    Should Be Equal    ${movie['title']}    Filme Admin Teste 10
    
    Log    Criação de filme como admin: SUCESSO

Atualizar Filme como Admin
    [Documentation]    CRUD Update: Buscar e Atualizar um filme existente como Admin
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    # Buscar um filme existente
    ${movies_response}=    Buscar Lista de Filmes    ${token}
    Should Be Equal As Integers    ${movies_response.status_code}    200
    
    ${movies}=    Set Variable    ${movies_response.json()['data']}
    Should Be True    len($movies) > 0    msg=Nenhum filme disponível para teste
    
    ${movie_id}=    Set Variable    ${movies[0]['_id']}
    
    # Atualizar o filme encontrado
    &{update_data}=    Create Dictionary
    ...    title=Filme Atualizado Admin
    ...    director=Diretor Atualizado
    ...    duration=110
    
    ${update_response}=    Atualizar Filme Como Admin    ${token}    ${movie_id}    ${update_data}
    Should Be Equal As Integers    ${update_response.status_code}    200
    
    ${updated_movie}=    Set Variable    ${update_response.json()['data']}
    Should Be Equal    ${updated_movie['title']}    Filme Atualizado Admin
    Should Be Equal    ${updated_movie['director']}    Diretor Atualizado
    
    Log    Atualização de filme existente: SUCESSO

Deletar Filme como Admin
    [Documentation]    CRUD Delete: Buscar e Deletar um filme existente como Admin
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    # Buscar um filme existente
    ${movies_response}=    Buscar Lista de Filmes    ${token}
    Should Be Equal As Integers    ${movies_response.status_code}    200
    
    ${movies}=    Set Variable    ${movies_response.json()['data']}
    Should Be True    len($movies) > 0    msg=Nenhum filme disponível para teste
    
    ${movie_id}=    Set Variable    ${movies[0]['_id']}
    
    # Deletar o filme
    ${delete_response}=    Deletar Filme Como Admin    ${token}    ${movie_id}
    Should Be Equal As Integers    ${delete_response.status_code}    200
    
    ${delete_json}=    Set Variable    ${delete_response.json()}
    Should Be Equal    ${delete_json['success']}    ${True}
    
    Log    Deleção de filme existente: SUCESSO

Criar Sessao como Admin
    [Documentation]    CRUD: Criar Sessão (POST /sessions) vinculada a um Filme e Teatro existentes
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    # Buscar um filme existente
    ${movies_response}=    Buscar Lista de Filmes    ${token}
    Should Be Equal As Integers    ${movies_response.status_code}    200
    
    ${movies}=    Set Variable    ${movies_response.json()['data']}
    Should Be True    len($movies) > 0    msg=Nenhum filme disponível
    ${movie_id}=    Set Variable    ${movies[0]['_id']}
    
    # Buscar um teatro existente
    ${theaters_response}=    Buscar Lista de Teatros
    Should Be Equal As Integers    ${theaters_response.status_code}    200
    
    ${theaters}=    Set Variable    ${theaters_response.json()['data']}
    Should Be True    len($theaters) > 0    msg=Nenhum teatro disponível
    ${theater_id}=    Set Variable    ${theaters[0]['_id']}
    
    # Criar sessão
    &{session_data}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id}
    ...    datetime=2025-11-11T20:00:00.000Z
    ...    fullPrice=25.00
    ...    halfPrice=12.50

    ${response}=    Criar Sessão Como Admin    ${token}    ${session_data}

    Should Be Equal As Integers    ${response.status_code}    201
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    
    ${session}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${session}    _id
    Dictionary Should Contain Key    ${session}    movie
    Dictionary Should Contain Key    ${session}    theater
    Dictionary Should Contain Key    ${session}    datetime
    
    Log    Criação de sessão como admin: SUCESSO

Listar Usuarios como Admin
    [Documentation]    CRUD: Listar Usuários (GET /users) como Admin e verificar a lista
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${response}=    Listar Usuários Como Admin    ${token}

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    Dictionary Should Contain Key    ${response_json}    count
    
    ${users}=    Set Variable    ${response_json['data']}
    Should Be True    isinstance($users, list)
    Should Be True    ${response_json['count']} > 0
    
    IF    len($users) > 0
        ${primeiro_usuario}=    Set Variable    ${users[0]}
        Dictionary Should Contain Key    ${primeiro_usuario}    _id
        Dictionary Should Contain Key    ${primeiro_usuario}    name
        Dictionary Should Contain Key    ${primeiro_usuario}    email
        Dictionary Should Contain Key    ${primeiro_usuario}    role
        Log    Estrutura do usuário validada: ${primeiro_usuario['name']}
    END
    
    Log    Listagem de usuários como admin: SUCESSO

Tentar Criar Sessao com Teatro ID Invalido
    [Documentation]    Segurança: Tentar Criar Sessão (POST /sessions) com Token de Admin, mas Teatro ID inválido
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    # Buscar um filme existente
    ${movies_response}=    Buscar Lista de Filmes    ${token}
    Should Be Equal As Integers    ${movies_response.status_code}    200
    
    ${movies}=    Set Variable    ${movies_response.json()['data']}
    Should Be True    len($movies) > 0    msg=Nenhum filme disponível
    ${movie_id}=    Set Variable    ${movies[0]['_id']}
    
    # Usar um teatro ID inválido
    ${theater_id_invalido}=    Set Variable    507f1f77bcf86cd799439011
    
    # Tentar criar sessão com teatro ID inválido
    &{session_data}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id_invalido}
    ...    datetime=2024-12-31T20:00:00.000Z
    ...    fullPrice=25.00
    ...    halfPrice=12.50

    ${response}=    Criar Sessão Como Admin    ${token}    ${session_data}

    Should Be Equal As Integers    ${response.status_code}    404
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de segurança - teatro ID inválido: SUCESSO

Criar Teatro como Admin
    [Documentation]    CRUD: Criar Teatro (POST /theaters) e validar a adição
    
    Garantir Que Usuário Existe    ${NOME_ADMIN}    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${login_response}=    Fazer Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    # Gerar nome aleatório para o teatro
    ${random_number}=    Evaluate    random.randint(10000, 99999)    modules=random
    ${theater_name}=    Set Variable    Teatro Admin ${random_number}

    &{theater_data}=    Create Dictionary
    ...    name=${theater_name}
    ...    capacity=150
    ...    type=3D

    ${response}=    Criar Teatro Como Admin    ${token}    ${theater_data}

    Should Be Equal As Integers    ${response.status_code}    201
    
    Log    Criação de teatro como admin: SUCESSO
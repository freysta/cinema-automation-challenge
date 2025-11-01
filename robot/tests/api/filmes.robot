*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/filmes_service.robot
Resource    ../../resources/api/admin_setup_service.robot
Resource    ../../resources/api/main_api.robot
Library    JSONLibrary


*** Test Cases ***
Teste Cadastrar Filme Com Sucesso
    [Tags]    Movies    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${movie_id}=    Cadastrar Filme Com Sucesso    ${token_admin}
    Should Not Be Empty    ${movie_id}

Teste Listar Filmes
    [Tags]    Movies    Positive
    ${movies}=    Listar Filmes
    Should Be True    ${movies} is not None

Teste Tentar Cadastrar Filme Sem Titulo
    [Tags]    Movies    Negative
    ${token_admin}=    Login User    admin@example.com    password123
    Tentar Cadastrar Filme Sem Titulo    ${token_admin}

Teste Tentar Cadastrar Filme Com Duracao Invalida
    [Tags]    Movies    Negative
    ${token_admin}=    Login User    admin@example.com    password123
    Tentar Cadastrar Filme Com Duracao Invalida    ${token_admin}

Teste Tentar Cadastrar Filme Com Titulo Muito Longo
    [Tags]    Movies    Robustness
    ${token_admin}=    Login User    admin@example.com    password123
    Tentar Cadastrar Filme Com Titulo Muito Longo    ${token_admin}

Teste Obter Filme Por ID
    [Tags]    Movies    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${movie_id}=    Cadastrar Filme Com Sucesso    ${token_admin}
    ${movie_data}=    Obter Filme Por ID    ${movie_id}
    Should Be Equal As Strings    ${movie_data}[_id]    ${movie_id}
    Should Be Equal As Strings    ${movie_data}[title]    Filme Teste

Teste Atualizar Filme Por ID
    [Tags]    Movies    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${movie_id}=    Cadastrar Filme Com Sucesso    ${token_admin}
    
    ${updated_title}=    Set Variable    Filme Atualizado
    ${updated_synopsis}=    Set Variable    Sinopse Atualizada
    ${updated_payload}=    Create Dictionary    title=${updated_title}    synopsis=${updated_synopsis}    director=Diretor Teste    genres=${{"Action", "Comedy"}}    duration=120    classification=PG-13    releaseDate=2024-01-01
    
    ${updated_movie_data}=    Atualizar Filme Por ID    ${token_admin}    ${movie_id}    ${updated_payload}
    
    Should Be Equal As Strings    ${updated_movie_data}[_id]    ${movie_id}
    Should Be Equal As Strings    ${updated_movie_data}[title]    ${updated_title}
    Should Be Equal As Strings    ${updated_movie_data}[synopsis]    ${updated_synopsis}

Teste Deletar Filme Por ID
    [Tags]    Movies    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${movie_id}=    Cadastrar Filme Com Sucesso    ${token_admin}
    Deletar Filme Por ID    ${token_admin}    ${movie_id}
    
    # Verify that the movie is no longer accessible
    ${response}=    GET    ${BASE_URL}/movies/${movie_id}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    404
    Should Be Equal As Strings    ${response.json()}[message]    Movie not found

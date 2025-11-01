*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/session_service.robot
Resource    ../../resources/api/filmes_service.robot
Resource    ../../resources/api/theaters_service.robot
Resource    ../../resources/api/main_api.robot

*** Test Cases ***
Teste Listar Sessoes
    [Tags]    Sessions    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${sessions}=    session_service.Listar Sessoes
    Should Be True    ${sessions} is not None
    Should Not Be Empty    ${sessions}

Teste Obter Sessao Por ID
    [Tags]    Sessions    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${session_data}=    session_service.Obter Sessao Por ID    ${session_id}
    Should Be Equal As Strings    ${session_data}[_id]    ${session_id}
    Should Be Equal As Strings    ${session_data}[movieId]    ${movie_id}
    Should Be Equal As Strings    ${session_data}[theaterId]    ${theater_id}

Teste Atualizar Sessao Por ID
    [Tags]    Sessions    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    
    ${updated_full_price}=    Set Variable    30.00
    ${updated_half_price}=    Set Variable    15.00
    ${updated_payload}=    Create Dictionary    fullPrice=${updated_full_price}    halfPrice=${updated_half_price}
    
    ${updated_session_data}=    session_service.Atualizar Sessao Por ID    ${token_admin}    ${session_id}    ${updated_payload}
    
    Should Be Equal As Strings    ${updated_session_data}[_id]    ${session_id}
    Should Be Equal As Strings    ${updated_session_data}[fullPrice]    ${updated_full_price}
    Should Be Equal As Strings    ${updated_session_data}[halfPrice]    ${updated_half_price}

Teste Deletar Sessao Por ID
    [Tags]    Sessions    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    session_service.Deletar Sessao Por ID    ${token_admin}    ${session_id}

    # Verify that the session is no longer accessible
    ${response}=    GET    ${BASE_URL}/sessions/${session_id}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    404
    Should Be Equal As Strings    ${response.json()}[message]    Session not found

Teste Resetar Assentos Da Sessao
    [Tags]    Sessions    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reset_session}=    session_service.Reset Seats In Session    ${token_admin}    ${session_id}
    Should Be Equal As Strings    ${reset_session}[_id]    ${session_id}

Teste Resetar Assentos Sem Permissao Admin
    [Tags]    Sessions    Negative
    ${token_user}=    auth_service.Login User    user@example.com    password123
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    session_service.Reset Seats In Session And Expect Failure    ${token_user}    ${session_id}    403    User role user is not authorized to access this route

Teste Resetar Assentos De Sessao Inexistente
    [Tags]    Sessions    Negative
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    session_service.Reset Seats In Session And Expect Failure    ${token_admin}    invalid_session_id    404    Session not found

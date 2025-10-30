*** Settings ***
Resource    ../../resources/api/session_service.robot
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/filmes_service.robot
Resource    ../../resources/api/reservations_service.robot
Resource    ../../resources/api/admin_setup_service.robot
Resource    ../../resources/api/theaters_service.robot
Resource    ../../resources/api/main_api.robot
Library    JSONLibrary
Library    FakerLibrary    WITH NAME    Faker
Suite Setup    Login Admin User

*** Variables ***
${token_admin}    ${EMPTY}

*** Keywords ***
Login Admin User
    ${token}=    Login User    admin@example.com    password123
    Set Suite Variable    ${token_admin}    ${token}

*** Test Cases ***
Teste Comprar Ingresso Para Sessao Lotada - Fluxo Completo
    [Tags]    Reservations    Negative
    ${token_user}=    Login User    user@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    # Agora tentar comprar para sessão lotada
    Comprar Ingresso Para Sessao Lotada    ${token_user}    ${session_id}

Teste Tentar Compra Concorrente Para Ultimo Assento
    [Tags]    Reservations    Negative
    ${token_user1}=    Login User    user@example.com    password123
    ${token_user2}=    Login User    user@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    Tentar Compra Concorrente Para Ultimo Assento    ${token_user1}    ${token_user2}    ${session_id}

Teste Comprar Ingresso Com Multiplos Assentos e Validar Estoque
    [Tags]    Reservations    Positive
    ${token_user}=    Login User    user@example.com    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${seat1}=    Create Dictionary    row=A    number=1    type=full
    ${seat2}=    Create Dictionary    row=A    number=2    type=full
    ${seats}=    Create List    ${seat1}    ${seat2}
    Comprar Ingresso Com Multiplos Assentos e Validar Estoque    ${token_user}    ${session_id}    ${seats}

Teste Listar Reservas
    [Tags]    Reservations    Positive
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reservation_id}=    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    
    ${reservations}=    reservations_service.Listar Reservas    ${token_admin}
    
    Should Be True    ${reservations} is not None
    Should Not Be Empty    ${reservations}
    ${found}=    Set Variable    ${FALSE}
    FOR    ${reservation}    IN    @{reservations}
        IF    '${reservation}[_id]' == '${reservation_id}'
            ${found}=    Set Variable    ${TRUE}
            BREAK
        END
    END
    Should Be True    ${found}    msg=Created reservation not found in the list of all reservations.

Teste Obter Reserva Por ID
    [Tags]    Reservations    Positive
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reservation_id}=    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    
    ${retrieved_reservation_data}=    reservations_service.Obter Reserva Por ID    ${token_admin}    ${reservation_id}
    
    Should Be Equal As Strings    ${retrieved_reservation_data}[_id]    ${reservation_id}
    Should Be Equal As Strings    ${retrieved_reservation_data}[user]    ${token_user}[_id]
    Should Be Equal As Strings    ${retrieved_reservation_data}[session]    ${session_id}

Teste Deletar Reserva Por ID
    [Tags]    Reservations    Positive
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reservation_id}=    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    
    reservations_service.Deletar Reserva Por ID    ${token_admin}    ${reservation_id}
    
    # Verify that the reservation is no longer accessible
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_admin}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/reservations/${reservation_id}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    404
    Should Be Equal As Strings    ${response.json()}[message]    Reservation not found

Teste Obter Minhas Reservas
    [Tags]    Reservations    Positive
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    ${my_reservations}=    reservations_service.Get My Reservations    ${token_user}
    Should Be True    ${my_reservations} is not None
    Should Not Be Empty    ${my_reservations}

Teste Obter Minhas Reservas Sem Autenticacao
    [Tags]    Reservations    Negative
    reservations_service.Get My Reservations And Expect Failure    ${EMPTY}    401    Not authorized, no token

Teste Obter Minhas Reservas Com Usuario Sem Reservas
    [Tags]    Reservations    Positive
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${my_reservations}=    reservations_service.Get My Reservations    ${token_user}
    Should Be True    ${my_reservations} is not None
    Should Be Empty    ${my_reservations}

Teste Atualizar Status Da Reserva
    [Tags]    Reservations    Positive
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reservation_id}=    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    ${payload}=    Create Dictionary    status=confirmed
    ${updated_reservation}=    reservations_service.Update Reservation Status    ${token_admin}    ${reservation_id}    ${payload}
    Should Be Equal As Strings    ${updated_reservation}[status]    confirmed

Teste Atualizar Status Da Reserva Sem Permissao Admin
    [Tags]    Reservations    Negative
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reservation_id}=    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    ${payload}=    Create Dictionary    status=confirmed
    reservations_service.Update Reservation Status And Expect Failure    ${token_user}    ${reservation_id}    ${payload}    403    User role user is not authorized to access this route

Teste Atualizar Status Da Reserva Com Transicao Invalida
    [Tags]    Reservations    Negative
    ${generated_name}=    Faker.Name
    ${generated_email}=    Faker.Email
    ${token_user}=    auth_service.Register User    ${generated_name}    ${generated_email}    password123
    ${movie_id}=    filmes_service.Cadastrar Filme Com Sucesso    ${token_admin}
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${session_id}=    session_service.Criar Sessao Com Token Admin    ${token_admin}    ${movie_id}    ${theater_id}
    ${reservation_id}=    reservations_service.Comprar Ingresso Com Sucesso e Validar Estoque    ${token_user}    ${session_id}
    ${payload}=    Create Dictionary    status=invalid_status
    reservations_service.Update Reservation Status And Expect Failure    ${token_admin}    ${reservation_id}    ${payload}    400    Invalid status transition

Suite Teardown
    # Limpeza de dados criados durante os testes
    Log    Suite Teardown: Limpeza de dados de teste concluída



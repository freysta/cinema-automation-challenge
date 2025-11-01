*** Settings ***
Resource    ../../resources/api/main_api.robot
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/theaters_service.robot
Resource    ../../resources/api/admin_setup_service.robot


*** Test Cases ***
Teste Cadastrar Teatro Com Token Admin - Fluxo Completo
    [Tags]    Theaters    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    Should Not Be Empty    ${theater_id}

Teste Listar Teatros
    [Tags]    Theaters    Positive
    ${theaters}=    Listar Teatros
    Should Be True    ${theaters} is not None

Teste Tentar Cadastrar Teatro Com Token User
    [Tags]    Theaters    Negative
    ${token_user}=    Login User    user@example.com    password123
    Tentar Cadastrar Teatro Com Token User    ${token_user}

Teste Tentar Cadastrar Teatro Sem Nome
    [Tags]    Theaters    Negative
    ${token_admin}=    Login User    admin@example.com    password123
    Tentar Cadastrar Teatro Sem Nome    ${token_admin}

Teste Tentar Cadastrar Teatro Com Tipo Invalido
    [Tags]    Theaters    Negative
    ${token_admin}=    Login User    admin@example.com    password123
    Tentar Cadastrar Teatro Com Tipo Invalido    ${token_admin}

Teste Obter Teatro Por ID
    [Tags]    Theaters    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    ${theater_data}=    Obter Teatro Por ID    ${theater_id}
    Should Be Equal As Strings    ${theater_data}[_id]    ${theater_id}
    Should Be Equal As Strings    ${theater_data}[capacity]    100

Teste Atualizar Teatro Por ID
    [Tags]    Theaters    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    
    ${updated_name}=    Set Variable    Teatro Atualizado
    ${updated_capacity}=    Set Variable    200
    ${updated_payload}=    Create Dictionary    name=${updated_name}    capacity=${updated_capacity}    type=standard
    
    ${updated_theater_data}=    Atualizar Teatro Por ID    ${token_admin}    ${theater_id}    ${updated_payload}
    
    Should Be Equal As Strings    ${updated_theater_data}[_id]    ${theater_id}
    Should Be Equal As Strings    ${updated_theater_data}[name]    ${updated_name}
    Should Be Equal As Strings    ${updated_theater_data}[capacity]    ${updated_capacity}
    Should Be Equal As Strings    ${updated_theater_data}[type]    standard

Teste Deletar Teatro Por ID
    [Tags]    Theaters    Positive
    ${token_admin}=    Login User    admin@example.com    password123
    ${theater_id}=    theaters_service.Cadastrar Teatro Com Token Admin    ${token_admin}
    Deletar Teatro Por ID    ${token_admin}    ${theater_id}
    
    # Verify that the theater is no longer accessible
    ${response}=    GET    ${BASE_URL}/theaters/${theater_id}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    404
    Should Be Equal As Strings    ${response.json()}[message]    Theater not found

*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/user_service.robot
Resource    ../../resources/api/main_api.robot
Library    FakerLibrary

*** Test Cases ***
Teste Listar Usuarios
    [Tags]    Users    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${users}=    user_service.Listar Usuarios    ${token_admin}
    Should Be True    ${users} is not None
    Should Not Be Empty    ${users}

Teste Obter Usuario Por ID
    [Tags]    Users    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${name}=    Set Variable    Test User Get By ID
    ${email}=    FakerLibrary.Email
    ${password}=    Set Variable    password123
    ${user_data}=    auth_service.Register User    ${name}    ${email}    ${password}
    ${user_id}=    Set Variable    ${user_data}[_id]
    
    ${retrieved_user_data}=    user_service.Obter Usuario Por ID    ${token_admin}    ${user_id}
    
    Should Be Equal As Strings    ${retrieved_user_data}[_id]    ${user_id}
    Should Be Equal As Strings    ${retrieved_user_data}[email]    ${email}

Teste Atualizar Usuario Por ID
    [Tags]    Users    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${name}=    Set Variable    Test User Update
    ${email}=    FakerLibrary.Email
    ${password}=    Set Variable    password123
    ${user_data}=    auth_service.Register User    ${name}    ${email}    ${password}
    ${user_id}=    Set Variable    ${user_data}[_id]
    
    ${updated_name}=    Set Variable    Updated User Name
    ${updated_payload}=    Create Dictionary    name=${updated_name}
    
    ${updated_user_data}=    user_service.Atualizar Usuario Por ID    ${token_admin}    ${user_id}    ${updated_payload}
    
    Should Be Equal As Strings    ${updated_user_data}[_id]    ${user_id}
    Should Be Equal As Strings    ${updated_user_data}[name]    ${updated_name}

Teste Deletar Usuario Por ID
    [Tags]    Users    Positive
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    ${name}=    Set Variable    Test User Delete
    ${email}=    FakerLibrary.Email
    ${password}=    Set Variable    password123
    ${user_data}=    auth_service.Register User    ${name}    ${email}    ${password}
    ${user_id}=    Set Variable    ${user_data}[_id]
    
    user_service.Deletar Usuario Por ID    ${token_admin}    ${user_id}
    
    # Verify that the user is no longer accessible
    ${headers}=    user_service.Get JSON Headers
    ${response}=    GET    ${BASE_URL}/users/${user_id}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    404
    Should Be Equal As Strings    ${response.json()}[message]    User not found

Teste Obter Usuario Por ID Comum Acessando Outro Usuario
    [Tags]    Users    Negative
    ${token_admin}=    auth_service.Login User    admin@example.com    password123
    
    ${name1}=    Set Variable    User One
    ${email1}=    FakerLibrary.Email
    ${password1}=    Set Variable    password123
    ${user_data1}=    auth_service.Register User    ${name1}    ${email1}    ${password1}
    ${user_id1}=    Set Variable    ${user_data1}[_id]
    ${token_user1}=    auth_service.Login User    ${email1}    ${password1}

    ${name2}=    Set Variable    User Two
    ${email2}=    FakerLibrary.Email
    ${password2}=    Set Variable    password123
    ${user_data2}=    auth_service.Register User    ${name2}    ${email2}    ${password2}
    ${user_id2}=    Set Variable    ${user_data2}[_id]
    
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user1}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/users/${user_id2}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    403
    Should Be Equal As Strings    ${response.json()}[message]    User role user is not authorized to access this route

Teste Obter Usuario Por ID Comum Acessando Seus Proprios Dados
    [Tags]    Users    Positive
    ${name}=    Set Variable    Self Access User
    ${email}=    FakerLibrary.Email
    ${password}=    Set Variable    password123
    ${user_data}=    auth_service.Register User    ${name}    ${email}    ${password}
    ${user_id}=    Set Variable    ${user_data}[_id]
    ${token_user}=    auth_service.Login User    ${email}    ${password}
    
    ${headers}=    Create Dictionary    Authorization=Bearer ${token_user}    Content-Type=application/json
    ${response}=    GET    ${BASE_URL}/users/${user_id}    headers=${headers}    expected_status=200
    
    Should Be Equal As Strings    ${response.json()}[data][_id]    ${user_id}
    Should Be Equal As Strings    ${response.json()}[data][email]    ${email}

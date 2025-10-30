*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/admin_setup_service.robot

*** Test Cases ***
Suite Setup
    ${result}=    Create Default Test Users Via Setup API
    Run Keyword Unless    ${result}    Fail    Test users setup failed

Login Bem-Sucedido
    [Tags]    Auth    Positive
    ${token}=    Login User    admin@example.com    password123
    Should Not Be Empty    ${token}

Login Com Senha Inválida
    [Tags]    Auth    Negative
    Login User And Expect Failure    admin@example.com    wrongpassword    401    Invalid email or password

Login Com Usuário Inexistente
    [Tags]    Auth    Negative
    Login User And Expect Failure    nonexistent@example.com    password123    401    Invalid email or password

Teste Tentar Registrar Usuario Com Email Existente
    [Tags]    Auth    Negative
    ${email}=    Set Variable    test_user_duplicate@example.com
    ${password}=    Set Variable    password123
    ${name}=    Set Variable    Test User Duplicate
    
    # First, register the user successfully
    Register User    ${name}    ${email}    ${password}
    
    # Then, attempt to register again with the same email, expecting failure
    Registrar Usuario E Esperar Falha    ${name}    ${email}    ${password}    400    User already exists

Teste Tentar Registrar Usuario Com Email Invalido
    [Tags]    Auth    Robustness
    ${email}=    Set Variable    invalid-email
    ${password}=    Set Variable    password123
    ${name}=    Set Variable    Invalid Email User

    Registrar Usuario Com Email Invalido E Esperar Falha    ${name}    ${email}    ${password}    400    Validation failed

Teste Obter Perfil Do Usuario Logado
    [Tags]    Auth    Positive
    ${token}=    Login User    admin@example.com    password123
    ${profile}=    Get User Profile    ${token}
    Should Be Equal As Strings    ${profile}[email]    admin@example.com
    Should Be Equal As Strings    ${profile}[role]    admin

Teste Obter Perfil Sem Autenticacao
    [Tags]    Auth    Negative
    Get User Profile And Expect Failure    ${EMPTY}    401    Not authorized, no token

Teste Obter Perfil Com Token Invalido
    [Tags]    Auth    Negative
    Get User Profile And Expect Failure    invalid_token    401    Not authorized, invalid token

Teste Atualizar Perfil Do Usuario
    [Tags]    Auth    Positive
    ${token}=    Login User    admin@example.com    password123
    ${updated_name}=    Set Variable    Admin Atualizado
    ${payload}=    Create Dictionary    name=${updated_name}
    ${updated_profile}=    Update User Profile    ${token}    ${payload}
    Should Be Equal As Strings    ${updated_profile}[name]    ${updated_name}

Teste Atualizar Perfil Sem Senha Atual
    [Tags]    Auth    Negative
    ${token}=    Login User    admin@example.com    password123
    ${payload}=    Create Dictionary    newPassword=newpassword123
    Update User Profile And Expect Failure    ${token}    ${payload}    401    Current password is incorrect

Teste Atualizar Perfil Com Email Existente
    [Tags]    Auth    Negative
    ${token}=    Login User    admin@example.com    password123
    ${payload}=    Create Dictionary    email=test@example.com
    Update User Profile And Expect Failure    ${token}    ${payload}    409    Email already in use

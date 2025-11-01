*** Settings ***
Resource    ../../resources/api/admin_setup_service.robot
Resource    ../../resources/api/auth_service.robot
Library    FakerLibrary

*** Test Cases ***
Teste Criar Usuario Admin Via Setup API
    [Tags]    AdminSetup    Positive
    ${name}=    FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${password}=    Set Variable    password123
    admin_setup_service.Create Admin User Via Setup API    ${name}    ${email}    ${password}

Teste Criar Usuarios De Teste Via Setup API
    [Tags]    AdminSetup    Positive
    ${status}=    admin_setup_service.Create Default Test Users Via Setup API
    Should Be True    ${status}

Teste Criar Usuarios De Teste Em Ambiente De Producao
    [Tags]    AdminSetup    Negative
    admin_setup_service.Create Test Users Via Setup API And Expect Failure    403    Setup routes are only available in development environment
    auth_service.Login User    ${email}    ${password}

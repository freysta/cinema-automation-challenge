*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/filmes_service.robot
Library    JSONLibrary

*** Test Cases ***
Teste Tentar Cadastrar Filme Sem Titulo
    ${token_admin}=    Login And Get Token    admin@test.com    admin123
    Tentar Cadastrar Filme Sem Titulo    ${token_admin}

*** Keywords ***
Login And Get Token
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${BASE_URL}/auth/login    json=${payload}    expected_status=200
    [Return]    ${response.json()}[token]

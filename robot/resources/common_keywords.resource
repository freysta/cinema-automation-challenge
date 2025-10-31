*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           FakerLibrary
Library           Process
Resource          ./variables/global_variables.robot

*** Keywords ***
Conectar na API
    [Documentation]    Cria a sessão principal para interação com a API, usando a URL base global.
    Create Session    alias=${API_ALIAS}    url=${API_BASE_URL}

Carregar Dados JSON
    [Arguments]    ${file_path}
    [Documentation]    Carrega os dados de um arquivo JSON.
    ${json_data}=    Load JSON From File    ${file_path}
    [Return]    ${json_data}

Teardown Test Session
    [Documentation]    Encerra todas as sessões da API.
    Delete All Sessions

Fazer Login
    [Arguments]    ${email}    ${password}
    [Documentation]    Realiza o login com as credenciais fornecidas e retorna o tokken.
    &{payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session
    ...    alias=${API_ALIAS}
    ...    url=/auth/login
    ...    json=${payload}
    ...    expected_status=200
    ${token}=    Set Variable    ${response.json()}[data][token]
    [Return]    ${token}

Obter Token de Admin
    [Documentation]    Faz o login como Admin usando as credenciais globais.
    ${token}=    Fazer Login    email=${ADMIN_EMAIL}    password=${ADMIN_PASS}
    Set Suite Variable    \${ADMIN_TOKEN}    ${token}
    [Return]    ${token}

Obter Token de User
    [Documentation]    Faz o login como User usando as credenciais globais.
    ${token}=    Fazer Login    email=${USER_EMAIL}    password=${USER_PASS}
    Set Suite Variable    \${USER_TOKEN}    ${token}
    [Return]    ${token}

Criar e Logar Usuario Dinamico
    [Arguments]    ${role}=user
    [Documentation]    Cria e loga um novo usuario com dados dinamicos, retornando o token e os dados do usuario.
    ${name}=       FakerLibrary.Name
    ${email}=      FakerLibrary.Safe Email
    ${password}=   FakerLibrary.Password
    &{payload}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    password=${password}
    ...    role=${role}

    POST On Session    alias=${API_ALIAS}    url=/auth/register    json=${payload}    expected_status=201
    ${token}=    Fazer Login    email=${email}    password=${password}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET On Session    alias=${API_ALIAS}    url=/auth/me    headers=${headers}
    ${user_data}=    Set Variable    ${response.json()}

    [Return]    ${token}    ${user_data}
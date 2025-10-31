*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Resource   main_api.robot

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Get JSON Headers
    ${headers}=    Create Dictionary    Content-Type=application/json
    [Return]    ${headers}

Create API Session
    [Arguments]    ${alias}    ${base_url}
    Create Session    ${alias}    ${base_url}

Login User
    [Arguments]    ${email}    ${password}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/login    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Dictionary Should Contain Key    ${response.json()}[data]    token
    [Return]    ${response.json()}[data][token]

Login User And Expect Failure
    [Arguments]    ${email}    ${password}    ${expected_status_code}    ${expected_message}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/login    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

Register User
    [Arguments]    ${name}    ${email}    ${password}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${payload}=    Create Dictionary    name=${name}    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/register    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    data
    Dictionary Should Contain Key    ${response.json()}[data]    _id
    Dictionary Should Contain Key    ${response.json()}[data]    email
    Should Be Equal As Strings    ${response.json()}[data][email]    ${email}
    Log    User ${email} registered successfully with ID: ${response.json()}[data][_id]
    [Return]    ${response.json()}[data]

Registrar Usuario E Esperar Falha
    [Arguments]    ${name}    ${email}    ${password}    ${expected_status_code}    ${expected_message}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${payload}=    Create Dictionary    name=${name}    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/register    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

Registrar Usuario Com Email Invalido E Esperar Falha
    [Arguments]    ${name}    ${email}    ${password}    ${expected_status_code}    ${expected_message}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${payload}=    Create Dictionary    name=${name}    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/register    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

Get User Profile
    [Arguments]    ${token}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json
    ${response}=    GET On Session    cinema_api    /auth/me    headers=${headers}    expected_status=200
    Dictionary Should Contain Key    ${response.json()}    data
    [Return]    ${response.json()}[data]

Get User Profile And Expect Failure
    [Arguments]    ${token}    ${expected_status_code}    ${expected_message}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json
    ${response}=    GET On Session    cinema_api    /auth/me    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

Update User Profile
    [Arguments]    ${token}    ${payload}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json
    ${response}=    PUT On Session    cinema_api    /auth/profile    json=${payload}    headers=${headers}    expected_status=200
    Dictionary Should Contain Key    ${response.json()}    data
    [Return]    ${response.json()}[data]

Update User Profile And Expect Failure
    [Arguments]    ${token}    ${payload}    ${expected_status_code}    ${expected_message}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json
    ${response}=    PUT On Session    cinema_api    /auth/profile    json=${payload}    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

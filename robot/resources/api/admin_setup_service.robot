*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource    ./auth_service.robot

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Create Admin User Via Setup API
    [Arguments]    ${name}    ${email}    ${password}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${payload}=    Create Dictionary    name=${name}    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /setup/admin    json=${payload}    headers=${headers}    expected_status=201
    Should Be Equal As Strings    ${response.json()}[message]    Admin user created successfully
    Log    Admin user ${email} created successfully.

Create Default Test Users Via Setup API
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${response}=    POST On Session    cinema_api    /setup/test-users    headers=${headers}    expected_status=any
    ${status}=    Set Variable    ${response.status_code}
    ${message}=    Set Variable    ${response.json()}[message]
    Log    Default test users setup completed (status: ${status}, message: ${message})
    ${result}=    Evaluate    ${status} in [200, 201, 400]
    [Return]    ${result}

Create Test Users Via Setup API And Expect Failure
    [Arguments]    ${expected_status_code}    ${expected_message}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Get JSON Headers
    ${response}=    POST On Session    cinema_api    /setup/test-users    headers=${headers}    expected_status=any
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

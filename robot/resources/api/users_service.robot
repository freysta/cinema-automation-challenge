*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource    ./auth_service.robot

*** Variables ***
${BASE_URL}    http://localhost:3000/api/v1

*** Keywords ***
Delete User By Email
    [Arguments]    ${email}    ${admin_token}
    Create API Session    cinema_api    ${BASE_URL}
    ${headers}=    Create Dictionary    Authorization=Bearer ${admin_token}
    ${response}=    GET On Session    cinema_api    /users    headers=${headers}    expected_status=200
    ${users}=    Set Variable    ${response.json()}[data]
    ${user_id}=    Set Variable    ${None}
    FOR    ${user}    IN    @{users}
        IF    '${user}[email]' == '${email}'
            ${user_id}=    Set Variable    ${user}[_id]
            BREAK
        END
    END

    IF    '${user_id}' is not '${None}'
        ${delete_response}=    DELETE On Session    cinema_api    /users/${user_id}    headers=${headers}    expected_status=200
        Log    User with ID ${user_id} and email ${email} deleted successfully.
    ELSE
        Log    User with email ${email} not found for deletion.
    END

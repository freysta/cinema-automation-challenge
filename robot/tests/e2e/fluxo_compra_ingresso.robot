*** Settings ***
Resource    ../../resources/api/auth_service.robot
Resource    ../../resources/api/users_service.robot
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/api/admin_setup_service.robot
Library     Collections

Suite Setup       Configurar Ambiente de Teste E2E
Suite Teardown    Desmontar Ambiente de Teste E2E

*** Variables ***
${BROWSER}          chrome
${FRONTEND_URL}     http://localhost:3002
${DEFAULT_USER_EMAIL}    user@example.com
${DEFAULT_USER_PASSWORD}    password123
${DEFAULT_ADMIN_EMAIL}    admin@example.com
${DEFAULT_ADMIN_PASSWORD}    admin123

*** Keywords ***
Configurar Ambiente de Teste E2E
    # 1. Create default test users via API setup endpoint
    Create Default Test Users Via Setup API

    # 2. Login as admin to get an admin token for setup/teardown actions
    ${admin_token}=    Login User    ${DEFAULT_ADMIN_EMAIL}    ${DEFAULT_ADMIN_PASSWORD}
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}

    # 3. Placeholder: Create a movie via API (requires movies_service.robot)
    Log    Placeholder: Creating movie via API...
    # Example: ${movie_id}=    Create Movie    ${ADMIN_TOKEN}    Movie Title    ...
    Set Suite Variable    ${MOVIE_ID}    fake_movie_id_123

    # 4. Placeholder: Create a session for that movie via API (requires sessions_service.robot)
    Log    Placeholder: Creating session via API...
    # Example: ${session_id}=    Create Session    ${ADMIN_TOKEN}    ${MOVIE_ID}    ...
    Set Suite Variable    ${SESSION_ID}    fake_session_id_456

Desmontar Ambiente de Teste E2E
    # 1. Placeholder: Delete the created movie and session via API
    Log    Placeholder: Deleting movie and session via API...
    # Example: Delete Session    ${ADMIN_TOKEN}    ${SESSION_ID}
    # Example: Delete Movie    ${ADMIN_TOKEN}    ${MOVIE_ID}

    # 2. Delete the created user via API (using admin token)
    Delete User By Email    ${DEFAULT_USER_EMAIL}    ${ADMIN_TOKEN}
    Delete User By Email    ${DEFAULT_ADMIN_EMAIL}    ${ADMIN_TOKEN}

*** Test Cases ***
Compra de Ingresso E2E Bem-Sucedida
    [Tags]    E2E    Purchase
    Open Browser    ${FRONTEND_URL}    ${BROWSER}
    Maximize Browser Window

    # Web: Login the newly created user
    Open Login Page
    Perform Login    ${DEFAULT_USER_EMAIL}    ${DEFAULT_USER_PASSWORD}
    Wait Until Page Contains    Bem-vindo    timeout=10s

    # Web: Navigate to movie details page (placeholder)
    Log    Placeholder: Navigating to movie details page for ${MOVIE_ID}
    # Example: Go To Movie Details Page    ${MOVIE_ID}

    # Web: Select session and seats (placeholder)
    Log    Placeholder: Selecting session ${SESSION_ID} and seats
    # Example: Select Session    ${SESSION_ID}
    # Example: Select Seats    A1, A2

    # Web: Complete checkout process (placeholder)
    Log    Placeholder: Completing checkout
    # Example: Proceed To Checkout
    # Example: Fill Payment Details    Credit Card    1234-5678-9012-3456    12/25    123
    # Example: Confirm Purchase

    # Web: Verify reservation (placeholder)
    Log    Placeholder: Verifying reservation confirmation
    # Example: Verify Reservation Confirmation

    Close Browser
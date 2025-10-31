*** Settings ***
Resource    ../../resources/web/base_web.resource

Suite Setup       Setup Testes Frontend
Suite Teardown    Teardown Testes Frontend
Test Setup        New Page    ${FRONTEND_BASE_URL}

*** Test Cases ***
Test Browser Opening
    Go To Home Page
    Capture Page Screenshot    screenshot_after_opening_login_page.png
    Log To Console    Browser opened and screenshot taken.
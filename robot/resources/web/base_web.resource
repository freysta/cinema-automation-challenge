*** Settings ***
Library    Browser          # Para testes E2E (Browser Library/Playwright)
Library    Collections      # Para manipulação de JSON/dicionários

*** Variables ***
${FRONTEND_BASE_URL}        http://localhost:3002
${BROWSER}                  chromium
${HEADLESS}                 ${True}

*** Keywords ***
Setup Testes Frontend
    [Documentation]    Inicializa o navegador e navega para a página inicial.
    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    New Page    ${FRONTEND_BASE_URL}

    Set Browser Timeout    15s

    Set ViewPort Size    1920    1080

Teardown Testes Frontend
    [Documentation]    Fecha o navegador após a execução do teste e limpa o local storage.
    Clear Local Storage
    Close Browser

Go To Home Page
    [Documentation]    Navega para a URL base da aplicação.
    Go To    ${FRONTEND_BASE_URL}

Clear Local Storage
    [Documentation]    Limpa o token JWT e outros dados de sessão do navegador.
    Evaluate Javascript    window.localStorage.clear()

*** Settings ***
Library    Browser          # Para testes E2E (Browser Library/Playwright)
Library    RequestsLibrary  # Para testes de API
Library    Collections      # Para manipulação de JSON/dicionários
Library    String           # Para geração de dados dinâmicos

*** Variables *** 
${BASE_URL_API}             http://localhost:3000/api/v1  
${FRONTEND_BASE_URL}        http://localhost:5173      

${BROWSER}                  firefox
${HEADLESS}                 ${False}

${NOME_USER}         Test User
${EMAIL_USER}        test@example.co
${SENHA_USER}        user123

${NOME_ADMIN}         Admin User
${EMAIL_ADMIN}        admin@example.com
${SENHA_ADMIN}        admin123

# Headers padrão para requisições
&{HEADERS_NO_AUTH}          Content-Type=application/json

*** Keywords ***
Setup Testes Frontend
    [Documentation]    Inicializa o navegador e navega para a página inicial.
    New Browser    browser=${BROWSER}    headless=${TRUE}  
    New Page    ${FRONTEND_BASE_URL}
    
    Set Browser Timeout    15s
    
    Set ViewPort Size    1920    1080

Teardown Testes Frontend
    [Documentation]    Fecha o navegador após a execução do teste.
    Close Browser

Go To Home Page
    [Documentation]    Navega para a URL base da aplicação.
    Go To    ${FRONTEND_BASE_URL}

Clear Local Storage
    [Documentation]    Limpa o token JWT e outros dados de sessão do navegador.
    Evaluate Javascript    window.localStorage.clear()
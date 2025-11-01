*** Settings ***
Library    SeleniumLibrary
Library    String
Resource    ./common_variables.robot

*** Variables ***
${BROWSER}    chrome
${URL}    ${FRONTEND_URL}
${TIMEOUT}    ${SELENIUM_TIMEOUT}

*** Keywords ***
Abrir Navegador
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${TIMEOUT}

Fechar Navegador
    Close Browser

Esperar Elemento Visivel
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}

Clicar Elemento
    [Arguments]    ${locator}
    Esperar Elemento Visivel    ${locator}
    Click Element    ${locator}

Preencher Campo
    [Arguments]    ${locator}    ${text}
    Esperar Elemento Visivel    ${locator}
    Input Text    ${locator}    ${text}

Verificar Texto Presente
    [Arguments]    ${text}
    Page Should Contain    ${text}

Verificar Elemento Presente
    [Arguments]    ${locator}
    Element Should Be Visible    ${locator}

Navegar Para
    [Arguments]    ${url}
    Go To    ${url}

Recarregar Pagina
    Reload Page

Esperar Pagina Carregar
    Wait Until Page Contains Element    //body    timeout=${TIMEOUT}

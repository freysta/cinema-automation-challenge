*** Settings ***
Library    Browser
Resource    ../../base.resource
Resource    ./LoginPage.resource

*** Variables ***
${BTN_ADM}    css=.nav > ul:nth-child(1) > li:nth-child(5) > a:nth-child(1)
${PAGE_TITLE_ADM}             role=heading[name="Painel de Administração"]

*** Keywords ***
Navegar ate a pagina de admin
    Navegar Para Login
    Realizar Login    ${EMAIL_ADMIN}    ${SENHA_ADMIN}
    Validar Login Bem Sucedido
    Click    ${BTN_ADM}

Validar pagina de admin
    Wait For Elements State    ${PAGE_TITLE_ADM}    visible    timeout=10s
    Get Text    ${PAGE_TITLE_ADM}
*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Verificar Login Bem Sucedido
    Wait Until Page Contains Element    id=welcome-message    timeout=10s    # Placeholder: Adjust selector as needed
    # Or check for URL change
    # Location Should Contain    /home

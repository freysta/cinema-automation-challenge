*** Settings ***
Resource    ../test-resources/page-objects/AdmPage.resource
Library     Browser

Suite Setup       New Browser    firefox    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173

*** Test Cases ***
Acessar a pagina de admin
    Navegar ate a pagina de admin
    Validar pagina de admin
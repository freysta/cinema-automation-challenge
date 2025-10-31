*** Settings ***
Resource    ../test-resources/page-objects/PaymentPage.resource
Library     Browser

Suite Setup       New Browser    chromium    headless=false
Suite Teardown    Close Browser
Test Setup        New Page    http://localhost:5173

*** Test Cases ***
Verificar se a pagina esta Completa e os botoes funcionando
    Ir para a pagina de pagamento
    Validar Resumo Da Reserva Completo
    Selecionar Metodo De Pagamento    ${PAYMENT_OPTION_CREDIT_CARTAO}
    Selecionar Metodo De Pagamento    ${PAYMENT_OPTION_DEBITO_CARTAO}
    Selecionar Metodo De Pagamento    ${PAYMENT_OPTION_PIX}
    Selecionar Metodo De Pagamento    ${PAYMENT_OPTION_TRANSFER}

Finalizar a compra
    Ir para a pagina de pagamento
    Selecionar Metodo De Pagamento    ${PAYMENT_OPTION_PIX}
    Finalizar Compra    
    Validar Confirmacao De Sucesso

    
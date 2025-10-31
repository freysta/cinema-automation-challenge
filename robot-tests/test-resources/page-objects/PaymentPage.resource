*** Settings ***
Library    Browser
Resource    ../../base.resource
Resource    ./LoginPage.resource
Resource    ./MoviesListPage.resource
Resource    ./MoviePage.resource
Resource    ./SeatsPage.resource

*** Variables ***
${CHECKOUT_PAGE_URL}          ${FRONTEND_BASE_URL}/checkout

${PAGE_TITLE_CHECKOUT}        css=.checkout-header > h1:nth-child(2)
${RESERVE_SUMMARY_SECTION}    xpath=/html/body/div/main/div/div[2]/div[1]/div[1]
${TOTAL_PURCHASE_VALUE}       xpath=/html/body/div/main/div/div[2]/div[1]/div[3]/div/span[2]
${SUMMARY_SEATS_LIST}         xpath=/html/body/div/main/div/div[2]/div[1]/div[2]/ul/li

${PAYMENT_OPTION_CREDIT_CARTAO}       css=div.payment-method:nth-child(1)
${PAYMENT_OPTION_DEBITO_CARTAO}       css=div.payment-method:nth-child(2)
${PAYMENT_OPTION_PIX}                 css=div.payment-method:nth-child(3)
${PAYMENT_OPTION_TRANSFER}            css=div.payment-method:nth-child(4)

${BTN_FINALIZAR_COMPRA}       xpath=/html/body/div/main/div/div[2]/div[2]/div[3]/button
${MSG_CONFIRMACAO_SUCESSO}    css=.confirmation-header > h1:nth-child(2)

*** Keywords ***
Ir para a pagina de pagamento
    [Documentation]    Faz todo o processo para ir ate a pagina de compra
    Navegar Para Login
    Realizar Login    ${EMAIL_USER}    ${SENHA_USER}
    Validar Login Bem Sucedido
    Navegar Para Lista De Filmes
    Clicar Ver Detalhes Do Filme
    Clicar Em Selecionar Assentos Da Primeira Sessao
    Selecionar Primeiro Assento Disponivel
    Validar Assento Selecionado
    Clicar Botao Continuar
    Validar redirecionamento para a próxima página    ${FRONTEND_BASE_URL}/checkout

Selecionar Metodo De Pagamento
    [Arguments]    ${method_id}
    [Documentation]    Seleciona o método de pagamento desejado pelo ID.
    Click    ${method_id}
Finalizar Compra
    [Documentation]    Clica no botão para simular o processamento do pagamento.
    Click    ${BTN_FINALIZAR_COMPRA}

Validar Resumo Da Reserva Completo
    [Documentation]    Verifica se a seção de resumo contém informações (Filme, Assentos).
    Wait For Elements State    ${RESERVE_SUMMARY_SECTION}    visible
    Get Element Count    ${SUMMARY_SEATS_LIST}    >=    1

Validar Confirmacao De Sucesso
    [Documentation]    Verifica a exibição da mensagem de confirmação final da reserva.
    Wait For Elements State    ${MSG_CONFIRMACAO_SUCESSO}    visible
    Get Text    ${MSG_CONFIRMACAO_SUCESSO}
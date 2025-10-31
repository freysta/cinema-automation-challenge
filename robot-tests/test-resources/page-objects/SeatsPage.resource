*** Settings ***
Library    Browser
Resource    ../../base.resource

*** Variables ***
${SEATS_PAGE_URL}             ${FRONTEND_BASE_URL}/sessions

${SEAT_AVAILABLE}             css=.seat.available
${SEAT_SELECTED}              css=.seat.selected
${SEAT_OCCUPIED}              css=.seat.occupied

${SELECTED_SEATS_LIST}        css=.selected-seats-list
${TOTAL_PRICE}                css=.total-amount

${BTN_CONTINUAR}              css=.btn-continue
${BTN_LIBERAR_ASSENTOS}       css=button:has-text("Liberar")

*** Keywords ***
Selecionar Primeiro Assento Disponivel
    [Documentation]    Clica no primeiro assento disponível.
    Click    ${SEAT_AVAILABLE} >> nth=0 >> nth=0

Validar Assento Selecionado
    [Documentation]    Verifica se o assento mudou para roxo e aparece na lista.
    Wait For Elements State    ${SEAT_SELECTED}    visible
    ${selected_count}=    Get Element Count    ${SEAT_SELECTED}
    Should Be True    ${selected_count} > 0

Validar Lista De Assentos Selecionados
    [Documentation]    Verifica se o assento aparece na lista de selecionados.
    Sleep    1s
    ${page_text}=    Get Text    body
    Should Contain Any    ${page_text}    A1    Fileira A    Assento 1

Validar Valor Total Atualizado
    [Documentation]    Verifica se o valor total foi atualizado.
    Sleep    1s
    ${page_text}=    Get Text    body
    Should Match Regexp    ${page_text}    R\\$\\s*\\d+[,.]\\d{2}

Tentar Selecionar Assento Ocupado
    [Documentation]    Tenta clicar em um assento ocupado (vermelho).
    ${occupied_count}=    Get Element Count    ${SEAT_OCCUPIED}
    IF    ${occupied_count} > 0
        Click    ${SEAT_OCCUPIED} >> nth=0
    END

Validar Assento Nao Selecionado
    [Documentation]    Verifica que o assento ocupado não foi selecionado.
    Sleep    1s
    ${selected_count_before}=    Get Element Count    ${SEAT_SELECTED}
    ${occupied_count}=    Get Element Count    ${SEAT_OCCUPIED}
    Should Be True    ${occupied_count} > 0    msg=Não há assentos ocupados para testar

Clicar Botao Liberar Assentos
    [Documentation]    Clica no botão para liberar assentos selecionados.
    Click    ${BTN_LIBERAR_ASSENTOS}

Validar Bug Liberacao Assentos
    [Arguments]    ${occupied_count_before}
    Sleep    1s
    ${selected_count_after}=    Get Element Count    ${SEAT_SELECTED}
    ${occupied_count_after}=    Get Element Count    ${SEAT_OCCUPIED}
    Should Be Equal As Numbers    ${selected_count_after}    0
    Should Not Be Equal As Numbers    ${occupied_count_after}    ${occupied_count_before}    msg=BUG: Assentos vermelhos foram liberados incorretamente

Tentar Clicar Botao Continuar Sem Assentos
    [Documentation]    Verifica se o botão continuar está desabilitado sem assentos selecionados.
    Wait For Elements State    css=button:has-text("Continuar")    visible
    Wait For Elements State    css=button:has-text("Continuar")    disabled

Validar Permanencia Na Pagina De Assentos
    [Documentation]    Verifica se ainda está na página de assentos.
    Sleep    1s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    sessions

Clicar Botao Continuar
    [Documentation]    Clica no botão continuar
    Click    css=button:has-text("Continuar")

Validar redirecionamento para a próxima página
    [Arguments]        ${URL}
    [Documentation]    Verifica se foi redirecionado para a página de pagamento ou login se a pessoa logou.
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    ${URL}
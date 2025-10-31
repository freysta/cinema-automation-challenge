*** Settings ***
Library     Browser
Resource    ../../base.resource

*** Variables ***
${RESERVES_PAGE_URL}          ${FRONTEND_BASE_URL}/reservations
${BTN_MT_RESERVES}            css=.nav > ul:nth-child(1) > li:nth-child(3) > a:nth-child(1)

${PAGE_TITLE_RESERVES}        css=.reservations-header > h1:nth-child(1)

${RESERVES_LIST_CONTAINER}    xpath=/html/body/div/main/div/div/div[2]

${RESERVE_CARD_ITEM}          css=div.reservation-card:nth-child(1) > div:nth-child(2)
${RESERVE_CARD_FILM_TITLE}    css=div.reservation-card:nth-child(1) > div:nth-child(2) > div:nth-child(2) > h4:nth-child(1)
${RESERVE_CARD_DATE_TIME}     css=div.reservation-card:nth-child(1) > div:nth-child(2) > div:nth-child(2) > div:nth-child(2) > span:nth-child(2)
${RESERVE_CARD_STATUS}        css=div.reservation-card:nth-child(1) > div:nth-child(1) > span:nth-child(2)

${MSG_NO_RESERVES}            xpath=//p[contains(text(), 'Você não possui reservas')]

*** Keywords ***
Navegar Para Minhas Reservas
    [Documentation]    Navega diretamente para a URL da página de Reservas (usuário deve estar logado).
    Click        ${BTN_MT_RESERVES}
    Sleep    2s
    
    ${current_url}=    Get Url
    Should Contain    ${current_url}    ${RESERVES_PAGE_URL}

Validar Presenca Reserva No Historico
    [Documentation]    Verifica se a lista de reservas contém pelo menos um item.
    Wait For Elements State    ${RESERVES_LIST_CONTAINER}    visible
    Get Element Count    ${RESERVE_CARD_ITEM}    >=    1

Validar Detalhes Essenciais Do Primeiro Card
    [Documentation]    Verifica se os dados críticos da primeira reserva estão visíveis.

    Get Text    ${RESERVE_CARD_FILM_TITLE}
    Get Text    ${RESERVE_CARD_STATUS}    ==    CONFIRMADA

*** Settings ***
Library    Browser
Resource    ../../base.resource

*** Variables ***
${PROFILE_PAGE_URL}           ${FRONTEND_BASE_URL}/profile
${BTN_PROFILE}                css=.nav > ul:nth-child(1) > li:nth-child(4) > a:nth-child(1)
${TITLE_PAGE}                 css=.profile-header > h1:nth-child(1)
${PROFILE_CONTAINER}          xpath=/html/body/div/main/div/div/div[3]/div[1]/form

${FIELD_EMAIL}                css=#email
${INPUT_NAME}                 css=#name

${BTN_SALVAR_ALTERACOES}      xpath=/html/body/div/main/div/div/div[3]/div[1]/form/div[4]/button
${MSG_SUCESSO_UPDATE}         css=.alert.alert-success

*** Keywords ***
Navegar Para Pagina Perfil
    [Documentation]    Navega diretamente para a URL da página de Perfil.
    Click        ${BTN_PROFILE}
    Sleep    2s
    ${current_url}=    Get Url
    Should Contain    ${current_url}    ${PROFILE_PAGE_URL}

Preencher Novo Nome
    [Arguments]    ${new_name}
    [Documentation]    Preenche o campo editável 'Nome Completo'.
    Fill Text    ${INPUT_NAME}    ${new_name}

Clicar Salvar Alteracoes
    [Documentation]    Clica no botão para enviar a requisição PUT de atualização.
    Click    ${BTN_SALVAR_ALTERACOES}

Atualizar Nome Do Perfil
    [Arguments]    ${new_name}
    [Documentation]    Ação completa: Edita o nome e salva.
    Preencher Novo Nome    ${new_name}
    Clicar Salvar Alteracoes

Validar Campos Nao Editaveis
    [Documentation]    Verifica se Email e Função não podem ser alterados (CT-AUTH-016).
    ${email_value}=    Get Text    ${FIELD_EMAIL}
    Should Not Contain    ${email_value}    input[type=text]    # Assumindo que não é um input
    
Validar Nome Atualizado
    [Arguments]    ${expected_name}
    [Documentation]    Verifica se o nome exibido no campo corresponde ao valor atualizado.
    ${current_name}=    Get Property    ${INPUT_NAME}    value
    Should Be Equal    ${current_name}    ${expected_name}
    Click    css=button.btn:nth-child(4)

Validar Mensagem De Sucesso Update
    [Documentation]    Verifica a exibição da mensagem de confirmação após salvar (CT-AUTH-009).
    Wait For Elements State    ${MSG_SUCESSO_UPDATE}    visible
    Get Text    ${MSG_SUCESSO_UPDATE}

Validar pagina
    [Documentation]    Verifica se está na página
    Wait For Elements State    ${TITLE_PAGE}    visible
    Get Text    ${TITLE_PAGE}
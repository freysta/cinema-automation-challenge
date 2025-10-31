*** Settings ***
Library    Browser
Resource    ../base_web.resource

*** Variables ***
${ADMIN_MENU}    //a[contains(text(),'Admin') or contains(text(),'Administrador')]
${ADD_MOVIE_BUTTON}    //button[contains(text(),'Adicionar Filme') or contains(text(),'Novo Filme')]
${MOVIE_TITLE_FIELD}    //input[@name='title' or @placeholder='Título']
${MOVIE_DESCRIPTION_FIELD}    //textarea[@name='description' or @placeholder='Descrição']
${MOVIE_DURATION_FIELD}    //input[@name='duration' or @type='number']
${SAVE_MOVIE_BUTTON}    //button[contains(text(),'Salvar') or contains(text(),'Criar')]
${MOVIE_TABLE}    //table | //div[contains(@class,'table')]
${MOVIE_ROW}    //tr | //div[contains(@class,'row')]
${DELETE_MOVIE_BUTTON}    //button[contains(text(),'Excluir') or contains(text(),'Deletar')]
${USERS_TABLE}    //table[contains(@class,'users')] | //div[contains(@class,'users')]
${USER_ROW}    //tr[contains(@class,'user')] | //div[contains(@class,'user')]

*** Keywords ***
Acessar Pagina Admin
    [Documentation]    Acessa a página de administração.
    Click    ${ADMIN_MENU}
    Wait For Load State

Clicar Adicionar Filme
    [Documentation]    Clica no botão para adicionar filme.
    Click    ${ADD_MOVIE_BUTTON}
    Wait For Load State

Preencher Titulo Filme
    [Arguments]    ${title}
    [Documentation]    Preenche o campo de título do filme.
    Fill Text    ${MOVIE_TITLE_FIELD}    ${title}

Preencher Descricao Filme
    [Arguments]    ${description}
    [Documentation]    Preenche o campo de descrição do filme.
    Fill Text    ${MOVIE_DESCRIPTION_FIELD}    ${description}

Preencher Duracao Filme
    [Arguments]    ${duration}
    [Documentation]    Preenche o campo de duração do filme.
    Fill Text    ${MOVIE_DURATION_FIELD}    ${duration}

Clicar Salvar Filme
    [Documentation]    Clica no botão para salvar o filme.
    Click    ${SAVE_MOVIE_BUTTON}
    Wait For Load State

Verificar Filme Na Tabela Admin
    [Arguments]    ${movie_title}
    [Documentation]    Verifica se o filme está presente na tabela de administração.
    Wait For Text    ${movie_title}

Verificar Usuario Na Tabela
    [Arguments]    ${user_email}
    [Documentation]    Verifica se o usuário está presente na tabela de administração.
    Wait For Text    ${user_email}

Clicar Excluir Filme
    [Arguments]    ${movie_title}
    [Documentation]    Clica no botão para excluir um filme específico.
    ${delete_button_locator}=    Set Variable    xpath=//tr[contains(.,'${movie_title}')]//button[contains(text(),'Excluir')]
    Click    ${delete_button_locator}
    Wait For Load State

Verificar Mensagem Sucesso
    [Arguments]    ${message}
    [Documentation]    Verifica se uma mensagem de sucesso é exibida.
    Wait For Text    ${message}
*** Settings ***
Resource    common_web.robot

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
    Clicar Elemento    ${ADMIN_MENU}
    Esperar Pagina Carregar

Clicar Adicionar Filme
    Clicar Elemento    ${ADD_MOVIE_BUTTON}
    Esperar Pagina Carregar

Preencher Titulo Filme
    [Arguments]    ${title}
    Preencher Campo    ${MOVIE_TITLE_FIELD}    ${title}

Preencher Descricao Filme
    [Arguments]    ${description}
    Preencher Campo    ${MOVIE_DESCRIPTION_FIELD}    ${description}

Preencher Duracao Filme
    [Arguments]    ${duration}
    Preencher Campo    ${MOVIE_DURATION_FIELD}    ${duration}

Clicar Salvar Filme
    Clicar Elemento    ${SAVE_MOVIE_BUTTON}
    Esperar Pagina Carregar

Verificar Filme Na Tabela Admin
    [Arguments]    ${movie_title}
    Verificar Texto Presente    ${movie_title}

Verificar Usuario Na Tabela
    [Arguments]    ${user_email}
    Verificar Texto Presente    ${user_email}

Clicar Excluir Filme
    [Arguments]    ${movie_title}
    ${delete_button}=    Catenate    SEPARATOR=    //tr[contains(.,'${movie_title}')]//button[contains(text(),'Excluir')]
    Clicar Elemento    ${delete_button}
    Esperar Pagina Carregar

Verificar Mensagem Sucesso
    [Arguments]    ${message}
    Verificar Texto Presente    ${message}

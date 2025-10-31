*** Settings ***
Resource         ../base.resource
Resource         ../test-resources/service-objects.resource
Test Setup       Conectar à API

*** Test Cases ***
Tentativa de Alterar Role via PUT auth profile
    [Documentation]    Valida que API ignora campo 'role' e mantém segurança

    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    &{dados_update}=    Create Dictionary    role=admin
    ${response}=    Atualizar Perfil Com Token    ${token}    ${dados_update}

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    
    Should Be Equal    ${response_json['data']['role']}    user
    
    Log    API ignorou campo 'role' corretamente - segurança mantida

Login Bem Sucedido Com Credenciais Validas
    [Documentation]    Valida login bem-sucedido e persistência do token JWT
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}

    ${response}=    Fazer Login     ${EMAIL_USER}    ${SENHA_USER}

    Should Be Equal As Integers    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json['data']}    token
    

    ${token}=    Set Variable    ${response_json['data']['token']}
    Should Not Be Empty    ${token}
    Should Match Regexp    ${token}    ^[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+$
    
    Log    Login bem-sucedido com token: ${token[:20]}...

Tentativa de Registro com Email Duplicado
    [Documentation]    Valida que a API retorna erro 400 ao tentar registrar email já existente

    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${response}=    Tentar Registrar Usuário    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}

    Should Be Equal As Integers    ${response.status_code}    400
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    Should Be Equal    ${response_json['message']}    User already exists
    
    Log    Validação de email duplicado: SUCESSO

Tentativa de Registro com Email Invalido
    [Documentation]    Valida que a API retorna erro 400 para email com formato inválido

    ${response}=    Tentar Registrar Usuário    ${NOME_USER}    email_invalido_sem_arroba    ${SENHA_USER}

    Should Be Equal As Integers    ${response.status_code}    400
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de email inválido: SUCESSO

Registro de Novo Usuario
    [Documentation]    Cenário P1. Valida US-AUTH-001

    ${email_prefix}=    Generate Random String    length=10    chars=[LETTERS][NUMBERS]
    ${email_novo}=      Set Variable    novo_${email_prefix}@cinemaqa.com

    ${response}=    Registrar Novo Usuário    ${NOME_USER}    ${email_novo}    ${SENHA_USER}

    Verificar Registro Bem Sucedido e Token    ${response}
    
    Log    Registro de API SUCESSO: ${email_novo}

Acesso ao Perfil Sem Token
    [Documentation]    Valida retorno 401 (Unauthorized) ao acessar GET /auth/me sem token

    ${response}=    Buscar Perfil Sem Token

    Should Be Equal As Integers    ${response.status_code}    401
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de acesso não autorizado: SUCESSO

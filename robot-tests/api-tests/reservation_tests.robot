*** Settings ***
Resource         ../base.resource
Resource         ../test-resources/service-objects.resource
Test Setup       Conectar à API

*** Test Cases ***
Criacao Direta de Reserva
    [Documentation]    Criação Direta (POST /reservations) e validação do retorno 201
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${sessions_response}=    Buscar Lista de Sessões
    Should Be Equal As Integers    ${sessions_response.status_code}    200
    
    ${sessions}=    Set Variable    ${sessions_response.json()['data']}
    Should Be True    len($sessions) > 0    msg=Nenhuma sessão disponível para teste
    
    ${session_id}=    Set Variable    ${sessions[1]['_id']}
    ${session_seats}=    Set Variable    ${sessions[1]['seats']}
    
    ${available_seat}=    Set Variable    ${None}
    FOR    ${seat}    IN    @{session_seats}
        IF    '${seat['status']}' == 'available'
            ${available_seat}=    Set Variable    ${seat}
            BREAK
        END
    END
    
    Should Not Be Equal    ${available_seat}    ${None}    msg=Nenhum assento disponível encontrado
    
    @{seats}=    Create List
    &{seat1}=    Create Dictionary    row=${available_seat['row']}    number=${available_seat['number']}    type=full
    Append To List    ${seats}    ${seat1}
    
    &{reservation_data}=    Create Dictionary    
    ...    session=${session_id}
    ...    seats=${seats}
    ...    paymentMethod=credit_card

    ${response}=    Criar Nova Reserva    ${token}    ${reservation_data}

    Should Be Equal As Integers    ${response.status_code}    201
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${True}
    Dictionary Should Contain Key    ${response_json}    data
    
    ${reservation}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${reservation}    _id
    Dictionary Should Contain Key    ${reservation}    session
    Dictionary Should Contain Key    ${reservation}    seats
    
    Log    Criação direta de reserva: SUCESSO

Tentar Criar Reserva com Assento Ocupado
    [Documentation]    Negativo: Tentar criar uma Reserva (POST /reservations) com um seat_id já ocupado
    
    Garantir Que Usuário Existe    ${NOME_USER}    ${EMAIL_USER}    ${SENHA_USER}
    ${login_response}=    Fazer Login    ${EMAIL_USER}    ${SENHA_USER}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}

    ${sessions_response}=    Buscar Lista de Sessões
    Should Be Equal As Integers    ${sessions_response.status_code}    200
    
    ${sessions}=    Set Variable    ${sessions_response.json()['data']}
    Should Be True    len($sessions) > 0    msg=Nenhuma sessão disponível para teste
    
    ${session_id}=    Set Variable    ${sessions[0]['_id']}
    
    @{seats}=    Create List
    &{seat_ocupado}=    Create Dictionary    row=A    number=1    type=full
    Append To List    ${seats}    ${seat_ocupado}
    
    &{reservation_data}=    Create Dictionary    
    ...    session=${session_id}
    ...    seats=${seats}
    ...    paymentMethod=credit_card

    ${response}=    Criar Nova Reserva    ${token}    ${reservation_data}

    Should Be Equal As Integers    ${response.status_code}    400
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de assento ocupado: SUCESSO

Tentar Criar Reserva sem Autenticacao
    [Documentation]    Segurança: Tentar Criar uma Reserva sem autenticação (Visitante)
    
    ${sessions_response}=    Buscar Lista de Sessões
    Should Be Equal As Integers    ${sessions_response.status_code}    200
    
    ${sessions}=    Set Variable    ${sessions_response.json()['data']}
    Should Be True    len($sessions) > 0    msg=Nenhuma sessão disponível para teste
    
    ${session_id}=    Set Variable    ${sessions[0]['_id']}
    
    @{seats}=    Create List
    &{seat1}=    Create Dictionary    row=B    number=5    type=full
    Append To List    ${seats}    ${seat1}
    
    &{reservation_data}=    Create Dictionary    
    ...    session=${session_id}
    ...    seats=${seats}
    ...    paymentMethod=credit_card

    ${response}=    Tentar Criar Reserva Sem Autenticação    ${reservation_data}

    Should Be Equal As Integers    ${response.status_code}    401
    
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['success']}    ${False}
    
    Log    Validação de segurança - sem autenticação: SUCESSO
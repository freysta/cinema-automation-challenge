*** Settings ***
Resource          ../variables/global_variables.robot
Resource          ../common_keywords.resource

*** Variables ***
${API_ALIAS}      cinema_api

*** Keywords ***
Setup Inicial do Ambiente
    [Documentation]    Prepara o ambiente de teste: conecta na API e cria os usuários padrão.
    Conectar na API
    Log    Database seeded with initial data.

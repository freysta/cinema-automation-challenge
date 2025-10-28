*** Settings ***
Resource    ../../resources/web/login_page.robot
Resource    ../../resources/web/common_web.robot
Suite Setup    Abrir Navegador
Suite Teardown    Fechar Navegador

*** Test Cases ***
Teste Login Bem Sucedido Admin
    Navegar Para    ${URL}/login
    Fazer Login    admin@test.com    admin123
    Verificar Login Bem Sucedido

Teste Login Bem Sucedido Usuario
    Navegar Para    ${URL}/login
    Fazer Login    user@test.com    user123
    Verificar Login Bem Sucedido

Teste Login Com Credenciais Invalidas
    Navegar Para    ${URL}/login
    Fazer Login    invalid@test.com    wrongpass
    Verificar Mensagem Erro Login    Credenciais inválidas

Teste Logout
    Navegar Para    ${URL}/login
    Fazer Login    admin@test.com    admin123
    Fazer Logout
    Verificar Elemento Presente    ${LOGIN_BUTTON}

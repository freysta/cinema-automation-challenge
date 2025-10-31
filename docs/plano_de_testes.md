# Plano de Testes - Cinema App

## 1. Introdução

Este documento detalha o plano de testes para a aplicação Cinema App, cobrindo a automação de testes de API e Web utilizando Robot Framework.

## 2. Escopo dos Testes

### 2.1. Funcionalidades em Escopo

- Autenticação (Registro, Login, Logout, Perfil)
- Gerenciamento de Filmes (Listagem, Detalhes)
- Gerenciamento de Sessões (Listagem, Detalhes)
- Reservas (Seleção de Assentos, Checkout, Histórico)
- Navegação Geral

### 2.2. Funcionalidades Fora de Escopo

- Testes de performance
- Testes de segurança (exceto validações básicas de autenticação)
- Testes de usabilidade exploratórios

## 3. Estratégia de Testes

### 3.1. Abordagem

Será utilizada uma abordagem de testes híbrida, combinando testes de API para validação do backend e testes Web para validação da interface do usuário, com testes End-to-End (E2E) que integram ambos.

### 3.2. Níveis de Teste

- **Testes de API:** Foco na validação dos endpoints do backend, lógica de negócio e persistência de dados.
- **Testes Web:** Foco na validação da interface do usuário, interações e fluxos de navegação.
- **Testes E2E:** Validação de jornadas completas do usuário, utilizando a API para pré-condições e pós-condições, e a interface Web para a execução do fluxo principal.

### 3.3. Padrões de Projeto

- **Service Objects:** Para encapsular interações com a API.
- **Page Objects:** Para encapsular interações com elementos da interface Web.
- **Keywords Reutilizáveis:** Para promover a reusabilidade e manutenibilidade do código.

## 4. Ferramentas e Tecnologias

- **Framework de Automação:** Robot Framework
- **Linguagem de Script:** Python
- **Bibliotecas Robot:**
  - `RequestsLibrary` (para testes de API)
  - `SeleniumLibrary` ou `Browser` (para testes Web)
  - `FakerLibrary` (para geração de dados de teste)
  - `JSONLibrary` (para manipulação de JSON)
- **Controle de Versão:** Git / GitHub
- **Integração Contínua:** GitHub Actions

## 5. Ambiente de Testes

- **Backend:** Aplicação Node.js/Express (cinema-backend)
- **Frontend:** Aplicação React (cinema-frontend)
- **Banco de Dados:** MongoDB
- **Navegadores:** Chrome (principal), Firefox (secundário)

## 6. Dados de Teste

- Serão utilizados dados de teste gerados dinamicamente (Faker) e dados pré-definidos em arquivos JSON/Python para cenários específicos.
- A criação e limpeza de dados serão realizadas via API nos `Suite Setup` e `Suite Teardown` dos testes E2E.

## 7. Cenários de Teste (Implementados)

### 7.1. Testes de API

#### Autenticação (auth.robot)

- **Login Bem-Sucedido**: Valida login com credenciais corretas (US-AUTH-002)
- **Login Com Senha Inválida**: Valida erro para senha incorreta (US-AUTH-002)
- **Login Com Usuário Inexistente**: Valida erro para usuário inexistente (US-AUTH-002)

#### Filmes (filmes.robot)

- **Cadastrar Filme Com Sucesso**: Valida criação de filme com dados válidos (US-MOVIE-001)
- **Listar Filmes**: Valida obtenção da lista de filmes (US-MOVIE-001)
- **Tentar Cadastrar Filme Sem Título**: Valida erro para filme sem título obrigatório (US-MOVIE-001)
- **Tentar Cadastrar Filme Com Duração Inválida**: Valida erro para duração negativa (US-MOVIE-001)

#### Reservas (reservations.robot)

- **Comprar Ingresso Para Sessão Lotada - Fluxo Completo**: Valida reserva em sessão lotada (US-RESERVE-001)
- **Tentar Compra Concorrente Para Último Assento**: Valida concorrência de reservas (US-RESERVE-001)
- **Comprar Ingresso Com Múltiplos Assentos e Validar Estoque**: Valida reserva múltipla e decremento de estoque (US-RESERVE-001)

#### Teatros (theaters.robot)

- **Cadastrar Teatro Com Token Admin - Fluxo Completo**: Valida criação de teatro por admin (US-SESSION-001)
- **Listar Teatros**: Valida obtenção da lista de teatros (US-SESSION-001)
- **Tentar Cadastrar Teatro Com Token User**: Valida erro para usuário não autorizado (US-SESSION-001)
- **Tentar Cadastrar Teatro Sem Nome**: Valida erro para teatro sem nome obrigatório (US-SESSION-001)

### 7.2. Testes Web

- Navegação para a página de login
- Preenchimento do formulário de login com sucesso/erro
- Visualização da lista de filmes na UI
- Interação com a página de detalhes do filme

### 7.3. Testes E2E

- Fluxo completo de registro, login, busca de filme, seleção de assentos e checkout.
- Fluxo de login, visualização de reservas e logout.

## 8. Relatórios e Métricas

- Os resultados dos testes serão gerados pelo Robot Framework (HTML, XML).
- Relatórios serão publicados no GitHub Actions como artefatos.
- **Cobertura Atual**: 14 testes de API implementados cobrindo autenticação, filmes, reservas e teatros.
- **Status de Execução**: Testes falham devido à API não estar rodando (Connection refused). Quando a API estiver ativa na porta 3000, todos os testes devem passar.

## 9. Cronograma (Exemplo)

- **Semana 1:** Configuração do ambiente, estrutura de arquivos, testes de API (Autenticação, Filmes).
- **Semana 2:** Testes de API (Sessões, Reservas, Usuários), dados de teste.
- **Semana 3:** Testes Web (Login, Navegação, Filmes).
- **Semana 4:** Testes E2E, refatoração, documentação final, CI.

## 10. Responsabilidades

- **QA Lead:** [Seu Nome]
- **Desenvolvedores:** Equipe de desenvolvimento do Cinema App

## 11. Glossário

- **API:** Application Programming Interface
- **E2E:** End-to-End
- **JWT:** JSON Web Token
- **PO:** Page Object
- **SO:** Service Object

---

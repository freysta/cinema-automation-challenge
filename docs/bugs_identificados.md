# Bugs Identificados nos Testes de API

## BUG-07: Problemas de autenticação nos testes de Movies

**Descrição:** Os testes de API de Movies estão falhando com erro 401 (não autorizado), mesmo quando o token de admin é passado corretamente. Isso indica problemas na autenticação ou autorização dos endpoints de movies.

**Passos para Reproduzir:**

1. Executar os testes em robot/tests/api/filmes.robot
2. Todos os testes que requerem autenticação falham com 401

**Resultado Esperado:**

- Testes de criação, atualização e deleção de filmes deveriam passar com token admin válido

**Resultado Obtido:**

- Todos os testes falham com status 401
- Apenas o teste de listagem (GET /movies) passa, pois não requer autenticação

**Impacto:**

- Impossibilita testar funcionalidades de CRUD de filmes
- Bloqueia testes downstream que dependem de criação de filmes (como reservations, sessions)

**Labels:** bug, auth, movies, api, backend

---

## BUG-08: Problemas de autenticação nos testes de Reservations

**Descrição:** Os testes de API de Reservations estão falhando no Suite Setup com erro 401 (não autorizado) ao tentar fazer login do admin. Isso indica problemas na autenticação que afetam todos os testes downstream.

**Passos para Reproduzir:**

1. Executar os testes em robot/tests/api/reservations.robot
2. O Suite Setup falha ao tentar fazer login do admin
3. Todos os testes subsequentes falham devido ao setup falhado

**Resultado Esperado:**

- Suite Setup deveria conseguir fazer login do admin com sucesso
- Todos os testes de reservations deveriam executar

**Resultado Obtido:**

- Suite Setup falha com 401 != 200
- Nenhum teste de reservations executa

**Impacto:**

- Impossibilita testar funcionalidades de reservas
- Bloqueia testes E2E que dependem de reservas
- Indica problema sistêmico na autenticação

**Labels:** bug, auth, reservations, api, backend

---

## BUG-09: Problemas de autenticação nos testes de Sessions

**Descrição:** Os testes de API de Sessions estão falhando com erro 401 (não autorizado) em todos os testes, mesmo aqueles que deveriam funcionar com autenticação de admin.

**Passos para Reproduzir:**

1. Executar os testes em robot/tests/api/sessions.robot
2. Todos os 12 testes falham com 401 != 200

**Resultado Esperado:**

- Testes de listagem deveriam passar (públicos)
- Testes com token admin deveriam passar
- Testes de criação/atualização/deleção deveriam funcionar com admin

**Resultado Obtido:**

- Todos os testes falham com status 401
- Nenhum teste passa

**Impacto:**

- Impossibilita testar funcionalidades de sessões
- Bloqueia testes downstream que dependem de criação de sessões
- Indica problema sistêmico na autenticação

**Labels:** bug, auth, sessions, api, backend

---

## BUG-10: Problemas de autenticação nos testes de Theaters

**Descrição:** Os testes de API de Theaters estão falhando com erro 401 (não autorizado) na maioria dos testes, afetando funcionalidades de CRUD de teatros.

**Passos para Reproduzir:**

1. Executar os testes em robot/tests/api/theaters.robot
2. 7 dos 8 testes falham com 401 != 200
3. Apenas o teste de listagem passa (público)

**Resultado Esperado:**

- Teste de listagem deveria passar (público)
- Testes com token admin deveriam passar
- Testes de criação/atualização/deleção deveriam funcionar com admin

**Resultado Obtido:**

- 7 testes falham com status 401
- Apenas 1 teste passa (listagem)

**Impacto:**

- Impossibilita testar funcionalidades de teatros
- Bloqueia testes downstream que dependem de criação de teatros
- Indica problema na autenticação de admin

**Labels:** bug, auth, theaters, api, backend

---

## BUG-11: Problemas de autenticação nos testes de Users

**Descrição:** Os testes de API de Users estão falhando com erro 401 (não autorizado) em todos os testes, afetando funcionalidades de gerenciamento de usuários.

**Passos para Reproduzir:**

1. Executar os testes em robot/tests/api/users.robot
2. Todos os 8 testes falham com 401 != 200

**Resultado Esperado:**

- Testes com token admin deveriam passar
- Testes de CRUD de usuários deveriam funcionar com admin
- Testes de autorização deveriam validar corretamente permissões

**Resultado Obtido:**

- Todos os testes falham com status 401
- Nenhum teste passa

**Impacto:**

- Impossibilita testar funcionalidades de gerenciamento de usuários
- Bloqueia testes que dependem de criação de usuários
- Indica problema sistêmico na autenticação de admin

**Labels:** bug, auth, users, api, backend

---

## Análise Geral dos Bugs de Autenticação

### Padrão Identificado:

- Todos os testes que requerem autenticação estão falhando com 401
- Apenas endpoints públicos (como GET /movies, GET /theaters) passam
- Problema afeta todos os módulos: Movies, Reservations, Sessions, Theaters, Users
- Suite Setup de reservations falha no login do admin

### Possíveis Causas:

1. **Problema no middleware de autenticação** - Token não está sendo validado corretamente
2. **Problema na geração de tokens** - Tokens gerados podem estar incorretos
3. **Problema no banco de dados** - Usuários de teste não existem ou têm dados incorretos
4. **Problema de configuração** - Variáveis de ambiente ou configurações incorretas
5. **Problema de CORS ou headers** - Headers de autorização não estão sendo enviados corretamente

### Próximos Passos:

1. Verificar se usuários de teste existem no banco
2. Testar manualmente endpoints de auth para confirmar funcionamento
3. Verificar logs do backend durante execução dos testes
4. Verificar configuração do JWT e middleware de auth
5. Testar geração e validação de tokens manualmente

### Impacto Geral:

- **Bloqueio total dos testes automatizados** - Nenhum teste que requer autenticação funciona
- **Impossibilidade de testar funcionalidades críticas** - CRUD operations, admin features
- **Bloqueio de testes E2E** - Dependem de criação de dados via API
- **Necessidade de correção prioritária** - Todos os outros testes dependem desta correção

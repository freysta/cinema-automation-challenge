# AI-Powered Development: Cinema Challenge Final

## 1. Project Overview & AI Role

**Project:** An automated testing suite (API + Web + E2E) for the "Cinema" app using Robot Framework.
**Frameworks:** Robot Framework, RequestsLibrary, SeleniumLibrary, Faker.
**Patterns:** Service Objects (API), Page Objects (UI), Hybrid E2E (API for Setup/Teardown).

**Your Role (AI Assistant):** You are my pair programmer. Your goal is to help me complete the pending tasks listed below, adhering to the project's established patterns (Service Objects, Page Objects) and the current state (including blockers).

---

## 2. CURRENT PROJECT STATE (MANDATORY CONTEXT)

Before generating any code, you must understand the following:

### 2.1. Project Structure

The structure (folders for `/tests/api`, `/resources/web`, etc.) is **already implemented**. All new code should follow this existing structure.

### 2.2. Critical Backend Bugs (BLOCKERS)

We have identified **2 critical backend bugs**. Our automation tests **correctly fail** when testing these. You must **NOT** try to "fix" the tests to pass; you must work _around_ them or implement tests for other features.

- **[BUG-01] Reservation Creation Fails (BLOCKER):**

  - **Problem:** `POST /reservations` fails with a `400 Bad Request` because the `totalPrice` field is `required` in the Mongoose model, but the controller logic (which calculates the price) runs _after_ validation.
  - **Impact:** All reservation creation tests are **BLOCKED**. The `fluxo_compra_ingresso.robot` E2E test cannot be implemented.

- **[BUG-02] Generic Validation Messages (Movies):**
  - **Problem:** `POST /movies` with invalid data (e.g., no title) returns a generic "Validation failed" message instead of a specific one (e.g., "Title is required").
  - **Impact:** Our API tests cannot validate specific error messages, only the generic one.

- **[BUG-03] Movie Title Length Not Validated:**
  - **Problem:** The `POST /movies` endpoint successfully creates a movie even when provided with an excessively long title (e.g., 1000 characters). The backend returns a `201 Created` status, indicating no validation for the maximum length of the movie title.
  - **Impact:** This lack of validation could lead to database integrity issues, unexpected behavior in the frontend display, or potential security vulnerabilities (e.g., buffer overflow if not handled correctly at a lower level).
  - **Suggested Backend Fix:** Implement a maximum length validation for the `title` field in the `Movie.js` Mongoose model or in the `createMovie` controller function, returning a `400 Bad Request` if the title exceeds the defined limit.

- **[BUG-04] Inconsistent Duplicate Email Error Message:**
  - **Problem:** When attempting to register a new user with an email that already exists, the backend returns the error message "User already exists". However, the `errorHandler` middleware (specifically for `err.code === 11000` - duplicate key error) is configured to return the message "Duplicate field value entered". This inconsistency means the actual error message returned by the API does not match the generic duplicate key error message defined in the error handling middleware.
  - **Impact:** This inconsistency can lead to confusion for frontend developers trying to implement consistent error handling and user feedback. It also indicates a potential lack of standardization in error messaging across the API.
  - **Suggested Backend Fix:** Standardize the error message for duplicate email registration. Either update the `errorHandler` to specifically handle duplicate email messages, or ensure that the controller/model returns the generic "Duplicate field value entered" message for this scenario.

- **[BUG-05] Duplicate Email Registration Allowed:**
  - **Problem:** The `POST /auth/register` endpoint allows multiple users to be registered with the same email address. The backend returns a `201 Created` status for subsequent registrations with an already existing email, instead of a `400 Bad Request` or similar error indicating a duplicate entry.
  - **Impact:** This is a critical data integrity and security issue. It can lead to multiple accounts associated with the same email, making user management and authentication unreliable.
  - **Suggested Backend Fix:** Implement a unique constraint on the `email` field in the `User.js` Mongoose model, or add explicit validation in the `register` controller function to check for existing emails before creating a new user.

- **[BUG-06] Theater Update Validation Failure:**
  - **Problem:** The `PUT /theaters/:id` endpoint returns a `400 Bad Request` even when attempting to update a theater with seemingly valid data (e.g., changing only the name or capacity, or using a valid 'type' like "standard").
  - **Impact:** Updating existing theater details via the API is currently not possible, which affects data management and potentially the frontend's ability to modify theater information.
  - **Suggested Backend Fix:** Review the validation logic for the `PUT /theaters/:id` endpoint in the backend's `theaterController.js` and `Theater.js` Mongoose model to ensure it correctly processes and validates update requests.

- **[BUG-07] GET /sessions Returns 404 Not Found:**
  - **Problem:** The `GET /sessions` endpoint, intended to retrieve a list of all sessions, returns a `404 Not Found` status code instead of `200 OK` with the session data.
  - **Impact:** It's currently impossible to retrieve a list of sessions via the API, which affects any frontend components or administrative tools that rely on this information.
  - **Suggested Backend Fix:** Verify the routing configuration for the `/sessions` endpoint in `sessionRoutes.js` and ensure that the corresponding controller function in `sessionController.js` is correctly implemented and accessible.

---

## 3. ACTION PLAN (OUR TO-DO LIST)

Your primary task is to help me execute this plan.

### Task 1: [WORKAROUND] Update Movie Validation Tests

- **Goal:** Make the movie validation tests pass by accepting the _actual_ (buggy) behavior.
- **File:** `robot/resources/api/filmes_service.robot`
- **Action:** Refactor keywords like `Tentar Cadastrar Filme Sem Titulo` to **expect** the generic error message "Validation failed" instead of the specific one "Title is required". This acknowledges the bug and lets our test suite pass.

### Task 2: [IMPLEMENT] Web UI (Page Objects)

- **Goal:** Implement the Page Objects for the frontend.
- **Files:** `robot/resources/web/login_page.robot`, `home_page.robot`, `admin_page.robot`.
- **Action:** Generate the `*** Variables ***` (with CSS/XPath locators) and `*** Keywords ***` (e.g., "Preencher Formulario de Login", "Clicar Botao Entrar", "Verificar Mensagem de Erro no Login") for these pages.

### Task 3: [IMPLEMENT] Web UI Test Cases

- **Goal:** Implement the test cases that use the Page Objects.
- **Files:** `robot/tests/web/login.robot`, `tests/web/admin_page.robot`.
- **Action:** Generate test cases (e.g., "Login com sucesso", "Login com credenciais invalidas", "Admin deve conseguir cadastrar filme") that call the keywords from the Page Objects.

### Task 4: [IMPLEMENT] E2E Test (Admin Flow)

- **Goal:** Implement the E2E "Cadastro de Filme" flow, as the "Compra" flow is blocked by BUG-01.
- **File:** `robot/tests/e2e/fluxo_cadastro_filme_admin.robot`.
- **Action:** Generate the test case using the **Hybrid E2E Pattern**:
  1.  **`Suite Setup`:** Call API keywords (from `auth_service.robot`) to create an 'admin' user.
  2.  **`Test Case`:** Call Web UI keywords (from `login_page.robot`, `admin_page.robot`) to login as admin, navigate, create a movie via the UI, and verify it appears.
  3.  **`Suite Teardown`:** Call API keywords to delete the 'admin' user.

### Task 5: [DELIVERABLE] Create Challenge Artifacts

- **Goal:** Generate the pending documentation.
- **Action 1 (Mapa Mental):** Generate a **Markdown-based text outline** for `docs/mapa_mental.md` that visualizes the test strategy (API-First, UI, E2E, Key Modules).
- **Action 2 (Prompt GenAI):** Generate a sample prompt for `docs/prompt_genai.md` that asks an AI to create complex E2E test scenarios based on the API Swagger.

### Task 6: [INNOVATION] Implement CI Pipeline

- **Goal:** Add the "Adicional de Inovação".
- **File:** `.github/workflows/run_tests.yml`
- **Action:** Generate the YAML code for a GitHub Actions workflow that:
  1.  Checks out the code.
  2.  Sets up Python 3.x.
  3.  Installs dependencies from `robot/requirements.txt`.
  4.  Runs the **API tests only** (since UI/E2E tests are complex to run in CI). Use the command: `robot -d results robot/tests/api/`

### Task 7: [DOCUMENTATION] Finalize this README

- **Goal:** Complete the main `README.md` for final delivery.
- **Action:** Help me write the "Apresentação Pessoal" section and update the "Como Executar" section with the final commands.

---

## 4. How to Execute Tests (Reference)

All commands are run from the project root.

- **All tests:** `robot -d results robot/tests/`
- **API only:** `robot -d results robot/tests/api/`
- **Web only:** `robot -d results robot/tests/web/`
- **E2E only:** `robot -d results robot/tests/e2e/`
- **By Tag:** `robot -d results -i smoke robot/tests/`

## 6. Understanding Test Results (IMPORTANT CONTEXT FOR AI)

**Core Principle:** The goal of this test suite is to **validate predictable behavior**, which includes both successful operations (happy path) and expected failures (sad path / error handling).

**Test Status Interpretation:**

- **`PASSED` Test:** Means the application behaved _exactly_ as the test expected.

  - Example 1: `Login Bem-Sucedido` expects `200 OK` -> API returns `200 OK`. (PASSED)
  - Example 2: `Login Com Senha Inválida` expects `401 Unauthorized` -> API returns `401 Unauthorized`. (PASSED - The API correctly handled the error).

- **`FAILED` Test:** Means the application behaved _unexpectedly_, indicating a **BUG** in the application itself.
  - Example 1: `Login Bem-Sucedido` expects `200 OK` -> API returns `500 Internal Server Error`. (FAILED - Application bug)
  - Example 2: `Login Com Senha Inválida` expects `401 Unauthorized` -> API returns `200 OK`. (FAILED - Critical security bug)

**Handling Known Bugs (Especially BUG-01):**

- **[BUG-01] Reservation Creation Blocker:** As stated in Section 2.2, all `POST /reservations` calls currently fail with a `400 Bad Request` due to the `totalPrice` validation issue in the backend.
- **Your Action (AI Assistant):**
  1.  **DO NOT "fix" the reservation tests** to make them pass by removing validation or expecting the `400` status. The tests are correctly identifying the bug.
  2.  **EXPECT these tests to FAIL.** When implementing or running reservation creation tests (e.g., `Teste Comprar Ingresso Com Multiplos Assentos`, E2E `fluxo_compra_ingresso.robot`), anticipate their failure due to this known backend issue.
  3.  **(Optional but Recommended):** Add a specific tag like `@known_bug` or `@blocked_by_bug_01` to these failing tests. This helps filter results and track dependencies.
  4.  **Focus Efforts Elsewhere:** Prioritize implementing and verifying tests for **unblocked** functionalities (Web UI components, E2E Admin flow, other API endpoints).

**In Summary:** Tests designed to provoke errors (`4xx` status codes) are crucial. A `PASSED` result on such a test means the API's error handling is working correctly. A `FAILED` result means we've likely found a bug in the application. Understand and respect the known blockers like BUG-01.

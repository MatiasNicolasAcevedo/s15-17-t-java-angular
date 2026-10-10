# Tablero
> Reglas: **una tarea a la vez** (máx. 1 PR de tarea abierto) · "Listas" es la **cola en orden de ejecución**: se toma siempre la primera ·
> si la primera no te corresponde (🧠 o 👤), no saltees a la siguiente: avisá con el formato de "Traspasos" y terminá ·
> las 👤 que no bloquean nada van al final de "Listas" con "(no bloquea la cola)" ·
> formato: `- T-NNN · Pn · S/M/L · 🤖 gratuito|🧠 frontera|👤 dueño · Título → [tarea](tasks/T-NNN-slug.md)`
> Próximo ID libre: T-019

## 🔨 En curso / en revisión (con su PR)
_(vacío: T-000 espera merge en PR #1)_

## ✅ Listas (cola en orden de ejecución, máx. 10)
- T-001 · P0 · S · 🧠 frontera · Read the JWT signing secret from configuration 🔴 → [tarea](tasks/T-001-externalize-jwt-secret.md)
- T-002 · P0 · M · 🧠 frontera · Set up backend test infrastructure → [tarea](tasks/T-002-backend-test-infra.md)
- T-003 · P0 · M · 🧠 frontera · Enforce ownership and admin role 🔴 → [tarea](tasks/T-003-enforce-resource-ownership.md)
- T-004 · P0 · S · 🤖 gratuito · Remove the spurious `package.json` npm dependency → [tarea](tasks/T-004-remove-spurious-dependency.md)
- T-005 · P0 · S · 🤖 gratuito · Move workspace API calls out of `Api.tsx` → [tarea](tasks/T-005-move-workspace-api-calls.md)
- T-018 · P0 · S · 🤖 gratuito · Move the `useAuth` hook out of `Api.tsx` → [tarea](tasks/T-018-move-useauth-hook.md)
- T-006 · P0 · S · 🤖 gratuito · Read the API base URL from `VITE_API_URL` → [tarea](tasks/T-006-read-api-url-from-env.md)
- T-007 · P0 · S · 🤖 gratuito · Characterization tests for `ReservationServiceImpl` → [tarea](tasks/T-007-characterize-reservation-service.md)
- T-008 · P0 · S · 🤖 gratuito · Characterization tests for login and registration → [tarea](tasks/T-008-characterize-auth-flow.md)
- T-010 · P0 · S · 👤 dueño · Protect `main` and clean up branches (no bloquea la cola) → [tarea](tasks/T-010-protect-main.md)

## ⛔ Bloqueadas (en el orden en que entrarán a la cola)
- T-011 · P0 · S · 👤 dueño · Rotate the JWT secret in production (no bloquea la cola) → [tarea](tasks/T-011-rotate-production-jwt-secret.md) · bloqueada por: T-001
- T-009 · P0 · S · 🤖 gratuito · Make the Render wake-up scheduler opt-in → [tarea](tasks/T-009-make-wakeup-scheduler-configurable.md) · bloqueada por: T-002 (y cupo de Listas)
- T-012 · P0 · M · 🧠 frontera · Consistent HTTP errors with ProblemDetail → [tarea](tasks/T-012-global-error-handling.md) · bloqueada por: T-002, T-003, T-008
- T-014 · P0 · M · 🧠 frontera · Add the CI workflow → [tarea](tasks/T-014-add-ci-workflow.md) · bloqueada por: T-002, T-018
- T-013 · P0 · M · 🧠 frontera · Frontend test infrastructure → [tarea](tasks/T-013-frontend-test-infra.md) · bloqueada por: T-018, T-006
- T-015 · P0 · S · 🤖 gratuito · Add Dependabot configuration → [tarea](tasks/T-015-add-dependabot.md) · bloqueada por: T-014
- T-016 · P0 · M · 🧠 frontera · Seed demo data for local development → [tarea](tasks/T-016-seed-demo-data.md) · bloqueada por: T-002, T-003
- T-017 · P0 · M · 🧠 frontera · Playwright smoke tests and `scripts/e2e.sh` → [tarea](tasks/T-017-e2e-smoke-tests.md) · bloqueada por: T-006, T-014, T-016

## 📥 Backlog (sin refinar; detalle en la [auditoría](audits/2026-10-10-initial.md))
**P0 Estabilizar**
- 🤖 Caracterización de `WorkspaceServiceImpl` y `UserServiceImpl` (tras T-002)
- 🤖 Caracterización de vistas del front: login, registro, dashboard, reserva, perfil (tras T-013)

**P1 Actualizar**
- 🧠 Quitar `spring-cloud-config-server`, `mysql-connector-j` y el pin de `spring-security-web` (`pom.xml:35-49,72-81`)
- 🧠 Spring Boot 3.2 → 3.5.x con OpenRewrite; `java.version` 21; jjwt 0.13
- 🧠 Flyway en lugar de `ddl-auto=update` (+ ADR)
- 🧠 Spring Boot 3.5 → 4.x (Security 7, Jackson 3, springdoc 3)
- 🧠 Quitar `cascade = ALL` de `QualitiesEntity.workspaces` (con test)
- 🧠 CORS por configuración en lugar de `*`; Swagger y `show-sql`/DEBUG solo en perfil local
- 🧠 Upload de imágenes a archivo temporal (no al working dir con el nombre original)
- 🧠 Actualizar axios, vite, postcss, react-router (CVEs altas); `npm audit` sin altas
- 🤖 `ReactDOM.render` → `createRoot` (`frontend/src/main.tsx`)
- 🧠 React 19, Vite 7/8, TypeScript, ESLint 9+ flat config; Tailwind 4 + HeroUI (ADR)

**P2 Terminar**
- 🧠 Spec de reservas: el front crea la reserva, disponibilidad/solapamiento (código comentado), regla de precio por fracción de hora, DTO de reserva
- 🧠 Spec de perfil: editar perfil (front manda JSON a endpoint multipart), historial real de reservas
- 🧠 Búsqueda/filtro por ubicación y precio; paginación de listados
- 🧠 Gestión de espacios para admin; valoraciones; recordatorios
- 🤖 Header `Authorization: Bearer<token>` sin espacio en login (`LoginController.java:33`)
- 🤖 Logs con SLF4J en lugar de `System.out` (10 usos)
- 👤 Formulario de contacto: implementarlo o quitarlo

**P3 Pulir**
- 🤖 `alt` en imágenes (4 en `/`, 1 en `/login`); foco y contraste
- 🤖 Code-splitting (bundle de 696 kB)
- 👤 Licencia (MIT sugerida) y renombrar el repo (dice "angular")
- 🧠 Demo online con cuenta demo; README con capturas nuevas, GIF y badges; `v1.0.0`
- 🧠 ADR sobre token en `localStorage` vs cookie httpOnly

## 🏁 Hecho reciente (máx. 10; las más viejas → archive/tasks/)
- T-000 · P0 · L · 🧠 frontera · Bootstrap agent harness and project audit → [tarea](tasks/T-000-agent-bootstrap.md) · PR #1

# Roadmap

Fases en orden; cada una cierra con un tag `v0.x.0` ([CONTRIBUTING](../CONTRIBUTING.md#7-releases)). El detalle vivo está en [BACKLOG.md](BACKLOG.md).

## P0 · Estabilizar → `v0.1.0`

**Objetivo:** que el proyecto sea seguro de tocar: compila y corre con JDK 21/Node 24, levanta en contenedores, tiene red de tests y CI, y la seguridad crítica está resuelta.

**Criterio de salida (verificable):**
- [ ] `./scripts/verify.sh` en verde con tests del back y del front corriendo (no saltados) y umbral de cobertura fijado.
- [ ] CI (`ci.yml`) en verde en `main`; `pr-title.yml` activo; `main` protegida (T-010).
- [ ] README verificado de punta a punta en los dos modos, **sin ⚠️**, incluido login desde la UI contra el back local (T-006, T-016).
- [ ] Sin 🔴 abiertos: secreto JWT fuera del código y rotado (T-001, T-011), autorización por dueño (T-003).
- [ ] Smoke E2E (Playwright) de login → dashboard → detalle en desktop y mobile (T-017).
- [ ] Caracterización de los flujos críticos de la [auditoría](audits/2026-10-10-initial.md#7-testing-dimensión-central).

**Tareas:** T-001 a T-017 (cola en BACKLOG).

## P1 · Actualizar → `v0.2.0`

**Objetivo:** versiones vigentes en pasos chicos, cada uno protegido por la red de P0.

**Criterio de salida:** Spring Boot 4.x (vía 3.5.x), Java 21 como `java.version`, jjwt 0.13, springdoc acorde; Node 24, Vite y React 19, router 7, ESLint flat config; `npm audit` sin altas/críticas; Flyway en lugar de `ddl-auto`; Dependabot activo; CI verde en cada paso.

**Tareas principales:** quitar deps sin uso/pins (config-server, MySQL, `spring-security-web`); Boot 3.2 → 3.5 (OpenRewrite); Flyway + ADR; Boot 3.5 → 4.x; React 19 + `createRoot`; Vite/TS/ESLint; Tailwind 4 + HeroUI (ADR); CORS por configuración; perfiles (Swagger y `show-sql` fuera de prod).

## P2 · Terminar → `v0.3.0`

**Objetivo:** la funcionalidad prometida en el README, cada feature con su spec y tests.

**Criterio de salida:** reservar desde el front (con disponibilidad y solapamiento), historial real de reservas en el perfil, editar perfil con foto, búsqueda/filtro por ubicación y precio, gestión de espacios para admin; cada flujo con test de integración y E2E.

**Tareas principales:** specs `reservations.md`, `profile.md`, `workspace-admin.md`; DTO de reservas; regla de precio por fracción de hora; paginación; contacto (o quitarlo).

## P3 · Pulir para portfolio → `v1.0.0`

**Objetivo:** pieza de portfolio presentable.

**Criterio de salida:** responsive y accesibilidad básica verificados (375/768/1280, `alt`, foco, contraste); cobertura ≥ 70 % en servicios y lógica del front; README con capturas actuales, GIF, badges de CI y cobertura, licencia; demo online con cuenta demo; `v1.0.0` publicada.

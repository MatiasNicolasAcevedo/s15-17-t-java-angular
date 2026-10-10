# T-014 · Add the CI workflow
- Estado: Bloqueada (por T-002, T-018) · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `ci/T-014-add-ci-workflow` · Depende de: T-002, T-005, T-018 (`verify.sh` en verde) · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
No hay CI (`.github/workflows/` solo tiene `pr-title.yml`): nada valida los PR. En T-000 no se agregó porque `verify.sh` fallaba (lint del front, tests saltados).

## Objetivo
Cada push a `main` y cada PR corre `verify.sh` por parte en GitHub Actions, con caché y cobertura como artefacto; los jobs quedan como checks requeridos.

## Alcance
- Incluye: `.github/workflows/ci.yml` con `on: push (main) + pull_request`, `concurrency` por rama, `permissions: contents: read`; job `server` (`actions/setup-java` Temurin 21 con `cache: maven`, `./scripts/verify.sh --server`, upload de `backend/coworkProject/target/site/jacoco/` y de `.verify-logs/` si falla); job `client` (`actions/setup-node` con `node-version-file: .nvmrc` y `cache: npm` + `cache-dependency-path: frontend/package-lock.json`, `./scripts/verify.sh --client`, upload de cobertura cuando exista); versiones de las actions fijadas a un tag mayor vigente (verificar); badge de CI en el README; instrucción para el dueño de sumar `server` y `client` como checks requeridos (actualizar T-010 / STATUS).
- **No incluye:** E2E (T-017), deploy, Dependabot (T-015).

## Leer antes
- `scripts/verify.sh` · `.github/workflows/pr-title.yml` (estilo) · `docs/tasks/T-010-protect-main.md` · `CONTRIBUTING.md` §5

## Archivos previstos
- crear: `.github/workflows/ci.yml` · modificar: `README.md` (badge), `docs/STATUS.md` (fila "CI en main"), `CONTRIBUTING.md` si cambia algo del merge

## Criterios de aceptación
- [ ] El PR de esta tarea muestra los checks `server` y `client` en verde.
- [ ] Un commit de prueba que rompe un test (en una rama descartable) pone `server` en rojo; borrar la rama después.
- [ ] El job `client` usa Node de `.nvmrc` y el `server` JDK 21 (visible en el log).
- [ ] Badge visible en el README.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Pendientes → nuevas tareas: …

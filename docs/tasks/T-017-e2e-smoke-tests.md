# T-017 · Add Playwright smoke tests and `scripts/e2e.sh`
- Estado: Bloqueada (por T-006, T-014, T-016) · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-017-e2e-smoke-tests` · Depende de: T-006, T-014, T-016 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
Ningún test cubre el recorrido real del usuario (flujo crítico 8 de la [auditoría](../audits/2026-10-10-initial.md#7-testing-dimensión-central)) ni el responsive, que hoy solo se verificó a mano con capturas.

## Objetivo
`./scripts/e2e.sh` levanta todo en contenedores, corre 3–5 smoke tests de Playwright en desktop (1280) y mobile (375) y apaga; un job de CI lo corre en cada PR.

## Alcance
- Incluye: proyecto Playwright (carpeta `e2e/` en la raíz o `frontend/e2e/`: decidir y documentar) con versión vigente; tests: home carga sin scroll horizontal, login con usuario demo → dashboard con workspaces, detalle de un workspace, ruta protegida sin sesión → `/login`; screenshots y trace en fallos; `scripts/e2e.sh` (`docker compose --profile app up -d --build --wait`, correr, `down -v`, código de salida); job `e2e` en `ci.yml` con artefactos; docs (`README`, `AGENTS.md` §3, `docs/TESTING.md` referencia).
- **No incluye:** reservar (el front no lo implementa: P2); tests visuales por píxel.

## Leer antes
- `docker-compose.yml` · `.github/workflows/ci.yml` (T-014) · `docs/TESTING.md` §1 y §3 · `frontend/src/App.tsx` (rutas)

## Criterios de aceptación
- [ ] `./scripts/e2e.sh` pasa desde un clon limpio y deja todo apagado.
- [ ] Romper el login a propósito (p. ej. password del demo) hace fallar el smoke (revertir).
- [ ] Job `e2e` verde en el PR, con artefactos en fallo.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …

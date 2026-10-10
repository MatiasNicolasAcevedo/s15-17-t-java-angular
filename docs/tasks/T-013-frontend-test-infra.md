# T-013 · Set up frontend test infrastructure (Vitest, Testing Library, MSW)
- Estado: Bloqueada (por T-005, T-018) · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-013-frontend-test-infra` · Depende de: T-005, T-018 (lint en verde), T-006 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
El front no tiene ningún test ni script `test` (`frontend/package.json`). Sin infraestructura y un test de referencia, el 🤖 no puede escribir tests de componentes.

## Objetivo
`npm test` corre Vitest (una sola pasada, no watch) con React Testing Library y MSW, mide cobertura v8 con umbral, y hay un test de referencia.

## Alcance
- Incluye: elegir versiones de Vitest/RTL/MSW **compatibles con Vite 5.2** (no actualizar Vite acá); `vitest.config.ts` (o `test` en `vite.config.ts`) con `jsdom`, `setupFiles` (jest-dom + MSW server), coverage v8 con umbral = base medida redondeada hacia abajo; scripts `test` (`vitest run`) y `test:watch`; `src/test/msw/handlers.ts` con login y listado de workspaces según `/v3/api-docs`; test de referencia `LoginForm.test.tsx` (render, error de validación, submit OK y credenciales inválidas vía MSW); excluir los tests del lint si hace falta; `verify.sh` ya corre `npm test`; actualizar `docs/TESTING.md` (referencia y umbral), `frontend/README.md` y `frontend/AGENTS.md`.
- **No incluye:** migrar ESLint/Vite/React; tests de todas las pantallas (van como tareas 🤖 de caracterización al Backlog: una por vista).

## Leer antes
- `frontend/package.json`, `frontend/vite.config.ts`, `frontend/tsconfig.json`
- `frontend/src/views/LoginView/LoginForm/LoginForm.tsx`, `frontend/src/services/useAuth.ts` (T-018)
- `docs/TESTING.md` §1, §3, §5

## Archivos previstos
- modificar: `package.json`, `package-lock.json` (npm), `vite.config.ts` o crear `vitest.config.ts`, `docs/TESTING.md`, `frontend/README.md`, `frontend/AGENTS.md`
- crear: `src/test/setup.ts`, `src/test/msw/{handlers,server}.ts`, `src/views/LoginView/LoginForm/LoginForm.test.tsx`

## Criterios de aceptación
- [ ] `./scripts/verify.sh --client` pasa y muestra `✅ tests`.
- [ ] `npx vitest run src/views/LoginView/LoginForm/LoginForm.test.tsx` corre solo ese archivo.
- [ ] Bajar el umbral de cobertura no es necesario para pasar; subirlo por encima de la base hace fallar `npm test` (probar y revertir).
- [ ] Backlog con una línea 🤖 de caracterización por vista principal.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Cobertura: … · Pendientes → nuevas tareas: …

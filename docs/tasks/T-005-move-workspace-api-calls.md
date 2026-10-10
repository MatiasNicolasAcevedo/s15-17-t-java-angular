# T-005 · Move workspace API calls out of `Api.tsx`
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `refactor/T-005-move-workspace-api-calls` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo)

## Por qué
`npm run lint` falla (se permiten 0 warnings) con 3 avisos `react-refresh/only-export-components` en `frontend/src/services/Api.tsx`: un archivo `.tsx` que exporta un componente (`AuthProvider`) no puede exportar también funciones. Dos de los tres avisos son `fetchWorkspaces` (línea ~173) y `fetchWorkspaceById` (línea ~187). El tercero (`useAuth`, línea ~170) es T-018.

## Objetivo
Las llamadas de workspaces viven en `src/services/workspaces.ts` y la URL base en `src/services/apiConfig.ts`; el lint baja de 3 warnings a 1.

## Alcance
- Incluye: crear `src/services/apiConfig.ts` con `export const API_URL = "https://woodwork.onrender.com/v1/api";` (mismo valor que hoy); crear `src/services/workspaces.ts` con `fetchWorkspaces` y `fetchWorkspaceById` **copiadas sin cambios de lógica** (mismos tipos, mismo uso de `axios` y del token de `localStorage`); en `Api.tsx` borrar esas dos funciones, la constante `API_URL` y los imports que queden sin uso (`axios`, `Workspace`, `WorkspaceDetail`), e importar `API_URL` desde `./apiConfig`; actualizar los 3 imports que las usan.
- **No incluye:** mover `useAuth` (T-018); leer la URL de una variable de entorno (T-006); cambiar `fetch` por `axios` o viceversa; tocar componentes más allá de la línea del import.

## Leer antes
- `frontend/src/services/Api.tsx` líneas 1–31 y 160–200
- `frontend/AGENTS.md`
- Líneas de import: `frontend/src/views/dashboardView/DashboardView.tsx:2`, `frontend/src/views/reservationView/ReservationView.tsx:6`, `frontend/src/views/EditProfileView/EditProfileView.tsx:3`

## Archivos previstos
- crear: `frontend/src/services/apiConfig.ts`, `frontend/src/services/workspaces.ts`
- modificar: `frontend/src/services/Api.tsx`, `DashboardView.tsx`, `ReservationView.tsx`, `EditProfileView.tsx` (solo el import: `from "../../services/workspaces"`)

## Tests
- No hay tests de front todavía (T-013). Verificación: `tsc` (dentro de `npm run build`) + lint.

## Pasos sugeridos
1. Crear `apiConfig.ts` y `workspaces.ts` (con `import axios from "axios";`, `import { Workspace, WorkspaceDetail } from "../types/Types";` y `import { API_URL } from "./apiConfig";`).
2. Editar `Api.tsx` y los 3 imports.
3. `npm run build` y `npm run lint` desde `frontend/`.

## Criterios de aceptación
- [ ] Desde `frontend/`: `npm run build` → `✓ built` (sin errores de TypeScript).
- [ ] Desde `frontend/`: `npm run lint` → `✖ 1 problem (0 errors, 1 warning)` y el único warning es el de `useAuth` en `src/services/Api.tsx`.
- [ ] `grep -rn "fetchWorkspaces\|fetchWorkspaceById" frontend/src/services/Api.tsx` → sin resultados.
- [ ] `grep -rn "woodwork.onrender.com" frontend/src` → solo `src/services/apiConfig.ts`.
- [ ] `./scripts/verify.sh --client` muestra `❌ lint (1 problem ...)` y `✅ build` (el lint queda en verde con T-018).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …

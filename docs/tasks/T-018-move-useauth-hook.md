# T-018 · Move the `useAuth` hook and auth context out of `Api.tsx`
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `refactor/T-018-move-useauth-hook` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-005 · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo)

## Por qué
Después de T-005 queda 1 warning de lint (`react-refresh/only-export-components`) en `frontend/src/services/Api.tsx`: el archivo exporta el componente `AuthProvider` y también el hook `useAuth` (`export default useAuth`). Mientras haya un warning, `./scripts/verify.sh` falla.

## Objetivo
`useAuth`, `AuthContext` y el tipo `AuthContextType` viven en `src/services/useAuth.ts`; `Api.tsx` solo exporta `AuthProvider`; el lint queda en 0 warnings.

## Alcance
- Incluye: crear `src/services/useAuth.ts` con la interfaz `AuthContextType` (exportada), `export const AuthContext = createContext<AuthContextType | undefined>(undefined);` y el hook `useAuth` **sin cambios de lógica**, con `export default useAuth;`; en `Api.tsx` borrar esas definiciones e importarlas (`import { AuthContext, AuthContextType } from "./useAuth";`) y quitar imports sin uso; cambiar en los importadores `services/Api` por `services/useAuth` **solo donde se importa `useAuth`**.
- **No incluye:** cambiar la lógica de login/registro; renombrar `Api.tsx`; tocar `AuthProvider` más allá de los imports; T-006.

## Leer antes
- `frontend/src/services/Api.tsx` líneas 1–31 y 155–175 (después de T-005 las líneas pueden moverse: buscá `interface AuthContextType`, `createContext` y `const useAuth`)
- `frontend/AGENTS.md`
- Imports a cambiar (`grep -rn "useAuth from" frontend/src`): `components/NavBar.tsx:3`, `App.tsx:12`, `views/RegisterView/RegisterForm/RegisterForm.tsx:4`, `views/LoginView/LoginForm/LoginForm.tsx:4`, `views/EditProfileView/Components/UserDescription.tsx:1`

## Archivos previstos
- crear: `frontend/src/services/useAuth.ts`
- modificar: `frontend/src/services/Api.tsx`, `NavBar.tsx`, `App.tsx`, `RegisterForm.tsx`, `LoginForm.tsx`, `UserDescription.tsx` (en `App.tsx` queda `import { AuthProvider } from "./services/Api";` y `import useAuth from "./services/useAuth";`)

## Tests
- No hay tests de front todavía (T-013). Verificación: `tsc` + lint + que la app cargue.

## Pasos sugeridos
1. Crear `useAuth.ts` (imports: `createContext`, `useContext` de `react` y `UserI` de `../types/Types`).
2. Editar `Api.tsx` y los 5 importadores.
3. `npm run lint`, `npm run build`, y `npm run dev` + abrir http://localhost:5173 (la home carga, sin errores en la consola del navegador).

## Criterios de aceptación
- [ ] Desde `frontend/`: `npm run lint` termina sin problemas (exit code 0).
- [ ] Desde `frontend/`: `npm run build` → `✓ built`.
- [ ] `grep -rn "useAuth from" frontend/src` → todos apuntan a `services/useAuth`.
- [ ] `./scripts/verify.sh --client` → `client: ✅ lint ✅ build ⚠️ sin tests (T-013)` y exit code 0.
- [ ] `STATUS.md` → fila `verify.sh` actualizada (el client pasa).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …

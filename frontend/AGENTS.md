# AGENTS.md · front

Solo lo específico del front. Lo general: [AGENTS.md raíz](../AGENTS.md).

- **Dónde correr:** desde `frontend/` con Node 24 (`.nvmrc` en la raíz) y `npm` (hay `package-lock.json`; no uses yarn ni bun). Gate: `../scripts/verify.sh --client`.
- **Lint estricto:** `npm run lint` con `--max-warnings 0`. `react-refresh/only-export-components`: los archivos `.tsx` que exportan componentes no deben exportar funciones/constantes.
- **Typecheck:** `npm run build` corre `tsc` (strict, `noUnusedLocals`, `noUnusedParameters`).
- **API:** todo pasa por `src/services/` (`Api.tsx`: `AuthProvider`/`useAuth` + llamadas). No llames a `fetch`/`axios` desde componentes nuevos. URL base: hoy hardcodeada (T-006); después `import.meta.env.VITE_API_URL`.
- **Rutas:** `src/App.tsx`; las privadas usan `ProtectedRoute`. Página nueva = `pages/<Nombre>/<Nombre>.tsx` que renderiza `views/<Nombre>View/...`.
- **Estilos:** Tailwind en `className` + componentes NextUI. Sin CSS nuevo salvo necesidad.
- **Formularios:** React Hook Form (referencia: `src/views/LoginView/LoginForm/LoginForm.tsx`).
- **Tipos:** compartidos en `src/types/Types.ts`.
- **Tests:** desde T-013, `*.test.tsx` junto al componente; un test: `npx vitest run src/ruta/X.test.tsx`.
- **No abrir:** `package-lock.json`, `node_modules/`, `dist/`. `Footer.tsx` es largo (datos del equipo): leelo por rangos.

# T-006 · Read the API base URL from `VITE_API_URL`
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `feat/T-006-read-api-url-from-env` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-005 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca configuración)

## Por qué
El front llama siempre a producción (`https://woodwork.onrender.com/v1/api`, hoy en `frontend/src/services/apiConfig.ts` después de T-005): no se puede desarrollar ni probar contra el back local, y el README tiene pasos marcados "⚠️ Hoy falla: ver T-006". `frontend/.env.example` ya define `VITE_API_URL`.

## Objetivo
`API_URL` sale de `import.meta.env.VITE_API_URL`; si no está definida, se usa la URL de producción actual (así el deploy existente no se rompe). Con `frontend/.env` copiado del ejemplo, el front habla con `http://localhost:8080/v1/api`.

## Alcance
- Incluye: `export const API_URL = import.meta.env.VITE_API_URL ?? "https://woodwork.onrender.com/v1/api";` en `apiConfig.ts`; tipar la variable en `frontend/src/vite-env.d.ts` (`interface ImportMetaEnv { readonly VITE_API_URL?: string }` + `interface ImportMeta { readonly env: ImportMetaEnv }`); quitar los "⚠️ Hoy falla: ver T-006" del README (opción A, pasos 7 y 8, tabla de problemas frecuentes) y las notas equivalentes en `frontend/.env.example`, `frontend/README.md`, `scripts/dev.sh` (mensaje final) y `AGENTS.md` §11.
- **No incluye:** cambiar endpoints, el manejo de errores o el AuthProvider; configurar Netlify/Vercel (si el dueño quiere, define `VITE_API_URL` allá: anotalo en "Resultado"); CORS del back (hoy acepta `*`).

## Leer antes
- `frontend/src/services/apiConfig.ts` y `frontend/src/vite-env.d.ts` (completos, son cortos)
- `frontend/.env.example`
- `README.md`: buscar `T-006` (`grep -n "T-006" README.md`)
- `docs/SETUP.md#variables` (fila `VITE_API_URL`)

## Archivos previstos
- modificar: `frontend/src/services/apiConfig.ts`, `frontend/src/vite-env.d.ts`, `frontend/.env.example`, `README.md`, `frontend/README.md`, `scripts/dev.sh`, `AGENTS.md`, `docs/SETUP.md` (columna "Obligatoria": "no (default: producción)")

## Tests
- No hay tests de front todavía (T-013). Verificación por build (criterios). T-017 (E2E) cubre el login contra el back local.

## Pasos sugeridos
1. Cambiar `apiConfig.ts` y `vite-env.d.ts`; `npm run build`.
2. Probar el bundle con y sin `.env` (criterios 2 y 3).
3. `./scripts/dev.sh`, abrir http://localhost:5173/login, iniciar sesión con `demo@woodwork.local` / `Demo1234!` y confirmar que redirige a `/dashboard` (en DevTools → Network las requests van a `localhost:8080`).
4. Actualizar las docs.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --client` pasa.
- [ ] Con `frontend/.env` copiado del ejemplo: `npm run build && grep -l "http://localhost:8080/v1/api" dist/assets/*.js` encuentra el bundle.
- [ ] Sin `frontend/.env` (renombralo temporalmente): `npm run build && grep -L "http://localhost:8080/v1/api" dist/assets/index-*.js` lo lista (usa el default de producción). Restaurá el `.env`.
- [ ] Login desde la UI con el usuario demo contra el back local funciona (paso 3), descripto en el PR.
- [ ] `grep -n "T-006" README.md AGENTS.md scripts/dev.sh frontend/README.md frontend/.env.example` → sin resultados.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …

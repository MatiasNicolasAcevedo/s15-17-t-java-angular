# WoodWork · front (`frontend/`)

SPA de WoodWork: React 18 + TypeScript + Vite 5, Tailwind + NextUI, React Router 6. Volver al [README raíz](../README.md).

## Configurar

Desde `frontend/` (Node 24: `nvm install` en la raíz lee `.nvmrc`):

```bash
cp .env.example .env
```

```bash
npm ci
```

Resultado esperado: `added N packages`. `VITE_API_URL` apunta al back local, ⚠️ pero hoy el código la ignora y usa producción (`src/services/Api.tsx:30`): ver T-006.

## Correr

```bash
npm run dev
```

Resultado esperado: `Local: http://localhost:5173/`; la home de WoodWork carga. Para la API local, levantá el back ([README del back](../backend/coworkProject/README.md)).

## Comandos

| Qué | Comando (desde `frontend/`) |
|---|---|
| Dev con hot reload | `npm run dev` |
| Lint (0 warnings permitidos) | `npm run lint` (⚠️ hoy falla: T-005) |
| Build (typecheck + bundle) | `npm run build` → `dist/` |
| Previsualizar build | `npm run preview` |
| Tests / un solo test | no hay todavía (T-013); será `npx vitest run src/ruta/Archivo.test.tsx` |
| Gate | `../scripts/verify.sh --client` |
| Imagen local | desde la raíz: `docker compose --profile app build client` (usa `Dockerfile.dev` + `nginx.dev.conf`) |

`netlify.toml` y `vercel.json` son la configuración de deploy original (SPA fallback).

## Estructura

```
src/
  App.tsx            rutas y ProtectedRoute
  main.tsx           punto de entrada
  pages/             una carpeta por ruta (envuelven las views)
  views/             pantallas con sus subcomponentes
  components/        NavBar, Footer, formularios compartidos
  services/Api.tsx   AuthProvider (contexto de auth) + llamadas a la API
  services/*API.ts   datos estáticos (FAQ, reviews, slides)
  types/Types.ts     tipos compartidos
  assets/            imágenes
```

Para agentes: [AGENTS.md](AGENTS.md).

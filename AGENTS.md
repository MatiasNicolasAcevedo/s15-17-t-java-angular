# AGENTS.md

Guía para cualquier agente que llega sin contexto (incluido el agente gratuito de IntelliJ). Imperativa y estable; el estado vive en [docs/STATUS.md](docs/STATUS.md).

## 1. Proyecto y ejecutores

WoodWork: reservas de espacios de coworking. Monorepo con `backend/coworkProject/` (Spring Boot, API REST `/v1/api/**`) y `frontend/` (React SPA). Retomado de un proyecto de equipo de 2024 para terminarlo y dejarlo de portfolio.

```
backend/coworkProject/   API (Maven)       → backend/coworkProject/AGENTS.md
frontend/                SPA (Vite)        → frontend/AGENTS.md
docs/                    estado, tareas, specs, ADRs, auditorías, protocolos
scripts/                 verify.sh (gate), dev.sh (entorno local)
docker-compose.yml       DB (siempre) + server/client (profile app)
```

| Ícono | Ejecutor | Hace |
|---|---|---|
| 🧠 | **Modelo de frontera** (p. ej. Claude Code) | relevar, decidir arquitectura, seguridad, infra de tests/CI/contenedores, migraciones, escribir tareas, revisar lo riesgoso, auditar |
| 🤖 | **Agente gratuito** de IntelliJ IDEA (Qwen) | tareas chicas y bien especificadas, de a una, con tests; revisar PRs chicos sin riesgo |
| 👤 | **Dueño** | decidir, configurar GitHub, rotar secretos, mergear, **cambiar de agente** |

**Traspasos:** cuando el próximo paso es de otro ejecutor, no lo hagas: terminá con
> **Próximo paso:** T-NNN · <título> · **ejecuta: 🤖 agente gratuito (IntelliJ)** | **🧠 modelo de frontera** | **👤 dueño**
> **Qué hacer:** abrí <chat nuevo del agente de IntelliJ | una sesión nueva de Claude Code | GitHub → …> y escribí: «Seguí `docs/agents/implementer.md`».

## 2. Stack (versiones reales)

Back: Java 17 (compila y corre con JDK 21), Spring Boot 3.2.5, Spring Security 6.2 + jjwt 0.11.5, Spring Data JPA/Hibernate 6.4, PostgreSQL (imagen 18), MapStruct 1.5.5, Lombok, springdoc 2.2.0, Maven Wrapper 3.9.6. Front: Node 24 (`.nvmrc`), React 18.3, TypeScript 5.4 (strict), Vite 5.2, React Router 6.23, NextUI 2.3, Tailwind 3.4, axios 1.7, ESLint 8.

## 3. Comandos verificados

Setup completo: [README](README.md#levantar-el-proyecto-en-local). Desde la raíz salvo que se indique:

| Qué | Comando |
|---|---|
| Gate (build + lint + tests) | `./scripts/verify.sh` · `--server` · `--client` (detalle en `.verify-logs/`) |
| Entorno dev completo | `./scripts/dev.sh` (Ctrl+C corta; `--down` apaga la DB) |
| Solo DB | `docker compose up -d --wait` |
| Todo en contenedores | `docker compose --profile app up -d --build --wait` · apagar: `docker compose --profile app down -v` |
| Back | `cd backend/coworkProject && ./mvnw spring-boot:run` |
| Front | `cd frontend && npm ci && npm run dev` |
| Un test del back | `cd backend/coworkProject && ./mvnw test -Dtest='Clase#metodo'` (funciona desde T-002) |
| Un test del front | `cd frontend && npx vitest run src/ruta/X.test.tsx` (desde T-013) |
| E2E | `./scripts/e2e.sh` (desde T-017) |

## 4. Protocolo de sesión

Detalle completo: [docs/agents/implementer.md](docs/agents/implementer.md), [reviewer.md](docs/agents/reviewer.md), [auditor.md](docs/agents/auditor.md).
1. Leé `docs/STATUS.md` y `docs/BACKLOG.md` y mirá los PR/ramas abiertos (`gh pr list` o `git ls-remote --heads origin`).
2. **Una tarea por sesión y una a la vez:** si hay un PR de tarea abierto, no empieces otra.
3. Tomá siempre **la primera** de "Listas". Si no te corresponde (🧠 o 👤), avisá con el formato de Traspasos y terminá. No saltees.
4. **Creá la rama con el nombre exacto de la tarea antes del primer commit**; PR en draft enseguida.
5. Tests en el mismo PR; `./scripts/verify.sh` en verde; tablero, tarea y STATUS actualizados en el PR; PR "ready"; sugerí sesión nueva.

## 5. Gestión de contexto

1. **Una tarea = una sesión.** Al cerrar una tarea, revisión o auditoría, sugerí una **sesión nueva** (mejor que compactar).
2. Compactar **solo a mitad de un trabajo largo** y si: se cerró una sub-etapa; hay logs/archivos que ya no sirven; el contexto pasa ~60 % (🧠) o ~50 % (🤖); o hay degradación (releer archivos, olvidar decisiones, repetir intentos).
3. **Antes, persistir:** "Notas de implementación" de la tarea (hecho / pendiente / próximo paso), commit y push.
4. **Cómo:** 🧠 `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` + «después escribime "seguí con T-NNN"». 🤖 (sin `/compact`): «abrí un chat nuevo y escribí: Seguí `docs/agents/implementer.md` (retomando T-NNN)».
5. No compactar justo antes de terminar ni entre tareas.
6. Higiene: salida acotada (`| tail -n 60`, logs a archivo + `grep`); grep/glob y rangos de líneas; no abrir `package-lock.json`, `target/`, `node_modules/`, `dist/`, generados ni `docs/archive/`; respuestas cortas.

## 6. Configuración

Regla: **todo archivo de configuración por entorno tiene su `.example` commiteado y el real en `.gitignore`.**

| Ejemplo | Se copia a | Nota |
|---|---|---|
| `backend/coworkProject/src/main/resources/env.properties.example` | `.../resources/env.properties` | se lee del **classpath**, no de la raíz del módulo |
| `frontend/.env.example` | `frontend/.env` | `VITE_*`, se resuelve en build |

Al agregar o renombrar una variable: `.example` + `docs/SETUP.md#variables` + README + `docker-compose.yml`, en el mismo PR. Nunca leas ni copies valores de los archivos reales.

## 7. Mapa de documentación

| Archivo | Qué contiene | Cuándo leerlo |
|---|---|---|
| `docs/STATUS.md` | estado, salud, próximo paso | siempre, primero |
| `docs/BACKLOG.md` | cola de tareas | siempre |
| `docs/tasks/T-NNN-*.md` | contrato de la tarea | la que tomás |
| `docs/agents/*.md` | protocolos de sesión | el de tu sesión |
| `CONTRIBUTING.md` | ramas, commits, PR, revisión | al abrir PR o revisar |
| `docs/TESTING.md` | estrategia y reglas de tests | al escribir tests |
| `docs/ARCHITECTURE.md` | diagramas, modelo, endpoints | si la tarea lo enlaza |
| `docs/SETUP.md` | variables, puertos, IDE, agentes | al tocar configuración |
| `docs/ROADMAP.md`, `docs/adr/` | fases y decisiones | 🧠 al planificar |
| `docs/audits/` (vieja), `docs/archive/` | historia | **no leer** salvo que la tarea lo indique |

## 8. Convenciones actuales del código

- Back: capas `controller → service (interfaz + impl) → repository`; DTOs en `dto/request|response` con Bean Validation; MapStruct en `mapper/`; inyección por campo `@Autowired` (heredada; en código nuevo, por constructor con `@RequiredArgsConstructor`). Referencias: `controller/LoginController.java`, `service/impl/ReservationServiceImpl.java`, `dto/request/RegisterRequestDTO.java`, `mapper/UserMapper.java`. Endpoints estilo RPC (`/v1/api/workspace/listOfWorkspaces`): no los renombres sin tarea.
- Front: componentes funcionales con hooks; páginas en `pages/` que envuelven `views/`; Tailwind en `className`; formularios con React Hook Form (`views/LoginView/LoginForm/LoginForm.tsx`); auth en `services/Api.tsx` (`useAuth`). Indentación 2 espacios, comillas dobles (mayoritarias).
- Tests: ver tabla de referencias en `docs/TESTING.md` (se completa en T-002/T-013).

## 9. Git

Rama `<tipo>/T-NNN-slug` desde `main` antes del primer commit · Conventional Commits con `Refs: T-NNN` · un PR por tarea, título Conventional Commit, draft → ready · squash merge por el dueño. Detalle: [CONTRIBUTING.md](CONTRIBUTING.md).

## 10. Límites (no tocar sin una tarea que lo pida)

Versiones mayores de dependencias · esquema de DB y datos · seguridad/autenticación · deploy (`Dockerfile` de producción, `netlify.toml`, `vercel.json`) y CI · secretos y configuración real · borrar, saltear o debilitar tests o bajar umbrales · commitear a `main` · mergear sin revisión · trabajo "de paso" (va al Backlog).

## 11. Gotchas

- `env.properties` en la raíz del módulo **no se lee** (`ClassNotFoundException: org.hibernate.dialect.`): va en `src/main/resources/`.
- `pom.xml` tiene `skipTests=true`: `./mvnw test` no corre nada hasta T-002.
- El front llama a producción (`src/services/Api.tsx:30`) hasta T-006.
- Errores del back → 403 sin cuerpo (no hay manejo global y `/error` está protegido) hasta T-012: no asumas que 403 = falta de permisos.
- `ServerWakeUpScheduler` hace GET a Render cada 14 min también en local (T-009).
- `npm run lint` usa `--max-warnings 0`: un warning rompe el gate.
- Puerto 5173/8080/5432 ocupado → cortá el `npm run dev`/back/Postgres anterior.

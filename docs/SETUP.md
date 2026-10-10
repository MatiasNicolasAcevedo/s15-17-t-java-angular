# Setup detallado

Complementa el [README](../README.md#levantar-el-proyecto-en-local) (no repite el paso a paso).

## Variables

Back: `backend/coworkProject/src/main/resources/env.properties` (copia de `.example`) o variables de entorno (tienen prioridad). Front: `frontend/.env` (Vite, se resuelve en build).

| Nombre | Para qué | Valor local | Obligatoria | Dónde se define en prod |
|---|---|---|---|---|
| `DB_URL` | host:puerto de Postgres | `localhost:5432` (en compose: `db:5432`) | sí (default `localhost:3306`) | Render → Environment |
| `DB_NAME` | base | `woodwork` | sí (default `coworkProject`) | Render |
| `DB_USER` / `DB_PASSWORD` | credenciales | `woodwork` / `woodwork` | sí | Render (secreto) |
| `DB_DRIVER_CLASS_NAME` | driver JDBC | `org.postgresql.Driver` | sí (default MySQL, incorrecto) | Render |
| `DB_DIALECT` | dialecto Hibernate | `PostgreSQLDialect` | sí | Render |
| `CLOUDINARY_NAME` / `CLOUDINARY_API_KEY` / `CLOUDINARY_API_SECRET` | subida de imágenes | valores falsos (arranca; subir falla) | sí (sin ellas no arranca) | Render (secreto) |
| `JWT_SECRET` | firma HMAC de tokens (base64, ≥ 32 bytes) | generado en el `.example` | desde T-001 | Render (secreto, **rotar**: T-011) |
| `VITE_API_URL` | base de la API para el front | `http://localhost:8080/v1/api` | desde T-006 | Netlify/Vercel → build env |

Al agregar o renombrar una variable: actualizá el `.example`, esta tabla, el README y `docker-compose.yml` en el mismo PR ([CONTRIBUTING](../CONTRIBUTING.md#configuración)).

## Sin Docker

Necesitás un PostgreSQL propio (14+): creá la base y el usuario y ajustá `DB_URL`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` en `env.properties`. El esquema lo crea Hibernate (`ddl-auto=update`).

## Puertos

| Servicio | Puerto | Cómo cambiarlo |
|---|---|---|
| Postgres | 5432 | `ports` de `db` en `docker-compose.yml` + `DB_URL` |
| Back | 8080 | `SERVER_PORT=8081 ./mvnw spring-boot:run` (y `VITE_API_URL`) |
| Front (dev y contenedor) | 5173 | `npm run dev -- --port 5174`; en compose, `ports` de `client` |

## IDE

- **IntelliJ IDEA:** abrir la raíz; importar `backend/coworkProject/pom.xml` como proyecto Maven; SDK 21; habilitar *annotation processing* (Lombok + MapStruct). Run config: `CoworkProjectApplication` (lee `env.properties` del classpath, no hace falta cargar variables).
- **VS Code:** Extension Pack for Java + ESLint + Tailwind CSS IntelliSense.
- Debug del back: `./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"` y "Remote JVM Debug" a `localhost:5005`.

## Resetear datos

`docker compose down -v && docker compose up -d --wait` borra la base. No hay seed (T-016): `./scripts/dev.sh` crea el usuario demo `demo@woodwork.local` / `Demo1234!`.

## Agentes

### 🤖 Agente gratuito de IntelliJ (Qwen)

⚠️ No verificado en la IDE. Según la documentación de JetBrains AI Assistant (búsqueda web, 2026-10), los **agentes** leen `AGENTS.md` del proyecto y el **chat** usa las reglas de `.aiassistant/rules/`; Junie usaba `.junie/guidelines.md`. Los dos últimos existen en el repo como punteros de una línea a `AGENTS.md`.

1. Abrí el panel de AI Assistant → **chat nuevo** → elegí el **modo agente** (no solo chat) y el agente/modelo gratuito (Qwen).
2. Permitile ejecutar comandos en la terminal del IDE (aprobá cada comando o agregá a la lista permitida: `./scripts/verify.sh`, `./mvnw`, `npm`, `git status|diff|log|switch|add|commit|push`).
3. Escribí: «Leé `AGENTS.md` y seguí `docs/agents/implementer.md`» (o `reviewer.md`).
4. Git: el agente crea la rama, commitea y hace `git push -u origin <rama>`. No tiene `gh`: al final te deja el **link de comparación** (`https://github.com/MatiasNicolasAcevedo/s15-17-t-java-angular/compare/main...<rama>?expand=1`) con título y cuerpo listos; vos abrís el PR (draft al empezar, "ready" al terminar).
5. Sin `/compact`: si el chat se llena, el agente guarda "Notas" en la tarea, commitea y te pide abrir un chat nuevo con la frase de retomar.

### 🧠 Modelo de frontera (Claude Code)

`CLAUDE.md` importa `AGENTS.md`. `.claude/settings.json` permite los comandos seguros (verify, mvnw, npm, git de lectura, `gh pr ...`) y niega push forzado, push a `main` y leer la configuración real. Sesión nueva por tarea; `/compact` según [AGENTS.md](../AGENTS.md#5-gestión-de-contexto).

## Notas del entorno de la sesión de bootstrap

En el contenedor donde se verificó (2026-10-10) Docker Hub devolvía 429 y la salida HTTPS pasa por un proxy con CA propia: las imágenes se bajaron de `mirror.gcr.io` y los builds de `Dockerfile.dev` se verificaron con una variante que agrega ese CA (no commiteada). En una máquina normal no hace falta nada de esto.

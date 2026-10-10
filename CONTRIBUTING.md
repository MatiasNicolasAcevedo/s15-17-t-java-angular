# Cómo contribuir

Flujo para humanos y agentes. Ejecutores: 🧠 modelo de frontera · 🤖 agente gratuito (IntelliJ) · 👤 dueño ([AGENTS.md](AGENTS.md)).

## 1. Ramas (GitHub Flow)

- `main` siempre en verde. **Nadie commitea directo a `main`.**
- **Antes del primer commit de cualquier tarea** se crea su rama desde `main` actualizado, con el nombre exacto que figura en la tarea:
  ```bash
  git switch main && git pull && git switch -c <tipo>/T-NNN-slug-corto
  ```
- Tipos: `feat`, `fix`, `test`, `refactor`, `chore`, `docs`, `ci`, `build`, `perf`. Ej.: `fix/T-001-externalize-jwt-secret`.
- Vida corta. Si `main` avanzó: `git fetch origin && git rebase origin/main` (en tu rama, antes de pedir revisión).

## 2. Commits (Conventional Commits)

```
tipo(alcance): descripción en imperativo, en inglés

Cuerpo opcional: el porqué.

Refs: T-NNN
```

- Alcances: `server`, `client`, `infra`, `docs`, `board`. Ej.: `fix(server): read JWT secret from configuration`.
- Atómicos (un cambio lógico por commit). `!` y `BREAKING CHANGE:` para cambios incompatibles.
- Prohibido: "wip", "fix", "cambios", "Update README.md".

## 3. Pull requests

- **Uno por tarea, chico** (< ~400 líneas sin lockfiles ni generados) y **uno abierto a la vez**: no se empieza otra tarea hasta que el PR anterior se mergea o se cierra.
- **Título = Conventional Commit** (lo valida `.github/workflows/pr-title.yml`; se mergea con squash, así que el título es el commit final).
- Se abre en **draft apenas se crea la rama** (primer commit: `docs(board): start T-NNN`) y pasa a **ready** con `./scripts/verify.sh` en verde y el [template](.github/pull_request_template.md) completo.
- Sin `gh` (🤖): `git push -u origin <rama>` y el dueño abre el PR desde `https://github.com/MatiasNicolasAcevedo/s15-17-t-java-angular/compare/main...<rama>?expand=1` con el título y cuerpo que deja el agente.

## 4. Revisión

Siempre en una **sesión nueva** con [docs/agents/reviewer.md](docs/agents/reviewer.md).

| PR | Implementa | Revisa | Quién lanza la revisión |
|---|---|---|---|
| Tarea 🤖 S, sin riesgo | 🤖 agente gratuito | 🤖 agente gratuito, **chat nuevo** | 👤 abre el chat nuevo |
| Tarea 🤖 M, o que toca back y front, seguridad, datos, configuración o CI | 🤖 agente gratuito | 🧠 modelo de frontera | 👤 abre una sesión de frontera |
| Tarea 🧠 | 🧠 modelo de frontera | 🧠 sesión nueva o sub-agente (si el dueño lo pide) + 👤 | 👤 |
| Dependabot | bot | 🤖; versión mayor → tarea 🧠 | 👤 |

- La tarea dice en "Revisa" quién revisa; la respuesta final de quien implementó dice qué abrir y qué escribir.
- Sin cuenta bot, la revisión es un **comentario** con veredicto: `APROBADO` / `CAMBIOS REQUERIDOS` / `ESCALAR A 🧠/DUEÑO`.
- Máximo 2 rondas; después se escala a 🧠 o al dueño.

## 5. Merge

Squash, con CI en verde (o `verify.sh` sin regresiones mientras no haya CI) y revisión aprobada. Lo hace 👤, o 🧠 solo si el dueño lo pide explícitamente para ese PR. Después: borrar la rama.

## 6. Protección de `main`

Tarea 👤 [T-010](docs/tasks/T-010-protect-main.md): ruleset (PR obligatorio, checks requeridos, rama actualizada, historia lineal, sin force push), solo squash, borrar ramas al mergear.

## 7. Releases

Al cerrar cada fase del [ROADMAP](docs/ROADMAP.md): `git tag v0.x.0 && git push origin v0.x.0 && gh release create v0.x.0 --generate-notes`.

## 8. Dependabot

Maven (`/backend/coworkProject`), npm (`/frontend`) y GitHub Actions; semanal; minor/patch agrupados; prefijos `build(deps)` / `ci(deps)` compatibles con el check de título. **Solo con CI en verde**: [T-015](docs/tasks/T-015-add-dependabot.md).

## Configuración

Regla permanente: **todo archivo de configuración con valores por entorno tiene su `.example` commiteado y el real en `.gitignore`.** Todo cambio que agregue o renombre una variable actualiza en el mismo PR: el `.example`, [docs/SETUP.md](docs/SETUP.md#variables), el README y `docker-compose.yml`. Los valores de ejemplo son inventados y válidos para local (secretos: `openssl rand -base64 32`).

## Tests

Reglas en [docs/TESTING.md](docs/TESTING.md#4-reglas-para-todas-las-tareas): tests en el mismo PR, bugfix con test que falla primero, nada de borrar o debilitar tests.

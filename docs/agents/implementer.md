# Protocolo · Implementador (una tarea por sesión)

**Lo usan:** 🤖 agente gratuito (IntelliJ) y 🧠 modelo de frontera. Sos el implementador de **una sola** tarea. Repo: `MatiasNicolasAcevedo/s15-17-t-java-angular`, rama por defecto `main`.

## 1. Orientarse (sin escribir código)
- Leé `AGENTS.md`, `docs/STATUS.md`, `docs/BACKLOG.md`.
- `git status` y `git log --oneline -10`.
- PRs y ramas abiertas: `gh pr list` · sin `gh`: `git fetch origin && git ls-remote --heads origin` (ramas `*/T-NNN-*` distintas de `main` = trabajo en vuelo).

## 2. Primero lo que está en vuelo
- Si hay un PR tuyo con **cambios pedidos** (veredicto `CAMBIOS REQUERIDOS`): atendelo en su rama (`git switch <rama> && git pull`) y saltá al paso 6.
- Si hay **un PR de tarea abierto** esperando revisión o merge: no tomes otra tarea. Terminá con el traspaso (paso 11) diciendo quién revisa (según "Revisa" de la tarea) o «👤 mergear PR <link>».

## 3. Línea de base
`git switch main && git pull` y `./scripts/verify.sh`. Anotá el resumen. Si falla por algo **que no es lo que ya documenta STATUS**, no sigas: creá/tomá la tarea que lo arregla o escalá (paso 9).

## 4. Tomar la tarea
- Tomá **la primera** de "✅ Listas" en `docs/BACKLOG.md` (que no tenga PR ni rama remota).
- Si dice `Ejecuta: 🧠` y sos el 🤖, o dice `👤`: **no la tomes ni saltees a otra.** Terminá con el traspaso (paso 11).
- Creá la rama con el **nombre exacto** del campo "Rama" de la tarea, antes de cualquier commit:
  `git switch -c <tipo>/T-NNN-slug`
- Mové la tarea a "🔨 En curso" en `BACKLOG.md` y poné `Estado: En curso` en el archivo de la tarea. Commit `docs(board): start T-NNN` y `git push -u origin <rama>`.
- PR en draft con el template (`.github/pull_request_template.md`) y título Conventional Commit (el de la tarea):
  - con `gh`: `gh pr create --draft --title "<título>" --body-file <archivo>`
  - sin `gh` (🤖): dejale al dueño el link `https://github.com/MatiasNicolasAcevedo/s15-17-t-java-angular/compare/main...<rama>?expand=1` + título + cuerpo listos para pegar, y pedile que lo abra **en draft**. Seguí trabajando.

## 5. Contexto mínimo
Leé la tarea completa y **solo** lo de "Leer antes" y "Archivos previstos", por rangos de líneas. No abras `package-lock.json`, `target/`, `node_modules/`, `dist/`, `docs/archive/` ni auditorías viejas.

## 6. Implementar con tests
- Respetá "No incluye". Bugfix: primero el test que falla, después el fix.
- Entre pasos corré el test más específico (`./mvnw test -Dtest='Clase#metodo'` · `npx vitest run <archivo>`); al final `./scripts/verify.sh`.
- Si agregás o cambiás una variable: `.example`, `docker-compose.yml`, `docs/SETUP.md#variables` y README.
- Commits atómicos Conventional Commits con footer `Refs: T-NNN`. `git push` seguido.

## 7. Contexto largo
Si se cerró una sub-etapa y el contexto pasa ~50 % (🤖) / ~60 % (🧠), o notás que releés archivos u olvidás decisiones: completá "Notas de implementación" (hecho / pendiente / próximo paso), commit y push, y decí:
- 🧠: `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` → «después escribime "seguí con T-NNN"».
- 🤖: «Abrí un chat nuevo del agente de IntelliJ y escribí: Seguí `docs/agents/implementer.md` (retomando T-NNN)».

## 8. Reglas duras
No editar los criterios de aceptación · no borrar, deshabilitar ni debilitar tests · no bajar umbrales · no cambiar versiones mayores, arquitectura, seguridad, CI, deploy ni configuración de producción sin que la tarea lo pida · no tocar secretos ni leer los archivos de configuración reales · no commitear a `main` · no mergear. Trabajo extra descubierto → línea nueva en "📥 Backlog" (próximo ID libre), no "de paso".

## 9. Escalar
Después de **2 intentos fallidos**, ante una **decisión de diseño** o algo **fuera de alcance**: commiteá lo sano, completá "Notas" con lo probado y el error, mové la tarea a "⛔ Bloqueadas" con `bloqueada por: requiere 🧠 — <motivo>` (o `requiere dueño`), commit + push, comentario en el PR draft (o en el mensaje al dueño si no tenés `gh`) y terminá con el traspaso: «**Próximo paso:** T-NNN · ejecuta: 🧠 modelo de frontera · abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/implementer.md` para retomar T-NNN». **La cola queda detenida en esa tarea**: no tomes la siguiente.

## 10. Cerrar
- Comprobá cada criterio de aceptación y marcalo `[x]` con evidencia breve.
- Completá "Notas de implementación" y "Resultado" (PR, qué cambió, tests, pendientes → IDs nuevos).
- En `BACKLOG.md`: tarea a "🏁 Hecho reciente" con el número de PR (si hay más de 10, mové las viejas a `docs/archive/tasks/`). Estado `Hecha (en revisión)` en la tarea.
- `docs/STATUS.md`: salud (verify, cobertura), "Foco" (PR abierto, próximo paso con el traspaso de revisión, las 3 siguientes de la cola) y "Últimas sesiones" (máx. 5; las viejas → `docs/archive/log/AAAA-MM.md`).
- Descripción del PR completa (resumen de `verify.sh`; capturas 375 y 1280 px si hay UI) y **ready** (`gh pr ready` o pedíselo al dueño), indicando quién revisa.

## 11. Respuesta final (máx. 5 líneas) + traspaso
Qué hiciste y el resultado de verify, y el traspaso según "Revisa" de la tarea:
> **Próximo paso:** revisar PR <link> (T-NNN) · **ejecuta: 🤖 agente gratuito (IntelliJ)** | **🧠 modelo de frontera**
> **Qué hacer:** abrí <un chat nuevo del agente de IntelliJ | una sesión nueva de Claude Code> y escribí: «Seguí `docs/agents/reviewer.md` para el PR <número o rama>».

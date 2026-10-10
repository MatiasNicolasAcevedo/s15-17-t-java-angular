# Protocolo · Revisor (un PR por sesión)

**Lo usa:** el ejecutor que indica el campo "Revisa" de la tarea (🤖 agente gratuito en un chat nuevo, o 🧠 modelo de frontera en una sesión nueva o como sub-agente). Nunca la misma sesión que implementó.

## 0. ¿Me corresponde?
Abrí la tarea del PR (`docs/tasks/T-NNN-*.md` en la rama del PR). Si dice `Revisa: 🧠` y sos el 🤖: no revises. Terminá con:
> **Próximo paso:** revisar PR <link> (T-NNN) · **ejecuta: 🧠 modelo de frontera** · **Qué hacer:** abrí una sesión nueva de Claude Code y escribí: «Seguí `docs/agents/reviewer.md` para el PR <número>».

## 1. Leer
`AGENTS.md`, `CONTRIBUTING.md`, `docs/TESTING.md`, la descripción del PR, la tarea y el **diff completo**:
- con `gh`: `gh pr view <n>` y `gh pr diff <n>`
- sin `gh`: `git fetch origin <rama> && git diff main...origin/<rama>` (y `git log main..origin/<rama> --oneline`)

## 2. Verificar (no confíes solo en el PR)
- `git switch <rama> && git pull` (o `git switch --track origin/<rama>`) y `./scripts/verify.sh`. Compará con `main` si algo falla.
- Estado de CI: `gh pr checks <n>` (sin `gh`: la pestaña Checks del PR; si no podés verla, anotalo).
- Corré los comandos de los criterios de aceptación uno por uno.

## 3. Revisar, en este orden
1. **Criterios de aceptación:** cada uno ✅/❌ con evidencia.
2. **Alcance y rama:** solo lo de la tarea; nada de "No incluye"; la rama se llama exactamente como dice la tarea.
3. **Tests:** ¿fallarían si el código estuviera mal? ¿hay tests borrados, `@Disabled`/`.skip` o asserts debilitados? ¿bajó la cobertura o un umbral? Bugfix: ¿hay test que reproduce el bug?
4. **Corrección:** lógica, casos borde, manejo de errores, nulls.
5. **Seguridad:** secretos, autorización, validación de entrada, datos expuestos.
6. **Convenciones:** las de `AGENTS.md` §8 y el estilo del archivo de referencia.
7. **Configuración:** `.example`, compose y `docs/SETUP.md` al día; sin secretos ni valores reales.
8. **Docs y registro:** tablero, tarea ("Notas", "Resultado"), `STATUS.md`, título Conventional Commit, tamaño (< ~400 líneas).

## 4. Publicar
Con `gh` (o MCP): `gh pr review <n> --comment --body-file <archivo>` (sin cuenta bot no se puede aprobar el propio PR: va como comentario). Sin `gh`: dejale el texto al dueño para que lo pegue como comentario. Formato:

```
**Veredicto: APROBADO | CAMBIOS REQUERIDOS | ESCALAR A 🧠 | ESCALAR A DUEÑO**
verify.sh: <resumen> · CI: <estado>

Criterios:
- [✅/❌] <criterio> — <evidencia>

Bloqueantes:
1. `archivo:línea` — <problema> → <corrección sugerida>

Nits (opcionales, máx. 5):
- ...

Fuera de alcance → Backlog: <propuestas>
```

## 5. Reglas
Sugerí, no reescribas (no commitees en la rama del PR salvo que seas el 🧠 en modo sub-agente y el dueño lo haya pedido). Nada fuera de alcance. **Segunda ronda:** solo lo pedido + regresiones; si sigue sin aprobarse → `ESCALAR`.

## 6. Merge
Lo hace el dueño (squash). **Excepción:** si el dueño pidió explícitamente "revisá y mergeá el PR #N", con `APROBADO` y CI en verde (sin CI: `verify.sh` sin regresiones respecto de `main`): `gh pr merge <n> --squash --delete-branch`. Nunca commitees a `main`.

## 6b. Modo sub-agente
Si el 🧠 te lanzó como sub-agente: trabajá **solo** con este archivo, el repo y el PR; no asumas nada de la sesión que te lanzó; devolvé el veredicto con el formato del paso 4.

## 7. Respuesta final (máx. 5 líneas) + traspaso
- `APROBADO` → «**Próximo paso:** mergear PR <link> · **ejecuta: 👤 dueño** · GitHub → Squash and merge → borrar rama. Después: abrí <chat nuevo del agente de IntelliJ | sesión nueva de Claude Code, según la próxima tarea de la cola> y escribí: Seguí `docs/agents/implementer.md`».
- `CAMBIOS REQUERIDOS` → «**Próximo paso:** atender la revisión del PR <link> · **ejecuta:** <quien implementó: 🤖 o 🧠> · abrí <chat nuevo del agente de IntelliJ | sesión nueva de Claude Code> y escribí: Seguí `docs/agents/implementer.md` (cambios pedidos en el PR <n>)».
- `ESCALAR` → «**ejecuta: 🧠 modelo de frontera** (o 👤) · abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/reviewer.md` para el PR <n>».

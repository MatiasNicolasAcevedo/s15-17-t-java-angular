# T-010 · Protect `main` and clean up branches
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 👤 dueño
- Fase: P0 Estabilizar
- Rama: — (configuración de GitHub, sin PR) · Depende de: merge de T-000 · Spec/ADR: —
- Revisa: — (no bloquea la cola)

## Por qué
`main` no tiene protección (MCP GitHub: `protected: false`) y la historia tiene commits directos sin convención. El flujo de [CONTRIBUTING](../../CONTRIBUTING.md) necesita que GitHub lo haga cumplir.

## Objetivo
`main` solo cambia por PR con squash, título validado y sin force push; las ramas mergeadas se borran solas.

## Pasos (GitHub web)
1. **Settings → General → Pull Requests:** desmarcá "Allow merge commits" y "Allow rebase merging"; dejá **"Allow squash merging"** con "Default commit message: Pull request title"; marcá **"Automatically delete head branches"**.
2. **Settings → Rules → Rulesets → New ruleset → New branch ruleset:**
   - Name: `main` · Enforcement status: **Active** · Target branches: **Include default branch**.
   - Marcá: **Restrict deletions**, **Require linear history**, **Require a pull request before merging** (Required approvals: `0`, porque sin cuenta bot no podés aprobar tus propios PR; marcá "Require conversation resolution"), **Require status checks to pass** → "Require branches to be up to date" → agregá `conventional-title` (aparece después de que corra en un PR; cuando exista CI, T-014 agrega sus jobs), **Block force pushes**.
   - Bypass list: vacía (o vos mismo solo para emergencias).
   - Create.
3. **Limpieza de ramas locales mergeadas** (en tu clon):
   ```bash
   git switch main && git pull --prune
   ```
   ```bash
   git branch --merged main | grep -vE '^\*|^\s*main$' | xargs -r git branch -d
   ```
   Remotas: hoy solo existe `main` (+ las de PR abiertos). Para borrar una remota ya mergeada: `git push origin --delete <rama>`.

## Criterios de aceptación
- [ ] `git push origin main` desde un clon con un commit local es rechazado (`GH013: Repository rule violations`). Deshacé el commit local después (`git reset --hard origin/main`).
- [ ] Un PR con título `Update stuff` muestra el check `conventional-title` en rojo.
- [ ] Al mergear un PR, la rama se borra sola.
- [ ] Marcá esta tarea como hecha en `docs/BACKLOG.md` en el próximo PR (o pedíselo al agente).

## Resultado
- Fecha: … · Notas: …

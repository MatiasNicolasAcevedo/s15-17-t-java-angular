# T-004 · Remove the spurious `package.json` npm dependency and stray root files
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `chore/T-004-remove-spurious-dependency` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo)

## Por qué
`frontend/package.json:17` declara `"package.json": "^2.0.1"`, un paquete de npm que nadie usa (vino de un `yarn add packaje.json` fallido, ver `yarn-error.log` en la raíz). Arrastra 5 dependencias con vulnerabilidades **críticas**. En la raíz quedaron `package-lock.json` (vacío) y `yarn-error.log` (log de una PC con Windows). Auditoría: [§1–2](../audits/2026-10-10-initial.md#12-versiones-y-dependencias).

## Objetivo
La dependencia y los dos archivos sueltos desaparecen; `npm audit` baja de 40 a 30 vulnerabilidades (críticas de 6 a 1).

## Alcance
- Incluye: desinstalar `package.json` con npm (actualiza `frontend/package.json` y `frontend/package-lock.json`); borrar `package-lock.json` y `yarn-error.log` **de la raíz** del repo.
- **No incluye:** actualizar ninguna otra dependencia ni correr `npm audit fix` (es P1); tocar `frontend/package-lock.json` a mano; tocar código.

## Leer antes
- `frontend/package.json` (completo, 44 líneas)
- `AGENTS.md` §3 y `frontend/AGENTS.md`

## Archivos previstos
- modificar: `frontend/package.json`, `frontend/package-lock.json` (lo regenera npm; no lo abras)
- borrar: `package-lock.json` (raíz), `yarn-error.log` (raíz)

## Tests
- No hay tests de front todavía (T-013). La verificación es build + lint + audit (criterios).

## Pasos sugeridos
1. Desde `frontend/`: `npm uninstall package.json`
2. Desde la raíz: `git rm package-lock.json yarn-error.log`
3. Desde `frontend/`: `npm ci` y `npm run build`.
4. Commits sugeridos: `chore(client): remove spurious package.json dependency` y `chore: remove stray root lockfile and yarn log` (footer `Refs: T-004`).

## Criterios de aceptación
- [ ] `grep -c '"package.json"' frontend/package.json` → `0`.
- [ ] `ls package-lock.json yarn-error.log` en la raíz → "No such file or directory" para los dos (`frontend/package-lock.json` sigue existiendo).
- [ ] Desde `frontend/`: `npm ci` termina sin error y `npm run build` muestra `✓ built`.
- [ ] Desde `frontend/`: `npm audit` resume `30 vulnerabilities (1 low, 10 moderate, 18 high, 1 critical)` (o menos).
- [ ] `./scripts/verify.sh --client`: build ✅ (el lint sigue fallando por T-005/T-018: es esperado, no lo arregles acá).

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …

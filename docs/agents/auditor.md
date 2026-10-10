# Protocolo · Auditor (auditoría periódica)

**Lo usa:** solo 🧠 modelo de frontera. Cuándo: cada 5–10 PR mergeados, antes de un cambio grande (migración de versión, refactor transversal) o cuando hay 2+ tareas `requiere 🧠`. Si sos el 🤖: no la hagas; terminá con «**Próximo paso:** auditoría periódica · ejecuta: 🧠 modelo de frontera · abrí una sesión nueva de Claude Code y escribí: Seguí `docs/agents/auditor.md`».

Trabajá **por bloques**; al cerrar cada bloque: commit + push y, si el contexto está cargado (> ~60 %), `/compact Conservar: auditoría AAAA-MM-DD, bloque N cerrado, hallazgos ya volcados en el archivo, próximo bloque. Descartar: salidas de comandos.`

Rama: `docs/audit-AAAA-MM-DD` (crearla desde `main` antes del primer commit). Archivo: `docs/audits/AAAA-MM-DD-periodic.md`.

## Bloque 1 · Situación
- Leé `docs/STATUS.md`, `docs/BACKLOG.md`, `docs/ROADMAP.md` y la última auditoría en `docs/audits/`.
- Cambios desde la anterior: `git log audit/<fecha-anterior>..main --oneline` (la primera vez: desde el merge de T-000) y PRs mergeados con sus revisiones (`gh pr list --state merged --limit 20`).

## Bloque 2 · Trabajo de los agentes
- Calidad de lo mergeado: ¿se cumplieron los criterios de verdad? ¿hubo trabajo "de paso" o fuera de alcance?
- Revisiones que dejaron pasar problemas (comparar veredicto vs. código).
- Spot check de tests: romper una línea de lógica en un servicio cubierto y ver si algo falla (revertir después); PIT/Stryker puntual si hace falta.

## Bloque 3 · Salud
- `./scripts/verify.sh` y CI en `main`; cobertura vs. umbral → **subir el umbral** si creció (nunca bajarlo).
- Tests lentos o inestables (tiempos de `verify.sh`, reintentos en CI).
- **Onboarding desde un clon limpio** (`git clone` en una carpeta temporal) en los dos modos del README: contenedores y desarrollo. Corregí lo que falle y actualizá "Verificado el …".
- `.example` completos vs. variables usadas (`grep -rn '\${' backend/coworkProject/src/main/resources`, `grep -rn 'import.meta.env' frontend/src`).
- Deriva documental: README/AGENTS/SETUP/ARCHITECTURE vs. código; `npm audit`; dependencias desactualizadas.

## Bloque 4 · Resolver y replanificar
- Decisiones del dueño en "Decisiones pendientes" de STATUS → ADR (`docs/adr/`, plantilla en `docs/agents/templates/adr.md`).
- Tareas 🧠 prioritarias: **de a una**, cada una en su rama y PR (no dentro del PR de auditoría).
- Relevamiento liviano de lo que cambió (dimensiones de la auditoría inicial que tocaron los PR).
- Reordenar la cola y refinar 5–10 tareas en "Listas" en orden de ejecución, con al menos 3 para 🤖 si hay trabajo apto (Definición de Listo en `docs/agents/templates/task.md` + CONTRIBUTING).
- Si algo falla repetidamente (agentes que se saltean pasos, tareas mal especificadas): ajustá `AGENTS.md`, las plantillas o estos protocolos.

## Bloque 5 · Cerrar
- `docs/audits/AAAA-MM-DD-periodic.md`: resumen con semáforo, hallazgos (severidad, evidencia, recomendación, tarea), cobertura y umbral.
- `docs/STATUS.md` (salud, "Última auditoría", próximo paso) y archivo (tareas y sesiones viejas a `docs/archive/`).
- PR `docs: periodic audit AAAA-MM-DD` desde `docs/audit-AAAA-MM-DD`. Después del merge (lo hace 👤): `git tag audit/AAAA-MM-DD && git push origin audit/AAAA-MM-DD`.
- Sugerí sesión nueva y terminá con el traspaso:
> **Próximo paso:** T-NNN · <título> · **ejecuta: <🤖 agente gratuito (IntelliJ) | 🧠 modelo de frontera | 👤 dueño>** · **Qué hacer:** abrí <…> y escribí: «Seguí `docs/agents/implementer.md`».

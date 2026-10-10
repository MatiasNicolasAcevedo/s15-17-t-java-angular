# Estado del proyecto
_Actualizado: 2026-10-10 · por: 🧠 Claude Code · sesión: auditoría (T-000)_

## En una línea
Auditado y con harness listo; compila y levanta (contenedores y dev), pero sin red de tests, con 2 fallas 🔴 de seguridad y el front apuntando a producción.

## Salud
| Check | Estado | Nota |
|---|---|---|
| verify.sh | ❌ | server ✅ build (tests saltados por pom → T-002) · client ❌ lint 3 warnings → T-005, T-018 |
| CI en main | sin CI | solo `pr-title.yml` → T-014 |
| Levantar en local (README) | ✅ verificado 2026-10-10 | contenedores y desarrollo; login desde la UI ❌ (front → producción, T-006) |
| Cobertura back / front | 9,4 % / — (sin umbral) | medida con agente JaCoCo; umbral en T-002 / T-013 |
| E2E smoke | no existe | → T-017 |
| Dependencias vulnerables | npm: 6 críticas, 21 altas · Maven: Boot 3.2 sin soporte | → T-004, Backlog P1 |
| Última auditoría | 2026-10-10 | [inicial](audits/2026-10-10-initial.md) |

## Fase actual
P0 Estabilizar · 0/18 tareas · ver [ROADMAP](ROADMAP.md)

## Foco
- PR abierto (máx. 1): ninguno (#1 T-000 mergeado)
- **Próximo paso:** T-001 · Read the JWT signing secret from configuration · **ejecuta: 🧠 modelo de frontera**
- **Qué hacer:** abrí una sesión nueva de Claude Code y escribí: «Seguí `docs/agents/implementer.md`»
- **Después:** T-002 (🧠) → T-003 (🧠) → T-004 (🤖) _(después de T-003 toca cambiar al agente gratuito de IntelliJ para T-004, T-005, T-018, T-006, T-007 y T-008)_

## Decisiones pendientes del dueño
- ¿El deploy (Render + Netlify/Vercel) sigue vivo y se mantiene? (bloquea T-011)
- ¿Alcanza con roles `USER`/`ADMIN` o hace falta "dueño de espacio"? (afecta T-003)
- Licencia (MIT sugerida, con acuerdo del equipo original) y renombrar el repo (dice "angular" y es React)
- ¿Qué agente gratuito de IntelliJ es exactamente (AI Assistant + Qwen, Junie, Qwen Code vía ACP)? Ver [SETUP](SETUP.md#-agente-gratuito-de-intellij-qwen)

## Últimas sesiones (máx. 5; las anteriores → archive/log/AAAA-MM.md)
- 2026-10-10 · Claude Code (🧠 sub-agente) · revisó T-000 · APROBADO, mergeado con squash · PR #1
- 2026-10-10 · Claude Code (🧠) · auditó y armó el harness · T-000 · PR #1

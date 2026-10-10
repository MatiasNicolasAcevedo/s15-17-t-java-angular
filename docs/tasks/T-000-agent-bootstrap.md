# T-000 · Bootstrap the agent harness and audit the project
- Estado: Hecha (en revisión) · Prioridad: P0 · Esfuerzo: L · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `chore/T-000-agent-bootstrap` · Depende de: — · Spec/ADR: [ADR 0001](../adr/0001-testcontainers-postgres.md)
- Revisa: 👤 dueño (o 🧠 sub-agente si el dueño lo pide)

## Por qué
Proyecto de 2024 sin tests, CI, documentación para levantarlo ni flujo de trabajo; se retoma para terminarlo con agentes.

## Objetivo
Auditoría inicial + harness (contenedores, `.example`, `verify.sh`, `dev.sh`) + docs (README, AGENTS, CONTRIBUTING, TESTING, SETUP, ARCHITECTURE, ROADMAP) + tablero con tareas refinadas + protocolos de agentes, en un PR. Modo A: sin tocar código de la aplicación.

## Alcance
- **No incluye:** código de la app, versiones, CI de build (hoy fallaría), arreglar hallazgos (son T-001…T-018).

## Criterios de aceptación
- [x] Auditoría con evidencia: `docs/audits/2026-10-10-initial.md`
- [x] Modo contenedores y modo desarrollo verificados desde cero (ver README "Verificado el …")
- [x] `scripts/verify.sh` y `scripts/dev.sh` funcionando (verify falla hoy por el lint: T-005/T-018)
- [x] Tablero con 10 tareas en Listas (6 🤖) y protocolos en `docs/agents/`

## Notas de implementación
- Hecho: todo lo anterior · Pendiente: revisión y merge del dueño · Próximo paso: T-001

## Resultado
- PR: #1 · Rama `chore/T-000-agent-bootstrap` (la pedida; el push funcionó) · Pendientes → T-001…T-018

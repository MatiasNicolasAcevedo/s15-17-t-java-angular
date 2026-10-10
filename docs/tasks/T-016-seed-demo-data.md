# T-016 · Seed demo data for local development
- Estado: Bloqueada (por T-002, T-003) · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `feat/T-016-seed-demo-data` · Depende de: T-002, T-003 (rol ADMIN) · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
La base arranca vacía: el dashboard no muestra nada y el usuario demo hay que crearlo con `curl` (README, `scripts/dev.sh`). Sin datos no hay demo ni E2E (T-017).

## Objetivo
Con una propiedad activada solo en local (`APP_SEED_ENABLED=true` en el `.example` y en compose; `false` por defecto), el back crea de forma idempotente: usuario demo (`demo@woodwork.local` / `Demo1234!`, rol USER), un admin local, 4–6 workspaces con imágenes públicas, horarios y qualities, y alguna reserva del usuario demo.

## Alcance
- Incluye: `ApplicationRunner` condicionado por propiedad (o `data.sql` si Flyway llegó antes: decidir y justificar); idempotencia (no duplica al reiniciar); variable en `.example`, compose, SETUP y README; quitar el registro manual de `scripts/dev.sh` y del README (paso 6 y opción A); test de integración que verifica que con la propiedad hay datos y sin ella no.
- **No incluye:** activar el seed en producción; Flyway (P1).

## Leer antes
- `backend/coworkProject/src/main/java/org/example/coworkproject/entity/*.java` · `README.md` (opción A y paso 6) · `scripts/dev.sh` (paso 4) · `docs/SETUP.md#variables`

## Criterios de aceptación
- [ ] `./scripts/verify.sh` pasa y la cobertura no baja.
- [ ] `docker compose --profile app down -v && docker compose --profile app up -d --build --wait` → login con el usuario demo (curl) 200 y `listOfWorkspaces` con su token devuelve ≥ 4 workspaces.
- [ ] Reiniciar el back no duplica datos.
- [ ] README sin el `curl` de register; SETUP con la variable.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …

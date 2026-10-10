# T-003 · Enforce ownership and admin role on user, reservation and catalog endpoints
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-003-enforce-resource-ownership` · Depende de: T-002 · Spec/ADR: crear `docs/adr/0002-authorization-model.md`
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

`<pkg>` = `backend/coworkProject/src/main/java/org/example/coworkproject`

## Por qué
🔴 No hay roles ni chequeo de dueño: cualquier usuario autenticado cambia la contraseña de otro sin conocer la actual (`<pkg>/service/impl/UserServiceImpl.java:33-56`, `controller/UserController.java:49-64`), lo borra (`UserController.java:79-90`), lista todos los usuarios (probe: `listOfUsers` → 200) y borra workspaces/reservas ajenas. `UserEntity.getAuthorities()` devuelve `null` (`entity/UserEntity.java:35-38`). Auditoría: [§6](../audits/2026-10-10-initial.md#6-seguridad).

## Objetivo
Cada usuario solo lee/modifica sus propios datos y reservas; las operaciones de catálogo (workspaces, qualities, listados globales) requieren rol `ADMIN`.

## Alcance
- Incluye: rol `USER`/`ADMIN` en `UserEntity` (nuevos registros `USER`; `null` existente tratado como `USER`); `getAuthorities()` real; reglas (ADR 0002): `/user/{id}/**` y `/reservation/...{id_user}` solo el propio usuario o `ADMIN`; `listOfUsers`, `listOfReservations`, escritura de `/workspace/**`, `/qualities/**` e `/images/**` solo `ADMIN`; lecturas de workspaces y qualities para cualquier autenticado; cambio de contraseña exige la contraseña actual; respuesta 403 al violar una regla; cómo crear el primer admin documentado (SQL o propiedad; T-016 lo automatiza).
- **No incluye:** formato de errores/ProblemDetail (T-012); CORS; cambios en el front (el front no usa estos endpoints, salvo `getUserById`/`updateUser` del propio usuario); renombrar endpoints.
- Decisión pendiente del dueño: si hace falta un rol "dueño de espacio" (STATUS). Por defecto: solo `USER`/`ADMIN`.

## Leer antes
- `<pkg>/configuration/security/SecurityConfig.java`, `AppConfig.java`, `jwt/JwtFilter.java`
- `<pkg>/controller/UserController.java`, `ReservationController.java`, `WorkspaceController.java:45-143`
- `<pkg>/entity/UserEntity.java` · `docs/TESTING.md` (referencia `AuthFlowIT`)

## Archivos previstos
- modificar: `UserEntity.java`, `SecurityConfig.java`, `UserController.java`, `UserServiceImpl.java`, `ReservationController.java`, `ChangePasswordRequestDTO.java`, `docs/ARCHITECTURE.md` (sección autenticación)
- crear: `docs/adr/0002-authorization-model.md`, `AuthorizationIT.java`

## Tests
- Primero los tests que fallan (bugfix): usuario A no puede `GET/PUT/DELETE` del usuario B (403); A sí sobre sí mismo (200); `listOfUsers` con `USER` → 403 y con `ADMIN` → 200; crear workspace con `USER` → 403; reserva para otro `id_user` → 403; cambio de contraseña sin la actual o con la actual incorrecta → 400/403.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa y la cobertura no baja.
- [ ] Los tests de `AuthorizationIT` fallan en `main` y pasan en la rama (pegar evidencia en el PR).
- [ ] Probe manual del README: con el usuario demo, `GET /v1/api/user/listOfUsers` → 403.
- [ ] ADR 0002 escrito; ARCHITECTURE actualizado.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …

# T-008 · Add characterization tests for login and registration
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `test/T-008-characterize-auth-flow` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-002 · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo)

`<pkg>` = `backend/coworkProject/src/main/java/org/example/coworkproject` · `<test>` = `backend/coworkProject/src/test/java/org/example/coworkproject`

## Por qué
Registro y login son los flujos críticos 1 y 2 y no tienen tests unitarios ni de controller ([auditoría §7](../audits/2026-10-10-initial.md#7-testing-dimensión-central)). T-012 (manejo de errores) va a cambiar sus respuestas: primero hay que fijar el comportamiento actual.

## Objetivo
Tests de `LoginServiceImpl` (unitario) y `LoginController` (`@WebMvcTest`) que documentan lo que hoy hacen, incluidos sus defectos.

## Alcance
- Incluye: `<test>/service/impl/LoginServiceImplTest.java` (Mockito, estilo de `RegisterServiceImplTest`): (1) credenciales válidas → DTO con email, id, fullName y el token que devuelve el `JwtService` mockeado; (2) `BadCredentialsException` → devuelve `null`; (3) usuario autenticado pero no encontrado en el repo → `MyException`. `<test>/controller/LoginControllerTest.java` (`@WebMvcTest(LoginController.class)`, estilo de `HealthCheckControllerTest`, con los mismos `@MockBean`/`@Import` de seguridad que use `HealthCheckControllerTest` más `@MockBean LoginService`): (4) login OK → 200 y el header `Authorization` vale `"Bearer" + token` **sin espacio** (comportamiento actual; ya está en el Backlog P2); (5) servicio devuelve `null` → 401 con el texto `Incorrect credentials or user not found`; (6) email con formato inválido → 400 (validación de `LoginRequestDTO`).
- **No incluye:** cambiar código de `<pkg>`; tests de registro de controller (los cubre el `AuthFlowIT` de T-002); arreglar el header ni la enumeración de usuarios (T-012).

## Leer antes
- `<pkg>/service/impl/LoginServiceImpl.java` (51 líneas) · `<pkg>/controller/LoginController.java` (36 líneas) · `<pkg>/dto/request/LoginRequestDTO.java`
- `<test>/service/impl/RegisterServiceImplTest.java` y `<test>/controller/HealthCheckControllerTest.java` (referencias de T-002)
- `docs/TESTING.md` §3 y §4

## Archivos previstos
- crear: `LoginServiceImplTest.java`, `LoginControllerTest.java`
- modificar: — (solo tests)

## Tests
- Los 6 casos de arriba.

## Criterios de aceptación
- [ ] `./mvnw test -Dtest='LoginServiceImplTest,LoginControllerTest'` → 6+ tests, 0 fallas.
- [ ] `./scripts/verify.sh --server` pasa y la cobertura no baja.
- [ ] Prueba de que sirven: devolver `HttpStatus.FORBIDDEN` en vez de `UNAUTHORIZED` en `LoginController` hace fallar el caso 5 (revertir y contarlo en el PR).
- [ ] `git diff main --stat` no muestra cambios en `src/main/`.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …

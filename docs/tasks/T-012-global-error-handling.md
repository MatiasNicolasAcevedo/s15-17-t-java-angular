# T-012 · Return consistent HTTP errors with ProblemDetail
- Estado: Bloqueada (por T-002) · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-012-global-error-handling` · Depende de: T-002, T-003, T-008 · Spec/ADR: crear `docs/adr/0003-error-format.md`
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
Toda excepción termina en **403 sin cuerpo** porque no hay `@RestControllerAdvice` y `/error` no está en `permitAll` (`SecurityConfig.java:43-51`). Login con email inexistente → 403 y con password incorrecta → 401 (enumeración de usuarios); sin token o token inválido → 403 en vez de 401; JSON inválido → 403; ruta inexistente → 403. El mensaje de registro duplicado incluye el email (`RegisterServiceImpl.java:34`). Tabla completa de probes: [auditoría §Verificación](../audits/2026-10-10-initial.md#verificación-fase-1).

## Objetivo
Respuestas de error RFC 9457 (`application/problem+json`) con los códigos esperados de la tabla de probes.

## Alcance
- Incluye: `@RestControllerAdvice` con `ProblemDetail` (`spring.mvc.problemdetails.enabled=true` o handler propio); `AuthenticationEntryPoint` → 401 y `AccessDeniedHandler` → 403 en JSON; permitir `/error`; login: misma respuesta 401 para email inexistente y password incorrecta (sin revelar cuál); register duplicado → 409 sin el email en el mensaje; validación → 400 con errores por campo; no encontrado → 404; inesperado → 500 sin stacktrace ni mensaje interno; actualizar los tests de caracterización de T-008 que cambien (es un cambio de comportamiento intencional: explicarlo en el PR).
- **No incluye:** cambiar rutas; mensajes en el front (si el front depende de algún status, anotarlo en Backlog); CORS.

## Leer antes
- `backend/coworkProject/src/main/java/org/example/coworkproject/configuration/security/SecurityConfig.java`
- `.../exception/*.java`, `.../controller/LoginController.java`, `ReservationController.java:58-78`
- Tabla de probes de la auditoría · `docs/TESTING.md`

## Archivos previstos
- crear: `exception/GlobalExceptionHandler.java`, `ErrorResponsesIT.java`, `docs/adr/0003-error-format.md`
- modificar: `SecurityConfig.java`, `LoginServiceImpl.java`/`LoginController.java`, `RegisterServiceImpl.java`, controllers con try/catch que devuelven `MyException` como cuerpo, tests de T-008

## Tests
- Un caso por fila de la tabla de probes (status + `type`/`title` del ProblemDetail), primero en rojo.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa y la cobertura no baja.
- [ ] Los probes de la auditoría (con `curl` contra `./mvnw spring-boot:run`) dan el status esperado; pegar la tabla obtenida en el PR.
- [ ] ADR 0003 escrito; `AGENTS.md` §11 sin el gotcha de los 403.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …

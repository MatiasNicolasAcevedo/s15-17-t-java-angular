# T-001 · Read the JWT signing secret from configuration
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-001-externalize-jwt-secret` (crearla desde `main` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño (seguridad)

`<pkg>` = `backend/coworkProject/src/main/java/org/example/coworkproject`

## Por qué
🔴 El secreto HMAC del JWT está hardcodeado en `<pkg>/configuration/security/jwt/JwtService.java:22` (`@Value("<literal>")`) y está en el historial desde 2024-05-22: cualquiera con el repo puede forjar tokens válidos para cualquier usuario del deploy. Auditoría: [§6 Seguridad](../audits/2026-10-10-initial.md#6-seguridad).

## Objetivo
El back lee el secreto de la variable `JWT_SECRET` y no arranca si falta; el literal desaparece del código.

## Alcance
- Incluye: `@Value("${JWT_SECRET}")` en `JwtService`; mensaje claro si falta; docs de la variable.
- **No incluye:** rotar el secreto en producción (es T-011, 👤); reescribir el historial de git (no sirve: hay que rotar); cambiar expiración, algoritmo o versión de jjwt; tests (no hay infraestructura: T-002 agrega un test de integración de login que cubre esto).

## Leer antes
- `<pkg>/configuration/security/jwt/JwtService.java` (completo, 75 líneas)
- `backend/coworkProject/src/main/resources/env.properties.example` (ya trae `JWT_SECRET`)
- `docs/SETUP.md#variables`

## Archivos previstos
- modificar: `JwtService.java`, `env.properties.example` (quitar la nota "hoy el código NO la lee"), `docs/SETUP.md` (columna "Obligatoria" de `JWT_SECRET`), `README.md` (lista de variables de prod: quitar "desde T-001")

## Tests
- Sin infraestructura de tests todavía: verificación manual (criterios). T-002 debe incluir el caso "login emite un token que el filtro acepta".

## Pasos sugeridos
1. Reemplazar el literal por `@Value("${JWT_SECRET}")`.
2. Correr con y sin la variable (criterios 2 y 3).
3. Actualizar docs. Avisar al dueño en el PR que **el deploy dejará de arrancar hasta definir `JWT_SECRET` en Render** (T-011).

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa.
- [ ] `git grep -nE '@Value\("[0-9a-f]{32,}"\)' -- backend` no devuelve nada.
- [ ] Con `env.properties` copiado del ejemplo: `./mvnw spring-boot:run` arranca; register + login (`curl` del README) devuelven 200 con `token`, y `GET /v1/api/workspace/listOfWorkspaces` con ese token devuelve 200/204.
- [ ] Sin `JWT_SECRET` (comentada en `env.properties`): el arranque falla con `Could not resolve placeholder 'JWT_SECRET'`.
- [ ] `docker compose --profile app up -d --build --wait` levanta y el login funciona (la variable llega por `env_file`).
- [ ] `.example`, SETUP y README actualizados.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: T-011 (rotación)

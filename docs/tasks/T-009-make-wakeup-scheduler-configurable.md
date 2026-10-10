# T-009 · Make the Render wake-up scheduler opt-in
- Estado: Bloqueada (por T-002) · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `fix/T-009-make-wakeup-scheduler-configurable` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-002 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca configuración)

`<pkg>` = `backend/coworkProject/src/main/java/org/example/coworkproject` · `<test>` = `backend/coworkProject/src/test/java/org/example/coworkproject`

## Por qué
`<pkg>/wakeUpRender/ServerWakeUpScheduler.java:12-16` hace un GET a `https://woodwork.onrender.com` cada 14 minutos **en cualquier entorno** (también en local, tests y CI), con la URL hardcodeada aunque existe `server.url` en `application.properties:27`.

## Objetivo
El scheduler solo existe si `app.wakeup.enabled=true` (por defecto `false`) y usa la URL de `server.url`.

## Alcance
- Incluye: `@ConditionalOnProperty(name = "app.wakeup.enabled", havingValue = "true")` en la clase; `@Value("${server.url}")` en lugar del literal; en `application.properties` agregar `app.wakeup.enabled=${APP_WAKEUP_ENABLED:false}`; `APP_WAKEUP_ENABLED=false` (con comentario) en `env.properties.example`; fila nueva en `docs/SETUP.md#variables` ("en Render: `true`"); reemplazar `System.out/err` por un logger SLF4J (`@Slf4j`).
- **No incluye:** cambiar el intervalo ni el endpoint de health; tocar el deploy (el dueño define `APP_WAKEUP_ENABLED=true` en Render: anotalo en "Resultado" y en T-011).

## Leer antes
- `<pkg>/wakeUpRender/ServerWakeUpScheduler.java` (completo, 28 líneas)
- `backend/coworkProject/src/main/resources/application.properties`
- `docs/TESTING.md` §3 (referencias) · `docs/SETUP.md#variables`

## Archivos previstos
- modificar: `ServerWakeUpScheduler.java`, `application.properties`, `env.properties.example`, `docs/SETUP.md`
- crear: `<test>/wakeUpRender/ServerWakeUpSchedulerTest.java`

## Tests
- `ApplicationContextRunner` (sin levantar Spring completo): sin la propiedad → no hay bean `ServerWakeUpScheduler`; con `app.wakeup.enabled=true` y `server.url=http://example.test` → el bean existe.

## Criterios de aceptación
- [ ] `./mvnw test -Dtest='ServerWakeUpSchedulerTest'` → 2+ tests, 0 fallas.
- [ ] `./scripts/verify.sh --server` pasa y la cobertura no baja.
- [ ] `./mvnw spring-boot:run > /tmp/run.log 2>&1` con el `env.properties` del ejemplo; al aparecer `Started CoworkProjectApplication` (la primera ejecución del scheduler es inmediata), `grep -c "Health Check" /tmp/run.log` → `0`.
- [ ] `grep -n "onrender" backend/coworkProject/src/main/java -r` → sin resultados.
- [ ] `.example` y SETUP actualizados.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: … · Acción del dueño: `APP_WAKEUP_ENABLED=true` en Render

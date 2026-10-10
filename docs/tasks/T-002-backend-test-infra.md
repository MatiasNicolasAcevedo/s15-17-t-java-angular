# T-002 · Set up backend test infrastructure (JaCoCo, Testcontainers, reference tests)
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-002-backend-test-infra` · Depende de: T-001 (para que el test de login use `JWT_SECRET`) · Spec/ADR: [ADR 0001](../adr/0001-testcontainers-postgres.md)
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
El back tiene 1 test (`contextLoads`) que necesita una DB externa y `env.properties`, y el pom lo saltea (`backend/coworkProject/pom.xml:161-167`, `<skipTests>true</skipTests>`). Cobertura base medida por fuera: 9,4 % línea / 0 % rama. Sin esto ninguna tarea 🤖 de tests puede empezar. Auditoría: [§7 Testing](../audits/2026-10-10-initial.md#7-testing-dimensión-central).

## Objetivo
`./mvnw clean verify` corre tests unitarios, de slice y de integración (Postgres en Testcontainers) sin configuración manual, mide cobertura con JaCoCo y falla si baja del umbral; quedan tests de referencia por tipo.

## Alcance
- Incluye: quitar `skipTests`; JaCoCo (`prepare-agent`, `report`, `check` con umbral = cobertura medida al final, redondeada hacia abajo); `spring-boot-testcontainers` + `org.testcontainers:postgresql` (versiones del BOM de Boot 3.2); configuración de test que no dependa de `env.properties` (`application-test.properties` o `@DynamicPropertySource`/`properties`) con driver y dialecto de Postgres, Cloudinary falso y `JWT_SECRET` de test; `*IT` con failsafe (o criterio equivalente documentado); 3 tests de referencia: `service/impl/RegisterServiceImplTest` (Mockito: email duplicado lanza `IllegalArgumentException`; guarda la contraseña codificada), `controller/HealthCheckControllerTest` (`@WebMvcTest`, público → 200), `AuthFlowIT` (`@SpringBootTest` + Testcontainers: register → login → endpoint protegido 200 con token y 403 sin token); que `verify.sh` cuente tests de surefire y failsafe y deje de levantar la DB de compose si ya no hace falta (hoy la deja corriendo: `scripts/verify.sh:39-41`); `docs/TESTING.md` (tabla de referencias y umbral) y `docs/STATUS.md` (cobertura).
- **No incluye:** arreglar bugs que los tests revelen (se documentan como caracterización y van al Backlog); cambiar código de producción salvo lo mínimo para testear (y justificarlo); actualizar Spring Boot; CI (T-014).

## Leer antes
- `backend/coworkProject/pom.xml:118-169` (build)
- `backend/coworkProject/src/main/resources/application.properties` (placeholders sin default: `DB_DIALECT`, `CLOUDINARY_*`)
- `docs/TESTING.md` §1, §3, §5 · `docs/adr/0001-testcontainers-postgres.md`
- `scripts/verify.sh` (función `verify_server`)

## Archivos previstos
- modificar: `pom.xml`, `scripts/verify.sh`, `CoworkProjectApplicationTests.java` (que use Testcontainers o quitarle la dependencia de DB, sin borrarlo), `docs/TESTING.md`, `docs/STATUS.md`
- crear: `src/test/resources/application-test.properties` (o equivalente), `RegisterServiceImplTest.java`, `HealthCheckControllerTest.java`, `AuthFlowIT.java`, opcional `support/TestcontainersConfig.java`

## Tests
- Los 3 de referencia + `contextLoads` funcionando. Cada uno con al menos un caso de error.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa y su resumen muestra la cantidad de tests (≥ 5), no "saltados".
- [ ] Pasa **con y sin** `src/main/resources/env.properties` presente, y sin DB de compose levantada (`docker compose down`).
- [ ] `target/site/jacoco/index.html` se genera; `jacoco:check` falla si se baja el umbral a mano (probarlo y revertir).
- [ ] `./mvnw test -Dtest='RegisterServiceImplTest'` corre solo ese test.
- [ ] `docs/TESTING.md` lista los archivos de referencia y el umbral; `STATUS.md` muestra la cobertura nueva.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Cobertura: …% (umbral …%) · Pendientes → nuevas tareas: …

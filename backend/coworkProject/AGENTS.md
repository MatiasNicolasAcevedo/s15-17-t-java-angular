# AGENTS.md · back

Solo lo específico del back. Lo general: [AGENTS.md raíz](../../AGENTS.md).

- **Dónde correr:** comandos Maven desde `backend/coworkProject/` con `./mvnw` (Windows: `mvnw.cmd`). Gate: `../../scripts/verify.sh --server`.
- **Config:** `src/main/resources/env.properties` (copia de `.example`, classpath). En tests, desde T-002, no se usa: Testcontainers + `src/test/resources`.
- **Paquete raíz:** `org.example.coworkproject` (`controller`, `service` + `service/impl`, `repository`, `entity`, `dto/request|response`, `mapper`, `exception`, `configuration`, `helper`).
- **Nuevo endpoint:** controller fino → servicio (interfaz + impl) → repository; request/response como DTO con Bean Validation y `@Valid`; no devolver entidades JPA.
- **Seguridad:** `configuration/security/SecurityConfig.java` define lo público; todo lo demás requiere `Authorization: Bearer <jwt>`. Cambios acá = tarea 🧠.
- **Esquema:** Hibernate `ddl-auto=update` (sin migraciones). Cambiar entidades = tarea 🧠 (afecta datos).
- **Tests:** `src/test/java/org/example/coworkproject/...`; `*Test` (unit/slice), `*IT` (Testcontainers). Un test: `./mvnw test -Dtest='Clase#metodo'`. Referencias en `docs/TESTING.md`.
- **Lombok + MapStruct:** el orden de annotation processors está en `pom.xml` (`lombok-mapstruct-binding`); no lo toques.
- **Logs:** en código nuevo usá SLF4J (`@Slf4j`), no `System.out`.
- **Caros de leer:** `pom.xml` (~170 líneas) leelo por rangos; `target/` nunca.

# Estrategia de testing

Estable. Base medida el 2026-10-10: back **9,4 % línea / 0 % rama** (1 test `contextLoads`, saltado por `pom.xml:165`); front **sin tests**. Detalle: [auditoría](audits/2026-10-10-initial.md#7-testing-dimensión-central).

## 1. Pirámide y herramientas

| Capa | Herramienta | Para qué |
|---|---|---|
| Back · unitarios | JUnit 5 (del BOM de Boot), AssertJ, Mockito con mesura | reglas de negocio en `service/impl` (capacidad, horarios, precio, validaciones) |
| Back · web | `@WebMvcTest` + `spring-security-test` | validación, códigos HTTP, formato de error, acceso con/sin token |
| Back · JPA | `@DataJpaTest` + Testcontainers | solo queries propias (`ReservationRepository.findByWorkspaceAndEndTimeAfterAndStartTimeBefore`) |
| Back · integración | `@SpringBootTest` + **Testcontainers PostgreSQL** | flujos completos (registro → login → endpoint protegido) contra la misma DB que prod. Sin H2: [ADR 0001](adr/0001-testcontainers-postgres.md) |
| Back · cobertura | **JaCoCo** (`jacoco-maven-plugin`) con umbral en `verify` | trinquete (sección 5) |
| Front · componentes | **Vitest** + **React Testing Library** + `@testing-library/user-event` | comportamiento visible; consultas por rol/label |
| Front · API | **MSW** | mockear la API con el contrato de springdoc (`/v3/api-docs`) |
| Front · cobertura | Vitest coverage v8 | trinquete |
| E2E | **Playwright** (desktop 1280 + mobile 375) | 3–5 smoke de flujos críticos; screenshots y trazas en fallos; `scripts/e2e.sh` |

Versiones objetivo (2026-10): JUnit 6.1.x o la del BOM, Testcontainers 2.0.x, JaCoCo 0.8.15, Vitest 5, RTL 16, MSW 3, Playwright 1.64. La infra la agregan T-002 (back), T-013 (front), T-017 (E2E).

## 2. Qué testear y qué no

- **Sí:** reglas de negocio, validaciones de DTOs, permisos (dueño/admin), contratos de API (status + cuerpo), estados de UI (cargando, error, vacío), rutas protegidas.
- **No:** getters/setters, código generado (MapStruct, Lombok), el framework (que Spring inyecte un bean), estilos.

## 3. Convenciones

- **Ubicación:** back en `src/test/java/<mismo paquete>`, sufijos `*Test` (unitario/slice) y `*IT` (integración con Testcontainers). Front junto al archivo: `Componente.test.tsx`.
- **Nombres:** `metodo_condicion_resultado` o frase en inglés (`rejectsReservationOverCapacity`).
- **Estructura:** Arrange / Act / Assert separados por línea en blanco. Datos con builders (`UserEntity.builder()` existe; para el resto, `TestData` en `src/test/.../support/`).
- **Archivos de referencia** ("copiá el estilo de"): los crea T-002 / T-013 / T-017 y se listan acá al mergear.

| Tipo | Referencia |
|---|---|
| Unitario de servicio | _pendiente T-002_ (`service/impl/RegisterServiceImplTest.java`) |
| `@WebMvcTest` | _pendiente T-002_ (`controller/HealthCheckControllerTest.java`) |
| Integración | _pendiente T-002_ (`AuthFlowIT.java`) |
| Componente front | _pendiente T-013_ |
| E2E | _pendiente T-017_ |

- **Un solo test:** back `./mvnw test -Dtest=NombreTest` o `-Dtest='NombreTest#metodo'` (desde `backend/coworkProject/`); front `npx vitest run src/ruta/Archivo.test.tsx` o `-t "nombre"` (desde `frontend/`).

## 4. Reglas para todas las tareas

1. Los tests van **en el mismo PR** que el cambio.
2. **Bugfix = primero un test que falla** y reproduce el bug; después el fix.
3. **Caracterización antes de refactorizar o migrar:** tests que fijan el comportamiento actual (aunque sea raro) antes de tocarlo.
4. **Prohibido** borrar, deshabilitar (`@Disabled`, `.skip`), debilitar asserts o bajar umbrales. Si un test está mal, se arregla en una tarea con justificación.
5. **Deterministas:** sin depender del orden, la hora (`Clock` inyectado o fechas fijas), la red ni datos compartidos entre tests.

## 5. Cobertura como trinquete

Medir la base, fijar el umbral en ese valor **redondeado hacia abajo** y **no bajarlo nunca**. Cada auditoría lo sube si la cobertura creció. Meta orientativa: ≥ 70–80 % en `service/` y lógica del front.

| Parte | Base | Umbral | Dónde se configura |
|---|---|---|---|
| Back | 9,4 % línea | se fija en T-002 | `jacoco-maven-plugin` → `check` |
| Front | — | se fija en T-013 | `vitest.config.ts` → `coverage.thresholds` |

## 6. Opcional

Mutation testing puntual en auditorías: PIT (`pitest-maven`) sobre `service/impl`, Stryker sobre la lógica del front.

## Roadmap de testing (antes de cualquier migración)

1. 🧠 T-002 infra back: tests habilitados, JaCoCo con umbral, Testcontainers, perfil de test sin configuración manual, tests de referencia.
2. 🧠 T-013 infra front: Vitest + RTL + MSW (Vite ya está: no hace falta migrar de CRA).
3. 🧠 T-017 infra E2E: Playwright + `scripts/e2e.sh` + job de CI.
4. 🤖 Caracterización: T-007 (reservas), T-008 (registro/login) y las de Backlog P0 (workspaces, usuarios).

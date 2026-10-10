# T-007 · Add characterization tests for `ReservationServiceImpl`
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `test/T-007-characterize-reservation-service` (crearla desde `main` actualizado antes del primer commit) · Depende de: T-002 · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo)

`<pkg>` = `backend/coworkProject/src/main/java/org/example/coworkproject` · `<test>` = `backend/coworkProject/src/test/java/org/example/coworkproject`

## Por qué
La reserva (capacidad, horario de apertura, precio) es el flujo de negocio central y no tiene ningún test. Antes de corregir sus bugs o migrar versiones, hay que fijar el comportamiento **actual** (caracterización). Auditoría: [§7 flujos 4 y 6](../audits/2026-10-10-initial.md#7-testing-dimensión-central).

## Objetivo
`ReservationServiceImplTest` documenta con tests unitarios lo que hoy hace `createReservation`, `calculatePrice`, `isWithinOperatingHours` y `getReservationsByUser`, incluidos los comportamientos raros.

## Alcance
- Incluye: un test unitario con Mockito (`@ExtendWith(MockitoExtension.class)`, `@Mock` de los 3 repositorios, `@InjectMocks ReservationServiceImpl`), copiando el estilo de la referencia de T-002 (`<test>/service/impl/RegisterServiceImplTest.java`). Fechas fijas (p. ej. lunes `2030-01-07`), nunca `LocalDateTime.now()`.
- Casos: (1) reserva válida → `save` llamado y precio = horas × `pricePerHour`; (2) capacidad excedida → `CapacityException`; (3) inicio igual o posterior al fin → `InvalidTimeException`; (4) fuera del horario → `OutsideOperatingHoursException`; (5) día cerrado → `OutsideOperatingHoursException`; (6) workspace inexistente → `IllegalArgumentException`; (7) **comportamiento actual**: 1 h 30 min se cobra como 1 h (`toHours()` trunca); (8) **comportamiento actual**: con capacidad excedida **y** horario inválido gana `CapacityException` (se valida antes); (9) `getReservationsByUser` de usuario inexistente → `IllegalArgumentException`.
- **No incluye:** corregir ningún bug (los casos 7 y 8 llevan un comentario `// Comportamiento actual (ver docs/BACKLOG.md, P2)`; la regla de precio ya está en el Backlog P2 y para el orden de validaciones agregá una línea 🧠 en "📥 Backlog" P2); tocar código de `<pkg>`; tests de controller o de integración.

## Leer antes
- `<pkg>/service/impl/ReservationServiceImpl.java` líneas 25–120
- `<pkg>/entity/WorkspaceEntity.java` (setters por Lombok) y `entity/ReservationEntity.java`
- `<test>/service/impl/RegisterServiceImplTest.java` (referencia de estilo, creada en T-002)
- `docs/TESTING.md` §3 y §4

## Archivos previstos
- crear: `<test>/service/impl/ReservationServiceImplTest.java`
- modificar: `docs/BACKLOG.md` (líneas nuevas para los bugs caracterizados)

## Tests
- Los 9 casos de arriba, uno por método de test, con nombres descriptivos en inglés.

## Criterios de aceptación
- [ ] Desde `backend/coworkProject/`: `./mvnw test -Dtest='ReservationServiceImplTest'` → `Tests run: 9, Failures: 0` (o más).
- [ ] `./scripts/verify.sh --server` pasa y la cobertura no baja (y `service/impl/ReservationServiceImpl` sube: mirá `target/site/jacoco/index.html`).
- [ ] Prueba de que los tests sirven: cambiar temporalmente `>` por `>=` en la validación de capacidad hace fallar al menos un test (revertir y contarlo en el PR).
- [ ] `git diff main --stat` no muestra cambios en `src/main/`.

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …

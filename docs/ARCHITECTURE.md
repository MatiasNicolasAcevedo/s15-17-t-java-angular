# Arquitectura

Estado al 2026-10-10 (auditoría inicial). Rutas de código relativas a `backend/coworkProject/src/main/java/org/example/coworkproject/` y `frontend/src/`.

## Componentes (local)

```mermaid
flowchart LR
  user([Navegador])
  subgraph compose[docker-compose.yml]
    client["client · nginx :5173→80<br/>build de Vite (profile app)"]
    server["server · Spring Boot :8080<br/>(profile app)"]
    db[("db · postgres:18-alpine :5432<br/>volumen db-data")]
  end
  cloud[(Cloudinary)]
  render[["woodwork.onrender.com<br/>(producción)"]]
  user --> client
  user -- "fetch/axios (hoy a producción, T-006)" --> render
  user -. "desde T-006" .-> server
  server --> db
  server -- "subida de imágenes" --> cloud
  server -- "ping cada 14 min (T-009)" --> render
```

En desarrollo (`scripts/dev.sh`): solo `db` en contenedor; back con `./mvnw spring-boot:run` y front con `vite` (hot reload).

## Flujo de una request

```mermaid
sequenceDiagram
  participant F as Front (services/Api.tsx)
  participant J as JwtFilter
  participant S as SecurityFilterChain
  participant C as Controller
  participant V as Service impl
  participant R as Repository (JPA)
  participant D as PostgreSQL
  F->>J: GET /v1/api/workspace/listOfWorkspaces<br/>Authorization: Bearer jwt
  J->>J: valida firma y expiración, carga UserEntity por email
  J->>S: SecurityContext autenticado
  S->>C: permitido (anyRequest().authenticated())
  C->>V: workspaceService.findAll()
  V->>R: findAll()
  R->>D: SELECT ...
  D-->>R: filas
  R-->>V: entidades
  V-->>C: DTOs (MapStruct)
  C-->>F: 200 JSON (204 si vacío)
```

Errores: no hay `@RestControllerAdvice`; las excepciones no capturadas van a `/error`, que Security bloquea → **403 sin cuerpo** (T-012).

## Autenticación

```mermaid
sequenceDiagram
  participant U as Usuario
  participant F as Front
  participant A as LoginController / RegisterController
  participant M as AuthenticationManager (DaoAuthenticationProvider + BCrypt)
  participant T as JwtService (HS256, 10 días)
  U->>F: email + password
  F->>A: POST /v1/api/auth/login
  A->>M: authenticate(email, password)
  M-->>A: OK / BadCredentials (401) / usuario inexistente (403, T-012)
  A->>T: generateToken(user)
  T-->>A: jwt (secreto hardcodeado: T-001)
  A-->>F: 200 {token, id_user, email, fullName}
  F->>F: localStorage token + idUser
  F->>A: requests con Authorization: Bearer jwt
```

Sin roles ni chequeo de dueño: cualquier usuario autenticado accede a todo (T-003).

## Modelo de datos

```mermaid
erDiagram
  USER_ENTITY ||--o{ RESERVATION_ENTITY : "reservations"
  WORKSPACE_ENTITY ||--o{ RESERVATION_ENTITY : "reservations"
  WORKSPACE_ENTITY }o--o{ QUALITIES_ENTITY : "workspaces_qualities"
  USER_ENTITY {
    long id_user PK
    string email
    string password "BCrypt"
    string fullName
    string profilePicture
  }
  WORKSPACE_ENTITY {
    long id_workspace PK
    string workspaceName
    string address
    double pricePerHour
    string description
    int capacity
    string mainImage
    list workspaceImages "ElementCollection"
    set openDays "ElementCollection DayOfWeek"
    time openingTime
    time closingTime
  }
  RESERVATION_ENTITY {
    long id_reservation PK
    datetime startTime
    datetime endTime
    double price
    int numberOfPeople
  }
  QUALITIES_ENTITY {
    long id_quality PK
    string QualityName
    boolean isActive
  }
```

Esquema generado por Hibernate (`ddl-auto=update`), sin migraciones. Ojo: `QualitiesEntity.workspaces` tiene `cascade = ALL` (borrar una quality puede borrar workspaces).

## Endpoints principales

Prefijo `/v1/api`. Públicos: `/auth/*`, `/render/health`, Swagger. Contrato completo: `http://localhost:8080/v3/api-docs`.

| Endpoint | Pantalla que lo usa |
|---|---|
| `POST /auth/register` | `/register` (`views/RegisterView`) |
| `POST /auth/login` | `/login` (`views/LoginView`) |
| `GET /user/getUserById/{id}` | todas (carga de usuario en `AuthProvider`) |
| `PUT /user/updateUser/{id}` (multipart) | `/editProfile/:id` — ⚠️ el front manda JSON |
| `PUT /user/changeUserPassword/{id}`, `DELETE /user/deleteUser/{id}`, `GET /user/listOfUsers` | ninguna |
| `GET /workspace/listOfWorkspaces` | `/dashboard`, `/editProfile/:id` |
| `GET /workspace/getWorkspaceById/{id}` | `/reservation/:id` |
| `POST /workspace/createWorkspace`, `PUT /updateWorkspace/{id}`, `DELETE /deleteWorkspace/{id}`, imágenes y qualities | ninguna (solo Swagger/Postman) |
| `POST /reservation/createReservation/{ws}/{user}` | ninguna — el modal de pago no lo llama |
| `GET /reservation/getReservationsByUser/{id}` | ninguna |
| `/qualities/*` | ninguna |
| `GET /render/health` | health checks (compose, dev.sh, Render) |

## Arquitectura objetivo

- Tests con Testcontainers PostgreSQL, sin H2: [ADR 0001](adr/0001-testcontainers-postgres.md).
- Pendientes de ADR (🧠 al llegar a esas tareas): migraciones con Flyway en lugar de `ddl-auto`; manejo de errores con `ProblemDetail` (RFC 9457); autorización por dueño + rol `ADMIN`; camino de migración Boot 3.2 → 3.5 → 4.x y React 18 → 19 / Vite 8; JWT stateless con secreto por entorno (y cookie httpOnly vs `localStorage`).

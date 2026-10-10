# WoodWork · back (`backend/coworkProject/`)

API REST de WoodWork: Spring Boot 3.2.5, Java 17 (compila con JDK 21), PostgreSQL, JWT. Volver al [README raíz](../../README.md).

## Configurar

Desde `backend/coworkProject/` (los valores sirven tal cual para local):

```bash
cp src/main/resources/env.properties.example src/main/resources/env.properties
```

Resultado esperado: `src/main/resources/env.properties` existe (está en `.gitignore`). Va en `src/main/resources/` porque `application.properties:1` lo importa **desde el classpath**; en la raíz del módulo no se lee. Variables: [docs/SETUP.md](../../docs/SETUP.md#variables).

## Correr

1. DB (desde la raíz del repo): `docker compose up -d --wait` → `Container woodwork-db-1 Healthy`.
2. App (desde `backend/coworkProject/`):
   ```bash
   ./mvnw spring-boot:run
   ```
   Resultado esperado: `Started CoworkProjectApplication`; `curl http://localhost:8080/v1/api/render/health` → `Server is awake and running!`. Swagger: http://localhost:8080/swagger-ui.

## Comandos

| Qué | Comando (desde `backend/coworkProject/`) |
|---|---|
| Build + tests (gate) | `./mvnw -B clean verify` (o `../../scripts/verify.sh --server`) |
| Correr | `./mvnw spring-boot:run` |
| Un solo test | `./mvnw test -Dtest=CoworkProjectApplicationTests` (⚠️ hoy no corre: `skipTests=true` en `pom.xml`, T-002) |
| Un método | `./mvnw test -Dtest='ReservationServiceImplTest#rejectsOverCapacity'` (desde T-002) |
| Jar | `./mvnw -B clean package -DskipTests` → `target/coworkProject-0.0.1-SNAPSHOT.jar` |
| Imagen local | desde la raíz: `docker compose --profile app build server` (usa `Dockerfile.dev`) |

`Dockerfile` (sin `.dev`) es el de producción original (Render); no se usa en local.

## Estructura

```
src/main/java/org/example/coworkproject/
  configuration/        CORS, Spring Security, JWT (filtro y servicio)
  controller/           endpoints REST /v1/api/**
  dto/request|response  DTOs con Bean Validation
  entity/               entidades JPA (User, Workspace, Reservation, Qualities)
  exception/            excepciones propias
  helper/               Cloudinary (imágenes)
  mapper/               MapStruct
  repository/           Spring Data JPA
  service/ + impl/      lógica de negocio
  wakeUpRender/         ping periódico al deploy de Render
src/main/resources/     application.properties + env.properties(.example)
src/test/java/...       tests (hoy solo contextLoads)
```

Para agentes: [AGENTS.md](AGENTS.md).

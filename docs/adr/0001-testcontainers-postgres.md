# 0001 · Tests de integración con Testcontainers PostgreSQL (sin H2)

- Estado: Aceptado · Fecha: 2026-10-10 · Decide: 🧠 (auditoría inicial) · Tarea: T-002

## Contexto
El back corre contra PostgreSQL (`application.properties:5`, imagen `postgres:18-alpine` en compose) y el esquema lo genera Hibernate. El único test (`contextLoads`) necesita una DB levantada a mano y `env.properties`, por eso está apagado (`skipTests=true`). Hace falta una red de tests que corra igual en local, en CI y en el agente gratuito, sin configuración manual.

## Decisión
Los tests de integración (`@SpringBootTest`, `@DataJpaTest`) usan **Testcontainers** con la misma imagen de PostgreSQL que `docker-compose.yml`, vía `@ServiceConnection`. Los unitarios y `@WebMvcTest` no levantan DB. Requisito: Docker disponible (ya lo es para desarrollo).

## Alternativas
- **H2 en memoria:** rápido y sin Docker, pero otro dialecto (tipos, `ElementCollection`, funciones de fecha) → falsos verdes. Descartada.
- **DB de compose compartida:** sin aislamiento entre corridas, depende de pasos manuales. Descartada.
- **Embedded Postgres (zonky):** binarios nativos por SO, menos estándar. Descartada.

## Consecuencias
- `./mvnw verify` necesita Docker; `verify.sh` lo avisa.
- Primer arranque más lento (descarga de imagen); se reutiliza el contenedor por clase/suite.
- CI (`ubuntu-latest`) trae Docker: sin pasos extra.

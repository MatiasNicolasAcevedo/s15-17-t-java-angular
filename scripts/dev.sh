#!/usr/bin/env bash
# Entorno de desarrollo: DB en contenedor + back (spring-boot:run) + front (vite, hot reload).
# Uso: ./scripts/dev.sh          levanta todo; Ctrl+C corta back y front (la DB queda corriendo)
#      ./scripts/dev.sh --down   apaga la DB (los datos quedan en el volumen; para borrarlos: docker compose down -v)
# Hace lo mismo que el paso a paso "Opción B" del README.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT/backend/coworkProject"
CLIENT_DIR="$ROOT/frontend"
LOGS="$ROOT/.dev-logs"
API="http://localhost:8080/v1/api"
DEMO_EMAIL="demo@woodwork.local"
DEMO_PASSWORD="Demo1234!"

if [ "${1:-}" = "--down" ]; then
  cd "$ROOT" && docker compose down
  exit 0
fi

mkdir -p "$LOGS"
set -m  # cada proceso en segundo plano queda en su propio grupo: se puede cortar el árbol completo

PIDS=()
cleanup() {
  trap - INT TERM EXIT
  echo; echo "dev: cortando back y front..."
  for pid in "${PIDS[@]}"; do kill -- "-$pid" 2>/dev/null || true; done
  wait 2>/dev/null || true
  echo "dev: listo. La DB sigue corriendo (./scripts/dev.sh --down para apagarla)."
}
trap cleanup INT TERM EXIT

wait_for() { # url, nombre, segundos
  local i
  for ((i = 0; i < $3; i++)); do
    curl -sf -o /dev/null "$1" && { echo "dev: ✅ $2 listo"; return 0; }
    sleep 1
  done
  echo "dev: ❌ $2 no respondió en $3 s (ver .dev-logs/)"; return 1
}

# 1. Configuración: el archivo real si existe, si no el .example
[ -f "$SERVER_DIR/src/main/resources/env.properties" ] || {
  cp "$SERVER_DIR/src/main/resources/env.properties.example" "$SERVER_DIR/src/main/resources/env.properties"
  echo "dev: copiado backend env.properties.example -> src/main/resources/env.properties"; }
[ -f "$CLIENT_DIR/.env" ] || { cp "$CLIENT_DIR/.env.example" "$CLIENT_DIR/.env"; echo "dev: copiado frontend .env.example -> .env"; }

# 2. Base de datos
echo "dev: levantando la DB (docker compose up -d --wait)..."
(cd "$ROOT" && docker compose up -d --wait db)

# 3. Back
echo "dev: arrancando el back (log: .dev-logs/server.log)..."
(cd "$SERVER_DIR" && exec sh ./mvnw -B spring-boot:run) >"$LOGS/server.log" 2>&1 &
PIDS+=("$!")
wait_for "$API/render/health" "back (http://localhost:8080)" 180

# 4. Usuario demo (no hay seed todavía: T-016). Si ya existe, el back responde 403 y se ignora.
code=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$API/auth/register" -H 'Content-Type: application/json' \
  -d "{\"email\":\"$DEMO_EMAIL\",\"password\":\"$DEMO_PASSWORD\",\"fullName\":\"Demo User\"}" || true)
[ "$code" = "200" ] && echo "dev: usuario demo creado" || echo "dev: usuario demo ya existía (HTTP $code)"

# 5. Front
[ -d "$CLIENT_DIR/node_modules" ] || (cd "$CLIENT_DIR" && npm ci --no-audit --no-fund)
echo "dev: arrancando el front (log: .dev-logs/client.log)..."
(cd "$CLIENT_DIR" && exec npm run dev -- --port 5173 --strictPort) >"$LOGS/client.log" 2>&1 &
PIDS+=("$!")
wait_for "http://localhost:5173" "front (http://localhost:5173)" 60

cat <<EOF

  Front:    http://localhost:5173
  API:      $API   (Swagger: http://localhost:8080/swagger-ui)
  Usuario:  $DEMO_EMAIL / $DEMO_PASSWORD
  ⚠️ Hasta T-006 el front llama a la API de PRODUCCIÓN, no a este back.

  Ctrl+C para cortar back y front.
EOF
wait

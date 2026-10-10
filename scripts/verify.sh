#!/usr/bin/env bash
# Gate rápido del proyecto: build (con clean) + lint + tests de cada parte.
# Uso: ./scripts/verify.sh [--server] [--client]   (sin opciones: ambas partes)
# Sale con código != 0 si algo falla. Detalle en .verify-logs/ (ignorado por git).
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="$ROOT/backend/coworkProject"
CLIENT_DIR="$ROOT/frontend"
LOGS="$ROOT/.verify-logs"
mkdir -p "$LOGS"

RUN_SERVER=0; RUN_CLIENT=0
for arg in "$@"; do
  case "$arg" in
    --server) RUN_SERVER=1 ;;
    --client) RUN_CLIENT=1 ;;
    -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
    *) echo "Opción desconocida: $arg" >&2; exit 2 ;;
  esac
done
if [ $RUN_SERVER -eq 0 ] && [ $RUN_CLIENT -eq 0 ]; then RUN_SERVER=1; RUN_CLIENT=1; fi

FAILED=0
SUMMARY=()

# --- server ---------------------------------------------------------------
verify_server() {
  local log="$LOGS/server.log" status jdk tests
  jdk="$(java -version 2>&1 | grep -m1 -oE 'version "[0-9]+' | grep -oE '[0-9]+$' || echo '?')"
  cd "$SERVER_DIR" || return 1

  # Configuración local: usa la real si existe; si no, copia el ejemplo (ruta del classpath).
  if [ ! -f src/main/resources/env.properties ]; then
    cp src/main/resources/env.properties.example src/main/resources/env.properties
    echo "verify: copiado env.properties.example -> src/main/resources/env.properties"
  fi
  # La DB solo hace falta para tests que la usan; si Docker está disponible, se levanta.
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    (cd "$ROOT" && docker compose up -d --wait db) >"$LOGS/db.log" 2>&1 || echo "verify: ⚠️ no se pudo levantar la DB (ver .verify-logs/db.log)"
  fi

  echo "verify: server → ./mvnw -B clean verify (log: .verify-logs/server.log)"
  if sh ./mvnw -B clean verify >"$log" 2>&1; then
    if grep -q "Tests are skipped" "$log"; then
      tests="⚠️ tests saltados por pom.xml (T-002)"
    else
      tests="✅ tests ($(grep -E 'Tests run: [0-9]+' "$log" | tail -1 | grep -oE 'Tests run: [0-9]+' | grep -oE '[0-9]+' || echo 0))"
    fi
    status="✅ build $tests [JDK $jdk]"
  else
    FAILED=1
    if grep -qE 'Tests run:.*(Failures: [1-9]|Errors: [1-9])' "$log"; then
      status="✅ build ❌ tests ($(grep -E 'Tests run:' "$log" | tail -1 | sed 's/^\[[A-Z]*\] //')) [JDK $jdk]"
    else
      status="❌ build [JDK $jdk]"
      grep -m3 -E '\[ERROR\]' "$log" | sed 's/^/  /'
      if grep -qiE 'release version|invalid target release|Unsupported class file|lombok' "$log"; then
        echo "  pista: revisá la versión del JDK (el proyecto compila con JDK 21; ver .sdkmanrc)"
      fi
    fi
  fi
  SUMMARY+=("server: $status")
}

# --- client ---------------------------------------------------------------
verify_client() {
  local status="" lint build tests
  cd "$CLIENT_DIR" || return 1
  if [ ! -d node_modules ] || [ package-lock.json -nt node_modules ]; then
    echo "verify: client → npm ci"
    npm ci --no-audit --no-fund >"$LOGS/client-install.log" 2>&1 || { FAILED=1; SUMMARY+=("client: ❌ npm ci (ver .verify-logs/client-install.log)"); return; }
  fi

  echo "verify: client → npm run lint"
  if npm run lint >"$LOGS/client-lint.log" 2>&1; then lint="✅ lint"; else
    FAILED=1; lint="❌ lint ($(grep -oE '[0-9]+ problems? \([0-9]+ errors?, [0-9]+ warnings?\)' "$LOGS/client-lint.log" | tail -1))"
  fi

  echo "verify: client → npm run build"
  if npm run build >"$LOGS/client-build.log" 2>&1; then build="✅ build"; else
    FAILED=1; build="❌ build"; grep -m3 -iE 'error' "$LOGS/client-build.log" | sed 's/^/  /'
  fi

  if node -e "process.exit(require('./package.json').scripts?.test ? 0 : 1)"; then
    echo "verify: client → npm test"
    if npm test >"$LOGS/client-test.log" 2>&1; then tests="✅ tests"; else FAILED=1; tests="❌ tests (ver .verify-logs/client-test.log)"; fi
  else
    tests="⚠️ sin tests (T-013)"
  fi
  status="$lint $build $tests [Node $(node -v)]"
  SUMMARY+=("client: $status")
}

[ $RUN_SERVER -eq 1 ] && verify_server
[ $RUN_CLIENT -eq 1 ] && verify_client

echo
echo "verify: $(IFS='·'; echo "${SUMMARY[*]}" | sed 's/·/ · /g')"
[ $FAILED -eq 0 ] && echo "verify: ✅ OK" || echo "verify: ❌ FALLA (detalle en .verify-logs/)"
exit $FAILED

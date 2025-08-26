#!/usr/bin/env bash
# run_all.sh — one-command bootstrap for the project
# 1) Start PostgreSQL container (coffee_pg) with trust auth (no password)
# 2) Wait until DB is ready
# 3) Run SQL: src/GeneratedScript.sql -> src/CoffeeData.sql -> src/views.sql
# 4) Refresh materialized view product_info_m_view (if present)
# 5) Run demo queries (src/demo_queries.sql) if present
# 6) Export CSVs to data/: staff_locations_view.csv, product_info_m-view.csv
# Option: --reset  (recreate container from scratch)

set -euo pipefail

DB_USER="cafe"
DB_NAME="coffee_shop"
CONTAINER="coffee_pg"

# optional flags
if [[ "${1-}" == "--reset" ]]; then
  docker rm -f "$CONTAINER" adminer 2>/dev/null || true
fi

# sanity checks
command -v docker >/dev/null 2>&1 || { echo "Docker is required but not found."; exit 1; }
mkdir -p data

echo "1) Start PostgreSQL in Docker (passwordless trust auth)…"
if ! docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  docker run --name "$CONTAINER" \
    -e POSTGRES_HOST_AUTH_METHOD=trust \
    -e POSTGRES_USER="$DB_USER" \
    -e POSTGRES_DB="$DB_NAME" \
    -d postgres:16 >/dev/null
else
  docker start "$CONTAINER" >/dev/null || true
fi

echo "   Waiting for database to become ready…"
docker exec "$CONTAINER" bash -lc 'until pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; do sleep 0.5; done'

run_sql () {
  local file="$1"
  if [ -f "$file" ]; then
    echo "2) Running $file"
    # pass the file from host to container via stdin
    docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -q -f - < "$file"
  else
    echo "   Skip: file not found $file"
  fi
}

# schema -> data -> views
run_sql src/GeneratedScript.sql
run_sql src/CoffeeData.sql
run_sql src/views.sql

echo "3) Refresh materialized view (if present)…"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c \
"DO \$\$BEGIN
   IF EXISTS (SELECT 1 FROM pg_matviews WHERE matviewname='product_info_m_view') THEN
     EXECUTE 'REFRESH MATERIALIZED VIEW product_info_m_view';
   END IF;
 END\$\$;" >/dev/null || true

if [ -f src/demo_queries.sql ]; then
  echo "4) Run demo queries…"
  docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -f - < src/demo_queries.sql
fi

echo "5) Export CSV from views (if they exist)…"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c \
  "COPY (SELECT * FROM staff_locations_view) TO STDOUT WITH CSV HEADER" > data/staff_locations_view.csv 2>/dev/null || echo "   staff_locations_view not found — skip"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c \
  "COPY (SELECT * FROM product_info_m_view) TO STDOUT WITH CSV HEADER" > data/product_info_m-view.csv 2>/dev/null || echo "   product_info_m_view not found — skip"

echo "6) Objects summary:"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "\dt"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "\dv"



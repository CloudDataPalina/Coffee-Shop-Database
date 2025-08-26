#!/usr/bin/env bash
set -e

DB_USER="cafe"
DB_NAME="coffee_shop"
CONTAINER="coffee_pg"

echo "1) Стартую PostgreSQL в Docker (без пароля)…"
if ! docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  docker run --name "$CONTAINER" \
    -e POSTGRES_HOST_AUTH_METHOD=trust \
    -e POSTGRES_USER="$DB_USER" \
    -e POSTGRES_DB="$DB_NAME" \
    -d postgres:16 >/dev/null
else
  docker start "$CONTAINER" >/dev/null || true
fi

echo "   Жду готовности БД…"
docker exec "$CONTAINER" bash -lc 'until pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; do sleep 0.5; done'

run_sql () {
  local file="$1"
  if [ -f "$file" ]; then
    echo "2) Выполняю $file"
    docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -q -f - < "$file"
  else
    echo "   Пропускаю: нет файла $file"
  fi
}

run_sql src/GeneratedScript.sql   # схема
run_sql src/CoffeeData.sql        # данные
run_sql src/views.sql             # представления

echo "3) Обновляю materialized view (если есть)…"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c \
"DO \$\$BEGIN
   IF EXISTS (SELECT 1 FROM pg_matviews WHERE matviewname='product_info_m_view') THEN
     EXECUTE 'REFRESH MATERIALIZED VIEW product_info_m_view';
   END IF;
 END\$\$;" >/dev/null || true

if [ -f src/demo_queries.sql ]; then
  echo "4) Прогоняю demo_queries.sql"
  docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -f - < src/demo_queries.sql
fi

echo "5) Экспорт CSV (если вьюхи существуют)…"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c \
  "COPY (SELECT * FROM staff_locations_view) TO STDOUT WITH CSV HEADER" > data/staff_locations_view.csv 2>/dev/null || echo "   нет staff_locations_view — пропускаю"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c \
  "COPY (SELECT * FROM product_info_m_view) TO STDOUT WITH CSV HEADER" > data/product_info_m-view.csv 2>/dev/null || echo "   нет product_info_m_view — пропускаю"

echo "6) Сводка объектов:"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "\dt"
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "\dv"

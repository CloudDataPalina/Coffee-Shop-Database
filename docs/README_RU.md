# Coffee Shop Database — документация (RU)

Учебный проект по PostgreSQL для кофейни.
В репозитории есть: схема БД (из ERD в pgAdmin), тестовые данные, представления (включая materialized view), демо-запросы, а также CSV-выгрузки для импорта в MySQL и IBM Db2. В папке images/ — скриншоты ключевых этапов.

## Структура репозитория
```
Coffee-Shop-Database/
├── data/
│   ├── staff_locations_view.csv                 ← CSV из view для внешних систем (MySQL/Db2)
│   └── product_info_m-view.csv                  ← CSV из materialized view для маркетинга
│
├── docs/
│   └── README_RU.md                             ← этот документ (RU)
│
├── images/
│   ├── 01_dataset_overview.png                  ← обзор исходных таблиц/данных
│   ├── 02_erd_relationships.png                 ← ERD: связи (sales_detail↔sales_transaction, product↔product_type)
│   ├── 03_postgresql_staff_locations_view.png   ← staff_locations_view в pgAdmin
│   ├── 04_postgresql_product_info_m_view.png    ← materialized view в pgAdmin
│   ├── 05_mysql_staff_locations_table.png       ← таблица после импорта в MySQL
│   ├── 06_mysql_product_info_table.png          ← просмотр product_info_m_view в MySQL (по CSV)
│   ├── 07_db2_load_success.png                  ← успешный Load Data в IBM Db2
│   └── 08_db2_staff_locations_table.png         ← таблица в Db2 после загрузки
│
├── output/
│   ├── db2_staff_locations_ddl.sql              ← (опц.) DDL таблицы STAFF_LOCATIONS для Db2
│   └── mysql_staff_locations.sql                ← (опц.) дамп таблицы staff_locations для MySQL
│
├── src/
│   ├── GeneratedScript.sql                      ← DDL: таблицы и связи (сгенерировано из ERD в pgAdmin)
│   ├── CoffeeData.sql                           ← тестовые данные (pg_dump)
│   ├── views.sql                                ← staff_locations_view + product_info_m_view
│   └── demo_queries.sql                         ← 3–5 показательных SELECT’ов
│
├── LICENSE
└── README.md                                    ← краткое описание (EN)

```

### 1) Что внутри БД

Основные таблицы (см. images/02_erd_relationships.png):
- product, product_type — каталог товаров и типы
- sales_transaction, sales_detail — продажи (шапка + строки)
- staff, sales_outlet, customer — персонал, точки продаж, клиенты
Представления:
- staff_locations_view — легкая витрина «сотрудник → локация» для передач во внешние системы (MySQL/Db2).
- product_info_m_view — materialized view с товаром + категорией (для аналитики/маркетинга).

### 2) Быстрый старт (PostgreSQL)
Требования: PostgreSQL 13+ и/или pgAdmin 4.
1. Создайте пустую БД (например, coffee).
2. Выполните src/GeneratedScript.sql — создаст таблицы и связи.
3. Загрузите данные из src/CoffeeData.sql.
4. Создайте представления из src/views.sql.
Если product_info_m_view создано с WITH NO DATA, выполните:
```
REFRESH MATERIALIZED VIEW public.product_info_m_view;
```
5. Проверьте:
```
SELECT * FROM public.staff_locations_view LIMIT 10;
SELECT * FROM public.product_info_m_view  LIMIT 10;
```
6. Запустите примеры из src/demo_queries.sql (топ-товары, продажи по точкам и т.п.).

### 3) Экспорт и интеграции

#### MySQL
- Быстро: импортируйте data/staff_locations_view.csv в таблицу staff_locations (phpMyAdmin → Import).
- Альтернатива: выполните готовый дамп output/mysql_staff_locations.sql.
Скриншоты: images/05_mysql_staff_locations_table.png, images/06_mysql_product_info_table.png.

#### IBM Db2 on Cloud
- Интерфейс Load Data → источник My Computer → файл data/staff_locations_view.csv.
Цель: новая таблица STAFF_LOCATIONS.
Скрин: images/07_db2_load_success.png, итоговая таблица — images/08_db2_staff_locations_table.png.
- (Опционально) Создать таблицу заранее DDL-скриптом output/db2_staff_locations_ddl.sql.

### 4) Как получены data/*.csv
- staff_locations_view.csv — результат SELECT из staff_locations_view.
- product_info_m-view.csv — выгрузка из product_info_m_view (после REFRESH MATERIALIZED VIEW).
Идея: хранить в data/ готовые к импорту CSV, чтобы любой мог быстро повторить шаги для MySQL/Db2.

### 5) Навигация по скриншотам
- 01_dataset_overview.png — исходные таблицы/поля.
- 02_erd_relationships.png — наглядные связи.
- 03_* 04_* — подтверждение работы view/materialized view в PostgreSQL.
- 05_* 06_* — результат импорта в MySQL.
- 07_* 08_* — результат загрузки в Db2.

### 6) Повторяемость и заметки
- Скрипты в src/ самодостаточны: DDL → данные → представления → демо-запросы.
- Экспорт в data/ синхронизирован с представлениями. При изменениях в источнике обновите CSV повторным экспортом.
- Нейминг скриншотов соответствует порядку шагов, чтобы читать репозиторий «сверху вниз».

### 7) Лицензия
Проект распространяется по MIT License (см. LICENSE).

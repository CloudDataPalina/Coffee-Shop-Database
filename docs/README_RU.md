# Coffee Shop Database — документация (RU)

Учебный проект по PostgreSQL для кофейни: схема БД (создана из ERD в pgAdmin), тестовые данные,
представления (включая материализованное), демонстрационные запросы, а также экспорт CSV для импорта в MySQL и IBM Db2.

## Структура репозитория
```
Coffee-Shop-Database/
├── data/
│   ├── staff_locations_view.csv              ← выгрузка для внешнего payroll/MySQL/Db2
│   └── product_info_m-view.csv               ← выгрузка для маркетинга
│
├── images/
│   ├── erd_relationships.png                 ← ERD со связями (sales_detail↔sales_transaction, product↔product_type)
│   ├── pgadmin_staff_locations_view.png      ← результат staff_locations_view в pgAdmin
│   ├── pgadmin_product_info_mview.png        ← результат materialized view в pgAdmin
│   ├── mysql_import_staff_locations.png      ← импорт CSV в phpMyAdmin
│   ├── mysql_staff_locations_table.png       ← просмотр таблицы в MySQL
│   ├── db2_load_success.png                  ← успешный Load Data в Db2
│   └── db2_staff_locations_table.png         ← таблица в Db2
│
├── output/
│   ├── mysql_staff_locations.sql             ← (опц.) дамп таблицы после импорта в MySQL
│   └── db2_staff_locations_ddl.sql           ← (опц.) DDL/DDL-скрипт из Db2
│   │
├── src/
│   ├── GeneratedScript.sql                   ← DDL: таблицы и связи (из ERD pgAdmin)
│   ├── CoffeeData.sql                        ← тестовые данные (pg_dump)
│   ├── views.sql                             ← staff_locations_view + product_info_m_view
│   └── demo_queries.sql                      ← 3–5 показательных SELECT’ов
│
├── docs/
│   └── README_RU.md                          ← русская документация
│
├── LICENSE
└── README.md                                 ← англоязычное описание

```

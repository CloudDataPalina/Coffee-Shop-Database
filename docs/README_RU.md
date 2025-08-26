# ☕️Coffee Shop Database — документация (RU)

Добро пожаловать! Это мини-проект по реляционному моделированию и интеграции данных:  
**ERD → DDL → данные → представления → CSV-экспорты → импорт в MySQL и IBM Db2.**

**Что вы найдёте в репозитории:**
- 🗺️ ERD и схема БД: [`src/GeneratedScript.sql`](../src/GeneratedScript.sql)
- 🐘 PostgreSQL данные и представления (включая MView): [`src/CoffeeData.sql`](../src/CoffeeData.sql), [`src/views.sql`](../src/views.sql)
- 🔁 Экспорты CSV для внешних систем: [`data/`](../data)
- 🐬 Импорт в MySQL и 🟦 Db2 (со скриншотами): [`images/`](../images)
- 🧪 Примеры аналитических запросов: [`src/demo_queries.sql`](../src/demo_queries.sql)

---

## 🚀 Запуск одной командой (GitHub Codespaces)

Никакой локальной установки и паролей — Docker работает внутри Codespaces.

```bash
git pull
chmod +x run_all.sh
./run_all.sh
```
Нужен «чистый» старт?

```bash
./run_all.sh --reset
```

Быстрая проверка:

```bash
docker exec -i coffee_pg psql -U cafe -d coffee_shop -c "SELECT * FROM staff_locations_view LIMIT 5;"
```
---

## 🎯 Цель проекта

Показать полный цикл построения реляционной БД для сети кофеен и обмена данными между СУБД:
- анализ источников и **выделение сущностей/атрибутов**;
- нормализация (в т.ч. переход ко **2НФ**), проектирование **ERD** и ключей/связей;
- генерация **DDL** и загрузка **демо-данных**;
- создание **view** и **materialized view** для операционных/маркетинговых задач;
- **экспорт CSV** и импорт в **MySQL** и **IBM Db2**;
- воспроизводимость через набор SQL-скриптов и наглядные скриншоты.

Практический результат — репозиторий-портфолио, по которому любой сможет развернуть схему, данные и повторить интеграции.

---

## 📦 Содержимое (быстро)

- Схема и данные: [`src/GeneratedScript.sql`](../src/GeneratedScript.sql), [`src/CoffeeData.sql`](../src/CoffeeData.sql)  
- Представления: [`src/views.sql`](../src/views.sql)  
- CSV-экспорты: [`data/`](../data)  
- Импорт в MySQL/Db2: [`output/mysql_staff_locations.sql`](../output/mysql_staff_locations.sql), [`output/db2_staff_locations_ddl.sql`](../output/db2_staff_locations_ddl.sql)  
- Скриншоты пайплайна: [`images/`](../images)
---

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
├── run_all.sh                                   ← скрипт инициализации и запуска одной командой
├── LICENSE
└── README.md                                    ← краткое описание (EN)

```

---

###  🗺️ 1) Что внутри БД 

Основные таблицы *(см. ERD →* [`images/02_erd_relationships.png`](../images/02_erd_relationships.png)*)*:

- `product`, `product_type` — каталог товаров и типы  
- `sales_transaction`, `sales_detail` — продажи (шапка + строки)  
- `staff`, `sales_outlet`, `customer` — персонал, точки продаж, клиенты  

**Представления:**

- `staff_locations_view` — легкая витрина «сотрудник → локация» для передачи во внешние системы (MySQL/Db2)  
- `product_info_m_view` — **materialized view** с товаром + категорией (для аналитики/маркетинга)

Скриншоты подтверждений:  
[`03_postgresql_staff_locations_view.png`](../images/03_postgresql_staff_locations_view.png) • [`04_postgresql_product_info_m_view.png`](../images/04_postgresql_product_info_m_view.png)

---

### 🐘 2) Быстрый старт (PostgreSQL) 

**Требования:** PostgreSQL 13+ и/или pgAdmin 4.

1. Создайте пустую БД (например, `coffee`).  
2. Выполните DDL: [`src/GeneratedScript.sql`](../src/GeneratedScript.sql) — создаст таблицы и связи.  
3. Загрузите данные: [`src/CoffeeData.sql`](../src/CoffeeData.sql).  
4. Создайте представления: [`src/views.sql`](../src/views.sql).  
   Если `product_info_m_view` создано с `WITH NO DATA`, выполните:

   ```sql
   REFRESH MATERIALIZED VIEW public.product_info_m_view;
   ```

5. Быстрая проверка:

   ```sql
   SELECT * FROM public.staff_locations_view LIMIT 10;
   SELECT * FROM public.product_info_m_view  LIMIT 10;
   ```
6. **Примеры запросов:** [`src/demo_queries.sql`](../src/demo_queries.sql)
*(топ-товары, продажи по точкам и т. п.).*

---

### 🔁 3) Экспорт и интеграции 

**MySQL 🐬**

- **Быстро:** импортируйте [`data/staff_locations_view.csv`](../data/staff_locations_view.csv)
  в таблицу `staff_locations` *(phpMyAdmin → Import)*.
- **Альтернатива:** выполните готовый дамп
  [`output/mysql_staff_locations.sql`](../output/mysql_staff_locations.sql).

Скриншоты:
[`05_mysql_staff_locations_table.png`](../images/05_mysql_staff_locations_table.png) •
[`06_mysql_product_info_table.png`](../images/06_mysql_product_info_table.png)

**IBM Db2 on Cloud 🟦**

- Интерфейс **Load Data** → источник **My Computer** → файл
  [`data/staff_locations_view.csv`](../data/staff_locations_view.csv).
  Цель: новая таблица `STAFF_LOCATIONS`.
  Подтверждения:
  [`07_db2_load_success.png`](../images/07_db2_load_success.png) •
  [`08_db2_staff_locations_table.png`](../images/08_db2_staff_locations_table.png)
- *(Опционально)* создать таблицу заранее DDL-скриптом:
  [`output/db2_staff_locations_ddl.sql`](../output/db2_staff_locations_ddl.sql).

---

### 💾 4) Как получены `data/*.csv` 

- [`staff_locations_view.csv`](../data/staff_locations_view.csv) — результат `SELECT` из `staff_locations_view`.
- [`product_info_m-view.csv`](../data/product_info_m-view.csv) — выгрузка из `product_info_m_view`
  *(после `REFRESH MATERIALIZED VIEW`)*.

В `data/` содержатся готовые к импорту CSV, чтобы можно было быстро повторить шаги для MySQL/Db2.

---

### 🖼️ 5) Навигация по скриншотам 

- [`01_dataset_overview.png`](../images/01_dataset_overview.png) — обзор исходных таблиц/полей  
- [`02_erd_relationships.png`](../images/02_erd_relationships.png) — наглядные связи  
- [`03_postgresql_staff_locations_view.png`](../images/03_postgresql_staff_locations_view.png) — PostgreSQL: `staff_locations_view`  
- [`04_postgresql_product_info_m_view.png`](../images/04_postgresql_product_info_m_view.png) — PostgreSQL: `product_info_m_view` (materialized)  
- [`05_mysql_staff_locations_table.png`](../images/05_mysql_staff_locations_table.png) — MySQL: импорт `staff_locations`  
- [`06_mysql_product_info_table.png`](../images/06_mysql_product_info_table.png) — MySQL: импорт `product_info_m_view`  
- [`07_db2_load_success.png`](../images/07_db2_load_success.png) — IBM Db2: успешный **Load Data**  
- [`08_db2_staff_locations_table.png`](../images/08_db2_staff_locations_table.png) — IBM Db2: таблица `STAFF_LOCATIONS`


---

### ♻️ 6) Повторяемость и заметки 

- Скрипты в `src/` самодостаточны: **DDL → данные → представления → демо-запросы**.  
- Экспорт в `data/` синхронизирован с представлениями 
- Имя файлов в `images/` отражает порядок шагов — репозиторий читается «сверху вниз».

---

## ✅ Итоги / что получилось

- Полноценная **реляционная модель** (PK/FK, связи `1–N`) и **ERD**.  
- Загруженные **демо-данные** для воспроизводимых примеров.  
- Два представления: `staff_locations_view` (операционное) и `product_info_m_view` (материализованное, аналитическое).  
- Готовые **CSV** для обмена с внешними системами.  
- Подтверждение **импорта в MySQL и IBM Db2** (скрипты + скриншоты).  
- Набор **демо-запросов** для быстрых аналитических проверок.

---

### 📜 7) Лицензия 

Проект распространяется по **MIT License** — см. [`LICENSE`](../LICENSE).  
Описание на английском: [`README.md`](../README.md).

***Приятного пользования и вкусных данных*** ☕️🙂

---

## 👩‍💻 Author

**Palina Krasiuk**  
Aspiring Cloud Data Engineer | ex-Senior Accountant  
[LinkedIn](https://www.linkedin.com/in/palina-krasiuk-954404372/) • [GitHub Portfolio](https://github.com/CloudDataPalina)
   

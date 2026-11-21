# 📝 Summary: Importing Files & Creating Tables in MySQL

A one-page revision sheet for the nine lessons. See the [README](README.md) for links to each lesson.

## 🔄 The big picture

```mermaid
flowchart LR
    T["1 · Create<br/>tables"] --> I["2, 7, 8 · Import<br/>Wizard / LOAD DATA / staging"]
    I --> M["3, 4 · Change<br/>& copy data"]
    M --> R["5, 6 · Relate<br/>& speed up"]
    R --> E["9 · Export"]
```

## 1 · Creating Tables

- Order: `CREATE DATABASE` → `USE` → `CREATE TABLE`.
- Types: `VARCHAR` for codes (keeps `0000400000`), `DECIMAL(15,2)` for money, `DATE` for dates.
- Constraints: `NOT NULL`, `PRIMARY KEY`, `DEFAULT`, `CHECK`.
- Inspect with `DESCRIBE` and `SHOW CREATE TABLE`; change with `ALTER`.

## 2 · Importing Excel / CSV (Wizard)

- The wizard reads **CSV and JSON** only: save Excel as **CSV UTF-8** first.
- Clean first: one header row, `YYYY-MM-DD` dates, plain numbers, codes as Text.
- **Fix field types**: the wizard guesses `int` and drops leading zeros.
- Failed rows are **skipped silently**: compare `records imported` with the source and read **Show Logs**.

## 3 · Inserting, Updating & Deleting Data

- Always list columns in `INSERT`; `ON DUPLICATE KEY UPDATE` makes an upsert.
- Preview with `SELECT` using the same `WHERE` before `UPDATE` / `DELETE`.
- Use `START TRANSACTION` … `COMMIT` / `ROLLBACK` for two-sided adjustments.
- `DELETE` can be rolled back; `TRUNCATE` and `DROP` can't.

## 4 · Copying Tables

| Need | Statement |
| --- | --- |
| Empty copy with keys | `CREATE TABLE new LIKE old;` |
| Full backup | `LIKE` + `INSERT INTO new SELECT * FROM old;` |
| Filtered / reshaped copy | `CREATE TABLE new AS SELECT … ;` (no keys or indexes) |

- Foreign keys are never copied.

## 5 · Foreign Keys

- Child column → parent key: `FOREIGN KEY (hkont) REFERENCES gl_accounts (saknr)`.
- Parent first when creating and loading; child first when emptying or dropping.
- Find orphans: `LEFT JOIN … WHERE parent.key IS NULL`.
- Use `ON DELETE RESTRICT` for audit data. Errors: **1452** (no parent), **1451** (parent in use).

## 6 · Indexes

- Primary and foreign keys are indexes already: `SHOW INDEX FROM t;`.
- `EXPLAIN` the query: `type = ALL` means a full table scan.
- Composite indexes follow the **leftmost-prefix rule**.
- Indexes are ignored with a leading `%`, a function on the column, or a number compared with text.

## 7 · Bulk Loading (LOAD DATA INFILE)

- Fastest for large files; enable `local_infile` on **server and client**.
- Match `FIELDS TERMINATED BY`, `ENCLOSED BY`, `LINES TERMINATED BY` (`\r\n` for Windows), `IGNORE 1 LINES`.
- Convert on the way in: `@var` + `SET col = STR_TO_DATE(…)`, `REPLACE(…)`.
- With `LOCAL`, problems become **warnings**: check `Skipped`, `Warnings`, `SHOW WARNINGS`.

## 8 · Staging Tables

- Load raw text into an all-`VARCHAR` table: no row is lost.
- Profile with `REGEXP`, `STR_TO_DATE … IS NULL`, `GROUP BY … HAVING COUNT(*) > 1`.
- Move clean rows with `INSERT … SELECT`, converting each column.
- Reconcile staged vs loaded counts; every difference must be explained.

## 9 · Exporting Data

| Need | Method |
| --- | --- |
| Query results | Result grid → **Export** (turn off the 1,000-row limit) |
| Whole table | **Table Data Export Wizard** |
| Scripted file | `SELECT … INTO OUTFILE` (server, `secure_file_priv`, no header) |
| Backup | **Server → Data Export** or `mysqldump` |

- Open CSVs in Excel with **Data → From Text/CSV** to keep leading zeros.

## 🚨 Error codes to recognise

| Code | Meaning | Lesson |
| --- | --- | --- |
| 1046 | No database selected | 1 |
| 1062 | Duplicate entry (primary key) | 1, 3 |
| 1175 | Safe update mode blocked `UPDATE`/`DELETE` | 3 |
| 1290 | File outside `secure_file_priv` | 7, 9 |
| 1451 / 1452 | Foreign key blocks delete / insert | 5 |
| 1701 | Can't truncate a referenced parent table | 5 |
| 2068 / 3948 | Local file loading disabled (client / server) | 7 |
| 3780 | Foreign key columns incompatible | 5 |
| 3819 | `CHECK` constraint violated | 1 |

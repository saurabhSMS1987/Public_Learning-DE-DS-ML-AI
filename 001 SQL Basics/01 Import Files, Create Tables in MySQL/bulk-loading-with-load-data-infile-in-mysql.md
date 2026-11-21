# 🚀 Bulk Loading with LOAD DATA INFILE in MySQL

Load large CSV and text files in seconds with `LOAD DATA INFILE`, and convert SAP formats (dates, thousands separators, trailing minus signs) **while loading**. The worked example is a raw **SAP ERP Trial Balance** export.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

**Before you start:** create the `trial_balance` table ([Creating Tables](creating-tables-in-mysql.md)).

**Sample file:** [`data/sap_trial_balance_fy2026_raw.csv`](data/sap_trial_balance_fy2026_raw.csv): the same 19-account TB in **SAP export format**, saved on Windows.

```text
1000,2026,012,31.12.2026,0000185000,Accumulated depreciation - PP&E,"540,000.00-",0.00,"180,000.00","720,000.00-",USD
```

## 🆚 Wizard or LOAD DATA?

| | Import Wizard | `LOAD DATA INFILE` |
| --- | --- | --- |
| Speed | Slow above ~100k rows | Millions of rows in seconds/minutes |
| Repeatable | Clicks each time | Save and rerun the script |
| Converts formats on load | ❌ | ✅ |
| Ease | Point and click | SQL |

## 🗺️ The process

```mermaid
flowchart LR
    A["1 · Enable<br/>local_infile"] --> B["2 · Write the<br/>LOAD DATA"] --> C["3 · Convert<br/>formats"] --> D["4 · Run"] --> E["5 · Check the<br/>result line"]
```

## Step 1 · Enable local file loading

`LOAD DATA LOCAL` reads a file from **your machine** and is off by default. It must be on at **both** ends.

| Side | How |
| --- | --- |
| Server (admin) | `SET GLOBAL local_infile = 1;` |
| MySQL Workbench | **Database → Manage Connections → Advanced → Others:** `OPT_LOCAL_INFILE=1`, then reconnect |
| Command line | `mysql --local-infile=1 -u <user> -p` |

```sql
SHOW GLOBAL VARIABLES LIKE 'local_infile';   -- ON
```

## Step 2 · Write the statement

| Clause | Purpose | Sample TB |
| --- | --- | --- |
| `LOAD DATA LOCAL INFILE 'path'` | File to read (use `/` in Windows paths) | `'C:/data/sap_trial_balance_fy2026_raw.csv'` |
| `INTO TABLE` | Target table | `trial_balance` |
| `CHARACTER SET` | File encoding | `utf8mb4` |
| `FIELDS TERMINATED BY` | Column separator | `','` (`'\t'` for tab, `'\|'` for pipe) |
| `OPTIONALLY ENCLOSED BY` | Quote around text | `'"'` |
| `LINES TERMINATED BY` | Line ending | `'\r\n'` Windows, `'\n'` Mac/Linux |
| `IGNORE n LINES` | Skip header lines | `1` |
| `(col, @var, …)` | Map file columns to table columns or variables | |
| `SET col = …` | Convert a variable before storing | |

## Step 3 · Convert SAP formats on the way in

Read raw text into `@variables`, then convert it in `SET`.

| SAP value | Conversion | Result |
| --- | --- | --- |
| `31.12.2026` | `STR_TO_DATE(@d, '%d.%m.%Y')` | `2026-12-31` |
| `"1,800,000.00"` | `REPLACE(@v, ',', '')` | `1800000.00` |
| `"540,000.00-"` | Move the trailing `-` to the front | `-540000.00` |
| empty | `NULLIF(@v, '')` | `NULL` |

## Step 4 · Run the load

```sql
TRUNCATE TABLE trial_balance;   -- only if the table already holds this TB

LOAD DATA LOCAL INFILE 'C:/data/sap_trial_balance_fy2026_raw.csv'
INTO TABLE trial_balance
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(bukrs, gjahr, period, @key_date, hkont, txt50,
 @bal_cf, @debit, @credit, @closing, waers)
SET key_date = STR_TO_DATE(@key_date, '%d.%m.%Y'),
    bal_cf   = IF(@bal_cf  LIKE '%-', CONCAT('-', REPLACE(TRIM(TRAILING '-' FROM @bal_cf),  ',', '')), REPLACE(@bal_cf,  ',', '')),
    debit    = REPLACE(@debit,  ',', ''),
    credit   = REPLACE(@credit, ',', ''),
    closing  = IF(@closing LIKE '%-', CONCAT('-', REPLACE(TRIM(TRAILING '-' FROM @closing), ',', '')), REPLACE(@closing, ',', ''));
```

**Duplicate rows** (same primary key) are controlled by a keyword before `INTO TABLE`:

| Keyword | Duplicate row is… |
| --- | --- |
| `REPLACE` | Overwrites the existing row |
| `IGNORE` | Skipped, with a warning |

## Step 5 · Check the result line

Workbench's **Output** panel shows:

```text
19 row(s) affected  Records: 19  Deleted: 0  Skipped: 0  Warnings: 0
```

⚠️ With **`LOCAL`**, bad values and duplicates **don't stop the load**: they become warnings or skipped rows. Any non-zero `Skipped` or `Warnings` needs a look:

```sql
SHOW WARNINGS;   -- lists each problem with its row number
```

## 🖥️ Server-side load (without LOCAL)

`LOAD DATA INFILE` (no `LOCAL`) reads the file from the **database server**, only from the folder in `secure_file_priv`:

```sql
SHOW VARIABLES LIKE 'secure_file_priv';   -- e.g. C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
```

Copy the file there and use that full path. It needs the `FILE` privilege, and errors stop the load instead of being skipped.

## 🧪 Try it

1. Enable `local_infile` (Step 1) and reconnect.
2. Run Step 4 with your own file path.
3. Confirm the result line shows `Records: 19 Skipped: 0 Warnings: 0`.
4. Check the converted values:

```sql
SELECT hkont, key_date, bal_cf, closing
FROM trial_balance
WHERE hkont = '0000185000';   -- 2026-12-31, -540000.00, -720000.00
```

5. Remove `IGNORE 1 LINES`, reload, and run `SHOW WARNINGS;`: the header row produces a list of warnings (`Incorrect integer value: 'GJAHR'`, …) and **the load still finishes**.

## ⚠️ Common issues

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Error 3948: Loading local data is disabled` | Server setting off | `SET GLOBAL local_infile = 1;` |
| `Error 2068: LOAD DATA LOCAL INFILE file request rejected` | Workbench/client setting off | Add `OPT_LOCAL_INFILE=1` and reconnect |
| `Error 1290: --secure-file-priv option` | Server-side load outside the allowed folder | Use `LOCAL`, or move the file to `secure_file_priv` |
| `Error 2 / file not found` | Backslashes in the path | Use `/`: `'C:/data/file.csv'` |
| `Warnings: 19`, `Incorrect date value` | Date format not converted | `STR_TO_DATE(@d, '%d.%m.%Y')` |
| `Data truncated` on amounts | Separators or trailing minus left in | Convert in `SET` (Step 3) |
| `Skipped: n` | Duplicate primary keys | `TRUNCATE` first, or use `REPLACE` |
| One extra junk row | Header loaded as data | `IGNORE 1 LINES` |

## 🎯 Key takeaways

1. **`LOAD DATA INFILE`** is the fastest way to load large files, and the script is repeatable.
2. **`LOCAL`** reads from your machine and needs `local_infile` on **server and client**; without `LOCAL`, files must sit in `secure_file_priv`.
3. **Convert while loading:** raw text into `@variables`, cleaned in `SET`.
4. Match **separators, quotes and line endings** to the file (`\r\n` for Windows).
5. With `LOCAL`, problems become **warnings, not errors**: always read `Skipped`, `Warnings` and `SHOW WARNINGS`.

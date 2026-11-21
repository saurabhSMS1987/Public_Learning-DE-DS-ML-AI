# ✏️ Inserting, Updating & Deleting Data in MySQL

Add, change and remove individual rows with `INSERT`, `UPDATE` and `DELETE`, and use **transactions** so a mistake can be undone. The worked example posts an audit adjustment to an **SAP ERP Trial Balance**.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

**Before you start:** create the `trial_balance` table ([Creating Tables in MySQL](creating-tables-in-mysql.md)) and load the sample TB ([Importing Excel / CSV into MySQL](importing-excel-csv-into-mysql.md)).

## 🗺️ The process

```mermaid
flowchart LR
    A["1 · INSERT<br/>new rows"] --> B["2 · Preview<br/>with SELECT"] --> C["3 · UPDATE<br/>rows"] --> D["4 · DELETE<br/>rows"] --> E["5 · Wrap in a<br/>transaction"] --> F["6 · COMMIT or<br/>ROLLBACK"]
```

## Step 1 · Insert rows

```sql
-- One row: columns left out take their DEFAULT (balances 0, currency USD)
INSERT INTO trial_balance (bukrs, gjahr, period, key_date, hkont, txt50)
VALUES ('1000', 2026, '012', '2026-12-31', '0000230000', 'Income tax payable');

-- Several rows in one statement
INSERT INTO trial_balance (bukrs, gjahr, period, key_date, hkont, txt50)
VALUES ('1000', 2026, '012', '2026-12-31', '0000700000', 'Interest expense'),
       ('1000', 2026, '012', '2026-12-31', '0000710000', 'Interest income');
```

✅ Always list the columns. `INSERT INTO trial_balance VALUES (...)` breaks as soon as a column is added.

**Insert or update ("upsert"):** when a row with the same primary key exists, update it instead of failing (MySQL 8.0.19+):

```sql
INSERT INTO trial_balance (bukrs, gjahr, period, key_date, hkont, txt50)
VALUES ('1000', 2026, '012', '2026-12-31', '0000230000', 'Income tax payable - current') AS new
ON DUPLICATE KEY UPDATE txt50 = new.txt50;
```

## Step 2 · Preview before you change anything

Run a `SELECT` with the **same `WHERE`** you plan to use. If it returns the wrong rows, so will the `UPDATE` or `DELETE`.

```sql
SELECT hkont, txt50, debit, credit, closing
FROM trial_balance
WHERE bukrs = '1000' AND gjahr = 2026 AND period = '012'
  AND hkont IN ('0000610000', '0000220000');
```

## Step 3 · Update rows

Audit adjustment: **unrecorded December rent of 12,000** (Dr Rent expense, Cr Accrued liabilities).

```sql
UPDATE trial_balance
SET debit   = debit   + 12000,
    closing = closing + 12000
WHERE bukrs = '1000' AND gjahr = 2026 AND period = '012' AND hkont = '0000610000';

UPDATE trial_balance
SET credit  = credit  + 12000,
    closing = closing - 12000
WHERE bukrs = '1000' AND gjahr = 2026 AND period = '012' AND hkont = '0000220000';
```

⚠️ An `UPDATE` without `WHERE` changes **every row**. Filter on the full primary key to change exactly one row.

## Step 4 · Delete rows

```sql
-- Remove the zero-balance account added in Step 1
DELETE FROM trial_balance
WHERE bukrs = '1000' AND gjahr = 2026 AND period = '012' AND hkont = '0000710000';
```

`DELETE` removes chosen rows and can be rolled back. `TRUNCATE` empties the whole table and can't.

## Step 5 · Use a transaction

A **transaction** groups statements so they succeed or fail together. A journal entry has two sides, so both updates must be kept or both undone.

```sql
START TRANSACTION;

UPDATE trial_balance SET debit = debit + 12000, closing = closing + 12000
WHERE bukrs = '1000' AND gjahr = 2026 AND period = '012' AND hkont = '0000610000';

UPDATE trial_balance SET credit = credit + 12000, closing = closing - 12000
WHERE bukrs = '1000' AND gjahr = 2026 AND period = '012' AND hkont = '0000220000';

SELECT SUM(closing) AS tb_net FROM trial_balance;   -- must be 0.00
```

## Step 6 · Commit or roll back

```sql
COMMIT;     -- TB nets to 0: save the changes
-- or
ROLLBACK;   -- something is wrong: undo everything since START TRANSACTION
```

| Point | Detail |
| --- | --- |
| Autocommit | Outside a transaction, every statement is saved immediately |
| Can't be rolled back | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` commit automatically |
| Visibility | Other sessions don't see your changes until `COMMIT` |

## 🧪 Try it

1. Run Step 1 and check the new accounts with `SELECT * FROM trial_balance WHERE closing = 0;`.
2. Run Step 5, but post the credit to the **wrong** amount (`12000` → `1200`).
3. Check `SUM(closing)`: it shows `10800.00`, not `0.00`.
4. Run `ROLLBACK;` and confirm the rent account is back to `180000.00` closing.
5. Repeat with the correct amount and `COMMIT;`.

## ⚠️ Common issues

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Error 1175: You are using safe update mode` | Workbench blocks `UPDATE`/`DELETE` without a key in `WHERE` | Filter on the primary key (preferred), or **Edit → Preferences → SQL Editor → untick Safe Updates** |
| `Error 1062: Duplicate entry` | Primary key already exists | Use the upsert in Step 1, or `UPDATE` instead |
| `Error 1136: Column count doesn't match` | Values don't match the column list | Count columns and values |
| `ROLLBACK` didn't undo anything | No `START TRANSACTION`, so autocommit saved each statement | Start the transaction first |
| Wrong rows changed | `WHERE` too broad | Preview with `SELECT` first (Step 2) |

## 🎯 Key takeaways

1. **`INSERT`** adds rows; always name the columns. **`ON DUPLICATE KEY UPDATE`** turns it into an upsert.
2. **Preview with `SELECT`** using the same `WHERE` before any `UPDATE` or `DELETE`.
3. **`WHERE` on the primary key** changes exactly one row; no `WHERE` changes them all.
4. **Transactions** keep both sides of an adjustment together: `START TRANSACTION` → check → `COMMIT` / `ROLLBACK`.
5. `DELETE` can be rolled back; `TRUNCATE` and `DROP` can't.

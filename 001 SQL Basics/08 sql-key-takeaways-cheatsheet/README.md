# 📘 SQL Basics: Key Takeaways & MySQL Cheat Sheet

A one-stop revision pack for the SQL basics I have learnt: the **key takeaways** from every topic, plus a **cheat sheet** for anyone writing MySQL queries.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📂 Files

| File | What it is | Use it when |
| --- | --- | --- |
| [KEY_TAKEAWAYS.md](KEY_TAKEAWAYS.md) | The main lessons from each topic, plus ten good habits | Revising, preparing for interviews |
| [CHEATSHEET.md](CHEATSHEET.md) | Syntax and examples for every topic in the takeaways, in the same order | Writing queries |
| [cheatsheet_examples.sql](cheatsheet_examples.sql) | Small demo database (`customers`, `sales`) | Trying the cheat sheet queries |
| [requirements.txt](requirements.txt) | Software needed | Setting up |

## 🧠 Topics covered

| Area | Topics |
| --- | --- |
| Setup | Installing MySQL Server & Workbench, `USE` |
| Tables | `CREATE DATABASE/TABLE`, data types, constraints, `ALTER`, `DROP`, copying tables, foreign keys, indexes |
| Data in & out | Import Wizard, `LOAD DATA INFILE`, staging tables, export, backups |
| Changing data | `INSERT`, `UPDATE`, `DELETE`, transactions |
| Text queries | `SELECT`, `*`, `AS`, `COUNT`, `DISTINCT`, `WHERE`, `LIKE` |
| Numeric queries | Comparison operators, `AND`/`OR`, `BETWEEN`, `IN`, `ORDER BY`, `LIMIT`, `OFFSET` |
| Summary analytics | `MIN`, `MAX`, `AVG`, `SUM`, `GROUP BY` |
| Filtering groups | `HAVING` |
| Calculated columns | Arithmetic, `IF`, `CASE`, `YEAR`, current year `YEAR(CURDATE())`, currency & unit conversion |

## 🚀 Try the cheat sheet

1. Install MySQL ([requirements.txt](requirements.txt)).
2. Load the demo data, either from the command line:

   ```bash
   mysql -u root -p < cheatsheet_examples.sql
   ```

   or by opening `cheatsheet_examples.sql` in MySQL Workbench and clicking ⚡ **Execute**.
3. Run `USE cheatsheet_demo;`, then copy any `sql` block from [CHEATSHEET.md](CHEATSHEET.md).

The demo script drops and recreates `cheatsheet_demo`, so it can be rerun at any time. Examples that change data run inside a transaction and end with `ROLLBACK`, so the demo stays intact.

## 🗂️ Demo data

| Table | Rows | Contents |
| --- | --- | --- |
| `customers` | 5 | ID (with leading zeros), name, region, created-on date |
| `sales` | 12 | Invoice lines and credit memos for 2026 (and one in January 2027): quantity in kg, price, cost, amount, currency (USD/EUR), user, note |

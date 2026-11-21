# 📗 SQL Intermediate: Key Takeaways & MySQL Cheat Sheet

A revision pack for working with **multiple tables** in SQL: the **key takeaways** from every intermediate topic, plus a **cheat sheet** for anyone writing MySQL queries with joins, transformations and analytics.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📂 Files

| File | What it is | Use it when |
| --- | --- | --- |
| [KEY_TAKEAWAYS.md](KEY_TAKEAWAYS.md) | The main lessons from each topic, plus ten good habits | Revising, preparing for interviews |
| [CHEATSHEET.md](CHEATSHEET.md) | Syntax and examples for every topic in the takeaways, in the same order | Writing queries |
| [cheatsheet_examples.sql](cheatsheet_examples.sql) | Small demo database used by the cheat sheet | Trying the queries |
| [requirements.txt](requirements.txt) | Software needed | Setting up |

## 🧠 Topics covered

| # | Topic | Highlights |
| --- | --- | --- |
| 1 | Why multiple tables | Less repetition, better organisation, easier updates, ERDs |
| 2 | Joins | `JOIN … ON … AND`, aliases, INNER (default), LEFT, RIGHT, FULL via `UNION`, CSV export |
| 3 | CROSS JOIN & SELF JOIN | Every combination; `CONCAT`; a table joined to itself |
| 4 | Transformation functions | Text, number, date, conversion and NULL functions |
| 5 | Joining more than two tables | Chained joins, `GROUP_CONCAT`, aggregate before joining |
| 6 | Analytics on tables | Merge + group, % of total, Top N / Bottom N |

## 🚀 Try the cheat sheet

1. Install MySQL ([requirements.txt](requirements.txt)).
2. Load the demo data, either from the command line:

   ```bash
   mysql -u root -p < cheatsheet_examples.sql
   ```

   or by opening `cheatsheet_examples.sql` in MySQL Workbench and clicking ⚡ **Execute**.
3. Run `USE cheatsheet_intermediate;`, then copy any `sql` block from [CHEATSHEET.md](CHEATSHEET.md).

The script drops and recreates `cheatsheet_intermediate`, so it can be rerun at any time.

## 🗂️ Demo data

| Table | Rows | Contents |
| --- | --- | --- |
| `customers` | 5 | ID, name (one with stray spaces), region; one customer has no orders |
| `products` | 3 | Product ID and description |
| `price_list` | 9 | List price per product **and** region (for two-column joins) |
| `employees` | 4 | Employee and manager (for self joins) |
| `orders` | 6 | Order header: date, customer, created by |
| `order_items` | 8 | Order lines: product, quantity, unit price (one above list price) |
| `payments` | 5 | Payments per order (one order paid in two parts) |
| `months` | 3 | January–March (for cross joins) |

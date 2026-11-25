# 📝 Summary: SQL Subqueries

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 Where a subquery can go

```sql
SELECT customer_id,
       SUM(net_value) / (SELECT SUM(net_value) FROM rv_billing_docs) * 100 AS pct  -- SELECT: one value
FROM (SELECT * FROM rv_billing_docs WHERE billing_type = 'F2') AS f                  -- FROM: derived table
WHERE customer_id IN (SELECT customer_id FROM rv_customers WHERE blocked = 'N')       -- WHERE: list
GROUP BY customer_id;
```

| Type | Returns | Use with | Example |
| --- | --- | --- | --- |
| Scalar | One value | `=` `>` `<`, or in `SELECT` | Invoices above the average |
| List | One column | `IN`, `NOT IN`, `ANY`, `ALL` | Invoices to blocked customers |
| Derived table | A table | `FROM (…) AS t` | Customers over credit limit |
| Correlated | Per outer row | `WHERE`, `SELECT` | Price above list, above own average |
| `EXISTS` / `NOT EXISTS` | TRUE / FALSE | `WHERE` | Invoices without items |

## ⚠️ Rules and errors

| Rule | Error if broken |
| --- | --- |
| Scalar subquery must return one row | `1242: Subquery returns more than 1 row` |
| `IN (…)` subquery selects one column | `1241: Operand should contain 1 column` |
| Derived table needs an alias | `1248: Every derived table must have its own alias` |
| No nested aggregates: `AVG(SUM(x))` | `1111: Invalid use of group function` |
| `NOT IN` with a NULL in the list | No error, **zero rows** → use `NOT EXISTS` |

## 🔎 Audit findings in the sample data

| Test | Subquery | Finding |
| --- | --- | --- |
| Large invoices | Scalar `> AVG` | 7 invoices above 7,585.00 |
| Billing block | `IN` | 2,400.00 billed to blocked C800 |
| Intercompany | `NOT IN` | 15,000.00 excluded: external revenue 132,300.00 |
| Dormant customer | `NOT IN` | C700 never billed |
| Credit limit | Derived table | Delta 27,300.00 vs 20,000.00 limit |
| Pricing | Correlated | 2 Delta items above list price |
| Completeness | `NOT EXISTS` | Invoice 90000019 (5,500.00) has no items |
| Header vs items | Derived / correlated | 6,000.00 difference on 2 invoices |
| Credit memos | `NOT EXISTS` | 2 without a valid original invoice (-2,700.00) |
| Cut-off | Correlated `MAX` | 90000020 billed 2027-01-04, posted 2026-12-31 |

## 🎯 Key takeaways

1. A subquery is a query in brackets whose result feeds the outer query; it replaces hard-coded values.
2. **What it returns decides the operator:** one value → `=` `>`; a list → `IN` / `ANY` / `ALL`; a table → `FROM` with an alias.
3. **Derived tables** let you filter, join or average on totals.
4. **Correlated** subqueries compare each row with its own group (customer, material, account).
5. **`NOT EXISTS` over `NOT IN`** when NULLs are possible; it is the go-to completeness test.
6. Subquery to **filter**, `JOIN` to **return columns**; index link columns for speed.

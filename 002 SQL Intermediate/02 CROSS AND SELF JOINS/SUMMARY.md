# 📝 Summary: CROSS JOIN & SELF JOIN

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 At a glance

| | CROSS JOIN | SELF JOIN |
| --- | --- | --- |
| What | Every row of A × every row of B | A table joined to itself |
| Condition | None (no `ON`) | `ON` between two aliases of the same table |
| Rows | rows(A) × rows(B) | Depends on the match condition |
| Keyword | `CROSS JOIN` | No special keyword: `JOIN` / `LEFT JOIN` with two aliases |
| Typical use | Grids, completeness checks, % of total | Hierarchies, duplicates, period comparisons |

```sql
-- CROSS JOIN: complete grid, then find the gaps
SELECT c.name, p.month_name
FROM cost_centers c
CROSS JOIN periods p
LEFT JOIN opex_postings o ON o.cost_center = c.cost_center AND o.period = p.period
WHERE o.doc_no IS NULL;

-- SELF JOIN: employee and manager from the same table
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON m.emp_id = e.manager_id;
```

## Cheat sheet

| Rule | Why |
| --- | --- |
| Cross join only small lists | Row counts multiply quickly |
| Grid + `LEFT JOIN` + `IS NULL` | Finds combinations with no data |
| Cross join a one-row total | Adds the total to every row for percentages |
| Two different aliases in a self join | Same alias gives `Error 1066` |
| `b.key > a.key` in self joins | Each pair once, never a row with itself |
| `LEFT JOIN` for hierarchies | Keeps the top of the hierarchy (no manager) |
| Tight match conditions for duplicates | Stops recurring items being flagged |

## 🔎 OpEx audit findings

| Finding | Join | Value |
| --- | --- | --- |
| December rent missing (unrecorded liability) | CROSS | 15,000.00 |
| Self-approved expenses | SELF (employees) | 50,800.00 (2 items) |
| Approver not the requester's manager | SELF (employees) | 3,200.00 |
| Above approval limit (50,000) | SELF (approver → manager) | 65,000.00 |
| Duplicate vendor invoice within 7 days | SELF (postings) | 9,400.00 |
| Rent increase in November | SELF (previous period) | +3,000.00 (+20%) |
| Largest spend categories | CROSS (% of total) | Rent 43.3%, Consulting 39.6% |

## 🎯 Key takeaways

1. **CROSS JOIN** = every combination; use it deliberately, on small tables.
2. **Grid + LEFT JOIN** shows what *should* exist but doesn't: missing months, missing categories.
3. **SELF JOIN** = one table, two aliases; compare rows with related rows.
4. Self joins turn an employee table into **approval-control tests** and a postings table into **duplicate and trend tests**.
5. Watch row counts: an accidental cross join or a loose self join multiplies rows and totals.

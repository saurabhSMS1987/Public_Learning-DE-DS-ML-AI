# 🧩 Common Table Expressions (CTE) in MySQL

A **CTE** is a **named, temporary result set** defined with `WITH` at the start of a query. It exists only while that query runs. A CTE does the same job as a subquery in `FROM`, but is written first, given a name, and read top to bottom.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ce_employees`, `ce_cost_centers`, `ce_budget`, `ce_expenses` ([setup](README.md#setup))

## Syntax

```sql
WITH cte_name AS (
    SELECT …                         -- any query
),
second_cte AS (                      -- more CTEs: separate with commas, no second WITH
    SELECT … FROM cte_name …         -- a CTE can use the CTEs defined before it
)
SELECT …
FROM second_cte …;                   -- the main query; the CTEs disappear after it
```

## Examples

**1 · Budget vs actual: lines more than 10% over budget**

```sql
WITH actual AS (
    SELECT cost_center, expense_type, SUM(amount) AS actual_amount
    FROM ce_expenses
    GROUP BY cost_center, expense_type
)
SELECT b.cost_center, b.expense_type, b.budget_amount,
       IFNULL(a.actual_amount, 0)                   AS actual_amount,
       IFNULL(a.actual_amount, 0) - b.budget_amount AS variance,
       ROUND((IFNULL(a.actual_amount, 0) - b.budget_amount) / b.budget_amount * 100, 1) AS variance_pct
FROM ce_budget b
LEFT JOIN actual a ON a.cost_center = b.cost_center AND a.expense_type = b.expense_type
WHERE IFNULL(a.actual_amount, 0) > b.budget_amount * 1.10
ORDER BY variance_pct DESC;
```

| cost_center | expense_type | budget_amount | actual_amount | variance | variance_pct |
| --- | --- | --- | --- | --- | --- |
| CC100 | Consulting | 15000.00 | 29898.00 | 14898.00 | **99.3** |
| CC300 | Travel | 18000.00 | 23750.00 | 5750.00 | 31.9 |
| CC200 | Utilities | 21000.00 | 25000.00 | 4000.00 | 19.0 |
| CC400 | Software | 80000.00 | 92500.00 | 12500.00 | 15.6 |

**2 · Two CTEs: cost-centre budget vs actual**

```sql
WITH bud AS (
    SELECT cost_center, SUM(budget_amount) AS budget
    FROM ce_budget GROUP BY cost_center
),
act AS (
    SELECT cost_center, SUM(amount) AS actual
    FROM ce_expenses GROUP BY cost_center
)
SELECT c.cost_center, c.name, b.budget, a.actual,
       a.actual - b.budget AS variance
FROM ce_cost_centers c
JOIN bud b ON b.cost_center = c.cost_center
JOIN act a ON a.cost_center = c.cost_center
ORDER BY c.cost_center;
```

| cost_center | name | budget | actual | variance |
| --- | --- | --- | --- | --- |
| CC100 | Administration | 204600.00 | 204498.00 | **-102.00** |
| CC200 | Operations | 45000.00 | 47000.00 | 2000.00 |
| CC300 | Sales | 78000.00 | 73250.00 | -4750.00 |
| CC400 | IT | 100000.00 | 111600.00 | 11600.00 |

CC100 looks on budget, but example 1 shows Consulting 99% over. It is offset by rent being 15,000 under, because **August rent was never posted** ([applications](cte-applications-in-mysql.md#1--recursive-cte-months-with-no-rent-posted)). Totals can hide offsetting errors.

**3 · A CTE built on another CTE: unusual months**

```sql
WITH monthly AS (
    SELECT MONTH(posting_date) AS mth, SUM(amount) AS total
    FROM ce_expenses
    GROUP BY MONTH(posting_date)
),
avg_month AS (
    SELECT AVG(total) AS avg_total FROM monthly          -- uses the first CTE
)
SELECT m.mth, m.total, ROUND(a.avg_total, 2) AS avg_total
FROM monthly m
CROSS JOIN avg_month a
WHERE m.total > a.avg_total * 1.5
   OR m.total < a.avg_total * 0.5
ORDER BY m.mth;
```

| mth | total | avg_total |
| --- | --- | --- |
| 8 | 4050.00 | 36362.33 |
| 9 | **103500.00** | 36362.33 |

August is low (missing rent); September is high (62,000.00 software invoice).

**4 · Filter a CTE: approvals above the approver's limit**

```sql
WITH over_limit AS (
    SELECT e.doc_no, e.posting_date, e.cost_center, e.amount,
           e.approved_by, p.approval_limit
    FROM ce_expenses e
    JOIN ce_employees p ON p.emp_id = e.approved_by
    WHERE e.amount > p.approval_limit
)
SELECT o.*, c.name AS cost_center_name
FROM over_limit o
JOIN ce_cost_centers c ON c.cost_center = o.cost_center
ORDER BY o.amount DESC;
```

| doc_no | posting_date | cost_center | amount | approved_by | approval_limit | cost_center_name |
| --- | --- | --- | --- | --- | --- | --- |
| 1600000026 | 2026-09-15 | CC400 | 62000.00 | E04 | 50000.00 | IT |
| 1600000021 | 2026-07-28 | CC100 | 19998.00 | E06 | 5000.00 | Administration |
| 1600000039 | 2026-12-14 | CC300 | 7400.00 | E08 | 5000.00 | Sales |
| 1600000041 | 2026-12-21 | CC300 | 6800.00 | E08 | 5000.00 | Sales |

**5 · Unbudgeted spend: CTE + `NOT EXISTS`** → CC400 Training, 3,500.00

```sql
WITH actual AS (
    SELECT cost_center, expense_type, SUM(amount) AS actual_amount
    FROM ce_expenses
    GROUP BY cost_center, expense_type
)
SELECT a.*
FROM actual a
WHERE NOT EXISTS (SELECT 1 FROM ce_budget b
                  WHERE b.cost_center = a.cost_center
                    AND b.expense_type = a.expense_type);
```

## ✅ Benefits of CTEs

| Benefit | Why it matters |
| --- | --- |
| **Readability** | Logic reads top to bottom in named steps, not inside-out nested brackets |
| **Reusability** | Define once, use several times in the same query (even join it to itself) |
| **Step-by-step building** | Each CTE can build on the previous one: base → summary → exceptions |
| **Easier testing** | Run the main query as `SELECT * FROM cte_name` to check each step |
| **Recursion** | `WITH RECURSIVE` handles hierarchies and date series, which subqueries cannot |
| **Documentation** | Names like `actual`, `over_limit` explain the audit test to a reviewer |
| **No clean-up** | Nothing is saved in the database; no tables to drop afterwards |

## CTE vs subquery vs temporary table vs view

| | CTE | Derived table (subquery) | Temporary table | View |
| --- | --- | --- | --- | --- |
| Lives for | One query | One query | The session | Permanent |
| Named | Yes | Alias only | Yes | Yes |
| Reuse in the same query | ✅ | ❌ repeat the code | ✅ | ✅ |
| Reuse in later queries | ❌ | ❌ | ✅ | ✅ |
| Recursive | ✅ | ❌ | ❌ | ❌ |
| Can be indexed | ❌ | ❌ | ✅ | ❌ |

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `WITH a AS (…) WITH b AS (…)` | `Error 1064` syntax error | One `WITH`; separate CTEs with commas |
| Semicolon after the CTE | `Error 1064`: a CTE needs its query in the same statement | `WITH … ( … ) SELECT …;` as one statement |
| Using a CTE in the next statement | `Error 1146: Table … doesn't exist` | Repeat the `WITH`, or save to a table |
| Referring to a CTE defined later | `Error 1146: Table … doesn't exist` | Order CTEs so each uses only earlier ones |
| Selecting a column not in the CTE | `Unknown column` | Add it to the CTE's `SELECT` |

## 🎯 Key takeaways

1. A CTE is a **named, temporary result** defined with `WITH`, available only to the query that follows.
2. Several CTEs use **one `WITH`** and commas; later CTEs can use earlier ones.
3. CTEs make complex logic **readable, reusable and testable**: base → summary → exceptions.
4. Use a CTE for one query; a temporary table or view when results are needed again later.
5. Check detail, not just totals: CC100 is on budget overall but hides a 99% consulting overrun and a missing month of rent.

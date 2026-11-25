# 🛠️ Applications of CTEs in MySQL

Beyond tidying up queries, CTEs can **generate rows** (recursive CTEs), **walk hierarchies**, be **joined to themselves**, and **feed tables** that become audit workpapers.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ce_employees`, `ce_cost_centers`, `ce_budget`, `ce_expenses` ([setup](README.md#setup))

## Recursive CTE syntax

```sql
WITH RECURSIVE cte_name AS (
    SELECT …                        -- 1. anchor: the starting row(s)
    UNION ALL
    SELECT … FROM cte_name …        -- 2. recursive part: refers to itself
    WHERE <stop condition>          -- 3. stops when no new rows are produced
)
SELECT … FROM cte_name;
```

MySQL stops a runaway recursion after **1,000** levels (`cte_max_recursion_depth`).

## Examples

### 1 · Recursive CTE: months with no rent posted

```sql
WITH RECURSIVE months AS (
    SELECT 1 AS mth                                    -- anchor: January
    UNION ALL
    SELECT mth + 1 FROM months WHERE mth < 12          -- add a month until December
)
SELECT m.mth
FROM months m
WHERE NOT EXISTS (SELECT 1 FROM ce_expenses e
                  WHERE e.expense_type = 'Rent'
                    AND MONTH(e.posting_date) = m.mth);   -- → 8
```

Rent is 15,000.00 every month except **August**: an unrecorded liability (accrual) to raise. Missing rows can't be found by grouping the data you have; a generated calendar finds them.

Month-end dates instead of numbers:

```sql
WITH RECURSIVE month_ends AS (
    SELECT DATE('2026-01-31') AS month_end
    UNION ALL
    SELECT LAST_DAY(DATE_ADD(month_end, INTERVAL 1 MONTH))
    FROM month_ends
    WHERE month_end < '2026-12-31'
)
SELECT month_end FROM month_ends;                       -- 12 rows: 2026-01-31 … 2026-12-31
```

### 2 · Recursive CTE: management hierarchy

```sql
WITH RECURSIVE org AS (
    SELECT emp_id, name, manager_id, 1 AS lvl,
           CAST(name AS CHAR(200)) AS path                  -- anchor: the CEO
    FROM ce_employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.emp_id, e.name, e.manager_id, o.lvl + 1,
           CONCAT(o.path, ' > ', e.name)                    -- each report under its manager
    FROM ce_employees e
    JOIN org o ON e.manager_id = o.emp_id
)
SELECT emp_id, lvl, path FROM org ORDER BY path;
```

| emp_id | lvl | path |
| --- | --- | --- |
| E01 | 1 | Helen Park |
| E02 | 2 | Helen Park > Laura Chen |
| E04 | 3 | Helen Park > Laura Chen > Mark Davis |
| E06 | 4 | Helen Park > Laura Chen > Mark Davis > Tom Wilson |
| E03 | 2 | Helen Park > Ravi Menon |
| E05 | 3 | Helen Park > Ravi Menon > Priya Nair |
| E08 | 4 | Helen Park > Ravi Menon > Priya Nair > Jake Kim |
| E07 | 4 | Helen Park > Ravi Menon > Priya Nair > Sara Lopez |

`CAST(… AS CHAR(200))` sizes the column in the anchor; without it, longer paths are cut off.

### 3 · Recursive CTE: who should have approved?

Walk up the chain from each over-limit approver until someone's limit covers the amount.

```sql
WITH RECURSIVE chain AS (
    SELECT e.doc_no, e.amount, p.emp_id, p.name, p.title,
           p.approval_limit, p.manager_id, 0 AS steps_up
    FROM ce_expenses e
    JOIN ce_employees p ON p.emp_id = e.approved_by
    WHERE e.amount > p.approval_limit                        -- anchor: over-limit approvals
    UNION ALL
    SELECT c.doc_no, c.amount, m.emp_id, m.name, m.title,
           m.approval_limit, m.manager_id, c.steps_up + 1
    FROM chain c
    JOIN ce_employees m ON m.emp_id = c.manager_id          -- one level up
    WHERE c.amount > c.approval_limit                        -- stop once covered
)
SELECT doc_no, amount, name AS required_approver, title, approval_limit
FROM chain
WHERE amount <= approval_limit
ORDER BY doc_no;
```

| doc_no | amount | required_approver | title | approval_limit |
| --- | --- | --- | --- | --- |
| 1600000021 | 19998.00 | Mark Davis | Finance Manager | 50000.00 |
| 1600000026 | 62000.00 | Laura Chen | Chief Financial Officer | 250000.00 |
| 1600000039 | 7400.00 | Priya Nair | Operations Manager | 50000.00 |
| 1600000041 | 6800.00 | Priya Nair | Operations Manager | 50000.00 |

### 4 · One CTE used twice: first half vs second half

```sql
WITH half AS (
    SELECT cost_center,
           IF(MONTH(posting_date) <= 6, 'H1', 'H2') AS hf,
           SUM(amount) AS total
    FROM ce_expenses
    GROUP BY cost_center, IF(MONTH(posting_date) <= 6, 'H1', 'H2')
)
SELECT h1.cost_center, h1.total AS h1_total, h2.total AS h2_total,
       ROUND((h2.total - h1.total) / h1.total * 100, 1) AS change_pct
FROM half h1
JOIN half h2 ON h2.cost_center = h1.cost_center AND h2.hf = 'H2'   -- same CTE, second alias
WHERE h1.hf = 'H1'
ORDER BY change_pct DESC;
```

| cost_center | h1_total | h2_total | change_pct |
| --- | --- | --- | --- |
| CC400 | 38500.00 | 73100.00 | **89.9** |
| CC300 | 26400.00 | 46850.00 | 77.5 |
| CC200 | 19600.00 | 27400.00 | 39.8 |
| CC100 | 94800.00 | 109698.00 | 15.7 |

With a subquery, the same logic would be written twice.

### 5 · Save a CTE's result as a workpaper table

```sql
DROP TABLE IF EXISTS ce_budget_variance;

CREATE TABLE ce_budget_variance AS
WITH actual AS (
    SELECT cost_center, expense_type, SUM(amount) AS actual_amount
    FROM ce_expenses
    GROUP BY cost_center, expense_type
)
SELECT b.cost_center, b.expense_type, b.budget_amount,
       IFNULL(a.actual_amount, 0)                   AS actual_amount,
       IFNULL(a.actual_amount, 0) - b.budget_amount AS variance
FROM ce_budget b
LEFT JOIN actual a ON a.cost_center = b.cost_center AND a.expense_type = b.expense_type;

SELECT COUNT(*), SUM(variance) FROM ce_budget_variance;   -- 9 lines · 5,248.00
```

5,248.00 + 3,500.00 unbudgeted training = 8,748.00 = total actual 436,348.00 − total budget 427,600.00. ✅ `INSERT INTO … WITH … SELECT …` works the same way.

## 🧭 Other applications

| Application | CTE type | Audit example |
| --- | --- | --- |
| Step-by-step audit tests | Multiple CTEs | Base population → summary → exceptions |
| Budget vs actual, variance analysis | CTE + join | Lines > 10% over budget |
| Missing periods / gaps in sequences | Recursive (series) | Months without rent; missing invoice numbers |
| Org charts and approval chains | Recursive (hierarchy) | Required approver; segregation of duties |
| Account or cost-centre roll-ups | Recursive (hierarchy) | Sub-accounts rolled up to a parent |
| Period comparisons | CTE joined to itself | H1 vs H2, this year vs last year |
| % of total, concentration | CTE + one-row total CTE | Top vendors' share of spend |
| Reconciliations | Two CTEs, then compare | Sub-ledger vs general ledger, header vs items |
| De-duplication | CTE with `GROUP BY … HAVING` | Duplicate vendor invoices |
| Saving workpapers | `CREATE TABLE … AS WITH …` | Budget variance table for review |

## More real-world examples

```sql
-- AP: duplicate vendor invoices (same vendor + reference)
WITH dupes AS (
    SELECT lifnr, xblnr FROM ap_invoices
    GROUP BY lifnr, xblnr HAVING COUNT(*) > 1
)
SELECT a.lifnr, a.name1, a.xblnr, a.belnr, a.dmbtr
FROM ap_invoices a
JOIN dupes d ON d.lifnr = a.lifnr AND d.xblnr = a.xblnr;

-- AR: aging buckets of year-end open items
WITH aged AS (
    SELECT open_amount,
           CASE WHEN days_overdue <= 0  THEN 'Current'
                WHEN days_overdue <= 30 THEN '1-30'
                WHEN days_overdue <= 90 THEN '31-90'
                ELSE '90+' END AS bucket
    FROM ar_open_items_ye
)
SELECT bucket, COUNT(*) AS items, SUM(open_amount) AS open_ar
FROM aged
GROUP BY bucket
ORDER BY FIELD(bucket, 'Current', '1-30', '31-90', '90+');

-- Journal entries: documents where debits ≠ credits
WITH doc_totals AS (
    SELECT belnr,
           SUM(IF(shkzg = 'S', dmbtr, 0)) AS debits,
           SUM(IF(shkzg = 'H', dmbtr, 0)) AS credits
    FROM je_lines
    GROUP BY belnr
)
SELECT COUNT(*) AS documents,
       SUM(IF(debits <> credits, 1, 0)) AS unbalanced          -- 20 · 0
FROM doc_totals;

-- Revenue: billing header vs sum of items
WITH items AS (
    SELECT billing_doc, SUM(net_amount) AS items_value
    FROM rv_billing_items GROUP BY billing_doc
)
SELECT d.billing_doc, d.net_value, IFNULL(i.items_value, 0) AS items_value
FROM rv_billing_docs d
LEFT JOIN items i ON i.billing_doc = d.billing_doc
WHERE d.net_value <> IFNULL(i.items_value, 0);

-- Opex: top 3 vendors' share of spend
WITH by_vendor AS (
    SELECT vendor, SUM(amount) AS total FROM opex_postings GROUP BY vendor
),
grand AS (
    SELECT SUM(total) AS g FROM by_vendor
)
SELECT v.vendor, v.total, ROUND(v.total / g.g * 100, 1) AS pct
FROM by_vendor v CROSS JOIN grand g
ORDER BY v.total DESC
LIMIT 3;

-- Approval chain above an employee (CROSS JOIN & SELF JOIN section's employees table)
WITH RECURSIVE chain AS (
    SELECT emp_id, name, title, manager_id, approval_limit, 0 AS lvl
    FROM employees WHERE emp_id = 'E06'
    UNION ALL
    SELECT m.emp_id, m.name, m.title, m.manager_id, m.approval_limit, c.lvl + 1
    FROM employees m JOIN chain c ON m.emp_id = c.manager_id
)
SELECT lvl, emp_id, name, title, approval_limit FROM chain;
```

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| No stop condition in a recursive CTE | `Error 3636: Recursive query aborted after 1001 iterations` | Add `WHERE` that ends the recursion |
| `WITH` instead of `WITH RECURSIVE` | `Error 1146: Table … doesn't exist` (self-reference) | Use `WITH RECURSIVE` |
| Anchor column too short for later rows | `Error 1406: Data too long for column` | `CAST(… AS CHAR(200))` in the anchor |
| `UNION` instead of `UNION ALL` | Extra work removing duplicates; can hide loops | `UNION ALL` (unless duplicates must go) |
| `SUM`, `MAX` etc. in the recursive part | `Error 3575: … can contain neither aggregation …` | Aggregate in the main query |

## 🎯 Key takeaways

1. `WITH RECURSIVE` = **anchor** + `UNION ALL` + **recursive part** with a **stop condition**.
2. Recursive CTEs **generate series** (find missing months, numbers) and **walk hierarchies** (org charts, approval chains).
3. A CTE can be **joined to itself**: compare periods without repeating code.
4. `CREATE TABLE … AS WITH …` / `INSERT … WITH …` save results as audit workpapers.
5. Always **reconcile** the result: variances + unbudgeted spend = actual − budget.

# 📝 Summary: Common Table Expressions (CTE)

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 Syntax

```sql
-- Regular CTEs: one WITH, commas between CTEs
WITH actual AS (SELECT cost_center, SUM(amount) AS total
                FROM ce_expenses GROUP BY cost_center),
     budget AS (SELECT cost_center, SUM(budget_amount) AS total
                FROM ce_budget GROUP BY cost_center)
SELECT a.cost_center, a.total - b.total AS variance
FROM actual a JOIN budget b ON b.cost_center = a.cost_center;

-- Recursive CTE: anchor + UNION ALL + recursive part with a stop condition
WITH RECURSIVE months AS (
    SELECT 1 AS mth
    UNION ALL
    SELECT mth + 1 FROM months WHERE mth < 12
)
SELECT * FROM months;
```

## ✅ Benefits

| Benefit | In one line |
| --- | --- |
| Readable | Named steps, top to bottom, no nested brackets |
| Reusable | Define once, use several times, even join to itself |
| Testable | `SELECT * FROM cte_name` checks each step |
| Recursive | Series and hierarchies |
| Self-documenting | Names explain the audit test |
| Nothing to clean up | Not stored in the database |

## 🧭 Applications

| Application | Audit example |
| --- | --- |
| Step-by-step tests | Population → summary → exceptions |
| Budget vs actual | Lines > 10% over budget |
| Gaps (recursive series) | Months with no rent posted |
| Hierarchies (recursive) | Org chart, required approver |
| Period comparison (CTE used twice) | H1 vs H2 by cost centre |
| Reconciliations | Header vs items, debits vs credits |
| Workpapers | `CREATE TABLE … AS WITH …` |

## 🔎 Audit findings in the sample data

| Finding | Value |
| --- | --- |
| Consulting over budget | 29,898.00 vs 15,000.00 (+99.3%) |
| Travel, utilities, software over budget by > 10% | +31.9% · +19.0% · +15.6% |
| August rent not posted (unrecorded liability) | 15,000.00 |
| Approvals above the approver's limit | 4 · 96,198.00 |
| Required approver for the 62,000.00 software invoice | CFO, not the Finance Manager |
| Unbudgeted spend | Training 3,500.00 |
| IT spend H2 vs H1 | +89.9% |

## 🎯 Key takeaways

1. A CTE is a **named, temporary result** defined with `WITH`; it exists only for one statement.
2. **One `WITH`, commas between CTEs**; later CTEs can use earlier ones.
3. CTEs make complex logic **readable, reusable and testable**.
4. `WITH RECURSIVE` = **anchor + `UNION ALL` + recursive part + stop condition**, for series and hierarchies.
5. Use a **temporary table or view** when results are needed beyond one query; `CREATE TABLE … AS WITH …` saves workpapers.
6. Test at the **detailed level** and reconcile: totals can hide offsetting variances.

# 🎤 Top Interview Questions: Common Table Expressions (CTE)

**1. What is a CTE?**
A named, temporary result set defined with `WITH` before a query. It exists only for that one statement.

```sql
WITH actual AS (SELECT cost_center, SUM(amount) AS total FROM ce_expenses GROUP BY cost_center)
SELECT * FROM actual WHERE total > 50000;
```

**2. Why use a CTE instead of a subquery?**
Readability (named steps, top to bottom), reuse (one definition used several times, even joined to itself), easier testing of each step, and recursion, which subqueries can't do. Performance is usually similar.

**3. How do you write several CTEs in one query?**
One `WITH`, CTEs separated by commas; each can use the ones defined before it.

```sql
WITH monthly AS (…),
     avg_month AS (SELECT AVG(total) FROM monthly)
SELECT …;
```

**4. How long does a CTE exist? Can the next query use it?**
Only for the statement it belongs to. The next statement gets `Error 1146: Table doesn't exist`. To reuse results, save them with `CREATE TABLE … AS`, a temporary table or a view.

**5. CTE vs temporary table vs view?**
CTE: one query, not stored, can be recursive. Temporary table: stored for the session, can be indexed and reused. View: a saved query, permanent, reusable by anyone with access.

**6. What is a recursive CTE, and what are its parts?**
A CTE that refers to itself (`WITH RECURSIVE`). Parts: **anchor** query (starting rows), `UNION ALL`, **recursive** query that joins to the CTE, and a **stop condition**.

```sql
WITH RECURSIVE months AS (
    SELECT 1 AS mth
    UNION ALL
    SELECT mth + 1 FROM months WHERE mth < 12
)
SELECT * FROM months;
```

**7. What happens if a recursive CTE never stops?**
MySQL aborts after `cte_max_recursion_depth` (default 1,000) levels: `Error 3636`. Fix the stop condition; raise the limit only if the data really needs more levels.

**8. Give real uses of recursive CTEs.**
Org charts and approval chains, finding missing dates or document numbers (generate a series, then `NOT EXISTS`), and rolling sub-accounts or cost centres up to a parent.

**9. Can a CTE be used with INSERT, UPDATE or CREATE TABLE?**
Yes. `CREATE TABLE t AS WITH … SELECT …`, `INSERT INTO t WITH … SELECT …`, and `WITH … UPDATE` / `DELETE` are supported in MySQL 8.

**10. Does MySQL support CTEs in every version?**
No. CTEs were added in **MySQL 8.0**; MySQL 5.7 needs derived tables instead.

**11. How do CTEs help in an audit?**
Each step of a test is named and reviewable: population → summary → exceptions. Examples: budget vs actual variances, approvals above limit, required approver via the hierarchy, missing months of rent, duplicate invoices, and reconciliations.

**12. Why did the cost-centre total look fine when one line was 99% over budget?**
Variances offset: Consulting was 14,898.00 over while rent was 15,000.00 under (August rent never posted). Always test at the detailed level, not just totals.

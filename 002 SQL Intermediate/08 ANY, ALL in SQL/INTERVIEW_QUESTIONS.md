# 🎤 Top 10 Interview Questions: ANY and ALL Operators

**1. What do `ANY` and `ALL` do?**
They compare one value with every value a subquery returns. `ANY` is TRUE if the comparison holds for **at least one** value; `ALL` only if it holds for **every** value.

**2. What is `SOME`?**
An exact synonym for `ANY`.

**3. How do `> ANY` and `> ALL` differ?**
`> ANY` = above the **smallest** value (`> MIN`). `> ALL` = above the **largest** value (`> MAX`).

```sql
WHERE amount > ANY (SELECT approval_limit FROM ox_approvers)  -- above 5,000 → 14 rows
WHERE amount > ALL (SELECT approval_limit FROM ox_approvers
                    WHERE approval_limit IS NOT NULL)        -- above 250,000 → 1 row
```

**4. What are `= ANY` and `<> ALL` equivalent to?**
`= ANY` = `IN`; `<> ALL` = `NOT IN`.

**5. Is `<> ANY` the same as `NOT IN`?**
No. `<> ANY` is TRUE if the value differs from **at least one** item, which is almost always true when the list has two or more values. In the sample, it returns all 27 rows instead of 23.

**6. What happens when the subquery returns no rows?**
`ANY` → always FALSE (no rows returned). `ALL` → always TRUE (every row returned), because nothing fails the test.

**7. What happens when the list contains a NULL?**
`ALL` can never be TRUE, because the comparison with NULL is unknown, so `> ALL` returns no rows. `ANY` still works if another value matches. Fix: `WHERE col IS NOT NULL` in the subquery.

**8. Can you write `x > ANY (100, 200)`?**
No. In MySQL, `ANY` and `ALL` need a subquery. For a typed list use `IN`, or `> LEAST(…)` / `> GREATEST(…)`.

**9. Why use `ALL` instead of `MAX` / `MIN`?**
`>= ALL` can compare against **totals** in `HAVING`, where `MAX(SUM(x))` isn't allowed:

```sql
SELECT cost_center, SUM(amount)
FROM ox_expenses
GROUP BY cost_center
HAVING SUM(amount) >= ALL (SELECT SUM(amount) FROM ox_expenses GROUP BY cost_center);
```

`MAX`/`MIN` subqueries are often clearer and ignore NULLs, so they avoid the NULL trap.

**10. Give audit examples.**
- `> ALL` approval limits: expenses above every limit (board approval needed).
- Correlated `> ALL`: expenses above the approver's own limit; new highs vs earlier periods.
- `= ANY`: spend with unapproved or related-party vendors.
- Correlated `= ANY`: same vendor, same amount (duplicates).
- `>= ALL`: highest-spend cost centre.

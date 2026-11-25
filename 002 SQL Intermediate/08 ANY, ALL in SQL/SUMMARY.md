# 📝 Summary: ANY and ALL Operators

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 Syntax

```sql
WHERE amount > ANY (SELECT approval_limit FROM ox_approvers)   -- at least one
WHERE amount > ALL (SELECT approval_limit FROM ox_approvers
                    WHERE approval_limit IS NOT NULL)         -- every one
```

| Expression | Means | Same as |
| --- | --- | --- |
| `= ANY` | equals one of them | `IN` |
| `> ANY` | above the smallest | `> MIN` |
| `< ANY` | below the largest | `< MAX` |
| `<> ANY` | differs from at least one | ⚠️ not `NOT IN` |
| `> ALL` | above the largest | `> MAX` |
| `< ALL` | below the smallest | `< MIN` |
| `>= ALL` | the top value (ties kept) | top row |
| `<> ALL` | matches none | `NOT IN` |

## ⚠️ Edge cases

| Case | `ANY` | `ALL` |
| --- | --- | --- |
| Empty subquery | FALSE: no rows | **TRUE: every row** |
| NULL in the list | Works if another value matches | **No rows**: add `IS NOT NULL` |
| Typed list `(1, 2)` | Syntax error: needs a subquery | Syntax error |

## 🔎 Audit findings in the sample data

| Test | Operator | Finding |
| --- | --- | --- |
| Above every approval limit | `> ALL` | 275,000.00 IT expense: board approval needed |
| Above the approver's own limit | Correlated `> ALL` | 4 expenses: 364,398.00 |
| Unapproved / related-party vendors | `= ANY`, `<> ALL` | 4 expenses: 61,398.00 (V07 related party: 29,898.00) |
| New highs in Q4 | Correlated `> ALL` | Utilities 8,900.00 (≈ 3× normal), rent up to 48,000.00 |
| Same vendor, same amount | Correlated `= ANY` | 7 recurring rent / cleaning charges |
| Highest-spend cost centre | `>= ALL` | CC200: 392,500.00 of 663,448.00 |

## 🎯 Key takeaways

1. `ANY` (= `SOME`) → TRUE for **at least one** value; `ALL` → TRUE for **every** value.
2. `= ANY` is `IN`; `<> ALL` is `NOT IN`; `<> ANY` is **not** `NOT IN`.
3. `> ANY` = above the minimum; `> ALL` = above the maximum.
4. Watch the edge cases: **empty list** makes `ALL` TRUE; **NULL** makes `ALL` return nothing.
5. `>= ALL` finds the top group on totals; correlated `ALL` / `ANY` compare each row with its own group.
6. Both need a **subquery**; use `MIN` / `MAX` when it reads more clearly.

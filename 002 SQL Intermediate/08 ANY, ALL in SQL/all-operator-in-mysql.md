# 🔸 ALL Operator in MySQL

`ALL` compares a value with **every value in a subquery's list** and is TRUE only if the comparison holds for **all** of them.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ox_approvers`, `ox_vendors`, `ox_expenses` ([setup](README.md#setup))

## Syntax

```sql
SELECT …
FROM table
WHERE column operator ALL (SELECT one_column FROM … );   -- operator: =  <>  >  >=  <  <=
```

| Expression | TRUE when | Same as |
| --- | --- | --- |
| `x > ALL (list)` | x is above every value | `x > MAX(list)` |
| `x < ALL (list)` | x is below every value | `x < MIN(list)` |
| `x >= ALL (list)` | x is the largest (or tied) | "the top one" |
| `x <> ALL (list)` | x matches none of them | `x NOT IN (list)` |
| list is **empty** | ⚠️ always TRUE | |
| list contains **NULL** | ⚠️ never TRUE (unless another value fails first) | |

## Examples

**1 · ⚠️ `> ALL` with a NULL: expenses above every approver's limit**

```sql
SELECT COUNT(*)                                                     -- 0 ❌
FROM ox_expenses
WHERE amount > ALL (SELECT approval_limit FROM ox_approvers);
```

Approver A06 has no limit yet (NULL). `275000 > NULL` is unknown, so no row can be TRUE for **all**. Exclude the NULLs:

```sql
SELECT doc_no, posting_date, vendor_id, expense_type, amount, approved_by
FROM ox_expenses
WHERE amount > ALL (SELECT approval_limit
                    FROM ox_approvers
                    WHERE approval_limit IS NOT NULL);
```

| doc_no | posting_date | vendor_id | expense_type | amount | approved_by |
| --- | --- | --- | --- | --- | --- |
| 1500000023 | 2026-11-27 | V04 | IT | **275000.00** | A01 |

Above even the CFO's 250,000 limit: needs board approval. Look for the minutes.

**2 · `>= ALL`: the cost centre with the highest spend**

```sql
SELECT cost_center, SUM(amount) AS total
FROM ox_expenses
GROUP BY cost_center
HAVING SUM(amount) >= ALL (SELECT SUM(amount)
                           FROM ox_expenses
                           GROUP BY cost_center);
```

→ CC200, 392,500.00 (CC100: 222,498.00 · CC300: 48,450.00). `>=` keeps ties; `MAX(SUM())` isn't allowed.

**3 · `<> ALL`: spend with vendors not on the approved list** (= `NOT IN`)

```sql
SELECT doc_no, vendor_id, amount
FROM ox_expenses
WHERE vendor_id <> ALL (SELECT vendor_id FROM ox_vendors WHERE approved = 'Y');
```

→ 4 documents: V06 22,000.00 and 9,500.00 · V07 19,998.00 and 9,900.00.

**4 · Correlated `> ALL`: Q4 expenses higher than every earlier expense of the same type**

```sql
SELECT e.doc_no, e.posting_date, e.expense_type, e.amount
FROM ox_expenses e
WHERE e.posting_date >= '2026-10-01'
  AND e.amount > ALL (SELECT x.amount
                      FROM ox_expenses x
                      WHERE x.expense_type = e.expense_type
                        AND x.posting_date < e.posting_date)
ORDER BY e.doc_no;
```

| doc_no | posting_date | expense_type | amount |
| --- | --- | --- | --- |
| 1500000019 | 2026-10-05 | Rent | 48000.00 |
| 1500000021 | 2026-10-19 | Travel | 4200.00 |
| 1500000023 | 2026-11-27 | IT | 275000.00 |
| 1500000024 | 2026-12-10 | Utilities | **8900.00** |
| 1500000025 | 2026-12-14 | Travel | 7400.00 |

New year highs to explain: rent increase, utilities nearly 3× the usual ~3,200.

**5 · Correlated `> ALL`: expenses above the approver's own limit**

```sql
SELECT e.doc_no, e.amount, e.approved_by
FROM ox_expenses e
WHERE e.amount > ALL (SELECT a.approval_limit
                      FROM ox_approvers a
                      WHERE a.emp_id = e.approved_by);
```

| doc_no | amount | approved_by |
| --- | --- | --- |
| 1500000014 | 19998.00 | A04 (limit 10,000) |
| 1500000017 | 62000.00 | A03 (limit 25,000) |
| 1500000023 | 275000.00 | A01 (limit 250,000) |
| 1500000025 | 7400.00 | A05 (limit 5,000) |

**6 · ⚠️ Empty list: `ALL` is always TRUE**

```sql
SELECT COUNT(*)                                                     -- 27: every row
FROM ox_expenses
WHERE amount > ALL (SELECT amount FROM ox_expenses WHERE expense_type = 'Insurance');
```

No insurance expenses, so there is nothing to fail against. Check that the list isn't empty before relying on `ALL`.

## More real-world examples

```sql
-- Trial balance: account with the largest closing balance
SELECT hkont, txt50, closing
FROM trial_balance
WHERE closing >= ALL (SELECT closing FROM trial_balance);

-- Opex: postings above every non-CFO approval limit (needed CFO sign-off)
SELECT doc_no, posting_date, amount, approved_by
FROM opex_postings
WHERE amount > ALL (SELECT approval_limit FROM employees WHERE emp_id <> 'E01');

-- Revenue: invoices bigger than all earlier invoices of the same customer
-- (each customer's first invoice also appears: its list of earlier invoices is empty)
SELECT d.billing_doc, d.customer_id, d.billing_date, d.net_value
FROM rv_billing_docs d
WHERE d.billing_type = 'F2'
  AND d.net_value > ALL (SELECT x.net_value
                         FROM rv_billing_docs x
                         WHERE x.customer_id = d.customer_id
                           AND x.billing_type = 'F2'
                           AND x.billing_date < d.billing_date);
```

## 🎯 Key takeaways

1. `ALL` is TRUE only if the comparison holds for **every** value in the subquery.
2. `> ALL` is "above the maximum"; `< ALL` is "below the minimum"; `<> ALL` is `NOT IN`.
3. `>= ALL` finds the top row, even on totals, where `MAX(SUM())` isn't allowed.
4. **NULL** in the list → no rows; filter with `IS NOT NULL`.
5. **Empty** list → every row; make sure the subquery returns something.

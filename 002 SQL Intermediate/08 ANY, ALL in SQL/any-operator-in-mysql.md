# 🔹 ANY Operator in MySQL

`ANY` compares a value with **every value in a subquery's list** and is TRUE if the comparison holds for **at least one** of them. `SOME` is an exact synonym.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ox_approvers`, `ox_vendors`, `ox_expenses` ([setup](README.md#setup))

## Syntax

```sql
SELECT …
FROM table
WHERE column operator ANY (SELECT one_column FROM … );   -- operator: =  <>  >  >=  <  <=
```

| Expression | TRUE when | Same as |
| --- | --- | --- |
| `x = ANY (list)` | x equals at least one value | `x IN (list)` |
| `x > ANY (list)` | x is above at least one value | `x > MIN(list)` |
| `x < ANY (list)` | x is below at least one value | `x < MAX(list)` |
| `x <> ANY (list)` | x differs from at least one value | ⚠️ **not** `NOT IN` |
| list is **empty** | always FALSE | |

`ANY` needs a **subquery**: `x > ANY (5000, 10000)` is a syntax error.

## Examples

**1 · `> ANY`: expenses above at least one approver's limit** (i.e. above the lowest limit, 5,000)

```sql
SELECT COUNT(*)                                                     -- 14
FROM ox_expenses
WHERE amount > ANY (SELECT approval_limit FROM ox_approvers);

SELECT COUNT(*)                                                     -- 14, same result
FROM ox_expenses
WHERE amount > (SELECT MIN(approval_limit) FROM ox_approvers);
```

These 14 need more than the most junior approver. Approver A06's limit is NULL, but `> ANY` still works: one TRUE comparison is enough.

**2 · `= ANY`: spend with unapproved or related-party vendors**

```sql
SELECT doc_no, posting_date, vendor_id, expense_type, amount, approved_by
FROM ox_expenses
WHERE vendor_id = ANY (SELECT vendor_id
                       FROM ox_vendors
                       WHERE approved = 'N' OR related_party = 'Y')
ORDER BY doc_no;
```

| doc_no | posting_date | vendor_id | expense_type | amount | approved_by |
| --- | --- | --- | --- | --- | --- |
| 1500000008 | 2026-05-15 | V06 | Marketing | 22000.00 | A03 |
| 1500000014 | 2026-07-28 | V07 | Consulting | **19998.00** | A04 |
| 1500000022 | 2026-11-16 | V06 | Marketing | 9500.00 | A04 |
| 1500000026 | 2026-12-18 | V07 | Consulting | 9900.00 | A04 |

V07 is a related party and not approved. 9,900.00 sits just under A04's 10,000 limit; 19,998.00 is well above it.

**3 · `> ANY` on another group: Sales expenses larger than at least one IT expense** (smallest IT: 12,000)

```sql
SELECT doc_no, cost_center, expense_type, amount
FROM ox_expenses
WHERE cost_center = 'CC300'
  AND amount > ANY (SELECT amount FROM ox_expenses WHERE expense_type = 'IT');
```

→ 1500000008, Marketing, 22,000.00.

**4 · Correlated `= ANY`: same vendor, same amount as another document** (duplicates or recurring charges)

```sql
SELECT e.doc_no, e.vendor_id, e.amount
FROM ox_expenses e
WHERE e.amount = ANY (SELECT x.amount
                      FROM ox_expenses x
                      WHERE x.vendor_id = e.vendor_id
                        AND x.doc_no <> e.doc_no)
ORDER BY e.vendor_id, e.doc_no;
```

| doc_no | vendor_id | amount |
| --- | --- | --- |
| 1500000001 | V01 | 45000.00 |
| 1500000006 | V01 | 45000.00 |
| 1500000013 | V01 | 45000.00 |
| 1500000005 | V03 | 2400.00 |
| 1500000012 | V03 | 2400.00 |
| 1500000018 | V03 | 2400.00 |
| 1500000027 | V03 | 2400.00 |

Quarterly rent and cleaning: recurring, so explained. Each one is still checked to its contract.

**5 · ⚠️ `<> ANY` is not `NOT IN`**

```sql
SELECT COUNT(*) FROM ox_expenses
WHERE vendor_id <> ANY (SELECT vendor_id FROM ox_vendors WHERE approved = 'N');   -- 27 ❌ every row

SELECT COUNT(*) FROM ox_expenses
WHERE vendor_id <> ALL (SELECT vendor_id FROM ox_vendors WHERE approved = 'N');   -- 23 ✅ = NOT IN
```

With two unapproved vendors (V06, V07), every vendor differs from at least one of them.

**6 · Empty list: `ANY` is always FALSE**

```sql
SELECT COUNT(*)                                                     -- 0
FROM ox_expenses
WHERE amount > ANY (SELECT amount FROM ox_expenses WHERE expense_type = 'Insurance');
```

## More real-world examples

```sql
-- AP: invoices with the same amount as another invoice from the same vendor
SELECT a.lifnr, a.name1, a.belnr, a.bldat, a.dmbtr
FROM ap_invoices a
WHERE a.dmbtr = ANY (SELECT b.dmbtr
                     FROM ap_invoices b
                     WHERE b.lifnr = a.lifnr
                       AND b.belnr <> a.belnr)
ORDER BY a.lifnr, a.belnr;          -- includes J. Doe Consulting 9,999.00 twice in 4 days

-- Revenue: billing to blocked or intercompany customers
SELECT billing_doc, customer_id, net_value
FROM rv_billing_docs
WHERE customer_id = ANY (SELECT customer_id
                         FROM rv_customers
                         WHERE blocked = 'Y' OR customer_group = 'Intercompany');

-- Opex: postings above at least one employee's approval limit
SELECT doc_no, posting_date, amount, approved_by
FROM opex_postings
WHERE amount > ANY (SELECT approval_limit FROM employees);
```

## 🎯 Key takeaways

1. `ANY` (= `SOME`) is TRUE if the comparison holds for **at least one** value in the subquery.
2. `= ANY` is `IN`; `> ANY` is "above the minimum"; `< ANY` is "below the maximum".
3. `<> ANY` is **not** `NOT IN`: use `<> ALL` or `NOT IN`.
4. An **empty** list makes `ANY` FALSE; a NULL in the list doesn't matter if another value matches.
5. `ANY` only works with a subquery, never with a typed list.

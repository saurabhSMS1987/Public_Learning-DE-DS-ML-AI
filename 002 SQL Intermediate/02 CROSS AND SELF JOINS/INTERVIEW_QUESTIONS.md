# 🎤 Top 10 Interview Questions: CROSS JOIN & SELF JOIN

**1. What is a CROSS JOIN?**
It returns the Cartesian product: every row of the first table paired with every row of the second, with no join condition. 4 cost centers × 12 periods = 48 rows.

**2. When is a CROSS JOIN useful in practice?**
To build a complete grid before adding data: cost centers × months, products × regions, categories × periods. A `LEFT JOIN` to the transactions then shows **missing** combinations (no rent posted in December) and **zero** cells in reports. It also attaches a one-row total to every row for percentage-of-total calculations.

**3. What is the risk of a CROSS JOIN, and how can one happen by accident?**
Row counts multiply: two 100,000-row tables give 10 billion rows. Accidental cross joins come from the old comma syntax with no `WHERE` (`FROM a, b`), or a `JOIN` with a missing or wrong `ON` condition. The symptom is inflated row counts and totals.

**4. What is a SELF JOIN?**
A table joined to itself using two aliases, so rows can be compared with other rows of the same table. There is no `SELF JOIN` keyword; it is a normal `JOIN` or `LEFT JOIN`.

**5. Write a query that shows each employee with their manager's name.**

```sql
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON m.emp_id = e.manager_id;
```

`LEFT JOIN` keeps the top-level employee, whose `manager_id` is `NULL`.

**6. Why must the two copies have different aliases?**
MySQL needs to know which copy each column comes from. The same alias twice raises `Error 1066: Not unique table/alias`.

**7. How do you find duplicate records with a self join, and avoid listing each pair twice?**
Join on the columns that define a duplicate, and compare keys with `>`:

```sql
SELECT a.doc_no, b.doc_no
FROM opex_postings a
JOIN opex_postings b
  ON b.vendor = a.vendor AND b.amount = a.amount
 AND b.doc_no > a.doc_no
 AND ABS(DATEDIFF(b.posting_date, a.posting_date)) <= 7;
```

`>` returns each pair once and never matches a row with itself; `<>` would return both A-B and B-A.

**8. How do you compare a value with the previous period using a self join?**
Join the table to itself on the same entity and `period = period - 1`:

```sql
SELECT cur.period, prev.amount, cur.amount
FROM opex_postings cur
JOIN opex_postings prev
  ON prev.cost_center = cur.cost_center AND prev.gl_account = cur.gl_account
 AND prev.period = cur.period - 1;
```

(Window functions such as `LAG()` are an alternative in MySQL 8.)

**9. What is the difference between a SELF JOIN and a CROSS JOIN?**
A self join is defined by **which table** is joined (the same one twice) and uses a matching condition. A cross join is defined by **how rows are combined** (every combination, no condition). A table can also be cross joined with itself, for example to list every pair of employees.

**10. How would you use these joins to audit operating expenses?**
- **CROSS JOIN** cost centers × periods (× accounts), then `LEFT JOIN` postings to find missing monthly costs, i.e. **unrecorded liabilities** such as December rent.
- **SELF JOIN** on employees to test **approval controls**: self-approval, approver not the requester's manager, and approvals above the limit, with the approver's own manager as the correct approver.
- **SELF JOIN** on postings to find **duplicate payments** and unusual **month-over-month** changes, such as the 20% rent increase.

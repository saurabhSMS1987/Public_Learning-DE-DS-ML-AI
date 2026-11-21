# 📝 Summary: Joining Multiple Tables & Analytics with SQL

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 Joining multiple tables

```sql
SELECT i.invoice_no, c.name, p.description, it.net_amount
FROM ar_invoices i
JOIN ar_customers     c  ON c.customer_id = i.customer_id     -- header → customer
JOIN ar_invoice_items it ON it.invoice_no = i.invoice_no      -- header → lines
JOIN ar_products      p  ON p.product_id  = it.product_id;    -- lines → product
```

| Rule | Why |
| --- | --- |
| Each `JOIN … ON` links to a table already joined | Builds the chain step by step |
| Different aliases when a table appears twice | Invoiced vs paying customer; avoids `Error 1066` |
| **Aggregate one-to-many tables before joining them together** | Lines × payments multiplies totals (fan-out) |
| Once a chain is `LEFT`, keep it `LEFT` | A later `INNER JOIN` removes the kept rows |
| Reconcile totals after joining | Catches duplicates and drops |

## 📈 Analytics: metrics and formulas

| Metric | Formula in SQL | Sample result |
| --- | --- | --- |
| YoY growth % | `(rev_cy / NULLIF(rev_py, 0) - 1) * 100` | +247% |
| Share of total | `x / total * 100` with `CROSS JOIN` to a one-row total | Steel beam 53.7% |
| Top-N concentration | `ORDER BY revenue DESC LIMIT 3` + share | Top 3 = 68.8% |
| AR aging | `CASE` on `DATEDIFF(@ye, due_date)` | 90+ days: 3,550.00 |
| DSO | `AR / revenue * 365` | 156 days |
| Credit utilisation | `AR / credit_limit * 100` + `HAVING` | Delta 171.8% |
| Days to pay | `AVG(DATEDIFF(payment_date, invoice_date))` | 29–49 days |
| Subsequent receipts | `LEFT JOIN` payments `AND payment_date > @ye` | 27.6% collected |

## 🔎 Audit findings

| Area | Finding |
| --- | --- |
| Revenue occurrence | New customer Delta: sold above list, 172% of credit limit, no January receipts |
| Cash application | 25,000.00 paid by a different customer than invoiced |
| AR presentation | -2,500.00 credit balance from an overpayment |
| AR valuation | 3,550.00 overdue 264 days; DSO 156 days vs 30–60-day terms |
| AR existence | Only 27.6% of year-end AR confirmed by subsequent receipts |
| Analytical review | Revenue +247% YoY and top 3 customers = 68.8%: explain |

## 🎯 Key takeaways

1. Chain joins **one table at a time**, with clear aliases and full keys.
2. **Fan-out** is the biggest multi-join risk: aggregate lines and payments separately, then join.
3. Analytics = **join → filter → group → calculate → compare**.
4. Build reusable bases (e.g. year-end open items) with `CREATE TABLE … AS SELECT` and a fixed `@ye` date.
5. Protect ratios with `NULLIF`, keep totals and details on the same filter, and always compare metrics with an expectation.

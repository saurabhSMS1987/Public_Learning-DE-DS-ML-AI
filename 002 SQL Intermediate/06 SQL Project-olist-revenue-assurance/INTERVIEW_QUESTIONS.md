# 🎤 Interview Questions: E-Commerce Revenue Assurance with SQL

Questions an interviewer might ask about this project, with answers drawn from it.

## 1 · The project

**Q1. Walk me through the project.**
I took the Olist Brazilian e-commerce dataset from Kaggle: seven related CSV files, about 450,000 rows. I loaded them into all-text staging tables, profiled data quality, then cleaned and converted them into typed MySQL tables with primary and foreign keys. Every row and the price and payment totals reconciled to the source. I then explored and analysed revenue and ran eight revenue assurance tests for FY2017. The main finding: 349,787.86 BRL of FY2017 revenue relates to orders delivered in 2018, and 269,735.11 BRL was paid on orders later canceled.

**Q2. Why this dataset?**
It is real, anonymised transaction data with several related tables: customers, orders, items, payments, products and sellers. Revenue assurance questions need joins across those tables, and the data contains genuine quality issues, which makes the cleaning steps meaningful.

**Q3. What does the ERD look like?**
`customers` 1-to-many `orders`; `orders` 1-to-many `order_items` and 1-to-many `order_payments`; `products` and `sellers` 1-to-many `order_items`; `category_translation` gives products their English category. Order items have a two-column primary key (`order_id`, `order_item_id`), and so do payments (`order_id`, `payment_sequential`).

## 2 · Loading and data quality

**Q4. Why load into staging tables first?**
All-text columns can't fail type conversion, so no row is silently skipped. I can query the raw values, find every problem, then convert only what's clean with `INSERT … SELECT`. The raw data stays untouched as evidence.

**Q5. Which data-quality problems did you find, and how did you fix them?**
- 23,995 zip codes lost their leading zero → `LPAD(zip, 5, '0')`.
- The translation file has Windows line endings and a byte-order mark → `REPLACE(col, CHAR(13), '')`, found with `HEX()`.
- Blank timestamps and categories → `NULLIF(col, '')` before `STR_TO_DATE` / `CAST`.
- 8 "delivered" orders with no delivery date, 610 products without a category, 2 categories without a translation, 775 orders without items.

**Q6. How did you prove the load was complete and accurate?**
Completeness: staged rows = loaded rows for all seven tables. Accuracy: `SUM(price)` = 13,591,643.70 BRL and `SUM(payment_value)` = 16,008,872.12 BRL in both staging and the final tables.

**Q7. Why `CHAR(32)` for IDs, `CHAR(5)` for zip codes and `DECIMAL` for money?**
IDs are fixed-length hashes. Zip codes are codes, not numbers, and must keep leading zeros. `DECIMAL` is exact, while `FLOAT` would create rounding differences in totals.

## 3 · SQL techniques

**Q8. What is the fan-out problem, and where did you see it?**
Joining `orders` to both `order_items` and `order_payments` pairs every item with every payment of the same order. "Paid" came out as 20,308,134.71 BRL instead of 15,846,280.17. The fix is to aggregate each table to one row per order in a derived table, then join.

**Q9. When did you use LEFT, RIGHT, FULL, CROSS and SELF joins?**
- **LEFT + `IS NULL`:** orders without items, untranslated categories.
- **RIGHT:** the order without any payment.
- **FULL (LEFT `UNION` RIGHT):** categories used vs translated.
- **CROSS:** state × month grid to find months without sales.
- **SELF:** `customers` to `customers` on `customer_unique_id`, to find the same person ordering again within 30 days (1,520 pairs).

**Q10. Give an example of joining on more than one column.**
Comparing each item with the seller's own average price for that product: the derived table is grouped by `seller_id, product_id`, joined `ON sp.seller_id = i.seller_id AND sp.product_id = i.product_id`. 8 items were sold at more than twice the average.

**Q11. What is the difference between `WHERE` and `HAVING` in your state revenue query?**
`WHERE` keeps delivered FY2017 rows before grouping; `HAVING SUM(i.price) > 100000` keeps only states whose total passes the threshold after grouping.

**Q12. How did you calculate % of total and Top N?**
`CROSS JOIN` a one-row derived table holding the total, then `SUM(x) / total * 100`. Top N is `ORDER BY revenue DESC LIMIT 10`, and Bottom N uses `ASC`, with `HAVING COUNT(*) >= 10` so tiny categories don't dominate.

**Q13. What does `GROUP_CONCAT` add?**
It lists text from several rows on one row: all categories in an order, or every payment of an order (`voucher 3.71 + voucher 8.51 + …`). Useful for reviewing exceptions without one row per detail.

**Q14. How did you keep results reproducible?**
Fixed dates in variables (`@fy_start`, `@fy_end`, `@as_at`) instead of `CURDATE()`. Assumptions (exchange rate, commission) are also variables. `run_all.sql` rebuilds everything from scratch.

## 4 · Audit logic

**Q15. Explain the cut-off finding.**
Revenue recognised on purchase date gives 5,962,902.01 BRL for FY2017; on delivery date, 5,612,817.85. 2,496 orders bought in FY2017 were delivered in 2018 (349,787.86 BRL). If revenue should be recognised on delivery, that amount belongs to FY2018: the proposed adjustment.

**Q16. Why do canceled orders with payments matter?**
1,234 canceled or unavailable orders carry 269,735.11 BRL of payments. Either refunds were made, and should be traced to bank records, or cash is owed back to customers and should be a liability. Neither belongs in revenue.

**Q17. Why might payments differ from items + freight, and what would you do next?**
Installment interest, vouchers, partial refunds or data errors. 310 orders differ by more than 1 BRL, a net of -2,004.17 BRL. That is immaterial overall, so I would sample the largest differences (up to -336.93 BRL) and check them against the payment provider's reports.

**Q18. What are the limitations of the analysis?**
There is no cost data, so profit is a commission estimate at an assumed 10%. The exchange rate is illustrative. The data is a public sample, not a complete ledger, and the fiscal-year and recognition rules are assumptions to state in the work papers.

**Q19. How would you scale this to a real client?**
The same pattern scales: bulk `LOAD DATA`, staging, indexes on filter and join columns, aggregation before joins, and scripted, reproducible steps. For larger volumes, I would add partitioning by date and automate the reconciliation checks.

**Q20. What would you add next?**
Window functions (`RANK`, `LAG`) for rankings and month-on-month change, CTEs for readability, the reviews table for service quality, and a dashboard on top of the findings table.

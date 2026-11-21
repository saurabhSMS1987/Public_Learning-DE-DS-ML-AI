# ✅ Expected Results

Use this page to check your run. All numbers come from a clean run of `run_all.sql` on MySQL 8 with the included CSV files. Each script also ends with a `Step N complete` line.

> `YEAR(CURDATE())` in step 6.7 depends on the day you run it; every other number is fixed.

## Steps 0–2 · Database, tables, staging

| Check | Expected |
| --- | --- |
| Tables after step 1 | 7 `stg_` tables + `customers`, `sellers`, `products`, `category_translation`, `orders`, `order_items`, `order_payments` |
| Staged rows | customers 99,441 · sellers 3,095 · products 32,951 · categories 71 · orders 99,441 · items 112,650 · payments 103,886 |
| `SHOW WARNINGS` | empty |

## Step 3 · Data quality

| Check | Expected |
| --- | --- |
| Order statuses | 8 (approved, canceled, created, delivered, invoiced, processing, shipped, unavailable) |
| Delivered orders: no approval / no delivery date | 14 / 8 |
| Zip codes with 4 digits | 23,995 (75,446 have 5) |
| Translation rows ending in `\r` | 70 (hex `0D`) |
| Products without category | 610 |
| Untranslated categories | `pc_gamer`, `portateis_cozinha_e_preparadores_de_alimentos` |
| Orphans in every relationship | 0 |
| Duplicate keys | none |
| Carrier before approval / delivered before purchase | 1,359 / 0 |
| Zero-value payments | voucher 6 · not_defined 3 |

## Step 4 · Transform and reconcile

| Check | Expected |
| --- | --- |
| Staged = loaded, all 7 tables | equal |
| Price total staged = loaded | 13,591,643.70 |
| Payment total staged = loaded | 16,008,872.12 |
| Zip codes not 5 characters / `\r` left | 0 / 0 |

## Step 5 · Exploration

| Query | Expected |
| --- | --- |
| 5.3 orders · customer ids · unique customers | 99,441 · 99,441 · 96,096 |
| 5.4 payment types / customer states | 5 / 27 |
| 5.6 open pipeline orders / orders purchased in 2017 | 1,729 / 45,101 |
| 5.7 furniture (`moveis`) categories | 6 |
| 5.8 products without category / delivered without date | 610 / 8 |
| 5.9 most expensive item | 6,735.00 |
| 5.10 3rd most expensive item | 6,499.00 |
| 5.11 `EXPLAIN` | `type = range`, `key = idx_orders_purchase` |

## Step 6 · Summaries and calculated columns

| Query | Expected |
| --- | --- |
| 6.1 FY2017 delivered orders · items · revenue · freight | 43,428 · 49,556 · 5,962,902.01 · 960,789.36 |
| 6.1 cheapest · dearest · average item | 1.20 · 6,735.00 · 120.33 |
| 6.2 states above 100,000 BRL | 12; SP first with 2,136,258.96 |
| 6.3b estimated commission (10%) | 596,290.20 |
| 6.4 on time / late | 89,936 / 6,534 |
| 6.5 value bands (orders) | under 50: 29,393 · 50-199: 54,169 · 200-999: 14,158 · 1,000+: 946 |
| 6.6 revenue by year | 2016: 40,470.98 · 2017: 5,962,902.01 · 2018: 7,218,125.12 |
| 6.7 audit year · days of history at year-end | 2017 · 483 |

## Step 7 · Joins

| Query | Expected |
| --- | --- |
| 7.2 orders without items | 775 (unavailable 603, canceled 164, created 5, invoiced 2, shipped 1) |
| 7.3 products without English category | NULL 610 · pc_gamer 3 · portateis_… 10 |
| 7.4 orders without payment | 1 (`bfbd0f9bdef84302105ad712db648a6c`) |
| 7.5 used but not translated / translated but unused | 2 / 0 |
| 7.6 items over 2× the seller's average | 8 (top: +215.2%) |
| 7.7 state-months with no orders in 2017 | 6 |
| 7.8 repeat orders within 30 days | 1,520 |

## Step 8 · Multi-table and transformations

| Query | Expected |
| --- | --- |
| 8.3 wrong (joined together): billed · paid | 16,571,671.89 · 20,308,134.71 |
| 8.3 right (aggregated first): billed · paid | 15,848,243.14 · 15,846,280.17 |
| 8.6 latest delivery vs estimate | 188 days late |

## Step 9 · Analytics

| Query | Expected |
| --- | --- |
| FY2017 helper table | 49,556 items · 5,962,902.01 |
| 9.1 peak month | 2017-11: 7,289 orders · 987,765.37 |
| 9.2 top category | bed_bath_table 490,596.92 (8.2%) |
| 9.4 top 10 sellers | 1,077,314.83 (18.1%) |
| 9.5 Jan–Aug 2017 → 2018 | 2,993,456.13 → 7,218,125.12 (+141.1%) |
| 9.6 payment mix | credit card 78.3% · boleto 17.9% · voucher 2.4% · debit 1.4% |
| 9.7 worst state for late delivery | AL 21.4% |

## Step 10 · Audit tests

| Test | Expected |
| --- | --- |
| T1 compared · with difference · paid more · paid less | 96,478 · 310 · 3,036.57 · -5,040.74 |
| T2 delivered with no payment | 1 |
| T3 canceled / unavailable paid | 625 · 143,255.60 / 609 · 126,479.51 |
| T4 purchase basis · delivery basis · difference | 5,962,902.01 · 5,612,817.85 · 350,084.16 |
| T4 FY2017 orders delivered in 2018 | 2,496 · 349,787.86 |
| T5 no delivery date · not approved · shipped before approval | 8 · 14 · 1,359 |
| T6 items over 2× seller average | 8 |
| T7 zero / undefined payments | not_defined 3 · voucher 6 |
| T8 more than 30 days late | 345 |

## Step 11 · Findings

| Check | Expected |
| --- | --- |
| Findings by test | T2 1 · T3 1,234 · T4 1 · T5 8 |
| After `UPDATE` | CONFIRMED 2 · OPEN 1,242 |
| Closed before / after `ROLLBACK` | 1,244 / 0 |
| After `DELETE` (refunds under 10 BRL) | 1,241 |
| Proposed adjustment | 349,787.86 |
| Orders now / backup | 99,441 / 99,441 |

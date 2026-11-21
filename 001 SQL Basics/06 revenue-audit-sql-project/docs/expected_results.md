# ✅ Expected Results

Use this page to check your run. Numbers come from a clean run on MySQL 8.4 with the included CSV files. Each script also prints `Step N complete` at the end.

## Steps 0–2 · Database, tables, load

| Check | Expected |
| --- | --- |
| Tables after step 1 | `billing_lines`, `customers`, `materials`, `stg_billing_raw` |
| `customers` / `materials` / `stg_billing_raw` rows | 20 / 8 / 958 |
| `SHOW WARNINGS` after each load | empty |

## Step 3 · Data quality

| Check | Expected |
| --- | --- |
| `DISTINCT fkart` | `F2`, `G2`, `''` (total line) |
| `DISTINCT ernam` | `''`, `BATCH_SD`, `SALES_MGR`, `SD_CLERK1`, `SD_CLERK2` |
| Report total line | row 958, `11,492,928.49` |
| Bad date | row 957, document `0091000002` |
| Unknown customer | row 956, customer `0000199999` |
| Unknown materials, bad amounts, duplicate keys | none |
| Credit lines / with trailing minus | 25 / 25 |

## Step 4 · Transform and reconcile

| Check | Expected |
| --- | --- |
| Staged / loaded / rejected | 958 / 955 / 3 |
| Loaded total = SAP report total | 11,492,928.49 = 11,492,928.49 |
| Backup rows | 955 |

## Step 5 · Exploration

| Query | Expected |
| --- | --- |
| Q5.3 lines / documents / customers / materials | 955 / 585 / 20 / 8 |
| Q5.4 FY2026 lines, net revenue | 949, 11,719,477.99 |
| Q5.5 manual users' lines | `SALES_MGR` 8, `SD_CLERK1` 103, `SD_CLERK2` 51 |
| Q5.7 customers named hospital/retail | 4 |
| Q5.8 credit memos without reference | 0 |
| Q5.9 largest invoice line | `0090000545`, 156,000.00 |
| Q5.11 3rd largest invoice line | `0090000547`, 72,000.00 |
| Q5.12 `EXPLAIN` | `type = range`, `key = idx_bl_fkdat` |

## Step 6 · Summary analytics (FY2026)

| Query | Expected |
| --- | --- |
| Q6.1 invoices | 556 documents, 11,801,764.99 |
| Q6.1 credit memos | 23 documents, -82,287.00 |
| Q6.1 net revenue | 11,719,477.99 |
| Q6.2 invoice lines min / max | 0.00 / 156,000.00 |
| Q6.2 first / last invoice date | 2026-01-02 / 2027-01-07 |
| Q6.3 average invoice line | 12,744.89 |
| Q6.3 `P-100` simple / weighted price | 1,244.38 / 1,260.92 |
| Q6.4 highest month | 12 (December): 1,572,282.33 |
| Q6.5 top material | `P-100`: 3,470,062.50 |
| Q6.6 `SALES_MGR` | 5 documents, 430,200.00 |
| Q6.7 top region | West: 2,937,332.17 |
| Q6.8 top customer | Prairie Agro Co: 876,812.15 |

## Step 7 · HAVING exceptions

| Query | Expected |
| --- | --- |
| Q7.1 months > 1.3 × average | December only |
| Q7.2 materials sold at more than one price | 8; largest spread `P-100` 825.00 |
| Q7.3 few documents, high revenue | `0000100020`: 3 documents, 355,800.00 |
| Q7.4 manual year-end users ≥ 100,000 | `SALES_MGR`: 6 lines, 430,200.00 |
| Q7.5 average line > 2 × overall | `0000100020`: 88,950.00 |
| Q7.6 customers with 2+ credit memos | 7 |

## Step 8 · Audit tests

| Test | Expected |
| --- | --- |
| T1 cut-off reversals | `0090000580` -156,000.00 and `0090000581` -89,400.00 |
| T2 new customers | `0000100020`, first billing 2026-12-29, 3 invoices, 355,800.00 |
| T3 above list price | 2 lines: +56.0% (`P-100`), +55.2% (`P-800`) |
| T4 invoice > credit limit | 3 invoices: 156,000.00 / 89,400.00 / 110,400.00 vs 50,000.00 |
| T5 duplicates | 3 pairs |
| T6 weekend | `0090000549` (Saturday), `0090000550` (Sunday) |
| T7 zero-value lines | 3 |
| T8 round amounts | 5 |
| T9 year-end manual | 7 lines |

## Step 9 · Findings

| Check | Expected |
| --- | --- |
| Findings by test after inserts | T1 2, T2 1, T6 2, T7 3 |
| After `UPDATE` | CONFIRMED 3, OPEN 5 |
| Rows "closed" before / after `ROLLBACK` | 8 / 0 |
| Findings after `DELETE` | 5 |
| Proposed adjustment | 245,400.00 |
| Final finding IDs | 1, 2, 4, 5, 10 (gaps are normal for `AUTO_INCREMENT`) |

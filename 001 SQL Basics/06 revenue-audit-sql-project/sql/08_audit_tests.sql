-- =====================================================================
-- STEP 8 · Revenue audit tests
-- Each test answers one audit question and returns the items to follow up.
-- Topics: everything so far, combined.
-- =====================================================================
USE revenue_audit;

-- T1 · CUT-OFF: credit memos after year-end that reverse 2026 invoices
--      (revenue recognised in 2026, then cancelled in 2027)
SELECT vbeln, fkdat, kunag, netwr, vgbel AS reversed_invoice
FROM billing_lines
WHERE fkart = 'G2'
  AND fkdat >= '2027-01-01'
  AND vgbel IN (SELECT vbeln FROM billing_lines WHERE fkdat <= '2026-12-31');
-- Expected: 2 credit memos, -245,400.00, both Delta Distributors

-- T2 · NEW CUSTOMERS billed at year-end (created in December)
SELECT kunag, MIN(fkdat) AS first_billing, COUNT(DISTINCT vbeln) AS invoices, SUM(netwr) AS invoiced_2026
FROM billing_lines
WHERE fkart = 'F2'
  AND fkdat BETWEEN '2026-01-01' AND '2026-12-31'
  AND kunag IN (SELECT kunnr FROM customers WHERE erdat >= '2026-12-01')
GROUP BY kunag;
-- Expected: 0000100020, 3 invoices, 355,800.00

-- T3 · PRICE ABOVE LIST PRICE (JOIN to the material master)
SELECT b.vbeln, b.fkdat, b.kunag, b.matnr, b.netpr, m.list_price,
       ROUND((b.netpr / m.list_price - 1) * 100, 1) AS pct_above_list
FROM billing_lines b
JOIN materials m ON m.matnr = b.matnr
WHERE b.fkart = 'F2'
  AND b.netpr > m.list_price;
-- Expected: 2 lines, 55-56% above list

-- T4 · SINGLE INVOICE ABOVE THE CUSTOMER'S CREDIT LIMIT
SELECT b.vbeln, b.kunag, SUM(b.netwr) AS invoice_value, c.klimk AS credit_limit
FROM billing_lines b
JOIN customers c ON c.kunnr = b.kunag
WHERE b.fkart = 'F2'
GROUP BY b.vbeln, b.kunag, c.klimk
HAVING SUM(b.netwr) > c.klimk;
-- Expected: 3 invoices, all Delta Distributors

-- T5 · POSSIBLE DUPLICATE BILLING (same customer, material, qty, price, date)
SELECT kunag, matnr, fkimg, netpr, fkdat,
       COUNT(*) AS copies, MIN(vbeln) AS first_doc, MAX(vbeln) AS second_doc
FROM billing_lines
WHERE fkart = 'F2'
GROUP BY kunag, matnr, fkimg, netpr, fkdat
HAVING COUNT(*) > 1;
-- Expected: 3 pairs

-- T6 · WEEKEND BILLING
SELECT vbeln, fkdat, DAYNAME(fkdat) AS weekday, kunag, netwr, ernam
FROM billing_lines
WHERE DAYOFWEEK(fkdat) IN (1, 7);
-- Expected: 2 documents (a Saturday and a Sunday)

-- T7 · ZERO-VALUE INVOICE LINES (free goods or pricing errors)
SELECT vbeln, fkdat, kunag, matnr, fkimg, netpr, ernam
FROM billing_lines
WHERE fkart = 'F2' AND netpr = 0;
-- Expected: 3 lines

-- T8 · ROUND AMOUNTS entered manually
SELECT vbeln, fkdat, kunag, netwr, ernam
FROM billing_lines
WHERE fkart = 'F2'
  AND ernam <> 'BATCH_SD'
  AND netwr > 0                    -- zero is a multiple of 10,000 too
  AND MOD(netwr, 10000) = 0;
-- Expected: 5 lines

-- T9 · YEAR-END MANUAL BILLING (last 8 days of the year)
SELECT vbeln, fkdat, kunag, matnr, netwr, ernam
FROM billing_lines
WHERE fkdat BETWEEN '2026-12-24' AND '2026-12-31'
  AND ernam <> 'BATCH_SD'
ORDER BY netwr DESC;

-- T10 · TEST SUMMARY: how much revenue does each finding touch?
SELECT 'T1 Cut-off reversals'        AS test, COUNT(*) AS items, SUM(netwr) AS value
FROM billing_lines WHERE fkart = 'G2' AND fkdat >= '2027-01-01'
UNION ALL
SELECT 'T3 Above list price', COUNT(*), SUM(b.netwr)
FROM billing_lines b JOIN materials m ON m.matnr = b.matnr
WHERE b.fkart = 'F2' AND b.netpr > m.list_price
UNION ALL
SELECT 'T6 Weekend billing', COUNT(*), SUM(netwr)
FROM billing_lines WHERE DAYOFWEEK(fkdat) IN (1, 7)
UNION ALL
SELECT 'T7 Zero-value lines', COUNT(*), SUM(netwr)
FROM billing_lines WHERE fkart = 'F2' AND netpr = 0;

SELECT 'Step 8 complete: audit tests' AS status;

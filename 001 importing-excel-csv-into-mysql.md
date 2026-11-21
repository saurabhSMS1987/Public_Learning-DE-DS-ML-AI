# 📥 Importing Excel / CSV into MySQL

Load an Excel, text or CSV file into MySQL with the **MySQL Workbench Table Data Import Wizard**, and confirm that every row made it in. The worked example is an **SAP ERP Trial Balance**.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 🧾 The example: SAP Trial Balance

A **trial balance (TB)** lists every general ledger (G/L) account with its opening balance, debits, credits and closing balance for a period. In SAP it is exported to Excel from a G/L balances report, such as `S_ALR_87012277`.

**Sample file:** [`data/sap_trial_balance_fy2026.csv`](data/sap_trial_balance_fy2026.csv): company code 1000, fiscal year 2026, period 12, **19 G/L accounts**.

| Column | SAP meaning | Example |
| --- | --- | --- |
| `BUKRS` | Company code | `1000` |
| `GJAHR` | Fiscal year | `2026` |
| `PERIOD` | Posting period | `012` |
| `KEY_DATE` | Reporting date | `2026-12-31` |
| `HKONT` | G/L account number | `0000400000` |
| `TXT50` | Account description | `Revenue - Domestic sales` |
| `BAL_CF` | Balance carried forward (opening) | `850000.00` |
| `DEBIT` / `CREDIT` | Period activity | `4210300.40` |
| `CLOSING` | Closing balance (credits negative) | `-1650000.00` |
| `WAERS` | Currency | `USD` |

Preview:

```text
BUKRS,GJAHR,PERIOD,KEY_DATE,HKONT,TXT50,BAL_CF,DEBIT,CREDIT,CLOSING,WAERS
1000,2026,012,2026-12-31,0000100000,Cash at bank - Operating,850000.00,4210300.40,4033028.42,1027271.98,USD
1000,2026,012,2026-12-31,0000180000,"Property, plant & equipment",1800000.00,225000.00,0.00,2025000.00,USD
1000,2026,012,2026-12-31,0000400000,Revenue - Domestic sales,0.00,0.00,3250000.00,-3250000.00,USD
```

## 🗺️ The process

```mermaid
flowchart LR
    A["1 · Prepare<br/>the TB file"] --> B["2 · Open<br/>the wizard"] --> C["3 · Choose<br/>destination"] --> D["4 · Configure<br/>settings"] --> E["5 · Import"] --> F["6 · Check<br/>for failed rows"]
```

## Step 1 · Prepare the TB file

The wizard reads **CSV** (and JSON) files only, so convert other formats first.

| Source | What to do |
| --- | --- |
| Excel (`.xlsx`) from SAP | **File → Save As → CSV UTF-8 (comma delimited)** |
| Text (`.txt`, tab or pipe delimited) | Rename to `.csv`; set the field separator in Step 4 |
| CSV | Use as is |

SAP exports need cleaning in Excel before saving. **Rows that fail conversion are skipped**, so these checks matter:

| SAP export issue | Fix before saving |
| --- | --- |
| Report title, run date and user lines above the data | Delete them; keep **one header row** |
| Subtotal and "Total" rows per account group | Delete them; they would load as accounts |
| Dates as `31.12.2026` | Convert to `2026-12-31` (format cells as `yyyy-mm-dd`) |
| Amounts as `1,800,000.00` or `1,800,000.00-` (trailing minus) | Plain numbers with a leading minus: `-1800000.00` |
| G/L accounts like `0000400000` | Format the column as **Text** so leading zeros are kept |

✅ Note the **row count** (excluding the header). For the sample TB it is **19 accounts**. You will compare against it at the end.

## Step 2 · Open the wizard

In **Navigator → Schemas** (for example, schema `audit_fy2026`):

- **New table:** right-click the schema → **Table Data Import Wizard**
- **Existing table:** right-click the `trial_balance` table → **Table Data Import Wizard**

Browse to `sap_trial_balance_fy2026.csv` → **Next**.

## Step 3 · Choose the destination

| Option | When to use |
| --- | --- |
| **Create new table** | First load; name it `trial_balance` |
| **Use existing table** | The `trial_balance` table already exists with the right column types |
| **Truncate table before import** | Reloading a corrected TB, to avoid duplicate accounts |
| **Drop table if exists** | Rebuilding the table from scratch |

## Step 4 · Configure import settings

| Setting | What to check |
| --- | --- |
| **Encoding** | `utf-8` (keeps characters in descriptions, such as `Bankgebühren`) |
| **Field separator** | `,` for CSV; `;`, tab or `\|` for text files |
| **Columns** | Tick all 11 TB columns; map each to the right target column |
| **Field type** | The wizard guesses types from the first rows. **Fix them here.** |

Field types for the TB:

| Column | Set type to | Why |
| --- | --- | --- |
| `HKONT`, `BUKRS`, `PERIOD` | `text` | The guess is `int`, which turns `0000400000` into `400000` and `012` into `12` |
| `KEY_DATE` | `datetime` | Only works when dates are `YYYY-MM-DD` |
| `BAL_CF`, `DEBIT`, `CREDIT`, `CLOSING` | `double` | Balances and activity |
| `TXT50`, `WAERS` | `text` | Descriptions and currency |

> 💡 For TB balances, create the table in advance with `DECIMAL(15,2)` columns and use **Use existing table**. `double` can cause small rounding differences when you total the TB.

## Step 5 · Import

Click **Next** to run the import. The sample TB loads in seconds; large files (100k+ rows, such as journal entry extracts) are slow in the wizard.

## Step 6 · Check for failed rows ⚠️

The wizard does **not stop on errors**. It skips any row that fails conversion and keeps going, so a G/L account can go missing without warning.

**1. Read the results page**

The last screen should show: `19 records imported`. Compare this number with the TB row count from Step 1.

**2. Open the log**

Click **Show Logs**. Each skipped account appears as an error, for example:

```text
Row import failed with error: ("Incorrect date value: '31.12.2026' for column 'KEY_DATE' at row 1", 1292)
Row import failed with error: ("Data truncated for column 'CLOSING' at row 1", 1265)
```

**3. Confirm the count in the table**

```sql
SELECT COUNT(*) FROM trial_balance;   -- sample TB: 19
```

If the counts don't match: fix the cause in the source file, choose **Truncate table before import** (or drop the table), and import again. A TB with missing accounts no longer balances.

## 🧪 Try importing the .csv file

Practise the wizard with the sample TB:

1. Download [`data/sap_trial_balance_fy2026.csv`](data/sap_trial_balance_fy2026.csv).
2. In Workbench, right-click your schema → **Table Data Import Wizard** → select the file.
3. Choose **Create new table** → name it `trial_balance`.
4. Set `BUKRS`, `PERIOD` and `HKONT` to `text`, and `KEY_DATE` to `datetime`.
5. Run the import and confirm **19 records imported**.
6. Check that leading zeros survived:

```sql
SELECT hkont, txt50, closing FROM trial_balance LIMIT 5;   -- hkont shows 0000100000, not 100000
```

> 🔁 **Challenge:** open the CSV in a text editor, change one date to `31.12.2026`, then import again with **Truncate table before import** ticked. The result shows 18 records, and **Show Logs** names the failed row.

## ⚠️ Common issues

| Symptom | Cause | Fix |
| --- | --- | --- |
| Fewer than 19 accounts loaded | Rows failed conversion | Check **Show Logs**; fix dates/amounts in the file |
| `0000400000` became `400000` | `HKONT` guessed as `int` | Set the field type to `text` in Step 4 |
| `Incorrect date value` | SAP date `31.12.2026` | Reformat as `2026-12-31` before saving |
| `Data truncated` on balances | Thousands separators or trailing minus (`1,000.00-`) | Plain numbers with a leading minus |
| Garbled descriptions (`Ã¼`) | Wrong encoding | Save as **CSV UTF-8**; select `utf-8` |
| Accounts duplicated after reloading | Table not emptied | Tick **Truncate table before import** |
| Extra "accounts" such as `Total` | Subtotal rows left in the export | Remove them before saving |
| `.xlsx` file not accepted | Wizard reads CSV/JSON only | Save as CSV first |

## 🎯 Key takeaways

1. The wizard imports **CSV and JSON** only. Save the SAP TB export (Excel or text) as CSV first.
2. **Clean the SAP export before importing:** one header row, no subtotals, `YYYY-MM-DD` dates, plain numbers, G/L accounts as text.
3. **Always review the field types**; the wizard's guesses drop leading zeros from G/L accounts.
4. Failed rows are **skipped silently**: compare the record count with the TB row count and read **Show Logs**.
5. Use **Truncate table before import** when reloading, to avoid duplicate accounts.

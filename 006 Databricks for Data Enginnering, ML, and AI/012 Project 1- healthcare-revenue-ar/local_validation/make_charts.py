"""Create the README / guide charts from the Gold CSV exports in ../outputs."""
import sys
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd

OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("../outputs")
IMG = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("../docs/images")
IMG.mkdir(parents=True, exist_ok=True)

SURFACE, INK, INK2, MUTED, GRID, AXIS = "#fcfcfb", "#0b0b0b", "#52514e", "#898781", "#e1e0d9", "#c3c2b7"
BLUE, ORANGE = "#2a78d6", "#eb6834"

def kfmt(x, _):
    return f"-${abs(x)/1000:,.0f}k" if x < 0 else f"${x/1000:,.0f}k"


plt.rcParams.update({
    "text.parse_math": False,
    "figure.facecolor": SURFACE, "axes.facecolor": SURFACE, "axes.edgecolor": AXIS,
    "axes.labelcolor": INK2, "xtick.color": MUTED, "ytick.color": MUTED, "text.color": INK,
    "font.size": 10, "axes.titlesize": 12, "axes.titleweight": "bold", "axes.titlelocation": "left",
    "axes.spines.top": False, "axes.spines.right": False,
})


def money(v):
    return f"-${abs(v)/1000:,.1f}k" if v < 0 else f"+${v/1000:,.1f}k"


# 1. FY2025 revenue: what explains GL vs subledger -------------------------------
items = pd.read_csv(OUT / "gold_reconciling_items.csv")
items = items[items["revenue_impact"].abs() > 0.01].copy()
items["label"] = items.apply(
    lambda r: f"{r['item_type']}\n{r['batch_reference'] if isinstance(r['batch_reference'], str) else r['je_id'] + ' (' + r['created_by'] + ')'}",
    axis=1)
items = items.iloc[::-1]
fig, ax = plt.subplots(figsize=(8, 4.6))
colors = [BLUE if v > 0 else ORANGE for v in items["revenue_impact"]]
ax.barh(items["label"], items["revenue_impact"], color=colors, height=0.55, edgecolor=SURFACE, linewidth=2)
ax.axvline(0, color=AXIS, linewidth=1)
for y, v in enumerate(items["revenue_impact"]):
    ax.text(v + (6000 if v > 0 else -6000), y, money(v), va="center",
            ha="left" if v > 0 else "right", color=INK2, fontsize=9)
ax.set_xlim(-130000, 330000)
ax.xaxis.grid(True, color=GRID, linewidth=0.8)
ax.set_axisbelow(True)
ax.xaxis.set_major_formatter(kfmt)
ax.set_title("FY2025 revenue: GL vs billing subledger, by reconciling item")
fig.text(0.02, 0.02, "Net difference is only -$15.7k, but the errors add up to $515.7k gross.\n"
         "Blue = GL revenue overstated, orange = GL revenue understated.", color=INK2, fontsize=9)
fig.tight_layout(rect=(0, 0.09, 1, 1))
fig.savefig(IMG / "fy2025_revenue_reconciling_items.png", dpi=150)
plt.close(fig)

# 2. AR difference by month (GL - subledger) --------------------------------------
roll = pd.read_csv(OUT / "gold_ar_rollforward_monthly.csv")
roll = roll[roll["period"].between("2025-01", "2025-12")]
fig, ax = plt.subplots(figsize=(8, 3.8))
ax.plot(roll["period"], roll["difference"], color=BLUE, linewidth=2, marker="o", markersize=6,
        markeredgecolor=SURFACE, markeredgewidth=2)
ax.axhline(0, color=AXIS, linewidth=1)
notes = {"2025-06": "Payment batch\nposted twice", "2025-09": "Charge batch\nmissing from GL",
         "2025-12": "Manual +$250k entry,\nyear-end charges\nposted in January"}
for p, txt in notes.items():
    v = roll.loc[roll["period"] == p, "difference"].iloc[0]
    ax.annotate(txt, (p, v), textcoords="offset points", xytext=(0, -42 if p != "2025-12" else 14),
                ha="center", fontsize=8.5, color=INK2)
ax.yaxis.grid(True, color=GRID, linewidth=0.8)
ax.set_axisbelow(True)
ax.set_ylim(-175000, 40000)
ax.yaxis.set_major_formatter(kfmt)
ax.set_xticks(range(len(roll)))
ax.set_xticklabels([p[5:] for p in roll["period"]])
ax.set_xlabel("Month of 2025")
ax.set_title("Accounts receivable: GL minus billing subledger, month end")
fig.tight_layout()
fig.savefig(IMG / "fy2025_ar_difference_by_month.png", dpi=150)
plt.close(fig)

# 3. AR aging at year end ---------------------------------------------------------
aging = pd.read_csv(OUT / "gold_ar_aging_year_end.csv")
aging = aging[aging["aging_bucket"] != "Credit balance"]
by_bucket = aging.groupby(["bucket_order", "aging_bucket"])["open_balance"].sum().reset_index()
fig, ax = plt.subplots(figsize=(8, 3.6))
ax.bar(by_bucket["aging_bucket"], by_bucket["open_balance"], color=BLUE, width=0.6, edgecolor=SURFACE, linewidth=2)
total = by_bucket["open_balance"].sum()
for x, v in enumerate(by_bucket["open_balance"]):
    ax.text(x, v + 40000, f"${v/1e6:,.2f}M  ({v/total:.0%})", ha="center", color=INK2, fontsize=9)
ax.yaxis.grid(True, color=GRID, linewidth=0.8)
ax.set_axisbelow(True)
ax.yaxis.set_major_formatter(lambda x, _: f"${x/1e6:,.1f}M")
ax.set_ylim(0, by_bucket["open_balance"].max() * 1.18)
ax.set_title("Open AR at 31 Dec 2025 by days since service")
fig.tight_layout()
fig.savefig(IMG / "fy2025_ar_aging.png", dpi=150)
plt.close(fig)
print("charts written to", IMG)

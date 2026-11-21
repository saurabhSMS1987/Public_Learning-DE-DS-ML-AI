"""
Optional: download the Olist dataset again from Kaggle into ./data

The 7 CSV files used by this project are already included in data/.
Use this script only if you want a fresh copy straight from Kaggle.

Requirements:
  1. pip install kaggle
  2. A Kaggle API token: Kaggle → Settings → API → "Create New Token",
     saved as ~/.kaggle/kaggle.json (Windows: C:\\Users\\<you>\\.kaggle\\kaggle.json)

Run from the project root:
  python scripts/download_data.py
"""
import shutil
import sys
import tempfile
import zipfile
from pathlib import Path

DATASET = "olistbr/brazilian-ecommerce"
FILES = [
    "olist_customers_dataset.csv",
    "olist_sellers_dataset.csv",
    "olist_products_dataset.csv",
    "product_category_name_translation.csv",
    "olist_orders_dataset.csv",
    "olist_order_items_dataset.csv",
    "olist_order_payments_dataset.csv",
]
DATA = Path(__file__).resolve().parent.parent / "data"

MANUAL_STEPS = f"""
Manual download:
  1. Open https://www.kaggle.com/datasets/{DATASET}
  2. Click "Download" (free Kaggle account needed) and unzip the archive
  3. Copy these files into {DATA}:
     - """ + "\n     - ".join(FILES)


def main() -> int:
    try:
        from kaggle.api.kaggle_api_extended import KaggleApi
    except ImportError:
        print("The 'kaggle' package is not installed (pip install kaggle)." + MANUAL_STEPS)
        return 1

    api = KaggleApi()
    try:
        api.authenticate()
    except Exception as exc:  # missing or invalid kaggle.json
        print(f"Kaggle authentication failed: {exc}" + MANUAL_STEPS)
        return 1

    DATA.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        print(f"Downloading {DATASET} …")
        api.dataset_download_files(DATASET, path=tmp, quiet=False)
        archive = next(Path(tmp).glob("*.zip"))
        with zipfile.ZipFile(archive) as z:
            z.extractall(tmp)
        for name in FILES:
            src = next(Path(tmp).rglob(name), None)
            if src is None:
                print(f"Missing in download: {name}")
                return 1
            shutil.copy(src, DATA / name)
            print(f"  saved {name}")
    print("Done. Now run: mysql --local-infile=1 -u root -p --table < run_all.sql")
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env bash
# Step 1: generate synthetic patients, encounters and claims with Synthea.
# Requires Java 17+. Produces ./output/csv/*.csv
set -euo pipefail

curl -L -o synthea.jar \
  https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar

# -p 2000            : population of about 2,000 living patients
# -s / -cs 2025      : fixed seeds so the output is reproducible
# -e 20260131        : simulation ends 31 Jan 2026 (one month after FY2025)
# years_of_history=2 : keep detailed records for the last two years (FY2024-FY2025)
java -jar synthea.jar -p 2000 -s 2025 -cs 2025 -e 20260131 \
  --exporter.csv.export=true \
  --exporter.fhir.export=false \
  --exporter.years_of_history=2 \
  Massachusetts

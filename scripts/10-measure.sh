#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-common.sh"
require curl

LABEL="${1:-run}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTDIR="$ROOT/results"
mkdir -p "$OUTDIR"
OUT="$OUTDIR/${LABEL}_$(date +%Y%m%d_%H%M%S).csv"

info "Measuring 10 requests -> $OUT"
echo "label,idx,time_total_s,http_code" > "$OUT"

for i in $(seq 1 10); do
  # time_total + http_code
  line="$(curl -sS -o /dev/null -w "%{time_total},%{http_code}" "http://localhost:8080/api/compute?n=60000" || echo "0,000")"
  tt="${line%,*}"
  code="${line#*,}"
  echo "${LABEL},${i},${tt},${code}" >> "$OUT"
done

info "Done. Preview:"
tail -n +1 "$OUT" | head -n 5

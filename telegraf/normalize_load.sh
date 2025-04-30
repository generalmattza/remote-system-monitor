#!/bin/bash
read load1 load5 load15 < /proc/loadavg 2>/dev/null || {
  echo "system_load,host=$HOSTNAME load1_percpu=0,load5_percpu=0,load15_percpu=0"
  exit 1
}
cores=$(nproc 2>/dev/null || echo 1)
if [ -z "$cores" ] || [ "$cores" -eq 0 ]; then
  cores=1
fi
load1_percpu=$(awk -v load="$load1" -v cores="$cores" "BEGIN {printf \"%.6f\", $load1 / $cores}")
load5_percpu=$(awk -v load="$load5" -v cores="$cores" "BEGIN {printf \"%.6f\", $load5 / $cores}")
load15_percpu=$(awk -v load="$load15" -v cores="$cores" "BEGIN {printf \"%.6f\", $load15 / $cores}")
echo "system_load,host=$HOSTNAME load1_percpu=$load1_percpu,load5_percpu=$load5_percpu,load15_percpu=$load15_percpu"
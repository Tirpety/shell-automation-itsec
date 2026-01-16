#!/usr/bin/env python3
"""
Simple Python analysis engine
Reads Linux JSON and Windows CSV logs, assesses failed login risks, writes report.
"""

import json, csv, os
from datetime import datetime

# File paths
linux_file = "data/linux_output.json"
windows_file = "data/windows_output.csv"
report_file = "data/final_report.txt"
log_file = "data/anomalies.log"

def log(msg):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(log_file, "a") as f:
        f.write(f"{timestamp} {msg}\n")

log("Python analysis engine started")

# --- Read Linux JSON ---
linux_failed = 0
if os.path.isfile(linux_file):
    try:
        with open(linux_file) as f:
            data = json.load(f)
            linux_failed = data.get("failed_logins", 0)
    except json.JSONDecodeError:
        log("ERROR: Failed to parse Linux JSON log")
else:
    log("ERROR: Linux log file not found")

# --- Read Windows CSV ---
windows_failed = 0
if os.path.isfile(windows_file):
    try:
        with open(windows_file, newline="") as f:
            reader = csv.DictReader(f)
            for row in reader:
                if row.get("Event") == "Failed login attempts":
                    windows_failed = int(row.get("Count", 0))
    except Exception as e:
        log(f"ERROR: Failed to read Windows CSV log ({e})")
else:
    log("ERROR: Windows CSV file not found")

# --- Risk assessment ---
risks = []
if linux_failed > 10:
    risks.append(f"Linux: High failed logins ({linux_failed})")
elif linux_failed > 0:
    risks.append(f"Linux: Medium failed logins ({linux_failed})")

if windows_failed > 10:
    risks.append(f"Windows: High failed logins ({windows_failed})")
elif windows_failed > 0:
    risks.append(f"Windows: Medium failed logins ({windows_failed})")

# --- Generate report ---
with open(report_file, "w") as f:
    f.write(f"Security Analysis Report - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    f.write("="*40 + "\n")
    if risks:
        for r in risks:
            f.write(f"- {r}\n")
    else:
        f.write("No significant risks detected.\n")

log("Report generated successfully")
log("Python analysis engine completed")
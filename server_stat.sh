#!/bin/bash

echo "============================================"
echo "SERVER PERFORMANCE STATS"
echo "============================================"
echo "Date and Time: $(date)"
echo "Hostname: $(hostname)"
echo "============================================"

echo "CPU Usage:"
top -bn1 | grep -i "cpu(s)" | sed 's/,/./g' | awk '{print "User: "$2"% | System: "$4"% | Idle: "$8"%"}'
echo

echo "Memory Usage:"
free -m | awk '/^Mem:/ { total=$2; used=$3; free=$4; perc=(used/total)*100; printf("Total: %dMB | Used: %dMB | Free: %dMB | Used: %.2f%%\n", total, used, free, perc) }'
echo

echo "Disk Usage:"
df -h --total | awk 'tolower($1) ~ /total/ { printf("Total: %s | Used: %s | Free: %s | Used: %s\n", $2, $3, $4, $5) }'
echo

echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --no-headers --sort=-%cpu | head -n 5 | awk '{printf "%-8s %-20s %6s%%\n",$1,$2,$3}'
echo

echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --no-headers --sort=-%mem | head -n 5 | awk '{printf "%-8s %-20s %6s%%\n",$1,$2,$3}'
echo

echo "============================================"
echo "ADDITIONAL SERVER INFORMATION"
echo "============================================"

echo "Operating System Version:"
. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME" || uname -a
echo

echo "System Uptime:"
uptime -p
echo

echo "Load Average:"
uptime | awk -F'load average:' '{ print $2 }'
echo

echo "Logged In Users:"
who | awk '{print $1}' | sort | uniq
echo

if [ "$(id -u)" -eq 0 ]; then
  echo "Failed Login Attempts:"
  lastb | head -n 10
else
  echo "Failed Login Attempts: Run as root to view"
fi

echo "============================================"
echo "Stats collection completed."
echo "============================================"

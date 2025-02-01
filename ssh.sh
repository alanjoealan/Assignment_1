#!/usr/bin/env sh

# Define the number of failed attempts to trigger a warning
FAILED_ATTEMPTS_THRESHOLD=10

# Log output file
OUTPUT_LOG="/var/log/failed_ssh_attempts.log"

# Extract failed SSH login attempts from journalctl and group by IP address
echo "Extracting failed SSH login attempts..." | tee -a "$OUTPUT_LOG"

# Capture failed login attempts from SSH service logs
failed_logins=$(sudo journalctl -u sshd | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr)

# Debugging output to see what we're capturing
echo "Failed login data extracted:" | tee -a "$OUTPUT_LOG"
echo "$failed_logins" | tee -a "$OUTPUT_LOG"

# Check if no failed login attempts were found
if [ -z "$failed_logins" ]; then
    echo "$(date): No failed login attempts detected." | tee -a "$OUTPUT_LOG"
    exit 0
fi

# Detect and report IP addresses with multiple failed login attempts
echo "Detecting multiple failed SSH attempts..." | tee -a "$OUTPUT_LOG"
echo "$failed_logins" | while read count ip; do
    echo "Checking IP: $ip with $count failed attempts" | tee -a "$OUTPUT_LOG"
    if (( count >= FAILED_ATTEMPTS_THRESHOLD )); then
        echo "$(date): ALERT - IP Address: $ip - Failed attempts: $count" | tee -a "$OUTPUT_LOG"
        # Optionally, block the IP using iptables (uncomment the next line if needed)
        # sudo iptables -A INPUT -s $ip -j DROP
    fi
done


#!/bin/bash
echo "Content-type: text/html"
echo ""
echo "<h1>🛡️ Security Report</h1>"
echo "<b>Date:</b> $(date)<br>"
echo "<b>Uptime:</b> $(uptime)<br>"
echo "<hr>"
echo "<h3>⚠️ Failed Login Attempts (Last 5):</h3>"
# Parse authentication logs for failed login attempts
sudo grep "Failed password" /var/log/auth.log | tail -n 5 | sed 's/$/<br>/'
echo "<hr>"
echo "<h3>🛡️ Nginx Attack Log (Last 2):</h3>"
# Display the last 2 attacks blocked by ModSecurity
sudo tail -n 2 /var/log/nginx/error.log | sed 's/$/<br>/'
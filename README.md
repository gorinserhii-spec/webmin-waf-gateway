# 🛡️ The Ultimate Admin Dashboard (Secure Webmin Gateway)

![Project Status](https://img.shields.io/badge/Status-Completed-success)
![Security](https://img.shields.io/badge/Security-ModSecurity%20WAF-blue)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%20Linux-orange)

A hardened server administration environment combining **Webmin** with a secure **Nginx Reverse Proxy** and **ModSecurity WAF**. This project demonstrates how to protect internal management tools from external threats (SQL Injection, XSS) while providing automated system auditing via a custom GUI interface.

---

## 🚀 Key Features

* **Reverse Proxy Architecture:** Webmin is hidden behind Nginx (port 8443), serving as a secure gateway.
* **WAF Protection (ModSecurity):** Integrated **OWASP Core Rule Set (CRS)** to block malicious requests (e.g., SQL Injection) before they reach the admin panel.
* **SSL/TLS Encryption:** Full HTTPS support for secure data transmission.
* **Automated Security Audits:** Custom Bash scripts integrated into the Webmin UI to generate real-time HTML reports on server health and attack attempts.
* **Port Hardening:** Direct access to Webmin (port 10000) is restricted to localhost only.

---

## 📸 Screenshots

### 1. Security Audit Dashboard
*A custom-built module that parses system logs and displays Nginx WAF blocks and failed auth attempts in real-time.*
![Security Audit Dashboard](/images/dashboard_audit.PNG)

### 2. WAF in Action (SQL Injection Blocked)
*Demonstration of ModSecurity blocking a malicious query (`/?id=1 AND 1=1`) with a 403 Forbidden response.*
![WAF Blocking Attack](/images/waf_block.PNG)

---

## 🛠️ Tech Stack

| Component | Technology | Role |
| :--- | :--- | :--- |
| **OS** | Ubuntu Server 24.04 LTS | Base System |
| **Web Server** | Nginx | Reverse Proxy & SSL Termination |
| **Firewall (WAF)** | ModSecurity v3 + OWASP CRS | Application Layer Protection |
| **Admin Panel** | Webmin | GUI for System Administration |
| **Scripting** | Bash | Log parsing & Automation logic |

---

## ⚙️ How It Works (Configuration Highlights)

### 1. Nginx Reverse Proxy & WAF Setup
Nginx is configured to listen on port 8443, terminate SSL, and pass traffic to Webmin (localhost:10000). ModSecurity inspects every packet.

```nginx
server {
    listen 8443 ssl;
    server_name _;
    
    # WAF Enabled
    modsecurity on;
    modsecurity_rules_file /etc/nginx/modsec/main.conf;

    location / {
        proxy_pass [https://127.0.0.1:10000](https://127.0.0.1:10000);
        proxy_set_header Host $host;
        # ... forwarding headers
    }
}
```

### 2. Custom Bash Automation (`audit.sh`)
This script runs with root privileges (via Webmin wrapper), parses `/var/log/nginx/error.log` and `/var/log/auth.log`, and outputs an HTML report.

```bash
#!/bin/bash
echo "Content-type: text/html"
echo "<h3>🛡️ Nginx Attack Log (Last Detected):</h3>"
# Extracts and displays blocked requests with ModSecurity codes
sudo tail -n 5 /var/log/nginx/error.log | grep "ModSecurity" | sed 's/$/<br>/'
```

---

## 🛡️ Security Testing
The system was stress-tested using common attack vectors:

1. SQL Injection: `https://server:8443/?id=1 AND 1=1` -> BLOCKED (403)
2. XSS Attempt: `https://server:8443/?q=<script>alert(1)</script>` -> BLOCKED (403)

---

## 👤 Author
**Serhii Gorin**
* Junior Network Engineer / System Administrator
* [My LinkedIn Profile](https://www.linkedin.com/in/gorinserhii/)

---
*Created as a capstone project for System Administration qualification.*
  

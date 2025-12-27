

# 📘 **Deep Server & Technology Fingerprinter**

### *A powerful Bash tool to detect server software, backend language, and frontend technologies (Wappalyzer-style)*

<p align="center">
  <img src="https://img.shields.io/badge/bash-script-brightgreen?style=for-the-badge">
  <img src="https://img.shields.io/badge/detection-server%20%7C%20backend%20%7C%20frontend-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/license-MIT-yellow?style=for-the-badge">
</p>

---

## 🚀 **Overview**

This project is a **deep web application fingerprinting tool** written in Bash.
It detects:

* **Web Server** (Apache, Nginx, LiteSpeed, Cloudflare, etc.)
* **Backend Language** (PHP, Node.js, Python, Ruby)
* **Frontend Technologies** (React, Vue, Angular, Next.js, Vite, Svelte, etc.)
* **Frameworks** (Laravel, Django, Express.js, Rails, etc.)
* **DNS Records**
* **SSL Certificate Issuer & Subject**
* **X-Powered-By headers**
* **CDNs / Reverse Proxies**

All detection is **passive and legal** — only public metadata and headers are analyzed.

---

## ✨ **Features**

### 🔍 **1. Server Detection**

* Extracts Server header
* Detects proxy/CDN (Cloudflare, Akamai, Fastly, CloudFront)

### 🤖 **2. Wappalyzer-Style Technology Detection**

Detects frontend frameworks by scanning:

* HTML
* JS bundles
* Meta tags
* Directory signatures

Supports:

* **React**
* **Next.js**
* **Vue**
* **Angular**
* **Svelte**
* **Vite**
* **WordPress**
* **Express.js**
* **Laravel**
* many more…

### 🧠 **3. Backend Language Detection**

Fingerprints based on:

* Cookies
* Headers
* Error signature
* Build identifiers

Languages detected:

* **PHP**
* **Node.js**
* **Python** (Django / Flask / FastAPI)
* **Ruby** (Rails / Puma / Sinatra)

### 🔐 **4. SSL Certificate Information**

* SSL Issuer
* Certificate Subject

### 🌐 **5. DNS Lookup**

* A records
* NS records

---

## 📥 **Installation**

Clone the repo:

```bash
git clone https://github.com/Novicer18/server-fingerprinter
cd server-fingerprinter
```

Make the script executable:

```bash
chmod +x server_detector.sh
```

---

## 🛠️ **Usage**

Run the scanner with:

```bash
./server_detector.sh -u <url>
```

### Example

```bash
./server_detector.sh -u https://tryhackme.com
```

---

## 📌 **Sample Output (Preview)**

> Replace with a real screenshot from your terminal later.

```
┌────────────────────────────────────────────────────┐
│   Deep Server + Framework + Backend Fingerprinter   │
└────────────────────────────────────────────────────┘

Target: https://tryhackme.com

[1] Fetching Headers...
Server: Cloudflare
X-Powered-By: Unknown

[2] Detecting Frontend Technologies...
• React
• Next.js

[3] Detecting Backend Language...
Backend: Node.js

[4] SSL Certificate Info...
Issuer: Cloudflare Inc
Subject: tryhackme.com

[5] DNS Info...
A RECORDS...
NS RECORDS...

Deep Fingerprinting Finished!
```

---

## 🧩 **File Structure**

```
📂 server-fingerprinter
│── server_detector.sh
│── README.md
```

---

## ❤️ **Contributions**

Pull requests welcome —
You can add signatures, detections, modules, or optimizations.

---

## 📜 **License**

This project is licensed under the **MIT License**.

---


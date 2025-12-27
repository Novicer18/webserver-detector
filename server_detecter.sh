#!/bin/bash

# ===============================
#  SERVER + TECHNOLOGY FINGERPRINT
#  Wappalyzer + Backend Detection
# ===============================

# Colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

banner() {
    echo -e "${CYAN}${BOLD}"
    echo "┌────────────────────────────────────────────────────┐"
    echo "│   Deep Server + Framework + Backend Fingerprinter   │"
    echo "└────────────────────────────────────────────────────┘"
    echo -e "${RESET}"
}

usage() {
    echo -e "${YELLOW}Usage:${RESET} $0 -u <url>"
    exit 1
}

while getopts "u:" opt; do
  case $opt in
    u) URL="$OPTARG" ;;
    *) usage ;;
  esac
done

if [[ -z "$URL" ]]; then usage; fi

DOMAIN=$(echo "$URL" | sed -E 's#https?://##' | cut -d/ -f1)

banner
echo -e "${BLUE}${BOLD}Target:${RESET} $URL\n"

# ---------------------------------------------------
# 1 — GET HEADERS
# ---------------------------------------------------
echo -e "${GREEN}[1] Fetching Headers...${RESET}"

HEADERS=$(curl -s -I "$URL")
HTML=$(curl -s "$URL")

SERVER=$(echo "$HEADERS" | grep -i "^Server:" | sed 's/Server: //I')
POWERED=$(echo "$HEADERS" | grep -i "x-powered-by:" | sed 's/X-Powered-By: //I')

echo -e "${CYAN}Server:${RESET} ${SERVER:-Unknown}"
echo -e "${CYAN}X-Powered-By:${RESET} ${POWERED:-Unknown}\n"


# ---------------------------------------------------
# 2 — TECHNOLOGY DETECTION (Wappalyzer-style)
# ---------------------------------------------------
echo -e "${GREEN}[2] Detecting Frontend Technologies...${RESET}"

declare -a TECHS

detect() { TECHS+=("$1"); }

# React
[[ "$HTML" =~ ReactDOM ]] && detect "React.js"
[[ "$HTML" =~ __next ]] && detect "Next.js"
curl -s "$URL/_next/" | grep -q "\.js" && detect "Next.js (build folder)"

# Vue
echo "$HTML" | grep -qi "vue" && detect "Vue.js"

# Angular
echo "$HTML" | grep -qi "ng-version" && detect "Angular"

# Svelte
echo "$HTML" | grep -qi "svelte" && detect "Svelte"

# Vite
echo "$HTML" | grep -qi "vite" && detect "Vite Frontend"

# WordPress
echo "$HTML" | grep -qi "wp-content" && detect "WordPress"

# Laravel
echo "$HEADERS" | grep -qi "laravel" && detect "Laravel"

# Express
echo "$HEADERS" | grep -qi "express" && detect "Express.js"

echo -e "${CYAN}Frontend Technologies Detected:${RESET}"
if [[ ${#TECHS[@]} -eq 0 ]]; then
    echo -e "  ${RED}No identifiable frontend framework.${RESET}"
else
    for t in "${TECHS[@]}"; do echo -e "  ${GREEN}• $t${RESET}"; done
fi
echo ""


# ---------------------------------------------------
# 3 — BACKEND LANGUAGE DETECTION
# ---------------------------------------------------
echo -e "${GREEN}[3] Detecting Backend Language...${RESET}"

BACKEND="Unknown"

# ---------- PHP ----------
if echo "$HEADERS" | grep -qi "php"; then BACKEND="PHP"; fi
echo "$HEADERS" | grep -qi "set-cookie:.*PHPSESSID" && BACKEND="PHP"
echo "$HTML" | grep -qi "index.php" && BACKEND="PHP"

# ---------- Python ----------
# Django
echo "$HEADERS" | grep -qi "csrftoken" && BACKEND="Python (Django)"
# Flask (Werkzeug)
echo "$HEADERS" | grep -qi "werkzeug" && BACKEND="Python (Flask)"
# Generic Python
echo "$POWERED" | grep -qi "python" && BACKEND="Python"

# ---------- Node.js ----------
echo "$HEADERS" | grep -qi "express" && BACKEND="Node.js"
echo "$POWERED" | grep -qi "node" && BACKEND="Node.js"
echo "$HTML" | grep -qi "next.config" && BACKEND="Node.js"

# ---------- Ruby ----------
echo "$HEADERS" | grep -qi "ruby" && BACKEND="Ruby"
echo "$HEADERS" | grep -qi "puma" && BACKEND="Ruby (Puma)"
echo "$HEADERS" | grep -qi "_rails" && BACKEND="Ruby on Rails"

echo -e "${CYAN}Backend Language:${RESET} $BACKEND\n"


# ---------------------------------------------------
# 4 — SSL CERT INFO
# ---------------------------------------------------
echo -e "${GREEN}[4] SSL Certificate Info...${RESET}"

SSL=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" 2>/dev/null | openssl x509 -noout -issuer -subject)

echo -e "${CYAN}Issuer:${RESET} $(echo "$SSL" | grep issuer | sed 's/issuer=//')"
echo -e "${CYAN}Subject:${RESET} $(echo "$SSL" | grep subject | sed 's/subject=//')\n"


# ---------------------------------------------------
# 5 — DNS INFO
# ---------------------------------------------------
echo -e "${GREEN}[5] DNS Info...${RESET}"

echo -e "${CYAN}A Record:${RESET}"
dig +short "$DOMAIN"

echo -e "\n${CYAN}NS Record:${RESET}"
dig +short ns "$DOMAIN"

echo -e "\n${GREEN}${BOLD}Deep Fingerprinting Finished!${RESET}"

#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
TEAL_BLUE='\033[0;36m'

# Get system information
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_INFO=$(free -m)
TOTAL_MEM=$(echo "$MEM_INFO" | awk 'NR==2{print $2}')
USED_MEM=$(echo "$MEM_INFO" | awk 'NR==2{print $3}')
FREE_MEM=$(echo "$MEM_INFO" | awk 'NR==2{print $4}')
MEM_PERCENTAGE=$(( 100 * USED_MEM / TOTAL_MEM ))

DISK_INFO=$(df -h)
TOTAL_DISK=$(echo "$DISK_INFO" | awk '$NF=="/"{print $2}')
USED_DISK=$(echo "$DISK_INFO" | awk '$NF=="/"{print $3}')
FREE_DISK=$(echo "$DISK_INFO" | awk '$NF=="/"{print $4}')
DISK_PERCENTAGE=$(echo "$DISK_INFO" | awk '$NF=="/"{print $5}')

# Get OS name and version from /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="$NAME"
    OS_VERSION="$VERSION"
else
    OS_NAME="Unknown"
    OS_VERSION="Unknown"
fi

# Get uptime and hostname
UPTIME=$(uptime -p)
HOSTNAME=$(hostname)

# Get logged in users
if command -v w &> /dev/null; then
    LOGGED_USERS=$(w -h | awk '{print $1}' | sort -u | tr '\n' ' ')
else
    LOGGED_USERS="Unknown"
fi

# Display the information
echo -e "${TEAL_BLUE}=== System Information ===${NC}"
echo -e "${GREEN}Hostname: ${HOSTNAME}${NC}"
# Check if OS name and version are known
if [ "$OS_NAME" != "Unknown" ] && [ "$OS_VERSION" != "Unknown" ]; then
    echo -e "${GREEN}OS Name: ${OS_NAME}${NC}"
    echo -e "${GREEN}OS Version: ${OS_VERSION}${NC}"
fi
echo -e "${GREEN}Uptime: ${UPTIME}${NC}"
#echo -e "${GREEN}Logged in Users: ${LOGGED_USERS}${NC}"
# Check if logged in users are known
if [ "$LOGGED_USERS" != "Unknown" ]; then
    echo -e "${GREEN}Logged in Users: ${LOGGED_USERS}${NC}"
fi
echo -e "${YELLOW}Total CPU Usage: ${CPU_USAGE}%${NC}"
echo -e "${YELLOW}Total Memory Usage: ${USED_MEM}MB / ${TOTAL_MEM}MB (${MEM_PERCENTAGE}%)${NC}"
echo -e "${YELLOW}Total Disk Usage: ${USED_DISK} / ${TOTAL_DISK} (${DISK_PERCENTAGE})${NC}"

echo -e "${TEAL_BLUE}=== Top 5 Processes by CPU Usage ===${NC}"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

echo -e "${TEAL_BLUE}=== Top 5 Processes by Memory Usage ===${NC}"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

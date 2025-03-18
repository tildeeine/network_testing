#!/bin/bash

# Variables
SERVER_IP="192.168.65.180"  #! Change during test setup
DISTANCE="$1"  # Enter as argument when starting script
INTERFACE="wlan0"  #! change if necessary, should be correct for voxl
LOG_DIR="logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/${DISTANCE}m_test_$TIMESTAMP.log"

mkdir -p $LOG_DIR

log_and_echo() {
    echo "$1" | tee -a "$LOG_FILE"
}

log_and_echo "Starting test at $DISTANCE meters"
log_and_echo "Timestamp: $TIMESTAMP"

# Check signal strength
log_and_echo "Checking signal strength (RSSI)..."
for i in {1..8}; do
    log_and_echo "Measurement $i:"
    SIGNAL=$(iwconfig $INTERFACE )
    echo "Signal: $SIGNAL" | tee -a "$LOG_FILE"
    
    # Extract just the first number from SIGNAL (before the slash)
    QUALITY_NUM=$(echo $SIGNAL | cut -d'/' -f1)
    
    # Calculate dBm using integer division (quality/2) - 100
    QUALITY=$(( (QUALITY_NUM / 2) - 100 ))
    
    echo "dBm: $QUALITY" | tee -a "$LOG_FILE"
    sleep 1
done

log_and_echo "Running throughput tests..."

# Download test
log_and_echo "Download test ..."
iperf3 -c $SERVER_IP -t 30 -i 1 -P 5 | tee "$LOG_DIR/${DISTANCE}m_download.log"
grep SUM "$LOG_DIR/${DISTANCE}m_download.log" | tee -a "$LOG_FILE"
sleep 1

# Upload test
log_and_echo "Upload test..."
iperf3 -c $SERVER_IP -t 30 -i 1 -R -P 5 | tee "$LOG_DIR/${DISTANCE}m_upload.log"
grep SUM "$LOG_DIR/${DISTANCE}m_upload.log" | tee -a "$LOG_FILE"
sleep 1

# Large packets test
log_and_echo "Large packet test..."
iperf3 -c $SERVER_IP -t 30 -i 1 -l 1400 | tee "$LOG_DIR/${DISTANCE}m_large_packet.log"
grep SUM "$LOG_DIR/${DISTANCE}m_large_packet.log" | tee -a "$LOG_FILE"

# Extra tests
log_and_echo "Ping and iwlist tests..."
ping -c 10 $SERVER_IP | tee -a "$LOG_FILE"

sudo iwlist $INTERFACE quality | tee -a "$LOG_FILE" #!check this

# Print summary
log_and_echo "Summary of Results:"
log_and_echo "Download Speed:"
grep SUM "$LOG_DIR/${DISTANCE}m_download.log" | tee -a "$LOG_FILE"

log_and_echo "Upload Speed:"
grep SUM "$LOG_DIR/${DISTANCE}m_upload.log" | tee -a "$LOG_FILE"

log_and_echo "Large Packet Speed:"
grep SUM "$LOG_DIR/${DISTANCE}m_large_packet.log" | tee -a "$LOG_FILE"

log_and_echo "Test completed for $DISTANCE meters. Logs saved in $LOG_DIR."

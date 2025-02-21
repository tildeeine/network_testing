#!/bin/bash

# Variables
SERVER_IP="192.168.0.104"  #! Change during test setup
DISTANCE="$1"  # Enter as argument when starting script
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
    log_and_echo "Measurement :"
    SIGNAL=$(iwconfig $INTERFACE 2>/dev/null | grep -o 'Signal level=-[0-9]* dBm' | awk -F '=' '{print $2}')
    echo $SIGNAL | tee -a "$LOG_FILE"
    sleep 1
done

log_and_echo "Running throughput tests..."

# Download test (3 times)
log_and_echo "Download test ..."
iperf3 -c $SERVER_IP -t 30 -i 1 -P 5 --logfile "$LOG_DIR/50m_download_.log"
sleep 1

# Upload test (3 times)
log_and_echo "Upload test ..."
iperf3 -c $SERVER_IP -t 30 -i 1 -R -P 5 --logfile "$LOG_DIR/50m_upload_.log"
sleep 1

# Large packets test
log_and_echo "Large packet test ..."
iperf3 -c $SERVER_IP -t 30 -i 1 -l 1400 --logfile "$LOG_DIR/50m_large_packet_.log"

# Extra tests
log_and_echo "Running additional network tests..."
ping -c 10 $SERVER_IP | tee -a "$LOG_FILE"
iwlist wlan1 scan | tee -a "$LOG_FILE"

log_and_echo "Test completed for $DISTANCE meters. Logs saved in $LOG_DIR."

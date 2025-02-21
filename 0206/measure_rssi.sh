#!/bin/bash

# wireless interface (change if needed)
INTERFACE="wlo1"

# measurement interval (seconds)
INTERVAL=1

# number of measurements to take
COUNT=50

RSSI_VALUES=()

echo "Measuring RSSI on $INTERFACE every $INTERVAL seconds ($COUNT samples)..."

for ((i=1; i<=COUNT; i++)); do
    SIGNAL=$(iwconfig $INTERFACE 2>/dev/null | grep -o 'Signal level=-[0-9]* dBm' | awk -F '=' '{print $2}')
    
    if [[ -n "$SIGNAL" ]]; then
        RSSI_VALUES+=("$SIGNAL")
        echo "[$i] RSSI: $SIGNAL"
    else
        echo "[$i] No signal detected."
    fi

    # Wait for the next measurement
    sleep $INTERVAL
done

# Calculate the average RSSI
if [[ ${#RSSI_VALUES[@]} -gt 0 ]]; then
    SUM=0
    for val in "${RSSI_VALUES[@]}"; do
        CLEAN_VAL=${val//[^0-9-]}  # Remove all non-numeric characters except '-'
        SUM=$((SUM + CLEAN_VAL))
    done
    AVG=$((SUM / ${#RSSI_VALUES[@]}))
    echo -e "Measurements done. Average RSSI: $AVG dBm"
else
    echo "No valid RSSI values collected."
fi
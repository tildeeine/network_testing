# Testing

Make new dir for every test. Naming convention: `mmdd`.

To run:
```sh
./testing.sh <distance testing at>
```

If issues:
```sh
chmod +x testing.sh
```

Run at different test distances. Previous distances: 10m, 30m, 50m, 80m, 110m.
MAKE SURE the iperf3 command gives actual measurements as output, not error msgs. Check the logs as you test to verify this. 

What does it test?
- RSSI (signal strength)
- Download throughput (5 parallell streams)
- Upload throughput (5 parallell streams)
- Download throughput with large packets (1400 bytes, approx MTU)
- Ping (RTT)
- iwlist quality (noise, signal level, link quality 1-100)

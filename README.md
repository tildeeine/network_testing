# Testing

Make new dir for every test. Naming convention: `mmdd`.

Running the script to test wifi as a client requires running iperf3 as a server on another computer. To start iperf3 as a server, run
```bash
iperf3 -s
````
Check the IP of the server, and insert in in the `SERVER_IP` in the script. 
The interface name is by default set to `wlan0`, which should be correct for the voxl. Verify this by running `ip a`and checking the interface name. 

Before first run:
```bash
chmod +x testing.sh
```

To run the test script:
```sh
./testing.sh <distance>
```
Where distance is the distance you're currently testing at as an input argument. 

Run at different test distances. Previous distances: 10m, 30m, 50m, 80m, 110m.
Check the logs after the first test to verify that you are getting test data, not just error messages. 

What does it test?
- RSSI (signal strength)
- Download throughput (5 parallell streams)
- Upload throughput (5 parallell streams)
- Download throughput with large packets (1400 bytes, approx MTU)
- Ping (RTT)
- iwlist, link quality (noise, signal level, link quality 1-100)

<img src="https://github.com/mikaellofgren/wandra/blob/main/images/wandra-ikon.png" width="40%"></img><br>
# Wandra
Simple Wi-Fi analyzer for macOS built in SwiftUI.<br>


It displays your Signal to Noise Ratio and Received Signal Strength.<br>
Basestation SSID and MAC-address, you can export measured data as<br>
a csv file to import to Numbers/Excel.<br>

System requirements<br>
macOS 11.0 <br>

Download from here:<br>
https://github.com/mikaellofgren/wandra/releases

<img src="https://github.com/mikaellofgren/wandra/blob/main/images/preview.png" width="30%"></img><br>

# Help<br>
Click the textfields in the app to bring up help texts.<br>
**Signal to Noise Ratio (SNR)**<br>
Higher value is better<br>

Its measured by taking the signal strength (RSSI)<br>
and subtracting the noise.<br>
Noise is all the RF around the radio in the spectrum<br>
from all RF sources. It can come from a microwave, bluetooth devices, etc.<br>

Wireless adapters (NIC) for laptops, tablets,<br>
aren’t capable of determining accurate SNR.<br>
An example is when a microwave is turned on.<br>
The NIC will not be able to see the RF signal<br>
because the microwave is sending unmodulated bits.<br>
Thus the built-in NIC believes there is no noise.<br>
<br>
**Received Signal Strength Indicator (RSSI)**<br>
Measured in dBm (decibel milliwatts)<br>

Lower value is better<br>
Every 3 dB lower = doubles signal strength<br>
Every 3 dB higher = halves signal strength<br>
Usually it starts around -30 near the access point,<br>
and gets higher (losing strength)<br>
when moving away from the access point.<br>
<br>
**Basic Service Set Identifiers (BSSID)**<br>
Most of the time it is associated with MAC address of the access point
Stick to current BSSID until:
- RSSI below -75dBm
- Choose 5Ghz over 2.4GHz as long as 5GHz is more than -68dBm
- Does NOT support 802.11k
- Choose AP with RSSI 12dB higher than current AP

If multiple 5 GHz SSIDs meet this level,
macOS chooses a network based on these criteria:
- 802.11ax is preferred over 802.11ac.
- 802.11ac is preferred over 802.11n or 802.11a.
- 802.11n is preferred over 802.11a.
- 80 MHz channel width is preferred over 40 MHz or 20 MHz.
- 40 MHz channel width is preferred over 20 MHz.

https://support.apple.com/en-us/HT206207

//
//  HelpTexts.swift
//  Wandra
//
//  Created by Mikael Löfgren on 2021-04-04.
//

import Foundation

let ssidHelp = ("""
Service set identifier (SSID)
Name of current connected Wi-Fi network
""")

let snrHelp = ("""
Signal to Noise Ratio (SNR)
Higher value is better

Click to show more info
""")

let snrHelpPopover = ("""
Signal to Noise Ratio (SNR)
Higher value is better

Its measured by taking the signal strength (RSSI)
and subtracting the noise.
Noise is all the RF around the radio in the spectrum
from all RF sources. It can come from a microwave,
bluetooth devices, etc.

Wireless adapters (NIC) for laptops, tablets,
aren’t capable of determining accurate SNR.
An example is when a microwave is turned on.
The NIC will not be able to see the RF signal
because the microwave is sending unmodulated bits.
Thus the built-in NIC believes there is no noise.
""")



let snrValueHelp = ("""
Full circle is 50
0-9  = Very poor signal
10-15 = Very low signal
16-25 = Low signal
26-40 = Very good signal
41-99 = Excellent signal
""")

let rssiHelp = ("""
Received Signal Strength Indicator (RSSI)
Lower value is better

Click to show more info
""")

let rssiHelpPopover = ("""
Received Signal Strength Indicator (RSSI)
Measured in dBm (decibel milliwatts)

Lower value is better
Every 3 dB lower = doubles signal strength
Every 3 dB higher = halves signal strength
Usually it starts around -30 near the access point,
and gets higher (losing strength)
when moving away from the access point.
""")

let rssiValueHelp = ("""
Full circle is -100 (negative scale)
0-49 = Maximum signal
50-59 = Excellent signal
60-67 = Very good signal
68-70 = Low signal
71-79 = Very low signal
80-100 = Very poor signal
""")

let bssidHelp = ("""
Basic Service Set Identifiers (BSSID)
Right click to copy the value

Click to show more info
""")

let bssidHelpPopover = ("""
Basic Service Set Identifiers (BSSID)
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
""")

let apNameHelp = ("""
Custom access point name (example Floor 2)
Textfield reloads every measure interval,
set higher interval to easier type a value,
then press enter to save
""")

let apNameDisabledHelp = "Disabled until a BSSID is found"

let buttonHelp = "Right click to save measured data as a csv file"

let soundHelp = """
Plays a sound if RSSI has a value higher than three (losing strength),
compared to the last measured value
"""

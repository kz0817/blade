# Example of launch

    wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf

## Options

    -dd Debug
    -B  Background


# Use of hidden AP
Add `scan_ssid=1` in a network section of a config file.

network={
```
    ssid="SSID"
    psk="password"
    scan_ssid=1
}
```

# Use of open network such as a cafe
Add `key_mgmt=None' in a network section of a config file.


# Examples of wpa_cli

    wpa_cli -i wlna0

## status

    status

## scan

    scan
    scan_resuls

## list network

    list_networks

## Example to connect a new network
```
> add_network
0
> set_network 0 ssid '"SSID"'
OK
> set_network 0 psk '"password"'
OK
> enable_network 0
OK
> select_network 0
OK
```

When using open network, use key_mgmt instead of psk
```
> set_network 0 key_mgmt NONE
```

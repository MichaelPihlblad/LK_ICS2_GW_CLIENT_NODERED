# LK ICS2 GW CLIENT NODERED

Interface for LK ICS2, floor heating room temperature regulator. https://www.lksystems.se/en/produkter/lk-golvvarme/produktsortiment/rumsreglering/ics.2-tradforbundentradlos/

This SW is currently a Modbus TCP gateway and MQTT client, developed in Node-red primarily targeting raspberry pi 3, should work on any raspberry version or Linux PC.

Should work with Raspberry PI RS485 HAT or any generic RS485 to USB or UART converter

Ready to use Raspberry image: [v0.1.0](https://github.com/MichaelPihlblad/LK_ICS2_GW_CLIENT_NODERED/releases/download/v0.1.0/raspios-bullseye-armhf-lite.zip)


## INSTALL - Generic
Note: For raspberry see [Raspberry install](#raspberry-install)
1. Install node-red
2. Checkout this repo in home folder (i.g. `~/LK_ICS2_GW_CLIENT_NODERED`)
3. Edit `~/.node-red/settings.js`  
   ```diff
   - flowFile: "flows.json",
   + flowFile: "../LK_ICS2_GW_CLIENT_NODERED/flows.json",   
   ```
4. To be able to run the TCP GW on standard modbus port 502
    * Add the following to: `/lib/systemd/system/nodered.service`
        ```bash
        # Allow binding to priviledged ports, ig 502 for modbus
        CapabilityBoundingSet=CAP_NET_BIND_SERVICE
        AmbientCapabilities=CAP_NET_BIND_SERVICE
        #NoNewPrivileges=true
        ```
    * run this command: 
        > sudo setcap 'cap_net_bind_service=+ep'  $(eval readlink -f \`which node`)
5. Install the following nodered modules from inside the web editor ():
    * node-red-contrib-modbus
    * node-red-contrib-xlsx-to-json
    * @node-red-contrib-themes/theme-collection    (for use of dark theme)
    * node-red-dashboard
    * node-red-node-ui-list
    * node-red-node-ui-table
    * node-red-node-serialport
    Note: can also alternatively be installed from command line but that requires a node-red restart 
   ```bash
   cd ~/.node-red/
   npm install [package name]
   systemctl restart nodered   
   ``` 
 
## configuration
* LKICS2 dashboard: http://lkics2.local:1880/ui
  * One tab for watching read values
  * One tab for admin:
    * set Modbus device
    * adding polling registers
    * mqtt settings
    * saving config changes to SD card
    * writing to registers

* node-red web editor: http://lkics2.local:1880 (used for code changes)

## Raspberry PI
#### Raspberry install
1. Either download the pre-built img file or see: [Raspberry setup from scratch](#raspberry-setup-from-scratch)
2. Either flash with [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
3. Or manually flash with dd, i.g.:
  > dd if=LKICS2-raspios-bullseye-armhf-lite.img of=/dev/mmcblk0
4. Follow [Raspberry PI wifi config](#raspberry-pi-wifi-config)

#### Raspberry PI wifi config
wifi can be set up in many different ways:
* In imager flashing tool advanced menu: `ctrl+shift+x`
* Use `raspi-config` commandline tool i.e. from ssh or hooking up to dispaly and keyboard. 

* After flashing the raspberry image to SD card, mount the SD card and edit `/etc/wpa_supplicant/wpa_supplicant.conf`, add wifi info i.g:
    ```bash
    country=SE
    network={
	  ssid="your ssid"
	  psk="your wifi password"
	  key_mgmt=WPA-PSK
    }
   ```
   Make sure to set your correct country code, see [ISO Country Code](https://www.iso.org/obp/ui/#search/code/).
* It is also possible to put wifi config on boot partition and it will be copied automatically on boot, see: https://www.raspberrypi.com/news/another-update-raspbian/
  > If a wpa_supplicant.conf file is placed into the /boot/ directory, this will be moved to the /etc/wpa_supplicant/ directory the next time the system is booted, overwriting the network settings; this allows a Wifi configuration to be preloaded onto a card from a Windows or other machine that can only see the boot partition.


#### Raspberry setup from scratch
1. Download standard raspios image, i.g. https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-01-28/2022-01-28-raspios-bullseye-armhf-lite.zip
2. Follow node-red on raspberry install guide: https://nodered.org/docs/getting-started/raspberrypi
3. Continue with: [Install generic, step 2](#install---generic)

## Python emulator for testing
* install python3 modules dependencies (i.g. using pip install):
  * pyserial
  * pymodbus
* Start emulator with: `python ModbusRtuEmulator.py`


## Howto run raspberry image under qemu for local dev on PC
1. Follow this guide: https://linuxconfig.org/how-to-run-the-raspberry-pi-os-in-a-virtual-machine-with-qemu-and-kvm
2. Download qemu raspberry kernel image: https://github.com/dhruvvyas90/qemu-rpi-kernel


## Troubleshooting
* Raspberry Wifi - make sure to set country code in wifi config. If still not working check that wifi is not blocked and manually unblock
  ```bash
  pi@LKICS2:~/ $ rfkill list
  0: phy0: Wireless LAN
    Soft blocked: yes
    Hard blocked: no

  pi@LKICS2:~/ $ sudo rfkill unblock wifi
  ```
* QEMU blank screen with spice: select view --> text consoles --> text console

## Links
* [www.lksystems.se](https://www.lksystems.se/en/produkter/lk-golvvarme/produktsortiment/rumsreglering/ics.2-tradforbundentradlos/)
* [Raspberry PI Documentation](https://www.raspberrypi.com/documentation/computers/remote-access.html)
## TODO
* Update Documentation, add HW modbus info e.t.c.
* Refactor - cleanup model for readability e.t.c.
* Convert PI installation to read only mounted filesystem (for dependability and lifetime of SD-card)
* Implement writing registers by mqtt
* implement dynamic UI setting of unitid/slaveid and baudrate e.t.c.
* UI improvements

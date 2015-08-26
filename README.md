# NPFNG Doorguard

Doorguard plugin for [npfng](http://npfng.com). Monitor your doors and windows from a central node with reed switches.

## Required hardware

Additionaly to your ESP8266 you will need:

* a bunch of reed switches: [Buy on AliExpress](http://s.click.aliexpress.com/e/F6UnMFU7Q?af=717073896)
* a ws2812b LED: [Buy on AliExpress](http://s.click.aliexpress.com/e/vrFiM3bi2?af=717073896)
* the "flash" button (a button that connects `GPIO 0` with ground when pressed)

### Assembling
#### Master

Connect the data pin of the LED to a GPIO port of the master.

#### Slave

Connect one end of the reed switch with a GPIO port and the other end to ground. You can connect multiple switches to
the same slave.


## Installation

Install NPFNG-core on your ESP.


### Master

The master is the central unit that shows the state of the slaves.

Upload `doorguard_master.lua` to your ESP and add `doorguard_master` to the PLUGINS setting.

Required settings in `config.lua`:

* `PIN_RGB_LED`: The pin where the data pin of the ws2812b LED is connected
* `SLAVE_IPS`: A list of the IPs of the slaves to check


### Slave

The slaves are the nodes that have the reedswitches connected.

Upload `doorguard_slave.lua` to your ESP and add `doorguard_slave` to the PLUGINS setting.

Required settings in `config.lua`:

* `PINS_REEDSWITCH`: The pins where the reed switches are connected. E.g. `{gpio[13], gpio[12]}`


## Usage

Press the flash button of the master. The LED turns yellow which indicates that the states are being checked. When all
states have been received it will turn green if all reed switches are closed or red if at least one is open.

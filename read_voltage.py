#!/usr/bin/python3

import time
import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn

# Create the I2C bus
i2c = busio.I2C(board.SCL, board.SDA)

# Create the ADC object using the I2C bus
ads = ADS.ADS1115(i2c)
ads.gain = 1
#ads.bits = 16

# Create single-ended input on channel 0
chan = AnalogIn(ads, ADS.P0)

# Define the resistor divider constant
#print("Battery is at {:>5.3f} volts".format(chan.voltage / r))

print("{:>5.3f} volts".format((chan.value * .0005032405) + .015868))

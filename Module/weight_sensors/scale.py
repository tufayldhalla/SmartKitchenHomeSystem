#!/usr/bin/python3
from hx711 import HX711     # import the class HX711
import RPi.GPIO as GPIO     # import GPIO
import time

try:
    ########## Change the pin values below to the pins you are using ###################
    dataPin = 5      # Pin 29, GPIO 5
    clockPin = 6     # Pin 31, GPIO 6
    
    
    numReadings = 8  # Number of samples to collect for averages
    ########## Calibrated measurement = (raw value - offset) / reference number ###################
    reference = 0
    offset = 0

    print("Reading HX711")
    # Create an object hx which represents your real hx711 chip
    # Required input parameters are only 'dout_pin' (data) and 'pd_sck_pin' (clock)
    # If you do not pass any argument 'gain_channel_A' then the default value is 128
    # If you do not pass any argument 'set_channel' then the default value is 'A'
    # you can set a gain for channel A even though you want to currently select channel B
    hx = HX711(dout_pin=dataPin, pd_sck_pin=clockPin, gain=128, channel='A')
    
    print("Reset")
    result = hx.reset()    # Before we start, reset the hx711 ( not necessary)
    if result:             # you can check if the reset was successful
        # Calibration
        print("[CALIBRATION] Calibrating offset...")
        time.sleep(5)
        offset_data = hx.get_raw_data(numReadings)
        offset = sum(offset_data) / len(offset_data)
        
        print("[CALIBRATION] Place reference object of known weight on scale.")
        prompt = input("[CALIBRATION] Enter anything to continue once reference object is placed: ")
        
        print("[CALIBRATION] Collecting reference data...")
        time.sleep(5)
        reference_data = hx.get_raw_data(numReadings)
        reference = (sum(reference_data) - (offset*len(reference_data))) / len(reference_data)
        reference_weight = input("[CALIBRATION] Enter weight of reference object in grams: ")
        reference = reference / float(reference_weight)
        print("[CALIBRATION] Calibration finished.")
    else:
        print('not ready')
        
    while(True):
        # Read data several, or only one, time and return mean value
        # it just returns exactly the number which hx711 sends
        # argument times is not required default value is 1
        # data = hx.get_raw_data(NumReadings)
        data = (hx._read() - offset) / reference
        print('[INFO] Measurement: ' + str(data) + ' grams')
        time.sleep(1)
        
        '''if data != False:    # always check if you get correct value or only False
            print('Raw data: ' + str(data))
        else:
            print('invalid data')'''

except (KeyboardInterrupt, SystemExit):
    print("[INFO] Cleaning up and quitting...")
    
finally:
    GPIO.cleanup()



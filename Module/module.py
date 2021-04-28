#!/usr/bin/python3
# Imports for barcode scanner
from pyzbar import pyzbar
import cv2
import os
import time
# Imports for scale
from hx711 import HX711
import RPi.GPIO as GPIO
import statistics
# Import Flask route api
from APILibrary import APILibrary


################### Global Variables ###################
# Constants
DATA_PIN = 5      # Pin 29, GPIO 5
CLOCK_PIN = 6     # Pin 31, GPIO 6
NUM_READINGS = 10  # Number of scale samples to collect for averages
RED_LED_PIN = 20
GREEN_LED_PIN = 21
SPEAKER_PIN = 26
BUTTON_PIN = 2

# Calibrated scale measurement = (raw value - offset) / reference
reference = 0.0
offset = 0.0

# Current user using the module
userID = ""

# Keep track of checked-out items
checkedOut = set()

# Keep track of items on scale
# Format {Barcode (Key): isCheckedOut (Boolean)}
#itemsOnScale = {}

# Total weight of items on scale
totalWeight = 0.0

# For scan in/out delay
paused = False
delay = 0

# For trashcan mode or module mode
trashCanMode = False

# Instantiate Flask route api
api = APILibrary()

GPIO.setmode(GPIO.BCM)

#setup speakers
GPIO.setup(SPEAKER_PIN, GPIO.OUT)
p = GPIO.PWM(SPEAKER_PIN,50)


def init_picam():
    """ Function to initialize Pi Camera """
    print("[INFO] Initializing PiCam")
    if os.path.exists("/dev/video0") == False:
        path = "sudo modprobe bcm2835-v4l2 "
        os.system (path)

def init_video_cap(camArg, frameWidth, frameHeight):
    """ Function to create video capture object """
    print("[INFO] Initializing video capture object")
    # argument 0, PiCam start
    # set dimensions
    # give camera sensor time to warm up
    vc = cv2.VideoCapture(camArg)
    vc.set(cv2.CAP_PROP_FRAME_WIDTH, frameWidth)
    vc.set(cv2.CAP_PROP_FRAME_HEIGHT, frameHeight)
    #vc.set(cv2.CAP_PROP_FPS, 30)
    time.sleep(1)
    return vc

def read_scale_once(hxChip):
    """ Function to read from the scale once and return the value """
    # Read and then adjust the raw value based on the scale's offset & reference
    scaleData = (hxChip._read() - offset) / reference
    return scaleData

def read_scale_average(hxChip, off, ref):
    """ Function to read from the scale and return the average from NUM_READINGS samples """
    scaleData = hxChip.get_raw_data(NUM_READINGS)

    # Remove outliers from samples
    scaleData.remove(max(scaleData))
    scaleData.remove(min(scaleData))

    # Calculate average = average / reference
    average = ((sum(scaleData) - (off*len(scaleData))) / len(scaleData)) / ref
    return average

def read_scale_median(hxChip, off, ref):
    """ Function to read from the scale and return the median from NUM_READINGS samples """
    scaleData = hxChip.get_raw_data(NUM_READINGS)
    # Read median and then adjust the raw value based on the scale's offset & reference
    scaleDataMedian = (statistics.median(scaleData) - off) / ref
    return scaleDataMedian

def read_scale(hxChip, off, ref):
    """ Function to read from the scale and return the value using one of the above methods """
    scaleData = read_scale_median(hxChip, off, ref)
    print(f"[INFO] Scale measurement: {scaleData} grams")
    return scaleData

def calibrate_scale(hxChip):
    """ Function to calibrate the scale """
    global offset
    global reference

    # Calculate offset
    print("[SCALE CALIBRATION] Calibrating offset...")
    offset = read_scale(hxChip, 0.0, 1.0)

    # Calculate reference
    print("[SCALE CALIBRATION] Place reference object of known weight on scale.")
    prompt = input("[SCALE CALIBRATION] Enter anything to continue once reference object is placed: ")
    print("[SCALE CALIBRATION] Collecting reference data...")
    reference = read_scale(hxChip, offset, 1.0)
    referenceWeight = float(input("[SCALE CALIBRATION] Enter weight of reference object in grams: "))
    reference = reference / referenceWeight
    read_scale(hxChip, offset, reference)
    print("[SCALE CALIBRATION] Calibration finished.\n")

def init_gpio():
    """ Setup GPIO """
    #setup LEDS
    GPIO.setup(RED_LED_PIN, GPIO.OUT)
    GPIO.setup(GREEN_LED_PIN, GPIO.OUT)

    #turn on led, by default we are in module mode
    GPIO.output(GREEN_LED_PIN, True)
    GPIO.output(RED_LED_PIN, False)

    #setup button
    GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

def beep(duration):
    """ Make the speaker beep for 'duration' seconds """
    p.start(70)
    p.ChangeFrequency(1800)
    time.sleep(duration)
    p.stop()


if __name__ == "__main__":
    
    # try, except, finally for handling errors
    try:
        # initialize pi camera
        init_picam()

        # initialize the gpio pins
        init_gpio()

        # create video capture object
        videoCapture = init_video_cap(0, 1024, 768)

        print("[INFO] Reading HX711")
        # Create an object hx which represents your real hx711 chip
        # Required input parameters are only 'dout_pin' (data) and 'pd_sck_pin' (clock)
        # If you do not pass any argument 'gain_channel_A' then the default value is 128
        # If you do not pass any argument 'set_channel' then the default value is 'A'
        # you can set a gain for channel A even though you want to currently select channel B
        hx = HX711(dout_pin=DATA_PIN, pd_sck_pin=CLOCK_PIN, gain=128, channel="A")
        
        # Before start, reset the hx711
        print("[INFO] Resetting HX711")
        result = hx.reset()
        if result: # check if the reset was successful
            calibrate_scale(hx)
        else:
            print("[ERROR] Reset failed.")
            raise Exception("HX711 reset failed.")

        while True:
            key = cv2.waitKey(1) & 0xFF

            # when the barcode detection is paused,
            # if "c" key pressed or if 20 loops passed, unpause
            if key == ord("c") or delay >= 20:
                paused = False

            # if the `q` key was pressed, quit script
            if key == ord("q"):
                break

            # If the push button has been pressed then change the mode
            if not GPIO.input(BUTTON_PIN) == GPIO.HIGH:
                print("flipped mode")
                trashCanMode = not trashCanMode # change mode based on what it was set to previously
                GPIO.output(RED_LED_PIN, trashCanMode) # if on then in trash can mode
                GPIO.output(GREEN_LED_PIN, not trashCanMode) # if on then in module mode
            
            #print(read_scale_once(hx))
            #print(read_scale_average(hx, offset, reference))
            #print(read_scale_median(hx, offset, reference))
            #read_scale(hx, offset, reference)

            # read a video frame by frame
            # read() returns tuple in which 1st item is boolean value
            # either True or False and 2nd item is frame of the video.
            # read() returns False when live video is ended so
            # no frame is read and error will be generated.
            ok, frame = videoCapture.read()

            # show the live video frame
            cv2.imshow("Barcode Scanner", frame)

            # Don't continue to barcode scan if paused
            if paused:
                delay += 1
                continue
            
            # Decode barcodes in frame
            barcodes = pyzbar.decode(frame)

            if len(barcodes) > 0: # Barcode detected
                # Scan successful beep
                beep(0.2)

                # Pause barcode scanning
                paused = True
                delay = 0

                barcode = barcodes[0]
                # the barcode data is a bytes object so 
                # convert it to a string first
                barcodeData = barcode.data.decode("utf-8")
                barcodeType = barcode.type

                # print the barcode type and data to the terminal
                print(f"[INFO] Detected {barcodeType} barcode: {barcodeData}")


                if barcodeType == "QRCODE": # QR SCAN - user account scan
                    user = api.get_from_users(barcodeData)
                    if user != None:
                        userID = barcodeData
                        print(f"[INFO] Signed in as {user['First_Name']} {user['Last_Name']}.")
                    else:
                        print("[INFO] User not found.")

                else: # BARCODE SCAN - item scan
                    # Initial user needs to be signed in since userID is empty at first
                    if userID == "":
                        print("[INFO] Please sign in with a QR code first.")
                        continue

                    item = api.get_from_inventory(barcodeData, userID)
                    
                    if item != None:    # Found in user inventory

                        if trashCanMode:
                             #delete from users inventory
                            api.remove_from_inventory(barcodeData, userID)

                            #confirmation beep
                            beep(1)

                        # If in module mode
                        else:
                            # Item added through app, but not on scale yet
                            #if barcodeData not in itemsOnScale:
                            if item["Measured_Weight"] == 0 or item["Measured_Weight"] == None:
                                # update "Measured_Weight" of item in database + update scale's totalWeight
                                print(f"[INFO] Adding {barcodeData} to scale.")
                                #itemsOnScale[barcodeData] = False
                                api.update_in_inventory(barcodeData, userID, "Scanned", 'in')
                                time.sleep(5)   # Wait for user to place item back on scale
                                newTotalWeight = read_scale(hx, offset, reference)
                                newItemWeight = newTotalWeight - totalWeight
                                api.update_in_inventory(barcodeData, userID, "Measured_Weight", newItemWeight)
                                totalWeight = newTotalWeight
                                #print(itemsOnScale)

                            # Scan out - set checkout to True
                            #elif not itemsOnScale[barcodeData]:
                            elif item["Scanned"] == 'in':
                                print(f"[INFO] Scanned {barcodeData}")
                                prevWeight = totalWeight

                                # Wait for user to put item on scale or remove item
                                time.sleep(5)

                                afterWeight = read_scale(hx, offset, reference)

                                if (prevWeight > afterWeight): #scanned out item 
                                    # Add to list of checked out items and update total weight on scale
                                    print(f"[INFO] Scanning {barcodeData} out.")
                                    #itemsOnScale[barcodeData] = True
                                    api.update_in_inventory(barcodeData, userID, "Scanned", 'out')
                                    time.sleep(3)
                                    totalWeight = afterWeight
                                else:
                                    print(f"[INFO] Appending item {barcodeData} in.")
                                    newItemWeight = afterWeight - prevWeight
                                    api.update_in_inventory_w_offset(barcodeData, userID, "Measured_Weight", newItemWeight)
                                    totalWeight = afterWeight
                                    print(f"[INFO] total weight: {totalWeight}")
                            
                            # Scan back in - set checkout to False
                            #else:
                            elif  item["Scanned"] == 'out':
                                # update weight of item in database + update total weight on scale
                                print(f"[INFO] Scanning {barcodeData} back in.")
                                #itemsOnScale[barcodeData] = False
                                api.update_in_inventory(barcodeData, userID, "Scanned", 'in')
                                time.sleep(5)   # Wait for user to place item back on scale
                                newTotalWeight = read_scale(hx, offset, reference)
                                newItemWeight = newTotalWeight - totalWeight
                                print(f"[INFO] new item weight on scan in: {newItemWeight}")

                                dbWeight = item["Measured_Weight"]/item["Count"]
                                difference = newItemWeight - dbWeight

                                if difference > -5 and difference < 5:
                                    print(f"[INFO] new total weight ~= to previous weight {difference}")
                                    totalWeight = newTotalWeight
                                    print(f"[INFO] total weight: {totalWeight}")

                                else:
                                    print(f"[INFO] Updating weight with difference: {difference}")
                                    print(f"[INFO] Updating measured_weight with difference: {difference}")
                                    api.update_in_inventory_w_offset(barcodeData, userID, "Weight", difference)
                                    api.update_in_inventory_w_offset(barcodeData, userID, "Measured_Weight", difference)
                                    totalWeight = newTotalWeight
                                    print(f"[INFO] total weight: {totalWeight}")

                    else:   # Not in user inventory - add new item to inventory
                        print("[INFO] Item not found in user inventory. Please add new items through app.")


    except (KeyboardInterrupt, SystemExit):
        print("[INFO] Keyboard interrupt...")
    except Exception as e:
        # if error occur then this block of code is run
        print(f"[ERROR] Video and scale capture has ended due to {e}.")
    finally:
        # Do a bit of cleanup
        print("[INFO] Cleaning up and quitting...")
        videoCapture.release()
        cv2.destroyAllWindows()
        GPIO.cleanup()

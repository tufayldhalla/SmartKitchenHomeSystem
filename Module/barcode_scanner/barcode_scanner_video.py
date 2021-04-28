#!/usr/bin/python3
# import the necessary packages
from pyzbar import pyzbar
import argparse
import cv2
import os
import datetime
import time
import requests

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-o", "--output", type=str, default="barcodes.csv",
    help="path to output CSV file containing barcodes")
args = vars(ap.parse_args())

# open the output CSV file for writing and initialize the set of
# barcodes found thus far
csv = open(args["output"], "w")
found = set()

# initialise pi camera
if os.path.exists('/dev/video0') == False:
    path = 'sudo modprobe bcm2835-v4l2 '
    os.system (path)
    time.sleep(1)

# creating a video capture object
# argument 0, PiCam start
# set dimensions
# give camera sensor time to warm up
cv2.namedWindow('Frame')
video_capture = cv2.VideoCapture(0)
video_capture.set(cv2.CAP_PROP_FRAME_WIDTH, 1024)
video_capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 768)
#video_capture.set(cv.CAP_PROP_FPS, 60)
time.sleep(2.0)

# try, except, finally for handling errors
try:
    while True:
        # read a video frame by frame
        # read() returns tuple in which 1st item is boolean value
        # either True or False and 2nd item is frame of the video.
        # read() returns False when live video is ended so 
        # no frame is readed and error will be generated.
        ok, image = video_capture.read()
       
        # loop over the detected barcodes
        barcodes = pyzbar.decode(image)
        if len(barcodes) != 0:
            print (barcodes)
        for barcode in barcodes:
            # extract the bounding box location of the barcode and draw the
            # bounding box surrounding the barcode on the image
            (x, y, w, h) = barcode.rect
            cv2.rectangle(image, (x, y), (x + w, y + h), (0, 0, 255), 2)
     
            # the barcode data is a bytes object so if we want to draw it on
            # our output image we need to convert it to a string first
            barcodeData = barcode.data.decode("utf-8")
            barcodeType = barcode.type
     
            # draw the barcode data and barcode type on the image
            text = "{} ({})".format(barcodeData, barcodeType)
            cv2.putText(image, text, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX,0.5, (0, 0, 255), 2)
     
            # print the barcode type and data to the terminal
            print("[INFO] Found {} barcode: {}".format(barcodeType, barcodeData))
            
            # if the barcode text is currently not in our CSV file, write
            # the timestamp + barcode to disk and update the set
            if barcodeData not in found:
                csv.write("{},{},{}\n".format(datetime.datetime.now(), barcodeType, barcodeData))
                csv.flush()
                found.add(barcodeData)
     
     
        # show the live video frame
        cv2.imshow("Barcode Scanner", image)
        key = cv2.waitKey(1) & 0xFF
       
        # if the `q` key was pressed, break from the loop
        if key == ord("q"):
            break
  
except:
    # if error occur then this block of code is run
    print("[ERROR] Video has ended..")
    
finally:
    # close the output CSV file do a bit of cleanup
    print("[INFO] Cleaning up and quitting...")
    csv.close()
    cv2.destroyAllWindows()
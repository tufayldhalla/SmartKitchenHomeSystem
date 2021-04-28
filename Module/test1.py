import RPi.GPIO as GPIO
import time

GPIO.cleanup() 

RED_LED_PIN = 20
GREEN_LED_PIN = 21
SPEAKER_PIN = 26
BUTTON_PIN = 3

GPIO.setmode(GPIO.BCM)
GPIO.setup(SPEAKER_PIN, GPIO.OUT)

p = GPIO.PWM(26,50)
p.start(70)

p.ChangeFrequency(1800)
time.sleep(0.08)

p.stop()
time.sleep(0.08)

p.start(70)

p.ChangeFrequency(1800)
time.sleep(0.08)

p.stop()

GPIO.setup(RED_LED_PIN, GPIO.OUT)
GPIO.setup(GREEN_LED_PIN, GPIO.OUT)

GPIO.output(RED_LED_PIN, True)
GPIO.output(GREEN_LED_PIN, True)

time.sleep(2)

GPIO.output(RED_LED_PIN, False)
GPIO.output(GREEN_LED_PIN, False)

GPIO.cleanup() 


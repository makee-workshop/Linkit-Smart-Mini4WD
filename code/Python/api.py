#!/usr/bin/python
from flask import Flask
from flask import json
from flask import Response
from flask import request
import pyupm_adxl345 as adxl
import mraa
import time
import os
import threading

f = os.popen('ifconfig br-lan | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1') # AP model
#f = os.popen('ifconfig apcli0 | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1') # Station model

inet_addr = f.read()
app = Flask(__name__)
device = adxl.Adxl345(0)
pin = mraa.Pwm(18)
pin.period_ms(2)
powerOnThread = 0
videoOnThread = 0

class videoOn(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
    def run(self):
        os.system('mjpg_streamer -i "input_uvc.so -r 320x240 -f 15 -d /dev/video0" -o "output_http.so"')
        #os.system('mjpg_streamer -i "input_uvc.so -f 20 -d /dev/video0" -o "output_http.so"')

class turnOn(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
    def run(self):
        self.ifdo = True;
        while self.ifdo:
            pin.enable(True)
            device.update()
            a = device.getAcceleration()
            if a[2]>0 :
                pin.write(0.2)
                print "(x,y,z)=%5.2f, %5.2f, %5.2f" % (a[0], a[1], a[2])
            elif a[2] > -0.7 and a[2] <= 0 :
                pin.write(0.6)
                print "(x,y,z)=%5.2f, %5.2f, %5.2f" % (a[0], a[1], a[2])
            else :
                pin.write(1)
                print "(x,y,z)=%5.2f, %5.2f, %5.2f" % (a[0], a[1], a[2])
            time.sleep(0.3)
    def stop (self):
        self.ifdo = False;
        pin.enable(False)
        device.update()

def str_to_bool(s):
    if s == 'True':
         return True
    elif s == 'False':
         return False

# POST http://192.168.0.101:5000/api/v1.0/enginestatus/
@app.route("/api/v1.0/power/", methods=['POST'])
def setpower():
    if request.headers['Content-Type'] == 'application/x-www-form-urlencoded':
        isStart = str_to_bool(request.form['power'])
        global powerOnThread
        if isStart:
            powerOnThread = turnOn()
            powerOnThread.start()
            return json.dumps({"status": 200, "comment": "call set Power On Finish"})
        else:
            powerOnThread.stop()
            return json.dumps({"status": 200, "comment": "call set Power Off Finish"})
    else:
        return json.dumps({"status": 415, "comment": "Unsupported Media Type"})

# http://192.168.100.1:5000/api/v1.0/video/on
# http://192.168.100.1:8080/?action=stream
@app.route("/api/v1.0/video/on", methods=['GET'])
def setvideoon():
    global videoOnThread
    videoOnThread = videoOn()
    videoOnThread.start()
    return json.dumps({"status": 200, "comment": "call set Video Finish"})

# GET http://192.168.1.117:5000/api/v1.0/test
@app.route("/api/v1.0/test", methods=['GET'])
def settest():
    return json.dumps({"status": 200, "comment": "call test Finish"})

if __name__ == "__main__":
    #app.debug = True
    app.run(
        host = inet_addr,
        port = 5000
    )
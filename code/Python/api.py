#!/usr/bin/python
from flask import Flask
from flask import json
from flask import Response
from flask import request
import pyupm_adxl345 as adxl
import mraa
import time
import os
import thread

f = os.popen('ifconfig br-lan | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1') # AP model
#f = os.popen('ifconfig apcli0 | grep "inet\ addr" | cut -d: -f2 | cut -d" " -f1') # Station model
inet_addr = f.read()
app = Flask(__name__)
isStart = True
enginespeed = 0

device = adxl.Adxl345(0)
pin = mraa.Pwm(18)
pin.period_ms(2)

def str_to_bool(s):
    if s == 'True':
         return True
    elif s == 'False':
         return False

def videoThread():
    os.system('mjpg_streamer -i "input_uvc.so -r 320x240 -f 15 -d /dev/video0" -o "output_http.so"')
    #os.system('mjpg_streamer -i "input_uvc.so -f 20 -d /dev/video0" -o "output_http.so"')

def turnOnThread(enginestatus):
    global enginespeed
    global isStart
    while True:
        isStart = str_to_bool(enginestatus)
        pin.enable(isStart)
        if isStart:
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

# POST http://192.168.0.101:5000/api/v1.0/enginestatus/
@app.route("/api/v1.0/enginestatus/", methods=['POST'])
def setenginestatus():
    if request.headers['Content-Type'] == 'application/x-www-form-urlencoded':
        thread.start_new_thread(turnOnThread, (request.form['enginestatus'],))
        return json.dumps({"status": 200, "comment": "call set Engine status Finish"})
    else:
        thread.start_new_thread(turnOffThread, ())
        return "415 Unsupported Media Type"

# http://192.168.100.1:5000/api/v1.0/video/on
# http://mylinkit.local:8080/?action=stream
@app.route("/api/v1.0/video/on", methods=['GET'])
def setvideoon():
    thread.start_new_thread(videoThread, ())
    return json.dumps({"status": 200, "comment": "call set Video Finish"})

# http://192.168.100.1:5000/api/v1.0/video/off
@app.route("/api/v1.0/power/off", methods=['GET'])
def setvideooff():
    cleanup_stop_thread();
    #sys.exit()

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
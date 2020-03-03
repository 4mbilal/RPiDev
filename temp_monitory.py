#Credit: Keval Patel
#https://medium.com/@kevalpatel2106/monitor-the-core-temperature-of-your-raspberry-pi-3ddfdf82989f

#watch 'vcgencmd measure_temp'

import os
import time

def measure_temp():
        temp = os.popen("vcgencmd measure_temp").readline()
        return (temp.replace("temp=",""))

while True:
        print(measure_temp())
        time.sleep(1)

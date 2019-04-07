---
layout: default
title: Mission 3 (Live)
has_children: false
parent: Space Cameras
nav_order: 3
permalink: /space-camera-3
---

# Space Camera 3 (Live)

*11 Sep 2011*<br />

![Image](docs/space-cameras/3/space-camera-3-header.jpg)

-----

This mission was special as it had a live camera broadcast from the payload. It used a 5mW
transmitter on 433 MHz to send JPEGs with [forward error correction](https://en.wikipedia.org/wiki/Forward_error_correction)
down at [baud](https://en.wikipedia.org/wiki/Baud) (bits per second) levels up to 1200.

Image livestream, sending the largest, highest, fastest images ever sent in realtime from the stratosphere by amateurs, with 10mW of radio power – as much as a single LED. We had two payloads attached to a weather balloon, and reached 36km altitude. We sent out and received live images as it was flying, plus GPS information, that everyone could receive and automatically post online for everyone to see – in real time! All scripts, PCB designs, etc, are all available for you under a creative commons licence. I’ll be posting those later. Feel free to leave a comment below, providing some feedback, e.g. stating what we can do better next launch, what sensors you would like to see in them, etc!

<iframe width="560" height="315" src="https://www.youtube.com/embed/2jlkxkstruI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Flight Statistics

Cost |	€150 (just helium+balloon)
Launch |	12:36 (11-09-2011 Delft Netherlands)
Touchdown |	15:00 (11-09-2011 Heereveen Friesland)
Burst |	14:26
Recovery |	15:55
Flight Time |	2h24m
Max. Altitude |	35.748 m (#28 arhab record)
Total Weight |	~1300g
Main Payload |	Beagleboard/GPS/GPRS/Webcam/Radio
Backup Payload |	Arduino/GPS/GPRS/Cutdown
Cutdown |	Yes, Hot-Wire
Pictures Taken |	1731 Pictures
Pictures Sent Live |	123 Pictures
Pictures Received Live |	119 Pictures
Data Received Live |	6.000.000 bits
Max Data Rate |	1.200 bits/s
Largest image sent live |	800×592 px (#1 record)
3D Distance Traveled |	205 km
Minimum inside temp |	+5°C
Radio Power |	10mW (434.653MHz, 8n2)

![Image](docs/space-cameras/3/space-camera-3-sensor.png)
<br>
_You can clearly see a steady velocity in height. The temperature data is from the backup-payload inside the plastic container. This confirms my theory that you dont need to worry about isolation for temperature, as there is little mass to transfer the cold at -50C at 30km altitude._

## Images

![Image](docs/space-cameras/3/space-camera-3-touchdown-pic-1.jpg)
<br>_From the outside of a building, we saw the parachute danling on the building_

![Image](docs/space-cameras/3/space-camera-3-recovery-security-guys.jpg)
<br>_When we found the payload (observe the security guys in the back) it was still taking pictures_

![Image](docs/space-cameras/3/space-camera-3-live-image-1.jpg)
<br>_A live image_

![Image](docs/space-cameras/3/space-camera-3-live-image-2.jpg)
<br>_A live image_

![Image](docs/space-cameras/3/space-camera-3-live-image-3.jpg)
<br>_A live image_

![Image](docs/space-cameras/3/space-camera-3-payload-1.jpg)
<br>_The main payload_

![Image](docs/space-cameras/3/space-camera-3-payload-2.jpg)
<br>_Contents of the payload_

![Image](docs/space-cameras/3/space-camera-3-payload-cutdown-1.jpg)
<br>_The secondary payload was a cutdown mechanism_

![Image](docs/space-cameras/3/space-camera-3-payload-cutdown-2.jpg)
<br>_Contents of the cutdown mechanism_

![Image](docs/space-cameras/3/space-camera-3-route-kml.png)
<br>_The full route. Notice the GPS height cut off at 35km [due to international regulations](https://en.wikipedia.org/wiki/Coordinating_Committee_for_Multilateral_Export_Controls)._

## Live transmission

**1700 images taken, 123 images sent.**
Sending an image took between 10seconds and 60 seconds. Within the time of sending an image, the webcam had taken much more. So, which one should it send next? The latest? No. Logically it would be, the prettiest or the best. So i made a simple algorithm that chooses the best image from two factors: (1) a mean grey value (2) a 8-bit standard deviation of ideally 30, so, not too much deviation in the image, but also not too little. You can read all about that algorithm in my post here. http://www.youtube.com/watch?v=jOAaTMMmrrA

<iframe width="560" height="315" src="https://www.youtube.com/embed/17BuY8hMTFw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
_Explanation of live image transfer_

## Media

<iframe width="560" height="315" src="https://www.youtube.com/embed/kt0gsJFKMOk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
_Stereo video of the recovered payload_


## Resources

TODO(tzaman)

---
layout: default
title: RTI Dome
has_children: false
nav_order: 13
permalink: /rti-dome
---

# Reflectance Transformation Imaging (RTI) Dome

*2015*<br />

![Image](docs/rti-dome/rti-dome-da-vinci.jpg)
*Scanning Da Vinci drawings in Windsor Castle (UK)*

-----

For fun, I made a RTI (Reflectance Transformation Imaging) Dome (geodesic semi-hemisphere).
What it does, is very simple. It creates an image which resemblance is computed a function of the
direction of the incoming light. So other than a normal picture, you can change the direction of
the light after the fact. This is actually super interesting if you care about subtle surface
topology, as you can compute material properties and surface normals, which can then be used to
calculate depth (by integration).

The files it creates can be stored in PTMs
([Polynomial Texture Maps](https://en.wikipedia.org/wiki/Polynomial_texture_mapping)).

Such domes are usually super expensive, tens of thousands of dollars, and they are clunky and
usually of poor hand-made quality. Because I have knowledge of both software and hardware, I decided
to make some software and printed circuit boards, and come up with an awesome and simple design.

The dome costs less than $100 dollars total to make. Disassembled, it fits in your pocket, and can
be mounted on any DSLR camera. I've used it to scan Aztec Codices and works by Michelangelo, Rafael
and Da Vinci.

<iframe width="736" height="414" src="https://www.youtube.com/embed/DpaUrq2ZhVw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
*Recto: Sketches for the Last Supper, and other studies. Verso: Calculations with architectural, engineering, and geometric sketches c.1492-4*

## Introduction

As with any design, it took a few iterations to get it right. I started with a transparent plastic
half-dome that i spray painted black with tar. I put some LEDs on the inside, and a massive 10x10"
(30x30cm) printed circuit board.

<img src="docs/rti-dome/picturae-dome/picturae-dome-pcb.jpg" width="256"/>
<img src="docs/rti-dome/picturae-dome/picturae-dome-setup.jpg" width="256"/>
<img src="docs/rti-dome/picturae-dome/picturae-dome-leds.jpg" width="256"/>

*Above was my first design. Took ages too construct.*

## Construction

I made two versions of the 'mini rti dome'. One that used some 3D printed components, and one without.
The one with the 3D printed components wasn't stiff anough, while the other (2nd design) was rock
solid. The following pictures I intermixed the two, but the idea is the same.

![Image](docs/rti-dome/rti-dome-step-1.jpg)
*The dome consist entirely out of printed circuit boards*

![Image](docs/rti-dome/rti-dome-step-2.jpg)
*Stitch them all up in a pattern*

![Image](docs/rti-dome/rti-dome-step-3.jpg)
*Finally put them together as a dome*

![Image](docs/rti-dome/rti-dome-step-4.jpg)
*Daisy chain the connections*

![Image](docs/rti-dome/rti-dome-step-5.jpg)
*Add (3D printed) camera mount and camera.*

![Image](docs/rti-dome/rti-dome-step-6.jpg)
*Scan works by Da Vinci*

## Video

I've made a small video to introduce how this thing works. The quality of the video is terrible,
and I'm even speaking Dutch, apologies.
736
<iframe width="736" height="414" src="https://www.youtube.com/embed/Q8Gc7evFmnI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Results

![Image](docs/rti-dome/alan-da-vinci.jpg)
*Windsor Castle head of collection Alan Donnithorne introducing a drawing Da Vinci*


<iframe width="736" height="414" src="https://www.youtube.com/embed/1lxpLe7iEG4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
RTI of a portion of item 912616.
(c) Windsor Castle, Paper Conservation
This is an image of a drawing by **Leonardo Da Vinci**, where he has studied hands. You can see several fingers in the image. It was drawn with a silver-point pensil. The silver is gone, but the indentation, as you can see, remains.

TODO(tzaman): add some RTI images here

## Resources

* [C++ code](https://github.com/TimZaman/rti), with OpenCL optimization.

### Component A

Download Gerbers: ([zip](docs/rti-dome/rti-mini-dome_A_v2.zip))

<img src="docs/rti-dome/A/minidome_A_v1.GTS.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GTP.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GTO.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GTL.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GML.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GBS.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GBP.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GBO.png" width="256"/>
<img src="docs/rti-dome/A/minidome_A_v1.GBL.png" width="256"/>

### Component B

Download Gerbers: ([zip](docs/rti-dome/rti-mini-dome_B_v2.zip))

<img src="docs/rti-dome/B/minidome_B_v1.GTS.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GTP.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GTO.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GTL.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GML.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GBS.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GBP.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GBO.png" width="256"/>
<img src="docs/rti-dome/B/minidome_B_v1.GBL.png" width="256"/>

---
title: 3D Scanning Paintings
has_children: false
nav_order: 30
permalink: /3d-scanning-paintings
---

# 3D Scanning

*2013*<br />

-----

For my MSc thesis [(pdf)](https://repository.tudelft.nl/islandora/object/uuid:bd71a192-eaa8-4f90-8778-b18f86cac79c)
I developed a super-high resolution, large-format 3D scanner, especially suited to 3D-scan paintings.
This was a succesful project, we scanned and printed many paintings by Rembrandt and Van Gogh,
developed into a commercial project, and got a ton of international media coverage. However, I was
not interested in any exploitation of this project, I moved on after I did the tech.

<iframe width="560" height="315" src="https://www.youtube.com/embed/EXRt64HEBrk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Paintings are not unlike sculptures, paint as a material has a huge impact on the way a painting looks. By illuminating a painting with light, it automatically gives highlights and shadows that form the way we see it. This is especially the case in the of late Rembrandt paintings and Van Gogh. This fact is often overlooked or not fully appreciated. In order to capture this topography convincingly, we needed to capture it in a very high resolution, which is already a problem for most 3-D scanners. Furthermore, the topography of the paint is very small compared to the size of the canvas and we want to capture color at the same time as we capture depth. This depth data is relevant for conservators and restorers (think of status-reports or analytical information about the craquela) and could in principle be used for exploitation using the museum shops (note that we as a university do not pursue this).

![Image](docs/3d-scanning/3d-scanning-schematic-sunday-times.jpg)
*Schematic of our scanning setup (c) Sunday Times*

Although such a print might fool the regular observer, anyone with knowledge of paintings will immediately see that this is not painted with a brush. (Anyone with a microscope will see its drops painted mechanically with a nozzle.) If you consider such a print light-years ahead of a common poster reproduction, it is still light-years away from the original. We noticed that things like glossiness and transparency that are in each painting are very distinguishing in the original, and we are not yet able to reproduce. We are now working on further research in trying to model these facts as well. The goal of making such accurate reproductions, and comparing them with the original, is that we learn to understand exactly what we are looking at, and why it looks the way it does. What we learned so far is that there are many more elements that make the painting look the way it does, a part from the color and topography, that have an importance that we did not anticipate.

![Image](docs/3d-scanning/3d-scanning-drawing-tedxdelft-djvdt.png)

## Scanning Equipment
The scanning equipment is actually very straightforward, and only consists out of these parts. The rest of the parts is just cables and stuff to make the camera move in X and Y.
Capture device	Nikon D800E
Lenses	Nikon 80mm PC-E scheimpflug & polarisation filters
Projector	

## 3D Scanning

See my thesis (linked to earlier) for comprehensive information. We used a hybrid system using stereo vision (2 camera’s) and fringe projection (using a projector). This system gives us unrivaled detail and capture speed, capturing 40 million points per capture, each point in 3-D space (XYZ) and in full color (RGB). Multiple captures allows us to capture the Jewish Bride for instance, a work that spans 160×120 cm; giving us more than a billion XYZ/RGB points. This is all done with proprietary camera’s that anyone can buy off-the shelf. 

![Image](docs/3d-scanning/3d-scan-setup-rembrandt.jpg)

## 3D Printing

Printer and 3D printing technology (c) 2013 Océ (Canon Group). I was not directly involved in the development of the printer or the 3D pritning process. Nor did i push any buttons on the printer. The whole data-to-print part was all done by Océ. 3D Printing Technology by High Resolution Océ 3-D Fine Art Reproductions. Printer by and with 3-D printing technology from Océ. Video (c) Océ, and if shown, should be shown in entirety including proper attributions including the Océ trademark. 

![Image](docs/3d-scanning/3d-painting-TEDxDelft-2013.jpg)

## BBC

<iframe width="560" height="315" src="https://www.youtube.com/embed/er5N1Zv3oac" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Timelapse

<iframe width="560" height="315" src="https://www.youtube.com/embed/EK-XtJopV_s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
*Scanning a Van Gogh at the Kroller Muller Museum*

## Topology Renders

<iframe width="560" height="315" src="https://www.youtube.com/embed/nDmgI4tMXto" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/owSUQ3rB-MA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Resources

[MSc Thesis(pdf)](https://repository.tudelft.nl/islandora/object/uuid:bd71a192-eaa8-4f90-8778-b18f86cac79c)

TODO(tzaman): Add publications around this

TODO(tzaman): Add Matlab code

TODO(tzaman): Add C++ code

TODO(tzaman): Add pcb (gerber) files


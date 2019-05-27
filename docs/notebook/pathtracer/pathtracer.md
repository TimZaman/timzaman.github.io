---
layout: default
title: Pathtracer
has_children: false
parent: Notebook
nav_order: 1
permalink: /pathtracer
---

# Pathtracer

*2018 APRIL*<br />

![Image](docs/notebook/pathtracer/pathtracer_opengl-3d.png)

-----

Recently, there has been a revival of raytracing and pathtracing. NVIDIA has kicked this off and
shown that the time is right. In order for me to really appreciate what raytracing is and how it
works, I'd need to write my own. I can only really understand something if I do it myself. Just
reading about something usually leaves me with too many questions.

So I decided to make pathtracer with only triangular primitives.

The only way to do so, is to visually verify that things are right. Knowing myself, I needed to
have some debugger. Therefore, I decided to make a system that has a small adapter to OpenGL that
renders my object primitives, and the camera in an OpenGL 3D environment so I can see what's going
on. The pathtracer rendering screen is also rendered inside this OpenGL world.

Here is a video to show it in action:

<iframe width="560" height="315" src="https://www.youtube.com/embed/FdaJnSDYsBc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

This pathtracer does around 0.00001 frames per second on 1080p resolution without much noise.
Clearly I cannot be accused of early optimization.

## Progress

![Image](docs/notebook/pathtracer/pathtracer_1.png)<br />
_Started with a *ray*tracer, and rendered the triangle._

![Image](docs/notebook/pathtracer/pathtracer_2.png)<br />
_Put a few triangles in the world, added illumination and color properties._

![Image](docs/notebook/pathtracer/pathtracer_3.png)<br />
_Added perspective. This render took around an evening._

![Image](docs/notebook/pathtracer/pathtracer_4.png)<br />
_My (shabby..) take on the [Cornell Box](https://en.wikipedia.org/wiki/Cornell_box)._


## Resources

* [Code](https://github.com/TimZaman/pathtracer) (GitHub

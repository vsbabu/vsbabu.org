+++
title = "Customize your Video on Conferencing"
date = 2020-04-12T08:00:00+05:30
description = "World is doing WFH and Video Conferencing. Let us make it a bit more private"
weight = 1
draft = false
in_search_index = true
[taxonomies]
categories = ["snippet"]
tags = [ "work", "linux",  "snippet"]
+++

For the last few weeks, whole world has been under various measures of lockdown. WFH (Working from home)
and VC (Video Calls) have been the norm. One of the pet peeves I had with various VC tools used (Google
Meet, Zoom etc) is that there is zero customization offered on choosing the output feed from your camera.

For most video calls, just face is enough - why bother with rest of the image? It also helps you in summer
to be little more relaxed with informal clothing; plus cute moments like children running into video feed
can be avoided. 

This is what I got my feed to be - read below on how to set it up.

![this should do it!](01.png)
<!-- more -->
Overall approach is to make a virtual camera and a filter that sits between real device and the virtual camera.
Then, in your VC software, choose the virtual camera.

In Linux, we have all the tools readily available.

## Tools

[WebCamoid](https://webcamoid.github.io/) takes care of everything. I downloaded the AppImage, put it in my path
 and started it from command line.

Now, this doesn't create a virtual camera just like that. You need to enable [virtual camera support](https://github.com/webcamoid/webcamoid/wiki/Virtual-camera-support). I downloaded [akvcam](https://github.com/webcamoid/akvcam). Compiling
and installing it is very easy and instructions are on the site. It should work on OSX also, but I have not
experimented with these.

## Setup

1. Start WebCamoid. Click on the gear icon for _Preferences_ and choose _Output_. Check the _Virtual Camera_
checkbox and add a new _Virtual Camera_ - give it an easy to remember name.

2. Now, click on the _Play_ button on the left of the toolbar - it starts the video feed. Click on _Effects_
and choose the desired effect. The one above is _Vignette_. Chosen effect has configurations on the 
right side - play with it.

3. Now, choose your VC. When you turn on the Video there, instead of regular camera, choose the virtual
camera you created. 

Done!

After that, whenever you change the effect in WebCamoid, it will be automatically applied. 

Like below :)
![pixelate](02.png)

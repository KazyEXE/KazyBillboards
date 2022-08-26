# KazyBillboards
2D Vertical Billboard Shader compatible with VRChat.

Created for my VRChat port of the AlphaWorld GZ from ActiveWorlds. They have 2D trees there that I could not find a working billboard shader for. They would either morph weirdly when you tilted your head, or have this weird bug where they all rendered along the same plane. 

This is the main shader it is based off of:
https://forum.unity.com/threads/cylindrical-billboard-shader-shader-for-billboard-with-rotation-restricted-to-the-y-axis.498406/

However, it did not support Alpha, and had the glitchy rendering issue.

To add Alpha, I followed a forum post which referred to this guide:
https://en.wikibooks.org/wiki/Cg_Programming/Unity/Transparent_Texture

This added Alpha, but if I had more than a certain amount of objects that used this material on screen, they would all render along a single plane and follow my head when I turned. To get around this, I looked at the code for several shaders that didn't have this issue (but had the head-tilting issue), and added several of the tags they used. I don't know which exactly fixed that, but it was either "IgnoreProjector"="True" or "DisableBatching"="True"

Anyway, this took several days of troubleshooting and trial and error, so I wanted to throw this out there in case anyone else is looking for this type of shader. Again, I am not a developer and do not completely understand all aspects of this code (though I more or less know the gist of what each section is doing), so this shader could probably use a lot of optimization. Feel free to submit pull requests if you find some way to make it better, or hit me up on Twitter, @KazyEXE


If you like this, feel free to leave a tip at paypal.me/KazyEXE

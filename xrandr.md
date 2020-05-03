
                                  _      
        __  ___ __ __ _ _ __   __| |_ __ 
        \ \/ / '__/ _` | '_ \ / _` | '__|
         >  <| | | (_| | | | | (_| | |   
        /_/\_\_|  \__,_|_| |_|\__,_|_|   
                                        

## Using xrandr (resize and rotate)

Xrandr is a powerful tool to configure screen resolution. Linux let us configure our screen resolution selecting it from a wide range of options. Sometimes OS do not recognize certain resolutions or sets the wrong resolution. But with this tool we can render the perfect resolution for our monitor.


    antonio (master) linux $ xrandr
    Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 16384 x 16384
    VGA-1 disconnected (normal left inverted right x axis y axis)
    HDMI-1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 527mm x 296mm
        1920x1080     60.00*+  50.00    59.94  
        1920x1080i    60.00    50.00    59.94  
        1600x1200     60.00  
        1600x900      60.00  
        1280x1024     75.02    60.02  
        1152x864      75.00  
        1280x720      60.00    50.00    59.94  
        1024x768      75.03    60.00  
        800x600       75.00    60.32  
        720x576       50.00  
        720x480       60.00    59.94  
        640x480       75.00    60.00    59.94  
        720x400       70.08 


    
    antonio (master) linux $ xrandr -s 1920x1080 -r 60

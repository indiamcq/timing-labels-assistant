# timing-labels-assistant
Timing Labels Assistant for use with Audacity to produce timings for SAB

##### A macro tool to speedup adding timing points and labels into an Audacity label track from a Scripture App Builder generated phrases file.

## Once only setup:

Put the file in a writable folder, not in a subdirectory of Program Files.

After starting the file the first time, it brings up a Select the default phrases folder dialog. This is to populate an ini file in the same folder. 

You may want to change the location of the phrases file path in the ini file for the next book or language.

## Normal usage:
  * Start the file by double clicking it.
  * Select the phrase file to use with the audio you are segmenting.

### Methods of use
  1 If you like listening to the file and inserting a timing point on the fly then just press [tab] or backslash [\\] or Numberpad plus [+] key. The timing point is added and the relevant reference 1a is inserted. Pressing again will insert the next point at that playback point and add the next label from the phrase file.

  2 If you like the guess timing points by the WAV form shape, then just right mouse click where you want the timing point and it will be added with the label.
  
You can mix the methods together if you like.

### New "Re-start at" option

You can now restart labeling if you quit part way through a previous session. Find the Timing-Labels-Assistant icon in the system tray or the System Tray overflow area and left click on it and select the bottom menu item, **Re-start timing at label? i.e. 5c**. The next label to be inserted will be the one you selected. If you typed a label that does not exist then it will ask you to try again.

### Pause or exit
  * Windows + p suspends the clip
  * Typing zx exits the macro program.
  * Left click in the icon in the taskbar and click Exit.
  * If no Audacity is open and you press any hot key the program will exit

This is a no going back method, if the timing is wrong, don't delete it, just move it to the right place. Click the mouse in the circle part of the timing point, then drag the point to the correct place.

When the last reference is found it is inserted then the program issues a beep then exits.

The EXE is on Github [Timing-Labels-Assistant.exe](https://github.com/indiamcq/timing-labels-assistant/blob/exitIfNoAudacity/current/Timing-Labels-Assistant.exe) v1.2


Ian 

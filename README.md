RTC Patch for Pokemon Crystal/Gold/Silver
=========================================


disassembled from:<br>
https://www.infine.st/<br>
https://www.romhacking.net/hacks/4450/<br>

Thank you infinest for the original patch.

"This patch allows the player to change the real-time clock while in the Pokegears clock menu.<br>
Simply press up to advance and down to turn back the time.<br>
Holding the A button allows you to change it faster."

The disassembly uses RGBDS's [RGBLINK overlaying features](https://rgbds.gbdev.io/docs/v0.7.0/rgblink.1#O).<br>
Thanks to [marcobledo's batteryless patcher](https://github.com/marcrobledo/game-boy-batteryless-patcher) for an example how to use it.

How to build roms/patches
------
1. get a pokemon crystal/gold/silver rom and save it to roms/<subdir>/input.gbc
2. install rgbds and flips
3. run make
<br>
instead of running make, you can build it manually:

```
rgbasm -opokegold_rtc.o --define _RTC --preinclude roms/pokegold/settings.asm src/main.asm
rgblink -o pokegold_rtc.gbc -O roms/pokegold/input.gbc pokegold_rtc.o
rm pokegold_rtc.o
rgbfix -p0 -v pokegold_rtc.gbc
flips --create --bps roms/pokegold/input.gbc pokegold_rtc.gbc pokegold_rtc.bps
```

How to add new targets
------

to build a new target you need to do the following things
- create a folder in roms/
- place a roms/<foldername>/input.gbc file
- create a roms/<foldername>/settings.asm file
- rtc patches are only created, if _RTC is found in settings.asm
- batteryless patches are only created, if _BATTERYLESS is found in settings.asm

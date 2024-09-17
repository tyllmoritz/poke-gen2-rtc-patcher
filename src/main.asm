
IF DEF(_RTC)
INCLUDE "src/rtc.asm"
ENDC

IF DEF(_BATTERYLESS)
INCLUDE "src/batteryless.asm"
ENDC

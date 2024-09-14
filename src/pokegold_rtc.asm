; RTC Patch for Pokemon Gold
; --------------------------
; disassembled from:
; https://www.infine.st/
; https://www.romhacking.net/hacks/4450/
; --------------------------
; This patch allows the player to change the real-time clock while in the Pokegears clock menu.
; Simply press up to advance and down to turn back the time.
; Holding the A button allows you to change it faster.

; Patch to "Pokemon - Gold Version (USA, Europe) (SGB Enhanced).gbc"
; MD5: a6924ce1f9ad2228e1c6580779b23878
; SHA-1: d8b8a3600a465308c9953dfa04f0081c05bdcb94
; SHA-256: fb0016d27b1e5374e1ec9fcad60e6628d8646103b5313ca683417f52b97e7e4e



DEF _JUMP_OPTIMISATION EQU 1

DEF Bank0_FreeSpace_0 EQU $0051
DEF Bank0_FreeSpace_1 EQU $0063
DEF Bank0_FreeSpace_2 EQU $009b

DEF hJoypadDown EQU $ffa6
DEF wStartDay_ EQU $d1dc
DEF wScriptFlags EQU $d15b
DEF wSpriteAnimAddrBackup EQU $c5c0
DEF wSpriteAnimAddrBackup_Value EQU $c5
DEF wJumptableIndex EQU $ce63

DEF UpdateTime_FixTime_ EQU $046d
DEF FixTime_ EQU $04de
DEF PokegearClock_Joypad_buttoncheck_ EQU $4f0e
DEF PokegearClock_Joypad_BANK EQU $24

INCLUDE "src/rtc.asm"

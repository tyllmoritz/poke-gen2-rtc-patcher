; RTC Patch for Pokemon Crystal
; --------------------------
; disassembled from:
; https://www.infine.st/
; https://www.romhacking.net/hacks/3841/
; --------------------------
; This patch allows the player to change the real-time clock while in the Pokegears clock menu.
; Simply press up to advance and down to turn back the time.
; Holding the A button allows you to change it faster.

; Patch to "Pokemon - Crystal Version (USA, Europe).gbc"
; MD5: 9f2922b235a5eeb78d65594e82ef5dde
; SHA-1: f4cd194bdee0d04ca4eac29e09b8e4e9d818c133
; SHA-256: d6702e353dcbe2d2c69183046c878ef13a0dae4006e8cdff521cca83dd1582fe

DEF _CRYSTAL EQU 1

DEF Bank0_FreeSpace_0 EQU $0063
DEF Bank0_FreeSpace_1 EQU $3fb5
DEF Bank0_FreeSpace_2 EQU $0069

DEF hJoypadDown EQU $ffa4
DEF wStartDay_ EQU $d4b6
DEF wScriptFlags EQU $d434
DEF wSpriteAnimAddrBackup EQU $c3b8
DEF wSpriteAnimAddrBackup_Value EQU $c3
DEF wJumptableIndex EQU $cf63

DEF UpdateTime_FixTime_ EQU $05ad
DEF FixTime_ EQU $061d
DEF PokegearClock_Joypad_buttoncheck_ EQU $4F45
DEF PokegearClock_Joypad_BANK EQU $24

INCLUDE "src/rtc.asm"

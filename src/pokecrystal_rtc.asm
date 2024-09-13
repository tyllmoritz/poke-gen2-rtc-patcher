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


DEF A_BUTTON   EQU 1 << 0
DEF B_BUTTON   EQU 1 << 1
DEF SELECT     EQU 1 << 2
DEF START      EQU 1 << 3
DEF D_RIGHT    EQU 1 << 4
DEF D_LEFT     EQU 1 << 5
DEF D_UP       EQU 1 << 6
DEF D_DOWN     EQU 1 << 7

DEF hJoypadDown EQU $ffa4

SECTION "WRAM - Time", WRAMX[$d4b6], BANK[$1]
; init time set at newgame
wStartDay::    db
wStartHour::   db
wStartMinute:: db
wStartSecond:: db





SECTION "ROM - Bank 0 free space #1", ROM0[$3fb5]
ChangeTimeInPokegear:
ld a,[$cfb9] ; is  wFarCallBC = $c5 ?
; TODO: use wSpriteAnimAddrBackup + 1 instead - as in gold and silver
cp a,$c5
jr z,.3fbf
jp FixTime
.3fbf
ld a,[$cf63] ; is wJumptableIndex = 1 ?
cp a,1
jr z,.3fc9
jp FixTime
.3fc9
ld a,[$d434] ; is wScriptFlags = 4 ?
cp a,4
jr z,.checkAButton
jp FixTime
.checkAButton
ld b,1
ldh a,[hJoypadDown]
and a,A_BUTTON
jr z,.checkUpButton
ld b,8
.checkUpButton:
ldh a,[hJoypadDown]
and a,D_UP
jr z,.checkDownButton
call increaseTime
jp FixTime
.checkDownButton
ldh a,[hJoypadDown]
and a,D_DOWN
jr z,.noChange
call decreaseTime
.noChange:
jp FixTime


SECTION "ROM - Bank0 free space #2", ROM0[$0065]
increaseTime:
ld a,[wStartMinute]
add b               ; increase Minutes
cp a,60
jr nc,.nextHour
ld [wStartMinute],a
ret
.nextHour:
xor a               ; set to 00 Minutes
ld [wStartMinute],a
ld a,[wStartHour]
add a,01            ; at the next Hour
cp a,24
jr nc,.nextDay
ld [wStartHour],a
ret
.nextDay:
xor a               ; set to 00 Hours
ld [wStartHour],a
ld a,[wStartDay]
add a,01            ; at the next Day
cp a,7
jr nc,.nextWeek
ld [wStartDay],a
ret
.nextWeek:
xor a               ; set to first day of Week
ld [wStartDay],a
ret

decreaseTime:
ld a,[wStartMinute]
sub b               ; decrease Minutes
jr c,.previousHour
ld [wStartMinute],a
ret
.previousHour:
ld a,59             ; set to 59 Minutes
ld [wStartMinute],a
ld a,[wStartHour]
sub a,1             ; at the previous Hour
jr c,.previousDay
ld [wStartHour],a
ret
.previousDay:
ld a,23             ; set to 23 Hours 
ld [wStartHour],a
ld a,[wStartDay]
sub a,1             ; at the previous Day
jr c,.previousWeek
ld [wStartDay],a
ret
.previousWeek:
ld a,6              ; set to last Day of Week
ld [wStartDay],a
ret



SECTION "UpdateTime: change jump", ROM0[$05ad]
;UpdateTime::
;   call GetClock
;   call FixDays
UpdateTime.fixTime:         ; <- new at 00:05ad
;   call FixTime            ; <- orig code - is overwritten
    call ChangeTimeInPokegear ; <- new  code
UpdateTime.afterFixTime:    ; <- new at 00:05b0
;   farcall GetTimeOfDay
;   ret


SECTION "FixTime", ROM0[$061d]
FixTime:
    ;orig code unmodified - only for Label


SECTION "PokegearClock_Joypad: overwrite exit Buttons", ROMX[$4F45], BANK[$24]

;PokegearClock_Joypad:
;   call .UpdateClock
;   ld hl, hJoyLast
;   ld a, [hl]
PokegearClock_Joypad.buttoncheck:               ; <- new at 24:4F45
;   and A_BUTTON | B_BUTTON | START | SELECT    ; <- orig code - is overwritten
    and B_BUTTON | START | SELECT               ; <- new  code
;   jr nz, .quit
;   ld a, [hl]
;   and D_RIGHT
;   ret z
;   ld a, [wPokegearFlags]
;   bit POKEGEAR_MAP_CARD_F, a
;   jr z, .no_map_card
;   ld c, POKEGEARSTATE_MAPCHECKREGION
;   ld b, POKEGEARCARD_MAP
;   jr .done

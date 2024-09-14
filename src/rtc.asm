DEF A_BUTTON   EQU 1 << 0
DEF B_BUTTON   EQU 1 << 1
DEF SELECT     EQU 1 << 2
DEF START      EQU 1 << 3
DEF D_RIGHT    EQU 1 << 4
DEF D_LEFT     EQU 1 << 5
DEF D_UP       EQU 1 << 6
DEF D_DOWN     EQU 1 << 7


IF DEF(_JUMP_OPTIMISATION)
SECTION "ROM - Bank 0 free space #0", ROM0[Bank0_FreeSpace_0]
FixAndUpdateTime:
call FixTime                 ; orig unmodified function
jp UpdateTime.afterFixTime   ; in UpdateTime (after our modified call to FixTime - run farcall GetTimeOfDay, then ret)
ENDC

SECTION "ROM - Bank 0 free space #1", ROM0[Bank0_FreeSpace_1]
ChangeTimeInPokegear:

IF DEF(_JUMP_OPTIMISATION)
ld hl,FixAndUpdateTime
ENDC

IF DEF(_CRYSTAL)

ld a,[wFarCallBC] ; TODO: use wSpriteAnimAddrBackup + 1 instead - as in gold and silver
cp a,$c5
jr z,.continue1
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC

.continue1
ld a,[wJumptableIndex]
cp a,1
jr z,.continue2
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC

.continue2
ld a,[wScriptFlags]
cp a,4
jr z,.checkAButton
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC

ELSE

ld a,[wScriptFlags]
cp a,4
jr z,.continue1          ; continue or
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC

.continue1:
ld a,[wSpriteAnimAddrBackup + 1]
cp a,$c5
jr z,.continue2          ; continue or
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC

.continue2:
ld a,[wJumptableIndex]
cp a,1
jr z,.checkAButton  ; continue or
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC

ENDC

.checkAButton:
ld b,1
ldh a,[hJoypadDown]
and a,A_BUTTON
jr z,.checkUpButton
IF DEF(_CRYSTAL)
ld b,8
ELSE
ld b,5
ENDC
.checkUpButton:
ldh a,[hJoypadDown]
and a,D_UP
jr z,.checkDownButton
call increaseTime
IF DEF(_JUMP_OPTIMISATION)
ELSE
jp FixTime
ENDC
.checkDownButton
ldh a,[hJoypadDown]
and a,D_DOWN
jr z,.noChange
call decreaseTime
.noChange:
IF DEF(_JUMP_OPTIMISATION)
jp hl               ; jump to FixAndUpdateTime
ELSE
jp FixTime
ENDC


SECTION "WRAM - Time", WRAMX[wStartDay_], BANK[$1]
; init time set at newgame
wStartDay::    db
wStartHour::   db
wStartMinute:: db
wStartSecond:: db

SECTION "ROM - Bank 0 free space #2", ROM0[Bank0_FreeSpace_2]
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



SECTION "UpdateTime: change jump", ROM0[UpdateTime_FixTime_]
;UpdateTime::
;   call GetClock
;   call FixDays
UpdateTime.fixTime:
;   call FixTime            ; <- orig code - is overwritten
IF DEF(_JUMP_OPTIMISATION)
    jp ChangeTimeInPokegear ; <- new  code
ELSE
    call ChangeTimeInPokegear
ENDC
UpdateTime.afterFixTime:
;   farcall GetTimeOfDay
;   ret


SECTION "FixTime", ROM0[FixTime_]
FixTime:
    ;orig code unmodified - only for Label

SECTION "PokegearClock_Joypad: overwrite exit Buttons", ROMX[PokegearClock_Joypad_buttoncheck_], BANK[PokegearClock_Joypad_BANK]

;PokegearClock_Joypad:
;   call .UpdateClock
;   ld hl, hJoyLast
;   ld a, [hl]
PokegearClock_Joypad.buttoncheck:
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

; ****************************************
; *** DEFINITIONS & ROM INITIALIZATION ***
; ****************************************

.MEMORYMAP
    DEFAULTSLOT 1
    SLOTSIZE $4000
    SLOT 0 $0000
    SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 32                    ; 32 banks
.ROMSIZE 4
.ROMGBCONLY                     ; Writes $C0 ("GBC only") into $0143 (CGB flag)
.CARTRIDGETYPE $1B				; MBC5 + RAM + Battery
.COMPUTEGBCOMPLEMENTCHECK       ; Computes the ROM complement check ($014D)
.COMPUTEGBCHECKSUM              ; Computes the ROM checksum ($014E-$014F)

.BACKGROUND "Final Fantasy Legend II (USA).gb"

.NAME "SAGA2 DX"
;.UNBACKGROUND $3FF9 $3FFF       ; Free space in bank $00
.UNBACKGROUND $7E28 $7FFF       ; Free space in bank $01
;.UNBACKGROUND $FFC0 $FFFF       ; Free space in bank $03
;.UNBACKGROUND $27E01 $27FFF     ; Free space in bank $09
;.UNBACKGROUND $2FFCF $2FFFF     ; Free space in bank $0B
;.UNBACKGROUND $33FF3 $33FFF     ; Free space in bank $0C
;.UNBACKGROUND $360DB $363FF     ; Free space in bank $0D
.UNBACKGROUND $37F00 $37FFF     ; Free space in bank $0D
;.UNBACKGROUND $3BFE8 $3BFFF     ; Free space in bank $0E
.UNBACKGROUND $3FD2D $3FFFF     ; Free space in bank $0F

.include "macros.asm"			; Macros 

.include "definitions.asm"		; Definitions
.include "system.asm"
.include "font.asm"
.include "palettes.asm"
.include "metatiles.asm"
.include "menu.asm"
.include "battle.asm"
.include "sprites.asm"
.include "transition.asm"
.include "intro.asm"
.include "title.asm"

;TODO: Transition out of final dungeon is broken _SOMETIMES_.  Ugh.
;TODO: Flare flickers, but it kinda looks cool.

.BANK $1F SLOT 1
.ORGA $7FFF
.SECTION "The End" OVERWRITE
    .db $FF
.ENDS

;00000 Main code
;04000 Unknown
;08000 Map tiles
;0c000 Sprites
;10000 Font/Title Image/Ending Image/Effect Sprites
;14000 Monsters
;18000 Monsters
;1C000 Unknown
;20000 Unknown
;24000 Unknown
;28000 Unknown
;2C000 Unknown
;30000 Unknown
;34000 Unknown
;38000 Unknown
;3C000 Unknown

;0000 HL = HL + A
;0008 ?
;0010 WaitVBlank?
;0018 Call sprite OAM DMA ($FF80)
;0020 ?
;0028 bankswitch a:bank
;0030 ?
;0038 wait for interrupt

;006C memclr hl:addr b:count
;0072 memclr hl:addr bc:count
;0073 memset a: value hl:addr bc:count
;0080 memcpy hl:source de:destination b:count
;0089 memcpy hl:source de:destination bc:count
;00C3 banked memcpy? hl:source de:destination a:bank b:count
;00CA banked memcpy? hl:source de:destination a:bank bc:count
;04F4 disable RAM, enable interrupts
;04FB enable RAM, disable interrupts

;move 0200~027D to ROM10
;ld a, $0E
;rst $28
;call $4003
;move 0286~02AB to ROM10

.UNBACKGROUND $01F5 $02EF       ; Free space in bank $00

.BANK $00 SLOT 0
.ORGA $0100
.SECTION "BootVector" OVERWRITE
    jp $01F5
.ENDS

.BANK $00 SLOT 0
.ORGA $0F0D
.SECTION "GameoverVector" OVERWRITE
    jp nz, Reboot
.ENDS

.BANK $00 SLOT 0
.SECTION "DXCode" FREE PRIORITY 100
    ;Double speed ENGAGE!
    ld a, 1
    ldh ($4D), a
    stop
    nop

Reboot:
    ld a, $C9
    ld ($C703), a
    ld ($C706), a
    ld sp,$CF00

    SET_ROMBANK $10
    call InitializeSystem
    SET_ROMBANK $01

    SET_WRAMBANK WRAM_SCRATCH_BANK
    call $D000 + FFL2Initialize - FFL2_CODE_START
    RESET_WRAMBANK

    call $500F
    jp nc, $1900
    jp $1903
.ENDS

.BANK $10 SLOT 1
.SECTION "TransplantedCode" FREE
FFL2_CODE_START:
FFL2Initialize:
    di   
    ld   a,$80
    ldh  ($40),a
    xor  a
    ldh  ($0F),a
    ldh  ($FF),a
    ldh  ($41),a
    ;ldh  ($47),a
    ;ldh  ($48),a
    ;ldh  ($49),a
    ldh  ($43),a
    ldh  ($42),a
    ld   b,a
    ld   a,$1B
    ld   hl,$C776
    push hl
    cp   (hl)
    inc  hl
    jr   nz,label0229
    cpl  
    cp   (hl)
    jr   nz,label0229
    inc  b
label0229:
    push bc
    ld   hl,$C000
    ld   b,$A0
    call $006C
    ld   hl,$C100
    ld   bc,$0D00
    call $0072
    ld   h,$CF
    ld   b,$01 ;Modified to not clear WRAM1 - they use all of it for maps anyway
    call $0072
    ld   hl,$FF80
    ld   b,$7F
    call $006C
    pop  bc
    pop  hl
    ld   a,$1B
    ldi  (hl),a
    cpl  
    ldi  (hl),a
    ld   (hl),b
    inc  b
    dec  b
    jr   nz,label0262
    ld   b,$40
    ld   hl,$C0A0
    ldh  a,($04)
label025D:
    ldi  (hl),a
    inc  a
    dec  b
    jr   nz,label025D
label0262:
    ld   hl,$C779
    ld   (hl),$A0
    inc  hl
    ld   (hl),$CC
    ld   hl,$00F2
    ld   de,$FF80
    ld   b,$08
    call $0080
    ld   hl,$00E6
    ld   de,$C0E0
    ld   b,$0C
    call $0080
    ld a, $0E
    rst $28
    call $4003
    di   
    xor  a
    ldh  ($45),a
    ldh  ($0F),a
    ld   a,$03
    ldh  ($FF),a
    ld   a,$40
    ldh  ($41),a
    ld   hl,$C703
    ld   a,$C3
    ldi  (hl),a
    ld   a,$DF
    ldi  (hl),a
    ld   a,$16
    ldi  (hl),a
    ld   hl,$C706
    ld   a,$C3
    ldi  (hl),a
    ld   a,$D9
    ldi  (hl),a
    ld   a,$16
    ld   (hl),a
    call $0550
    ld   hl,$4800
    ld   bc,$0800
    ld   a,$04
    call $00CA
    call $04FB
    ld   hl,$A781
    ldi  a,(hl)
    cp   a,$1B
    jr   nz,label02CA
    ld   a,(hl)
    cp   a,$E4
    jr   z,label02CF
label02CA:
    ld   a,$01
    ld   ($A780),a
label02CF:
    call $04F4
    ld   hl,$C200
    ld   c,$04
label02D7:
    ld   b,$04
    ld   a,$FF
    call $006D
    ld   a,$1C
    rst  $00
    dec  c
    jr   nz,label02D7
    ld   a,$01
    rst  $28

    ld a, 1
    ldh ($F0), a

    ret
FFL2_CODE_END:
.ENDS

.SECTION "TransplantedFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    ld a, WRAM_SCRATCH_BANK
    ld bc, FFL2_CODE_END - FFL2_CODE_START
    ld de, $D000
    ld hl, FFL2_CODE_START
    call CopyFarCodeToWRAM
.ENDS

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
.UNBACKGROUND $3FF9 $3FFF       ; Free space in bank $00
.UNBACKGROUND $7E28 $7FFF       ; Free space in bank $01
.UNBACKGROUND $FFC0 $FFFF       ; Free space in bank $03
.UNBACKGROUND $27E01 $27FFF     ; Free space in bank $09
.UNBACKGROUND $2FFCF $2FFFF     ; Free space in bank $0B
.UNBACKGROUND $33FF3 $33FFF     ; Free space in bank $0C
.UNBACKGROUND $37EB5 $37FFF     ; Free space in bank $0D
.UNBACKGROUND $3BFE8 $3BFFF     ; Free space in bank $0E
.UNBACKGROUND $3FD2D $3FFFF     ; Free space in bank $0F

.include "macros.asm"			; Macros 

.include "definitions.asm"		; Definitions
.include "system.asm"
.include "font.asm"
.include "palettes.asm"
.include "metatileattr.asm"
.include "map.asm"
.include "menu.asm"
.include "intro.asm"

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

;0028 bankswitch a:bank
;006C memclr hl:addr b:count
;0072 memclr hl:addr bc:count
;0080 memcpy hl:source de:destination b:count
;0089 memcpy hl:source de:destination bc:count
;00CA memcpy? hl:source de:destination a:bank bc:count
;04F4 disable RAM, enable interrupts
;04FB enable RAM, disable interrupts

;move 0200~027D to ROM10
;ld a, $0E
;rst $28
;call $4003
;move 0286~02AB to ROM10

.UNBACKGROUND $0200 $02AB       ; Free space in bank $00

.BANK $00 SLOT 0
.SECTION "DXCode" FREE PRIORITY 100
    ld sp,$CF00

    ;Double speed ENGAGE!
    ld a, 1
    ldh ($4D), a
    stop
    nop

    SET_ROMBANK $10
    call InitializeFarCode

    call FFL2Initialize
    ld a, $0E
    rst $28
    call $4003
    SET_ROMBANK $10
    call FFL2Initialize2
    SET_ROMBANK $01
    jp $02AC
.ENDS

.BANK $10 SLOT 1
.SECTION "TransplantedCode" FREE
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
    ld   b,$11
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
    ret

FFL2Initialize2:
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
    ret

.ENDS
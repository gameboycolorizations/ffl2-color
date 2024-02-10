.DEFINE WRAM_PALETTE_ADDR       WRAM1
.DEFINE WRAM_PALETTE_SIZE       $40
.DEFINE WRAM_PALETTE_FADECOUNT  $04
.DEFINE WRAM_BGPALETTE_ADDR     WRAM1
.DEFINE WRAM_OBJPALETTE_ADDR    WRAM1 + WRAM_PALETTE_SIZE
.DEFINE WRAM_BATTLEPALETTE_ADDR WRAM1 + WRAM_PALETTE_SIZE * 2
.DEFINE WRAM_TITLEPALETTE_ADDR  WRAM1 + WRAM_PALETTE_SIZE * 3
.DEFINE WRAM_PALETTE_LOOKUP     WRAM1 + $0300
.DEFINE WRAM_PALETTE_CODE       WRAM1 + $0400

.BANK $00 SLOT 0
.ORGA $19F4
.SECTION "SetFade19F4_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $28FE
.SECTION "SetFade28FE_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $2BDE
.SECTION "SetFade2BDE_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $2CF0
.SECTION "SetFade2CF0_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $2D31
.SECTION "SetFade2D31_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $2D62
.SECTION "FadeIn2D62_Hook" OVERWRITE
    call FadeIn
    nop
.ENDS
.ORGA $3201
.SECTION "SetFade3201_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $3EC6
.SECTION "SetFade3EC5_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $3E80
.SECTION "SetFade3E80_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS

.BANK $01 SLOT 1
.ORGA $5473
.SECTION "Fade5473_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $5ED3
.SECTION "Fade5ED3_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
    nop
    nop
    nop
.ENDS
.ORGA $5F0F
.SECTION "Fade5F0F_Hook" OVERWRITE
    di
    SET_WRAMBANK WRAM_PALETTE_BANK
    ld a, $D2
    ld ($C700), a
    call WRAM_PALETTE_CODE + SetFade_Far - PALETTE_CODE_START
    RESET_WRAMBANK
    ei
    nop
.ENDS
.ORGA $5EB9
.SECTION "Fade5EB9_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $5F24
.SECTION "Fade5F24_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $6D2D
.SECTION "Fade6D2D_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
    nop
    nop
    nop
    nop
.ENDS

.BANK $0F SLOT 1
.ORGA $609A
.SECTION "Fade609A_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $6132
.SECTION "Fade6132_Hook" OVERWRITE
    ld ($C700), a
    call SetFade
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
.ENDS
.ORGA $61F4
.SECTION "Fade61F6_Hook" OVERWRITE
    call FadeIn
    nop
.ENDS

.BANK $00 SLOT 0
.SECTION "Fade_Code" FREE
FadeIn:
    ld a, $D2
    call SetFade
    ret

FadeOut:
    ld a, $D2
    call SetFade
    ret

;a = Gameboy BGP Value
SetFade:
    FARCALL(WRAM_PALETTE_BANK, WRAM_PALETTE_CODE + SetFade_Far - PALETTE_CODE_START)
    ret
.ENDS

.BANK $10 SLOT 1
.SECTION "Palettes" FREE
InitialPal:
InitialBGPal:
    .db $54,$5A,$FF,$7F,$D8,$6A,$00,$00
    .db $10,$21,$5F,$29,$38,$25,$00,$00
    .db $2A,$2A,$76,$53,$51,$23,$00,$00
    .db $2D,$6A,$FF,$7F,$53,$73,$00,$41
    .db $0C,$11,$5C,$53,$14,$32,$00,$00
    .db $56,$3A,$9E,$6B,$1A,$5B,$00,$00
    .db $3A,$72,$FF,$7F,$9F,$6A,$00,$00
    .db $08,$21,$00,$40,$D6,$5A,$FF,$7F
InitialOBJPal:
    .db $FF,$7F,$FF,$7F,$5A,$6B,$00,$00
    .db $FF,$7F,$FF,$7F,$1F,$21,$00,$00
    .db $FF,$7F,$FF,$7F,$1F,$03,$00,$00
    .db $FF,$7F,$FF,$7F,$90,$23,$00,$00
    .db $FF,$7F,$FF,$7F,$53,$73,$00,$00
    .db $FF,$7F,$FF,$7F,$88,$7E,$00,$00
    .db $FF,$7F,$FF,$7F,$1C,$7E,$00,$00
    .db $FF,$7F,$FF,$7F,$14,$32,$00,$00
InitialBattlePal:
    .db $D6,$5A,$FF,$7F,$5A,$6B,$00,$00
    .db $10,$00,$FF,$7F,$1F,$21,$00,$00
    .db $B4,$01,$FF,$7F,$1F,$03,$00,$00
    .db $00,$22,$FF,$7F,$90,$23,$00,$00
    .db $2D,$6A,$FF,$7F,$53,$73,$00,$00
    .db $00,$70,$FF,$7F,$88,$7E,$00,$00
    .db $10,$70,$FF,$7F,$1C,$7E,$00,$00
    .db $08,$21,$00,$40,$D6,$5A,$FF,$7F
InitialTitlePal:
    .dw $1578,$4008,$1090,$129F
    .dw $0000,$3827,$1090,$7FFF
    .dw $0000,$3026,$1090,$7FFF
    .dw $0000,$2825,$1090,$7FFF
    .dw $0000,$2024,$1090,$4210
    .dw $0000,$1803,$1090,$4210
    .dw $0000,$1002,$1090,$4210
    .dw $0000,$0801,$1090,$4210
InitialPalEnd:

PaletteLookup:
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
    .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    .db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
.ENDS

.BANK $10 SLOT 1
.SECTION "PaletteCode" FREE
;Initialize fade lookup tables
InitializeFadeLookup:
    di
    PUSH_ALL
        
    SET_WRAMBANK WRAM_PALETTE_BANK

    ld hl, WRAM_PALETTE_ADDR
    ld c, 1 
    ld b, $FF
    call LoadFadeLevel

    ld hl, WRAM_BGPALETTE_ADDR + (WRAM_PALETTE_SIZE * 8)
    ld b, $FF
    call LoadFadeBlack

    RESET_WRAMBANK

    POP_ALL
    ei
    ret

LoadFadeLevel:
    PUSH_ALL
    inc c
    srl b

_colorLoop:
    ldi a, (hl)
    ld e, a
    ldi a, (hl)
    ld d, a
    push bc
 _fadeLoop:
    dec c
    jp z, _fadeLoopDone
    ld a, d
    and a, $7B
    srl a
    ld d, a
    ld a, e
    rr a
    and a, $EF
    ld e, a
    jr _fadeLoop
_fadeLoopDone:
    pop bc
    push hl

    ;HL = HL - 2 + (0x100 * (c - 1))
    ld a, c
    dec a
    add a, h
    ld h, a
    dec l
    dec l
    
    ld a, e
    ldi (hl), a
    ld a, d
    ldi (hl), a
    
    pop hl

    dec b
    jr nz, _colorLoop
    
    POP_ALL
    ret

;Load black palette into cache.  Requires wram bank already set
;@param HL  Target address
;@param B   Count
LoadFadeBlack:
    push af
    push bc

    ld a, 0
@loop:
    ldi (hl), a 
    dec b
    jr nz, @loop
    
    pop bc
    pop af
    ret
.ENDS

.BANK $10 SLOT 1
.SECTION "PaletteFarCode" FREE
PALETTE_CODE_START:
;a = Gameboy BGP value
SetFade_Far:
    push af
    push bc
    push de
    push hl

    ld hl, WRAM_PALETTE_LOOKUP
    ld l, a
    ld a, (hl)
    
_notzero:
    ld c, a
    ld a, ($DFFE)
    cp c
    jr equ, _done

    ld a, c
    ld ($DFFE), a

    cp 2
    jr neq, _dontresetpalette
    ld a, 0
    ld ($DFFF), a
_dontresetpalette:

    ld hl, WRAM_BGPALETTE_ADDR
    ld a, ($DFFF)
    swap a
    sla a
    sla a
    add a, l
    ld l, a

_LoadBGPal:
    ;HL = HL + (0x100 * c)
    ld a, c
    add a, h
    ld h, a
    
    ld a, $80            ; Set index to first color + auto-increment
    ldh (<BCPS),a       
    ld b, 64             ; 32 color entries=0x40 bytes
_LoopBGPAL:
    WAITBLANK
    ldi a, (hl)
    ldh (<BCPD),a
    dec b
    jr nz,_LoopBGPAL

_LoadOBJPal:
    ld hl, WRAM_OBJPALETTE_ADDR
    ;HL = HL + (0x100 * c)
    ld a, c
    add a, h
    ld h, a

    ld a, $80            ; Set index to first color + auto-increment
    ldh (<OCPS),a       
    ld b, 64             ; 32 color entries=0x40 bytes
_LoopOBJPAL:
    WAITBLANK
    ldi a, (hl)
    ldh (<OCPD),a
    dec b
    jr nz,_LoopOBJPAL
    
_done:
    pop hl
    pop de
    pop bc
    pop af
    ret
PALETTE_CODE_END:
.ENDS

.SECTION "PaletteFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    SET_WRAMBANK WRAM_PALETTE_BANK
    xor a
    ld ($DFFF), a

    ld a, WRAM_PALETTE_BANK
    ld bc, InitialPalEnd - InitialPal
    ld de, WRAM_PALETTE_ADDR
    ld hl, InitialPal
    call CopyFarCodeToWRAM

    call InitializeFadeLookup

    ld a, WRAM_PALETTE_BANK
    ld bc, $0100
    ld de, WRAM_PALETTE_LOOKUP
    ld hl, PaletteLookup
    call CopyFarCodeToWRAM

    ld a, WRAM_PALETTE_BANK
    ld bc, PALETTE_CODE_END - PALETTE_CODE_START
    ld de, WRAM_PALETTE_CODE
    ld hl, PALETTE_CODE_START
    call CopyFarCodeToWRAM
.ENDS

.DEFINE WRAM_PALETTE_ADDR       WRAM1
.DEFINE WRAM_PALETTE_SIZE       $40
.DEFINE WRAM_PALETTE_FADECOUNT  $04
.DEFINE WRAM_BGPALETTE_ADDR     WRAM1
.DEFINE WRAM_OBJPALETTE_ADDR    WRAM1 + WRAM_PALETTE_SIZE
.DEFINE WRAM_BATTLEPALETTE_ADDR WRAM1 + WRAM_PALETTE_SIZE * 2
.DEFINE WRAM_TITLEPALETTE_ADDR  WRAM1 + WRAM_PALETTE_SIZE * 3
.DEFINE WRAM_PALETTE_CODE       WRAM1 + $0400

.BANK $01 SLOT 1
.ORGA $5F0F
.SECTION "Fade" OVERWRITE
    di
    SET_WRAMBANK WRAM_PALETTE_BANK
    ld a, $0
    call WRAM_PALETTE_CODE + FadeOut - PALETTE_CODE_START
    RESET_WRAMBANK
    ei
    nop
    nop
    nop
    nop
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
.ENDS

.BANK $10 SLOT 1
.SECTION "PaletteCode" FREE
PALETTE_CODE_START:
FadeOut:
    push af
    push bc
    push de
    push hl
    
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

    ld a, WRAM_PALETTE_BANK
    ld bc, PALETTE_CODE_END - PALETTE_CODE_START
    ld de, WRAM_PALETTE_CODE
    ld hl, PALETTE_CODE_START
    call CopyFarCodeToWRAM
.ENDS

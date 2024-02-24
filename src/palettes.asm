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
.ORGA $1F6B
.SECTION "DisableLCD_Hook" OVERWRITE
    ;Replace call to disable LCD with call to existing code that eats entire non h/vblank portion of CPU time.
    ;GBC double speed mode means we can accomplish the data transfer in roughly the same amount of time as unfettered DMG.
    call $1674
    ld a, $C3
    ldh ($40), a
    nop
    nop
    nop
.ENDS

.ORGA $1F9B
.SECTION "EnableLCDC_Hook" OVERWRITE
    ;Revert to normal LCDC control.
    call $1691
    nop
.ENDS

.BANK $00 SLOT 0
.ORGA $19F4
.SECTION "SetFade19F4_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $296D
.SECTION "SetFade296D_Hook" OVERWRITE
    call FlashPlayerSprite
.ENDS
.ORGA $2981
.SECTION "SetFade2981_Hook" OVERWRITE
    call FlashPlayerSprite
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
.ORGA $3D0E
.SECTION "SetFade3D0E_Hook" OVERWRITE
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
.ORGA $3EC6
.SECTION "SetFade3EC5_Hook" OVERWRITE
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
.ORGA $5EB9
.SECTION "Fade5EB9_Hook" OVERWRITE
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
.ORGA $5F24
.SECTION "Fade5F24_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $5F53
.SECTION "Fade5F53_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $628C
;Inn
.SECTION "Fade628C_Hook" OVERWRITE
    call SetFade
    nop
    nop
    nop
.ENDS
.ORGA $64BF
;Shop
.SECTION "Fade64BF_Hook" OVERWRITE
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

.BANK $0D SLOT 1
.ORGA $425B
.SECTION "Fade425B_Hook" OVERWRITE
    call SetFade
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

LoadWhiteBGPalette:
    FARCALL(WRAM_PALETTE_BANK, WRAM_PALETTE_CODE + LoadWhiteBGPalette_Far - PALETTE_CODE_START)
    ret

FlashPlayerSprite:
    FARCALL(WRAM_PALETTE_BANK, WRAM_PALETTE_CODE + FlashPlayerSprite_Far - PALETTE_CODE_START)
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
    .dw $5A54,$7FFF,$6AD8,$0000
    .dw $2110,$295F,$2538,$0000
    .dw $2A2A,$5376,$2351,$0000
    .dw $6A2D,$7FFF,$7353,$4100
    .dw $110C,$535C,$3214,$0000
    .dw $3A56,$6B9E,$5B1A,$0000
    .dw $723A,$7FFF,$6A9F,$0000
    .dw $2108,$4000,$5AD6,$7FFF
InitialOBJPal:
    .dw $7FFF,$7FFF,$6B5A,$0000
    .dw $7FFF,$7FFF,$211F,$0000
    .dw $7FFF,$7FFF,$031F,$0000
    .dw $7FFF,$7FFF,$2390,$0000
    .dw $7FFF,$7FFF,$7353,$0000
    .dw $7FFF,$7FFF,$7E88,$0000
    .dw $7FFF,$7FFF,$7E1C,$0000
    .dw $7FFF,$7FFF,$3214,$0000
InitialBattlePal:
    .dw $5AD6,$7FFF,$6B5A,$0000
    .dw $0010,$7FFF,$211F,$0000
    .dw $01B4,$7FFF,$031F,$0000
    .dw $2200,$7FFF,$2390,$0000
    .dw $6A2D,$7FFF,$7353,$0000
    .dw $7000,$7FFF,$7E88,$0000
    .dw $7010,$7FFF,$7E1C,$0000
    .dw $2108,$4000,$5AD6,$7FFF
InitialTitlePal:
    .dw $1140,$61C0,$2200,$0080
    .dw $0000,$6604,$1090,$7FFF
    .dw $0000,$6A48,$1090,$7FFF
    .dw $0000,$6E8C,$1090,$7FFF
    .dw $0000,$72D0,$1090,$7FFF
    .dw $2108,$7714,$1090,$6318
    .dw $2108,$7B58,$1090,$6318
    .dw $4210,$7F9C,$1090,$6318
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
LoadWhiteBGPalette_Far:
    ld a, $FF
    ld ($DFFE), a
    ld a, $80            ; Set index to first color + auto-increment
    ldh (<BCPS),a       
    ld b, 64             ; 32 color entries=0x40 bytes
_LoopSetAllWhiteBGPAL:
    WAITBLANK
    ld a, $FF
    ldh (<BCPD),a
    dec b
    jr nz, _LoopSetAllWhiteBGPAL
    ret

LoadWhiteOBJPalette_Far:
    ld a, $FF
    ld ($DFFE), a
    ld a, $80            ; Set index to first color + auto-increment
    ldh (<OCPS),a       
    ld b, 64             ; 32 color entries=0x40 bytes
_LoopSetAllWhiteOBJPAL:
    WAITBLANK
    ld a, $FF
    ldh (<OCPD),a
    dec b
    jr nz, _LoopSetAllWhiteOBJPAL
    ret

LoadBlackBGPalette_Far:
    ld a, $FF
    ld ($DFFE), a
    ld a, $80            ; Set index to first color + auto-increment
    ldh (<BCPS),a       
    ld b, 64             ; 32 color entries=0x40 bytes
_LoopSetAllBlackBGPAL:
    WAITBLANK
    xor a
    ldh (<BCPD),a
    dec b
    jr nz, _LoopSetAllBlackBGPAL
    ret

LoadBlackOBJPalette_Far:
    ld a, $FF
    ld ($DFFE), a
    ld a, $80            ; Set index to first color + auto-increment
    ldh (<OCPS),a       
    ld b, 64             ; 32 color entries=0x40 bytes
_LoopSetAllBlackOBJPAL:
    WAITBLANK
    xor a
    ldh (<OCPD),a
    dec b
    jr nz, _LoopSetAllBlackOBJPAL
    ret

FlashPlayerSprite_Far:
    ld a, ($C003)
    xor $04
    ld ($C003), a
    ld a, ($C007)
    xor $04
    ld ($C007), a
    ld a, ($C00B)
    xor $04
    ld ($C00B), a
    ld a, ($C00F)
    xor $04
    ld ($C00F), a
    ld a, ($C103)
    xor $04
    ld ($C103), a
    ld a, ($C107)
    xor $04
    ld ($C107), a
    ld a, ($C10B)
    xor $04
    ld ($C10B), a
    ld a, ($C10F)
    xor $04
    ld ($C10F), a
    ret

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

    ldh a, ($C0) ;Screen wipe flag - 00 = fade, 01 = corners, 02+ different types of wavey
    cp $01
    jr neq, _fadeToBlack
    call WRAM_PALETTE_CODE + LoadWhiteBGPalette_Far - PALETTE_CODE_START
    call WRAM_PALETTE_CODE + LoadWhiteOBJPalette_Far - PALETTE_CODE_START
    pop hl
    pop de
    pop bc
    pop af
    ret
    
_fadeToBlack:

    ld a, c
    ld ($DFFE), a

    cp 2
    jr neq, _dontresetpalette
    ld a, 0
    ld ($DFFF), a
_dontresetpalette:

    ld hl, WRAM_BGPALETTE_ADDR
    ldh a, ($8B) ;FFL2 battle flag
    and $02
    ld b, a
    ldh a, ($E0) ;Our title screen flag
    add b
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

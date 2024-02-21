.DEFINE WRAM_MENU_CODE WRAM1

.BANK $00 SLOT 0
.ORGA $0AF7
.SECTION "MenuLoadTiles_Hook" OVERWRITE
    call MenuLoadTiles
.ENDS

.BANK $00 SLOT 0
.SECTION "Menu_Code" FREE
;b = x count
;c = y count remaining
;de = destination
;hl = source
MenuLoadTiles:
    FARCALL(WRAM_MENU_BANK, WRAM_MENU_CODE + MenuLoadTiles_Far - MENU_CODE_START)
    ret
.ENDS

.BANK $01 SLOT 1
.ORGA $5F2B
.SECTION "ClearMenuBackground_Hook" OVERWRITE
    call ClearMenuBackground
    jp   $017A  ;Disable lock out
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
    nop
    nop
    nop
    nop
    nop
    nop
.ENDS
.SECTION "ClearMenuBackground_Code" FREE
ClearMenuBackground:
    SET_VRAMBANK 1

    ld   e,$07
    ld   hl,$9C00
    ld   c,$12
    call $0177  ;Enable lock out CPU during non vblank
_clearLoopAttr:
    ld   b,$14
    ld   a,e
    call $006D  ;Memset
    ld   a,$0C
    rst  $00
    dec  c
    jr   nz,_clearLoopAttr
    ;jp   $017A  ;Disable lock out

    RESET_VRAMBANK 0

    ;original code    
    ld   e,$75
    ld   hl,$9C00
    ld   c,$12
    ;call $0177  ;Enable lock out CPU during non vblank
_clearLoopTileID:
    ld   b,$14
    ld   a,e
    call $006D  ;Memset
    ld   a,$0C
    rst  $00
    dec  c
    jr   nz,_clearLoopTileID
    ret
.ENDS

.BANK $10 SLOT 1
.SECTION "MenuFarCode" FREE
MENU_CODE_START:
;b = x count
;c = y count remaining
;de = destination
;hl = source
MenuLoadTiles_Far:
    push af
    SET_VRAMBANK 1
    push de
    push bc

_loopAttr:
    WAITBLANK
    ld a, 7
    ld (de), a
    inc de
    dec b
    jr nz, _loopAttr

    pop bc
    pop de
    RESET_VRAMBANK
    pop af

    ;original code
    push af
_loopTile:
    WAITBLANK
    ldi a, (hl)
    ld (de), a
    inc de
    dec b
    jr nz, _loopTile
    pop af

    ret  
MENU_CODE_END:
.ENDS

.SECTION "MenuFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    ld a, WRAM_MENU_BANK
    ld bc, MENU_CODE_END - MENU_CODE_START
    ld de, WRAM_MENU_CODE
    ld hl, MENU_CODE_START
    call CopyFarCodeToWRAM
.ENDS

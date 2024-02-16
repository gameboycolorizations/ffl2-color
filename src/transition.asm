;2df8: ld FF into all 9C00 tiles
;2E28: ld 9800 bank tiles into 9C00
;2E71: Clear right half of screen during transition
;0F:60B0 clear VRAM

.DEFINE WRAM_TRANSITION_CODE WRAM1 + $0100

.BANK $00 SLOT 0
.ORGA $2DB4
.SECTION "TransitionCopyTilesReverse_Hook" OVERWRITE
    call TransitionCopyTilesReverse
.ENDS

.ORGA $2E28
.SECTION "TransitionCopyTiles_Hook" OVERWRITE
    call TransitionCopyTiles
.ENDS
.ORGA $2E71
.SECTION "TransitionClearTiles_Hook" OVERWRITE
    call TransitionClearTiles
.ENDS

.BANK $00 SLOT 0
.SECTION "Transition_Code" FREE
;b = x count
;c = y count remaining
;hl = source
;de = destination
TransitionCopyTilesReverse:
    SET_VRAMBANK 1
    ld a, (de)
    ld (hl), a
    RESET_VRAMBANK

    ;original code
    ld a, (de)
    ld (hl), a
    ld a, l
    ret

;b = x count
;c = y count remaining
;de = destination
;hl = source
TransitionCopyTiles:
    SET_VRAMBANK 1
    ld a, (hl)
    ld (de), a
    RESET_VRAMBANK

    ;original code
    ld a, (hl)
    ld (de), a
    ld a, l
    ret

;hl = destination
TransitionClearTiles:
    SET_VRAMBANK 1
    xor a
    ld (hl), a
    RESET_VRAMBANK
    ;original code
    ld (hl), $FF
    ld a, l
    ret
.ENDS

.BANK $0F SLOT 1
.ORGA $60B0
.SECTION "TransitionClearMapVRAM_Hook" OVERWRITE
    call TransitionClearMapVRAM
.ENDS

.SECTION "TransitionClearMapVRAM_Code" FREE
;a = tileID
TransitionClearMapVRAM:
	PUSH_ALL
    SET_VRAMBANK 1
    ld hl, $9800
    ld bc, $0800
    ld a, 0
    call $009C
    RESET_VRAMBANK
    POP_ALL

    ;original code
    ld hl, $9800
    ret
.ENDS



;.BANK $10 SLOT 1
;.SECTION "TransitionFarCode" FREE
;TRANSITION_CODE_START:
;	nop
;TRANSITION_CODE_END:
;.ENDS
;
;.SECTION "TransitionFarCodeLoader" FREE APPENDTO "FarCodeLoader"
;    ld a, WRAM_MENU_BANK
;    ld bc, TRANSITION_CODE_END - TRANSITION_CODE_START
;    ld de, WRAM_TRANSITION_CODE
;    ld hl, TRANSITION_CODE_START
;    call CopyFarCodeToWRAM
;.ENDS

.DEFINE WRAM_TITLE_CODE WRAM1 + $0200
.DEFINE WRAM_TITLE_DATA WRAM1 + $0400

.BANK $01 SLOT 1
.ORGA $6898
.SECTION "Title_Hook" OVERWRITE
	call InitializeTitle
	nop
.ENDS

.BANK $01 SLOT 1
.ORGA $68A9
.SECTION "EndTitle_Hook" OVERWRITE
	call FinalizeTitle
.ENDS

.BANK $01 SLOT 1
.SECTION "Title_Code" FREE
InitializeTitle:
	SET_WRAMBANK WRAM_PALETTE_BANK
	ld a, $FF
	ld ($DFFE), a
	RESET_WRAMBANK

	ld a, $03
	ldh ($E0), a
	FARCALL(WRAM_MENU_BANK, WRAM_TITLE_CODE + InitializeTitle_Far - TITLE_CODE_START)

	ld a, $C3
	ldh ($40), a
	ret

FinalizeTitle:
	call $01B9

	SET_WRAMBANK WRAM_PALETTE_BANK
	ld a, $FF
	ld ($DFFE), a
	RESET_WRAMBANK

	xor a
	ldh ($E0), a

    ld a, $00
    ld ($C700), a
    FARCALL(WRAM_PALETTE_BANK, WRAM_PALETTE_CODE + SetFade_Far - PALETTE_CODE_START)

	ld a, ($C7CD)
	ret
.ENDS

.BANK $10 SLOT 1
.SECTION "TitleFarCode" FREE
TITLE_CODE_START:
InitializeTitle_Far:
	ld hl, $9940
	ld c, $01
	SET_VRAMBANK 1
_loopMapRow:
	ld b, $20
_loopMapColumn:
	WAITBLANK
	ld a, c
	ldi (hl), a
	dec b
	jr nz, _loopMapColumn
	inc c
	cp $07
	jr lst, _loopMapRow
	RESET_VRAMBANK

	call WRAM_TITLE_CODE + InitializeTitleSword_Far - TITLE_CODE_START
	ret

InitializeTitleSword_Far:
	ld hl, WRAM_TITLE_DATA + SwordTiles - TITLE_DATA_START
	ld de, $8300
	ld bc, SwordTilesEnd - SwordTiles
_loopSpriteTiles:
	WAITBLANK
	ldi a, (hl)
	ld (de), a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, _loopSpriteTiles

	ld hl, WRAM_TITLE_DATA + SwordOAM - TITLE_DATA_START
	ld de, $CC00
	ld bc, SwordOAMEnd - SwordOAM
_loopSpriteOAM:
	WAITBLANK
	ldi a, (hl)
	ld (de), a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, _loopSpriteOAM

    ld hl, WRAM_TITLE_DATA + SwordPalette - TITLE_DATA_START
    ld a, $88       ; Set index to second palette + auto-increment
    ldh (<OCPS), a
    ld b, 32
_loopSpritePalette:
    WAITBLANK
    ldi a, (hl)
    ldh (<OCPD), a
    dec b
    jr nz, _loopSpritePalette

	ret
TITLE_CODE_END:
.ENDS

.BANK $10 SLOT 1
.SECTION "TitleData" FREE
TITLE_DATA_START:
SwordTiles:
	.db $00,$00,$30,$08,$44,$3C,$28,$18,$00,$00,$00,$10,$30,$08,$20,$18
	.db $30,$08,$20,$18,$10,$00,$00,$6C,$10,$44,$00,$D7,$10,$D6,$00,$28
	.db $00,$10,$00,$00,$08,$28,$28,$08,$28,$08,$28,$08,$28,$18,$28,$18
	.db $28,$18,$28,$18,$28,$18,$28,$18,$28,$18,$28,$18,$28,$18,$28,$18
	.db $00,$10,$00,$10,$00,$10,$00,$10,$00,$10,$00,$10,$00,$10,$00,$10
	.db $00,$10,$00,$10,$00,$10,$00,$10,$00,$10,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$0F,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$E0,$00,$00,$00,$00
	.db $38,$38,$44,$44,$82,$82,$44,$44,$38,$38,$28,$28,$44,$44,$44,$44
	.db $44,$44,$44,$44,$6C,$6C,$92,$92,$AB,$AB,$28,$28,$29,$29,$D6,$D6
	.db $6C,$6C,$7C,$7C,$54,$54,$54,$54,$54,$54,$54,$54,$44,$44,$44,$44
	.db $44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44
	.db $28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$28
	.db $28,$28,$28,$28,$28,$28,$28,$28,$28,$28,$10,$10,$10,$10,$10,$10
	.db $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$30,$30,$2F,$2F,$10,$10,$0F,$0F,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$18,$18,$E8,$E8,$10,$10,$E0,$E0,$00,$00
SwordTilesEnd:

SwordOAM:
    .db $21,$6F,$30,$01, $29,$6F,$31,$01, $31,$6F,$32,$02, $39,$6F,$33,$02
    .db $41,$6F,$34,$02, $49,$6F,$35,$02, $51,$6F,$36,$02, $59,$6F,$37,$02
    .db $21,$67,$38,$01, $29,$67,$39,$01, $21,$77,$3A,$01, $29,$77,$3B,$01
    .db $21,$6F,$3C,$03, $29,$6F,$3D,$03, $31,$6F,$3E,$03, $39,$6F,$3F,$03
    .db $41,$6F,$40,$03, $49,$6F,$41,$03, $51,$6F,$42,$03, $59,$6F,$43,$03
    .db $21,$67,$44,$03, $29,$67,$45,$03, $21,$77,$46,$03, $29,$77,$47,$03
    .db $00,$00,$00,$00
SwordOAMEnd:

SwordPalette:
    .dw $7FFF,$129F,$1578,$1090
    .dw $7FFF,$7FFF,$7353,$7E88
    .dw $7FFF,$7FFF,$2390,$0000
    .dw $7FFF,$7FFF,$7353,$129F
SwordPaletteEnd:

TITLE_DATA_END:
.ENDS

.SECTION "TitleFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    ld a, WRAM_MENU_BANK
    ld bc, TITLE_CODE_END - TITLE_CODE_START
    ld de, WRAM_TITLE_CODE
    ld hl, TITLE_CODE_START
    call CopyFarCodeToWRAM

    ld a, WRAM_MENU_BANK
    ld bc, TITLE_DATA_END - TITLE_DATA_START
    ld de, WRAM_TITLE_DATA
    ld hl, TITLE_DATA_START
    call CopyFarCodeToWRAM
.ENDS

.DEFINE WRAM_METATILE_IDS	WRAM1 + $0000
.DEFINE WRAM_METATILE_ATTR	WRAM1 + $0100
.DEFINE WRAM_METATILE_CODE 	WRAM1 + $0800
;c400 appears to be metatile column/row buffer

;1F8D is where metatiles are loaded into VRAM, hook here to capture source/destination and stash IDs
;211E is where the metatile data gets written to C400 for rows
;2146 is where the metatile data gets written to C400 for columns
;215F is where C400 is copied to VRAM for rows
;2183 is where C400 is copied to VRAM for columns
;3887 is where tiles are "unhidden" during map transitions

.BANK $00 SLOT 0
.ORGA $1F93
.SECTION "StoreMetatileID_Hook" OVERWRITE
	call StoreMetatileID
.ENDS
.ORGA $211E
.SECTION "WriteMetatileToRAM211E_Hook" OVERWRITE
	call WriteMetatileToRAM
	nop
	nop
	nop
	nop
.ENDS
.ORGA $2146
.SECTION "WriteMetatileToRAM2146_Hook" OVERWRITE
	call WriteMetatileToRAM
	nop
	nop
	nop
	nop
.ENDS
.ORGA $215F
.SECTION "CopyMetatileToVRAM215F_Hook" OVERWRITE
    call CopyMetatileToVRAM
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
.ORGA $2183
.SECTION "CopyMetatileToVRAM2183_Hook" OVERWRITE
	push bc
	push de
	pop bc
	pop de
    call CopyMetatileToVRAM
    dec hl
	push bc
	push de
	pop bc
	pop de
    nop
    nop
.ENDS
.ORGA $3838
.SECTION "HideMetatile_Hook" OVERWRITE
	call ReplaceMetatile
	ret
.ENDS
.ORGA $387B
.SECTION "UnhideMetatile_Hook" OVERWRITE
	call ReplaceMetatile
	ret
.ENDS

.BANK $00 SLOT 0
.SECTION "Map_Code" FREE
StoreMetatileID:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + StoreMetatileID_Far - MAP_CODE_START)
    ret

WriteMetatileToRAM:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + WriteMetatileToRAM_Far - MAP_CODE_START)
    ret

CopyMetatileToVRAM:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + CopyMetatileToVRAM_Far - MAP_CODE_START)
    ret

ReplaceMetatile:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + ReplaceMetatile_Far - MAP_CODE_START)
	ret
.ENDS

.BANK $10 SLOT 1
.SECTION "Map_FarCode" FREE
MAP_CODE_START:
;B = Number of bytes to copy
;DE = Tile VRAM destination
;HL = ROM source
StoreMetatileID_Far:
	push de
	push hl
	push bc

	;Middle 8 bits of DE are destination tile number.  Assumes bottom 4 bits are 0.
	ld a, d
	and $07
	or a, e
	swap a

	;DE = WRAM_METATILE_IDS + tile number
	ld de, WRAM_METATILE_IDS
	ld e, a

	;((HL - $4000) >> 4) = ROM metatile number
	ld a, h
	sub a, $40
	ld h, a
	;Shift HL right 4 - value is tile number
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	;(HL + $D200) = ROM metatile attr address
	ld a, h
	add a, >WRAM_METATILE_ATTR
	ld h, a

	;Shift B right 4 - value is number of tiles
	ld a, b
	swap a
	and $0F
	ld b, a

	;b = tile count
	;de = destination
	;hl = 
_storeMetatileIDLoop:
	ldi a, (hl)
	ld (de), a
	inc de

	dec b
	jr nz, _storeMetatileIDLoop

	pop bc
	pop hl
	pop de

	;Original code
	call $0080
ret

;A = Tile ID
;HL = destination
WriteMetatileToRAM_Far:
	push af
	SET_VRAMBANK 1
	pop af
	push af
	push de
	push hl
	ld de, WRAM_METATILE_IDS
	ld e, a

	;Add $80 to L to get attributes
	set 7, l

	ld a, (de)
	inc de
	ldi (hl), a
	ld a, (de)
	inc de
	ldi (hl), a
	ld a, (de)
	inc de
	ldi (hl), a
	ld a, (de)
	ld (hl), a
	pop hl
	pop de

	RESET_VRAMBANK
	pop af

	;Original code
	ldi (hl), a
	inc a
	ldi (hl), a
	inc a
	ldi (hl), a
	inc a
	ldi (hl), a
	ret

;DE = source
;HL = destination
CopyMetatileToVRAM_Far:
	SET_VRAMBANK 1

	push hl
	push de

	;Add $80 to E to get attributes
	set 7, e

	ld a, (de)
	ldi (hl), a
	inc e
	ld a, (de)
	ldd (hl), a
	inc e
	set 5, l
	ld a, (de)
	ldi (hl), a
	inc e
	ld a, (de)
	ld (hl), a

	pop de
	pop hl

	RESET_VRAMBANK

	;Original code
	ld a, (de)
	ldi (hl), a
	inc e
	ld a, (de)
	ldd (hl), a
	inc e
	set 5, l
	ld a, (de)
	ldi (hl), a
	inc e
	ld a, (de)
	ld (hl), a
	inc e

	ret

ReplaceMetatile_Far:
	push af
	push de
	
	ld de, WRAM_METATILE_IDS
	ld e, a
	
	SET_VRAMBANK 1

	;Couldn't get this to run entirely during VBlank, so we're just
	;waiting until we're near the end of the frame and making sure
	;we only draw during VBlank _or_ HBlank.
_WaitVBlank:
	ldh a, ($44)
	cp a, $80
	jr c, _WaitVBlank
	cp a, $98
	jr nc, _WaitVBlank

	WAITBLANK
	ld a, (de)
	ld (hl), a
	
	RESET_VRAMBANK
	
	pop de
	pop af
	
	ld (hl), a
	ret

MAP_CODE_END
.ENDS

.SECTION "MapFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    ld a, WRAM_METATILE_BANK
    ld bc, MAP_CODE_END - MAP_CODE_START
    ld de, WRAM_METATILE_CODE
    ld hl, MAP_CODE_START
    call CopyFarCodeToWRAM
.ENDS

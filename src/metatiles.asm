.include "metatileattr.asm"

.DEFINE WRAM_METATILE_ATTR	WRAM1 + $0000
.DEFINE WRAM_METATILE_CODE 	WRAM1 + $0800
;c400 appears to be metatile column/row buffer

;1BD4 is where the current bank of metatiles are loaded
;1F8D is where metatiles are loaded into VRAM, hook here to capture source/destination and stash IDs
;211E is where the metatile data gets written to C400 for rows
;2146 is where the metatile data gets written to C400 for columns
;215F is where C400 is copied to VRAM for rows
;2183 is where C400 is copied to VRAM for columns
;3887 is where tiles are "unhidden" during map transitions

.BANK $00 SLOT 0
.ORGA $1BD4
.SECTION "StoreMetatileAttribute_Hook" OVERWRITE
	call StoreMetatileAttribute
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
.UNBACKGROUND $21C6 $21E9       ; Free space in bank $00
.ORGA $21C2
.SECTION "AnimateTiles_Hook" OVERWRITE
	call AnimateTiles
	ret
.ENDS
.UNBACKGROUND $21EE $2231       ; Free space in bank $00
.ORGA $21EA
.SECTION "AnimateHalfTiles_Hook" OVERWRITE
	call AnimateHalfTiles
	ret
.ENDS
.ORGA $387B
.SECTION "UnhideMetatile_Hook" OVERWRITE
	call ReplaceMetatile
	ret
.ENDS

.BANK $00 SLOT 0
.SECTION "Map_Code" FREE
StoreMetatileAttribute:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + StoreMetatileAttribute_Far - MAP_CODE_START)
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

AnimateTiles:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + AnimateTiles_Far - MAP_CODE_START)
	ret
AnimateHalfTiles:
	FARCALL(WRAM_METATILE_BANK, WRAM_METATILE_CODE + AnimateHalfTiles_Far - MAP_CODE_START)
	ret
.ENDS

.BANK $10 SLOT 1
.SECTION "Map_FarCode" FREE
MAP_CODE_START:
;B = Number of bytes to copy
;DE = Metatile metadata destination (C520~C53F)
;HL = ROM source (7000~77FF)
StoreMetatileAttribute_Far:
	push hl
	push de

	SET_ROMBANK $17

	ld a, h
	sub a, $70	;Metatile metadata starts at 07:7000
	ld h, a
	add hl, hl
	add hl, hl
	ld a, h
	add a, $40 	;Metatile attributes start at 17:4000
	ld h, a

	ld d, >WRAM_METATILE_ATTR
	ld a, e
	sub a, $20
	sla a
	sla a
	ld e, a

	ldi a, (hl)
	ld (de), a
	inc de
	ldi a, (hl)
	ld (de), a
	inc de
	ldi a, (hl)
	ld (de), a
	inc de
	ld a, (hl)
	ld (de), a

	pop de
	pop hl

	SET_ROMBANK $07

	;Original code
	ldi a, (hl)
	ld (de), a
	inc e
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
	ld de, WRAM_METATILE_ATTR
	ld e, a

	;Add $80 to L to get attribute destination
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

	WAITBLANK
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

	WAITBLANK
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
	
	ld de, WRAM_METATILE_ATTR
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

AnimateTiles_Far:
label21C2:
	ld   a,($C439)
	add  a,$80
	ld   l,a
	xor  a,$40
	ld   e,a
	ld   h,$97
	ld   d,h
	WAITBLANK
	ld   a,(de)
	ld   c,(hl)
	ldi  (hl),a
	ld   a,c
	ld   (de),a
	inc  e
	ld   a,(de)
	ld   c,(hl)
	ld   (hl),a
	ld   a,c
	ld   (de),a
	set  4,l
	set  4,e
	WAITBLANK
	ld   a,(de)
	ld   c,(hl)
	ldd  (hl),a
	ld   a,c
	ld   (de),a
	dec  e
	ld   a,(de)
	ld   c,(hl)
	ld   (hl),a
	ld   a,c
	ld   (de),a
	jr   label221D
AnimateHalfTiles_Far:
	ld   a,($C456)
	or   a
	jr   z,label21C2
	ld   e,a
	ld   d,a
	WAITBLANK
	ld   a,($C439)
	add  a,$C0
	ld   l,a
	ld   h,$97
	ld   c,(hl)
	set  4,l
	ld   b,(hl)
	ld   a,b
label21FF:
	rra  
	rr   c
	rr   b
	dec  d
	jr   nz,label21FF
	WAITBLANK
	ld   (hl),b
	res  4,l
	ld   (hl),c
	inc  l
	ld   c,(hl)
	set  4,l
	ld   b,(hl)
	ld   a,b
label2211:
	rra  
	rr   c
	rr   b
	dec  e
	jr   nz,label2211
	WAITBLANK
	ld   (hl),b
	res  4,l
	ld   (hl),c
label221D:
	ld   a,($C439)
	inc  a
	inc  a
	ld   ($C439),a
	ld   c,a
	and  a,$0F
	ret  nz
	ld   a,c
	add  a,$10
	and  a,$20
	ld   ($C439),a
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

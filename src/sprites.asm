.include "spriteattr.asm"

.DEFINE WRAM_SPRITE_IDS		WRAM1 + $0000
.DEFINE WRAM_SPRITE_ATTR 	WRAM1 + $0200
.DEFINE WRAM_SPRITE_CODE 	WRAM1 + $0C00

;Two shadow OAMs for the map that get toggled every few frames?  C000 and C100
;Third shadow OAM for menus - CC00

;00:161F seems to be the highest level call responsible for loading sprites, at least in menus
;00:178F clears all but the treasure and pointer sprites from the sprite OAM shadow
;00:181C loads a sprite OAM tile and attribute for a menu
;00:1F51 seems to be the highest level call responsible for loading the player sprite for the world
;00:2A5D clears shadow OAM for a given actor?
;00:2932 seems to load treasure and pointer sprites
;00:3672 seems to load other sprites for the world
;00:34B6 updates OAM shadows to point to the correct actor tiles, so is probably where to apply attr

;Overriding the memcpy functions would be tricky, since they may be used to copy to/from WRAM1.

;Currently we're doing our SpriteDMA handler a little too early, since the sprite OAM for menus is \
;never "active"

.BANK $00 SLOT 0
.ORGA $161B
.SECTION "StoreSpriteIDs161B_Hook" OVERWRITE
    call StoreSpriteIDs8
    nop
.ENDS
.ORGA $1819
.SECTION "WindowSpriteAttribute_Hook" OVERWRITE
    call WindowSpriteAttribute
    nop
.ENDS
.ORGA $1F51
.SECTION "StoreSpriteIDs1F51_Hook" OVERWRITE
    call StoreSpriteIDs
.ENDS
.ORGA $2932
.SECTION "StoreSpriteIDs2932_Hook" OVERWRITE
    call StoreSpriteIDs
.ENDS
.ORGA $2A3B
.SECTION "PlayerSpriteAttribute_Hook" OVERWRITE
	call PlayerSpriteAttribute
	nop
	nop
	nop
	nop
	nop
	nop
	nop
.ENDS
.ORGA $34B6
.SECTION "NPCSpriteAttribute_Hook" OVERWRITE
    call NPCSpriteAttribute
    nop
    nop
    nop
    nop
    nop
    nop
    nop
.ENDS
.ORGA $3672
.SECTION "StoreSpriteIDs3672_Hook" OVERWRITE
    call StoreSpriteIDs
.ENDS

.BANK $00 SLOT 0
.SECTION "Sprite_Code" FREE
StoreSpriteIDs8:
	ld a, $03
	push af
    FARCALL(WRAM_SPRITE_BANK, WRAM_SPRITE_CODE + StoreSpriteIDs8_Far - SPRITE_CODE_START)
    pop af
    reti
StoreSpriteIDs:
	ldh a, ($88)
    FARCALL(WRAM_SPRITE_BANK, WRAM_SPRITE_CODE + StoreSpriteIDs_Far - SPRITE_CODE_START)
	call $00AC
    ret
WindowSpriteAttribute:
    FARCALL(WRAM_SPRITE_BANK, WRAM_SPRITE_CODE + WindowSpriteAttribute_Far - SPRITE_CODE_START)
    ret
NPCSpriteAttribute:
    FARCALL(WRAM_SPRITE_BANK, WRAM_SPRITE_CODE + NPCSpriteAttribute_Far - SPRITE_CODE_START)
    ret
PlayerSpriteAttribute:
    FARCALL(WRAM_SPRITE_BANK, WRAM_SPRITE_CODE + PlayerSpriteAttribute_Far - SPRITE_CODE_START)
    ret
EffectSpriteAttribute:
    FARCALL(WRAM_SPRITE_BANK, WRAM_SPRITE_CODE + EffectSpriteAttribute_Far - SPRITE_CODE_START)
    ret
.ENDS

.BANK $10 SLOT 1
.SECTION "Sprite_FarCode" FREE
SPRITE_CODE_START:
;A is bank
;B is byte count
;DE is destination, must be $8000~$87FF
;HL is source
StoreSpriteIDs8_Far:
	ld bc, $80
	call WRAM_SPRITE_CODE + StoreSpriteIDs_Far - SPRITE_CODE_START
	ld b, $80
	ret

;Original code loads tiles into VRAM, additionally we record where they came from to 05:D000 block
;A is bank
;BC is byte count
;DE is destination, must be $8000~$87FF
;HL is source
StoreSpriteIDs_Far:
	push hl
	push de
	push bc
	push af

	;HL = ((HL >> 4) | (BANK << 10)), the index of the 16-byte block in the $4000~$7FFF range.
	ld a, h
	and $3F
	ld h, a
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	pop af
	push af
	sub 3
  	sla a
  	sla a
  	add $D2
  	add a, h
  	ld h, a
  	push hl

	;Get number of tiles into B
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld b, h

	;Calculate the destination address in WRAM
	;Divide the tile vram address by $10 (size of a tile) and multiply by two.  Easiest way is to shift left five times and discard the low value.
	;hl = $D000 | ((DE & $07FF) * $20)
	ld h, d
	ld l, e
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld l, h
	ld h, $D0

	;Pop the old HL (bank<<10|addr>>4) into DE
	pop de
_loop:
	ld a, (de)
	ldi (hl), a
	inc de
	dec b
	jr nz, _loop
	pop af
	pop bc
	pop de
	pop hl
	ret

WindowSpriteAttribute_Far:
	;original code
	and $F0
	or c

	push bc
	ld b, a

	;Load sprite tile ID from (hl - 1) into A
	dec hl
	ldi a, (hl)

	;load $D000 + A into HL
	push hl
	ld h, $D0
	ld l, a

	;load metatile attribute from HL
	ld a, (hl)
	or b
	pop hl

	pop bc

	;original code
	ldi (hl), a
	ret

NPCSpriteAttribute_Far:
	push bc

	;Load sprite tile ID from (de) + c into A
	ld a, (de)
	add c

	;load $D000 + A into HL
	push hl
	ld h, $D0
	ld l, a

	;load metatile attribute from HL
	ld a, (hl)
	ld b, a
	pop hl

	;Original code modified to mix in color attribute from B
	ld a, (de)
	add c
	ld (de), a
	inc e
	ld a, (de)
	and $F0
	or b
	ld (de), a
	dec e
	set 0, d
	ld a, (de)
	add c
	ld (de), a
	inc e
	ld a, (de)
	and $F0
	or b
	ld (de), a
	dec e
	res 0, d

	pop bc
	ret

PlayerSpriteAttribute_Far:
	push bc

	;Load sprite tile ID from (hl) + c into A
	ld a, (hl)
	add c

	;load $D000 + A into HL
	push hl
	ld h, $D0
	ld l, a

	;load metatile attribute from HL
	ld a, (hl)
	ld b, a
	pop hl

	;Original code modified to mix in color attribute from B
	ld a, (hl)
	add c
	ldi (hl), a
	ld a, (hl)
	and $F0
	or b
	ldd (hl), a
	set 0, h
	ld a, (hl)
	add c
	ldi (hl), a
	ld a, (hl)
	and $F0
	or b
	ldd (hl), a
	res 0, h

	pop bc
	ret

SPRITE_CODE_END:
.ENDS

.SECTION "SpriteFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    ld a, WRAM_SPRITE_BANK
    ld bc, SPRITE_CODE_END - SPRITE_CODE_START
    ld de, WRAM_SPRITE_CODE
    ld hl, SPRITE_CODE_START
    call CopyFarCodeToWRAM
.ENDS

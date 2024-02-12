.include "enemies.asm"

;0d:5326 calls 005D which does (HL*16) + 4000 to get the rom address of the enemy tiles
;0f:6292 Battle image loader?

;RAM information thanks to tehtmi@gmail.com... wish I'd found this _before_ I documented everything else!

;cfe0..cfe5 encounter monster data (count, type)
;d921..d926 first byte enemy graphics bank, second byte index (x3)
;d927..d92c enemy graphics dimension (width, height x3) (in 8x8 tiles)
;d92d..d932 enemy graphics offset (of first tile from start of tile data), size (number of tiles)
;d933..d935 x offset for each enemy group (not adjusted based on graphics size, used for animations)
;d936..d938 x offset for each enemy group (adjusted based on graphics size)
;d939..d93b y offset for each enemy group (adjusted based on graphics size)

.BANK $0F SLOT 1
.ORGA $616C
.SECTION "LoadEnemyTileIDs_Hook" OVERWRITE
    call LoadEnemyTileIDs
    nop
    nop
    nop
    nop
.ENDS

.BANK $0F SLOT 1
.SECTION "BattleCode" FREE
;FF90 = enemy index
LoadEnemyTileIDs:
	push af
	SET_VRAMBANK 1
	ldh a, ($90)
	push de
	ld de, $CFE0
	sla a
	add a, e
	ld e, a
	inc e
	ld a, (de)

	push hl
	ld hl, EnemyColors
	ld d, 0
	ld e, a
	add hl, de
	ld a, (hl)
	pop hl
	pop de
	ld (hl), a
	RESET_VRAMBANK
	pop af

	cp a, $98
	jr c, _skip
	ld (hl), d
_skip:
	inc hl
	inc d
	ret
.ENDS

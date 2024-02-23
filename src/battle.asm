.DEFINE WRAM_BATTLE_CODE       WRAM1 + $0400

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

.BANK $01 SLOT 1
.ORGA $6FC1
.SECTION "ColorizeMeat_Hook6FC1" OVERWRITE
	call ColorizeMeat
.ENDS
.ORGA $6FC8
.SECTION "ColorizeMeat_Hook6FC8" OVERWRITE
	call ColorizeMeat
.ENDS

.BANK $0F SLOT 1
.ORGA $616C
.SECTION "LoadEnemyTileIDs_Hook" OVERWRITE
    call LoadEnemyTileIDs
    nop
    nop
    nop
    nop
.ENDS

.BANK $00 SLOT 0
.SECTION "Battle_FarCode" FREE
ColorizeMeat:
	FARCALL(WRAM_BATTLE_BANK, WRAM_BATTLE_CODE + ColorizeMeat_Far - BATTLE_CODE_START)
	;Farcall loses the AF register results, but we know it needs to be 1.
	ld a, 1
	ret
.ENDS

.BANK $0F SLOT 1
.SECTION "BattleCode" FREE
;FF90 = enemy index
LoadEnemyTileIDs:
	push af
	SET_VRAMBANK 1

	;Find the ($90)th enemy that has a non-zero count
	push bc
	push de
	ld de, $CFE0
	ldh a, ($90)
	inc a
	ld b, a
_findLoop:
	ld a, (de)
	inc de
	inc de
	or a
	jr z, _findLoop
	dec b
	jr nz, _findLoop
	;Get the previous byte, that's the ($90)th enemy's count byte.
	dec e
	ld a, (de)

	push hl
	ld hl, EnemyColors
	ld d, 0
	ld e, a
	add hl, de
	ld a, (hl)
	pop hl
	pop de
	pop bc
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

.BANK $10 SLOT 1
.SECTION "BattleFarCode" FREE
BATTLE_CODE_START:
ColorizeMeat_Far:
    push af
    SET_VRAMBANK 1
    ld a, $01
    ldi (hl), a
    ldd (hl), a
    RESET_VRAMBANK
    pop af
    ;original code
    ldi (hl), a
    inc a
    ldi (hl), a
    ret
BATTLE_CODE_END:
.ENDS

.SECTION "BattleFarCodeLoader" FREE APPENDTO "FarCodeLoader"
    ld a, WRAM_BATTLE_BANK
    ld bc, BATTLE_CODE_END - BATTLE_CODE_START
    ld de, WRAM_BATTLE_CODE
    ld hl, BATTLE_CODE_START
    call CopyFarCodeToWRAM
.ENDS

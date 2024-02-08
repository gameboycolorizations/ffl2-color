
; This waits for V-Blank or H-Blank so both OAM and display RAM are accessible
.MACRO WAITBLANK
    wait\@:
    ldh a,(<STAT)
    bit 1,a
    jr nz,wait\@
.ENDM

.MACRO PUSH_ALL
	push af
	push bc
	push de
	push hl
.ENDM

.MACRO POP_ALL
	pop hl
	pop de
	pop bc
	pop af
.ENDM

.MACRO SET_ROMBANK ARGS ROMBANK
	ld a, ROMBANK
	ld (CHANGE_BANK), a
.ENDM

.MACRO SET_WRAMBANK ARGS WRAMBANK
	ld a, WRAMBANK
	ldh (<SVBK), a
.ENDM

.MACRO RESET_WRAMBANK
	xor a
	ldh (<SVBK), a
.ENDM

.MACRO SET_VRAMBANK ARGS VRAMBANK
	ld a, VRAMBANK
	ldh (<VBK), a
.ENDM

.MACRO RESET_VRAMBANK
	xor a
	ldh (<VBK), a
.ENDM

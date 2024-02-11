
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

.MACRO SWAP_BC_DE
	push de
	push bc
	pop de
	pop bc
.ENDM

.MACRO FARCALL ARGS WRAM_BANK, ADDRESS
    di
    push af
    SET_WRAMBANK WRAM_BANK
    pop af
    call ADDRESS
    RESET_WRAMBANK
    ei
.ENDM

.MACRO FARCALL_EI ARGS WRAM_BANK, ADDRESS
    push af
    SET_WRAMBANK WRAM_BANK
    pop af
    call ADDRESS
    RESET_WRAMBANK
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

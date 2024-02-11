.DEFINE SHADOW_A	$F1 
.DEFINE SHADOW_B	$F2
.DEFINE SHADOW_C	$F3
.DEFINE SHADOW_D	$F4
.DEFINE SHADOW_E	$F5
.DEFINE SHADOW_H	$F6
.DEFINE SHADOW_L	$F7
.DEFINE FARJUMP		$FFF8

.BANK $00 SLOT 0
.SECTION "FarCall_Code" FREE
FarCall:
	di

	;Stash args someplace else
	ldh (SHADOW_A), a
	ld a, l
	ldh (SHADOW_L), a
	ld a, h
	ldh (SHADOW_H), a
	;48 cycles

	;Get current return address into HL
	pop hl
	;60 cycles

	;Get RAMBANK into (<SVBK)
	ldi a, (hl)
	ldh (<SVBK), a
	;80 cycles

	;Get RAMADDR jp command into $F8~FA
	ld a, $C3
	ldh (<FARJUMP + $00), a
	ldi a, (hl)
	ldh (<FARJUMP + $01), a
	ld a, (hl)
	ldh (<FARJUMP + $02), a
	;140 cycles

	;Replace return vector
	ld hl, _ret
	push hl
	;168 cycles

	;Get args back
	ldh a, (SHADOW_H)
	ld h, a
	ldh a, (SHADOW_L)
	ld l, a
	ldh a, (SHADOW_A)
	;212 cycles

	jp FARJUMP
	;228 cycles
_ret:
	;Reset the RAMBANK
	xor a
   	ldh (<SVBK), a
  	reti
  	;260 cycles vs approximately 64 cycles for a hard coded RAM call
.ENDS

.BANK $10 SLOT 1
.SECTION "System_Code" FREE	
;a = destination WRAM bank
;bc = length
;de = destination
;hl = source
CopyFarCodeToWRAM:
	ldh (<SVBK), a
_copyCodeLoop:
	ldi a, (hl)
	ld (de), a
	inc de
	dec bc
	;dec bc does not set the z flag for some dumb reason, so oring b and c here
	ld a, b
	or c
	jp nz, _copyCodeLoop
	RESET_WRAMBANK
	ret
.ENDS

.SECTION "FarCodeLoader" FREE PRIORITY -1
InitializeFarCode:
	nop
.ENDS

.SECTION "FarCodeLoaderEnd" FREE PRIORITY -1000
	ret
.ENDS

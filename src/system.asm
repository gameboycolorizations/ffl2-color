.DEFINE SHADOW_A	$F1 
.DEFINE SHADOW_B	$F2
.DEFINE SHADOW_C	$F3
.DEFINE SHADOW_D	$F4
.DEFINE SHADOW_E	$F5
.DEFINE SHADOW_H	$F6
.DEFINE SHADOW_L	$F7
.DEFINE FARJUMP		$FFF8

;00:04BF seems to be their own implementation of far calling?  Very similar code, so I feel good about that!

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
	inc hl
	inc hl
	inc hl
	push hl
	dec hl
	dec hl
	dec hl
	;96 cycles

	;Get RAMBANK into (<SVBK)
	ldi a, (hl)
	ldh (<SVBK), a
	;116 cycles

	;Get RAMADDR jp command into $F8~FA
	ld a, $C3
	ldh (<FARJUMP + $00), a
	ldi a, (hl)
	ldh (<FARJUMP + $01), a
	ld a, (hl)
	ldh (<FARJUMP + $02), a
	;176 cycles

	;Replace return vector
	ld hl, _ret
	push hl
	;204 cycles

	;Get args back
	ldh a, (SHADOW_H)
	ld h, a
	ldh a, (SHADOW_L)
	ld l, a
	ldh a, (SHADOW_A)
	;248 cycles

	jp FARJUMP
	;264 cycles
_ret:
	;Reset the RAMBANK
	xor a
   	ldh (<SVBK), a
  	reti
  	;296 cycles vs approximately 64 cycles for a hard coded RAM call
.ENDS

;Their version of far call - I think mine is probably decently faster, but I didn't count the cycles.
;If I run out of space again, maybe I can replace theirs with mine and use it?
;	push af
;	push hl
;	push de
;	ld   hl,sp+$06
;	ld   a,(hl)
;	ld   e,a
;	add  a,$03
;	ldi  (hl),a
;	ld   d,(hl)
;	jr   nc,label04CD
;	inc  (hl)
;	label04CD:
;	ld   l,e
;	ld   h,d
;	ldi  a,(hl)
;	ld   ($C0E7),a
;	ldi  a,(hl)
;	ld   ($C0E8),a
;	ld   a,(hl)
;	rst  $28
;	ld   e,a
;	ld   hl,sp+$05
;	ld   a,(hl)
;	di   
;	ld   (hl),e
;	ld   ($C0E5),a
;	pop  de
;	pop  hl
;	pop  af
;	dec  sp
;	ei   
;	call $C0E4
;	push af
;	push hl
;	ld   hl,sp+$04
;	ld   a,(hl)
;	rst  $28
;	pop  hl
;	pop  af
;	inc  sp
;	ret  

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
InitializeSystem:
	ld c, $80
_clearHRAMLoop:
	xor a
	ldh (c), a
	inc c
	jr nz, _clearHRAMLoop
	
	ld b, 1
_InitializeWRAMBankLoop:
	ld a, b
	ldh (<SVBK), a
	ld hl, $D000
_InitializeWRAMByteLoop:
	ld a, $00
	ldi (hl), a
	ld a, h
	cp $E0
	jp lst, _InitializeWRAMByteLoop
	inc b
	ld a, b
	cp $8
	jp lst, _InitializeWRAMBankLoop

	SET_VRAMBANK 1
	ld hl, $9000
	ld bc, $1000
_clearVRAM:
	WAITBLANK
	xor a
	ldi (hl), a
	dec bc
	ld a, b
	or c
	jr nz, _clearVRAM
	RESET_VRAMBANK

	;Set default palette to something useful for testing
;	WAITBLANK
;    ld a, $80
;    ldh (<BCPS),a       
;    ld a, $10
;    ldh (<BCPD),a       
;    ld a, $42
;    ldh (<BCPD),a       
;    ld a, $FF
;    ldh (<BCPD),a       
;    ld a, $7F
;    ldh (<BCPD),a       
;    ld a, $18
;    ldh (<BCPD),a       
;    ld a, $63
;    ldh (<BCPD),a       
;    ld a, $00
;    ldh (<BCPD),a       
;    ld a, $00
;    ldh (<BCPD),a       
;
;	WAITBLANK
;    ld a, $80
;    ldh (<OCPS),a       
;    ld a, $10
;    ldh (<OCPD),a       
;    ld a, $42
;    ldh (<OCPD),a       
;    ld a, $FF
;    ldh (<OCPD),a       
;    ld a, $7F
;    ldh (<OCPD),a       
;    ld a, $18
;    ldh (<OCPD),a       
;    ld a, $63
;    ldh (<OCPD),a       
;    ld a, $00
;    ldh (<OCPD),a       
;    ld a, $00
;    ldh (<OCPD),a       

	nop
.ENDS

.SECTION "FarCodeLoaderEnd" FREE PRIORITY -1000
	ret
.ENDS

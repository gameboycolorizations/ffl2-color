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
	ld b,b
.ENDS

.SECTION "FarCodeLoaderEnd" FREE PRIORITY -1000
	ret
.ENDS

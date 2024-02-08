.UNBACKGROUND $6917 $6958

.BANK $01 SLOT 1
.SECTION "Intro" FREE
	call IntroFade
.ENDS

.SECTION "IntroLoadPalette_Code" FREE
IntroLoadPalette0:
    ld a, $86
    ldh (<BCPS), a
    ld a, $00
    ldh (<BCPD), a
    ld a, $40
    ldh (<BCPD), a
    ret

IntroLoadPalette1:
    ld a, $86
    ldh (<BCPS), a
    ld a, $10
    ldh (<BCPD), a
    ld a, $62
    ldh (<BCPD), a
    ret

IntroLoadPalette2:
    ld a, $86
    ldh (<BCPS), a
    ld a, $18
    ldh (<BCPD), a
    ld a, $73
    ldh (<BCPD), a
    ret

IntroLoadPalette3:
    ld a, $86
    ldh (<BCPS), a
    ld a, $FF
    ldh (<BCPD), a
    ld a, $7F
    ldh (<BCPD), a
    ret

IntroFade:
    SET_WRAMBANK WRAM_PALETTE_BANK

    WAITBLANK
    ld a, $82
    ldh (<BCPS), a
    ld a, $00
    ldh (<BCPD), a
    ld a, $40
    ldh (<BCPD), a
    
	ld b, $24
_waitA:
	ld a, ($ff00+c)
	cp b
	jr nz, _waitA
	call IntroLoadPalette1
    
	ld b, $28
_waitB:
	ld a, ($ff00+c)
	cp b
	jr nz, _waitB
	call IntroLoadPalette2

	ld b, $2C
_waitC:
	ld a, ($ff00+c)
	cp b
	jr nz, _waitC
	call IntroLoadPalette3

	ld b, $64
_waitD:
	ld a, ($ff00+c)
	cp b
	jr nz, _waitD
	call IntroLoadPalette2

	ld b, $68
_waitE:
	ld a, ($ff00+c)
	cp b
	jr nz, _waitE
	call IntroLoadPalette1

	ld b, $6C
_waitF:
	ld a, ($ff00+c)
	cp b
	jr nz, _waitF
	call IntroLoadPalette0

	RESET_WRAMBANK
	ret
.ENDS

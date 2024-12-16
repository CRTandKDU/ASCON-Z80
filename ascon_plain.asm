PLTEXT	ld	de,PLAIN	; Assuming plaintext length < 16B
	ld	hl,S
	ld	b,16		; Process last (only here) block
PLTLP	ld	a,(de)
	xor	a,(hl)
	ld	(hl),a
	inc	de
	inc	hl
	djnz	PLTLP
	ld	a,(PLEN)	; Assumes PLEN < 8
	ld	b,a
	ld	hl,CIPHER
	ld	de,S+7
CITLP	ld	a,(de)
	ld	(hl),a
	ld	a,b
	sub	a,1
	ld	b,a
	inc	hl
	dec	de
	jr	NZ,CITLP
	ret
	;; 

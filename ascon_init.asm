INITV	ld	hl,S		; Init vector
	xor	a
	ld	(hl),a		; 0x00
	inc	hl
	ld	(hl),a		; 0x00
	inc	hl
	ld	a,(RATE)	; Rate
	ld	(hl),a
	inc	hl
	xor	a
	ld	(hl),a		; Taglen (128 bits) on 2B
	inc	hl
	ld	a,128
	ld	(hl),a
	inc	hl
	ld	a,(BROUND)
	sla	a
	sla	a
	sla	a
	sla	a
	ld	c,a
	ld	a,(AROUND)
	add	a,c
	ld	(hl),a
	inc	hl
	xor	a
	ld	(hl),a
	inc	hl
	ld	a,(VERS)
	ld	(hl),a
	inc	hl
	;; 
PADKN	ld	c,16		; Concatenate key to current (HL)
	ld	b,0
	ex	de,hl
	ld	hl,KEY
	ldir
	ld	c,16
	ld	b,0
	ld	hl,NONCE
	ldir
	ex	de,hl
	ret
	;;
POSTINI	ld	hl,S+24		; Post permutation XOR key in state
	ld	de,KEY
	ld	b,16		; Only change last 2 64b of state
POSTL	ld	a,(de)
	xor	a,(hl)
	ld	(hl),a
	inc	de
	inc	hl
	djnz	POSTL
	ret

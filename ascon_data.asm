ADATA	ld	a,(ALEN)
	ld	c,a
	ld	de,ASSOC
ABLOCK	ld	hl,S
	ld	b,16		; AEAD128 RATE=16 bytes
ADATAL	ld	a,(de)
	xor	a,(hl)
	ld	(hl),a
	inc	hl
	inc	de
	djnz	ADATAL
	push	de
	push	bc
	ld	a,8
	ld	c,0xB4		; Round constant init for 8
	call	PERMUT		; Perform A rounds
	pop	bc
	ld	a,c
	sub	a,16
	ld	c,a
	pop	de
	jr	NZ,ABLOCK
	ld	hl,S+32		; S[4] ^= 1<<63
	ld	a,(hl)
	xor	a,0x80
	ld	(hl),a
	ret
	;; 

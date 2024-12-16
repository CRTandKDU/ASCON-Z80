FINALZ	ld	hl,S+16		; Finalization
	ld	de,KEY		; Update S[2], S[3]
	ld	b,16
	call	FINLP
	;;
	ld	a,12		; 12-round permutation
	ld	c,0xF0
	call	PERMUT
	;;
	ld	hl,S+24
	ld	de,KEY+8
	ld	b,8
	call 	FINLP
	ld	de,KEY
	ld	b,8
	call	FINLP
	;;
	ld	hl,TAG
	ld	de,S+31
	ld	b,8
TAGLP1	ld	a,(de)
	ld	(hl),a
	dec	de
	inc	hl
	ld	a,b
	sub	a,1
	ld	b,a
	jr	NZ,TAGLP1
	ld	de,S+39
	ld	b,8
TAGLP2	ld	a,(de)
	ld	(hl),a
	dec	de
	inc	hl
	ld	a,b
	sub	a,1
	ld	b,a
	jr	NZ,TAGLP2
	ret
	;;
FINLP	ld	a,(de)	
	xor	a,(hl)
	ld	(hl),a
	inc	hl
	inc	de
	djnz	FINLP
	ret

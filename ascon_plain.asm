PLTEXT	call	PTPADD		; Padding
	call	CLRCIPH
	ld	a,(PLEN)
	srl	a
	srl	a
	srl	a
	srl	a
	ld	c,a		; Preserve len // 16
	add	a,1
	ld	b,a
	ld	de,MSTORE
	ld	ix,CIPHER
PTLOOP	push	bc		; Mix block
	ld	hl,S
	ld	b,16
PTLP1	ld	a,(de)
	xor	a,(hl)
	ld	(hl),a
	inc	hl
	inc	de
	djnz	PTLP1
	pop	bc
	ld	a,b
	sub	a,1
	jr	Z,PTLAST	; Handle last block
	push	bc		; Handle n-1 blocks
	ld	hl,S+7		; Append to cipher
	ld	b,8
PTLP2	ld	a,(hl)
	ld	(ix),a
	dec	hl
	inc	ix
	djnz	PTLP2
	ld	hl,S+15
	ld	b,8
PTLP30	ld	a,(hl)
	ld	(ix),a
	dec	hl
	inc	ix
	djnz	PTLP30
	push	ix
	push	de
	ld	a,8
	ld	c,0xB4		; Round constant init for 8
	call	PERMUT		; Perform A rounds on each block
	pop	de
	pop	ix
PTNEXT	pop	bc
	djnz	PTLOOP
	ret
	;; 
PTLAST	push	bc
	ld	a,(PLEN)
	sla	c
	sla	c
	sla	c
	sla	c
	sub	a,c
	ld	b,a
	ld	c,a
	;; ld	a,b
	sub	a,8
	jr	C,LOWRES	; residual < 8
	ld	hl,S+7		; residual >= 8
	ld 	b,8
PTLP3	ld	a,(hl)
	ld	(ix),a
	dec	hl
	inc	ix
	djnz	PTLP3
	ld	hl,S+15
	call	PTRES
	jr	PTNEXT
	;;
LOWRES	ld	hl,S+7	
	call	PTRES
	ld	b,8		; Unnecessary if CLRed
	ld	a,0
PTLP4	ld	(ix),a
	inc	ix
	djnz	PTLP4
	jr	PTNEXT
	;;
PTRES	ld	b,c
PTLP5	ld	a,(hl)
	ld	(ix),a
	dec	hl
	inc	ix
	djnz	PTLP5
	ld	a,8
	sub	a,c
	ld	b,a
	ld	a,0
PTLP6	ld	(ix),a
	inc	ix
	djnz	PTLP6
	ret
	;; 
PTPADD	ld	a,(PLEN)	; Prepare text blocks in MSTORE
	ld	(PADLEN),a	; for plain text
	ld	ix,MSTORE+7
	ld	iy,PLAIN
	call	PADDING
	ret
	;;
CLRCIPH	ld	hl,CIPHER	
	ld	a,0
	ld	b,16		; Fixed length of cipher
CLRLP	ld	(hl),a
	inc	hl
	djnz	CLRLP
	ret
	;; 
;; PLTEXT	ld	de,PLAIN	; Assuming plaintext length < 16B
;; 	ld	hl,S
;; 	ld	b,16		; Process last (only here) block
;; PLTLP	ld	a,(de)
;; 	xor	a,(hl)
;; 	ld	(hl),a
;; 	inc	de
;; 	inc	hl
;; 	djnz	PLTLP
;; 	ld	a,(PLEN)	; Assumes PLEN < 8
;; 	ld	b,a
;; 	ld	hl,CIPHER
;; 	ld	de,S+7
;; CITLP	ld	a,(de)
;; 	ld	(hl),a
;; 	ld	a,b
;; 	sub	a,1
;; 	ld	b,a
;; 	inc	hl
;; 	dec	de
;; 	jr	NZ,CITLP
;; 	ret
;; 	;; 

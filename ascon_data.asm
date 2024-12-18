;; ADATA	ld	a,(ALEN)
;; 	ld	c,a
;; 	ld	de,ASSOC
;; ABLOCK	ld	hl,S
;; 	ld	b,16		; AEAD128 RATE=16 bytes
;; ADATAL	ld	a,(de)
;; 	xor	a,(hl)
;; 	ld	(hl),a
;; 	inc	hl
;; 	inc	de
;; 	djnz	ADATAL
;; 	push	de
;; 	push	bc
;; 	ld	a,8
;; 	ld	c,0xB4		; Round constant init for 8
;; 	call	PERMUT		; Perform A rounds
;; 	pop	bc
;; 	ld	a,c
;; 	sub	a,16
;; 	ld	c,a
;; 	pop	de
;; 	jr	NZ,ABLOCK
;; 	ld	hl,S+32		; S[4] ^= 1<<63
;; 	ld	a,(hl)
;; 	xor	a,0x80
;; 	ld	(hl),a
;; 	ret
	;;
ADFULL	call	ADPADD	
	ld	a,(ALEN)
	srl	a
	srl	a
	srl	a
	srl	a
	add	a,1
	ld	b,a
	ld	de,MSTORE
ADLOOP	push	bc
	ld	hl,S
	ld	b,16
ADLP1	ld	a,(de)
	xor	a,(hl)
	ld	(hl),a
	inc	de
	inc	hl
	djnz 	ADLP1
	push	de
	ld	a,8
	ld	c,0xB4		; Round constant init for 8
	call	PERMUT		; Perform A rounds on each block
	pop	de
	pop	bc
	djnz	ADLOOP
	ld	hl,S+32		; S[4] ^= 1<<63
	ld	a,(hl)
	xor	a,0x80
	ld	(hl),a
	ret
	;; 
ADPADD	ld	a,(ALEN)	; Prepare text blocks in MSTORE
	ld	(PADLEN),a	; for associated data (AD)
	ld	ix,MSTORE+7
	ld	iy,ADATA
PADDING	srl	a
	srl	a
	srl	a
	srl	a
	ld	b,a
	ld	c,a
	jr	Z,LASTB
	;; 
B1	push	bc
	ld	b,8
B1LP1	ld	a,(iy)
	ld	(ix),a
	inc	iy
	dec	ix
	djnz	B1LP1
	ld	b,0		; Necessary?
	ld	c,15
	add	ix,bc
	ld	b,8
B1LP2	ld	a,(iy)
	ld	(ix),a
	inc	iy
	dec	ix
	djnz	B1LP2
	ld	b,0		; Necessary?
	ld	c,15
	add	ix,bc
	pop	bc
	djnz	B1
	;;
LASTB	ld	a,(PADLEN)
	sla	c
	sla	c
	sla	c
	sla	c
	sub	a,c
	ld	b,a
	ld	c,a
	sub	a,8
	jr	C,LASTB1
	ld	c,a		; B = len
	push	bc		; C = len - 8 >= 0
	ld	b,8		
LASTL1	ld	a,(iy)		
	ld	(ix),a
	inc	iy
	dec	ix
	djnz	LASTL1
	ld	b,0
	ld	c,16
	add	ix,bc
	pop	bc
	call	FILLMIX
	ret
	;;
LASTB1	call	FILLMIX		; B = C = len < 8
	ld	b,0
	ld	c,16
	add	ix,bc
	ld	b,8
	ld	a,0
FILP4	ld	(ix),a
	dec	ix
	djnz	FILP4
	ret
	;; 
FILLMIX	ld	a,0		; B = len
	add	a,c		; C = 8 - len >= 0
	jr	Z,FILLB2
	ld	b,c
FILP1	ld	a,(iy)
	ld	(ix),a
	inc	iy
	dec	ix
	djnz	FILP1
	ld	a,8
	sub	a,c
	jr	Z,FILLOUT
	ld	a,1
	ld	(ix),a
	dec	ix
	ld	a,7
	sub	a,c
	jr	Z,FILLOUT
	ld	b,a
	ld	a,0
FILP2	ld	(ix),a
	dec	ix
	djnz	FILP2
FILLOUT	ret
	;; 
FILLB2	ld	a,1
	ld	(ix),a
	dec	ix
	ld	b,7
	ld	a,0
FILP3	ld	(ix),a
	dec	ix
	djnz	FILP3
	ret
	

PERMUT	ld	b,a		; Core permutation. Rounds in A
ROUND	ld	hl,S+23		; Constant in C 0xF0 or 0xB4
	ld	a,c		; Add round constant to S[2]
	xor	a,(hl)
	ld	(hl),a
	ld	a,c
	sub	15
	ld	c,a
	;;
	push	bc
	call	SUBSTIT		; Substitution layer
	call	LINEAR		; Linear diffusion layer
	;; 
	pop	bc
	djnz	ROUND
	ret
	;;
LINEAR	ld	hl,S		; Linear diffusion layer
	push	hl
	ld	b,19
	ld	c,28
	push	bc
	call	LDL
	ld	hl,S+8
	push	hl
	ld	b,61
	ld	c,39
	push	bc
	call	LDL
	ld	hl,S+16
	push	hl
	ld	b,1
	ld	c,6
	push	bc
	call	LDL
	ld	hl,S+24
	push	hl
	ld	b,10
	ld	c,17
	push	bc
	call	LDL
	ld	hl,S+32
	push	hl
	ld	b,7
	ld	c,41
	push	bc
	call	LDL
	ret
	;; 
LDL	push	hl		; Fill in temp vars T, T+8
	ld	de,TSTORE	; #rots sored in BC pushed on stack
	ld	b,0		; on top of HL
	ld	c,8
	ldir
	pop	hl
	ld	de,TSTORE+8
	ld	c,8
	ldir
	;;
	pop	iy		; preserve return address
	pop	bc
	ld	hl,TSTORE
ARG1L	push	bc
	call	ROTR1
	pop	bc
	djnz	ARG1L
	ld	b,c
	ld	hl,TSTORE+8
ARG2L	push	bc
	call	ROTR1
	pop	bc
	djnz	ARG2L
	;;
	pop	hl		; XOR S[HL] T and T+8
	ld	b,8
	ld	de,TSTORE+8
	ld	ix,TSTORE
XOR3L	ld	a,(de)
	xor	a,(ix)
	xor	a,(hl)
	ld	(hl),a
	inc	hl
	inc	ix
	inc	de
	djnz	XOR3L
	push	iy
	ret
	;; 
ROTR1	push	hl		; Rot right 1b the 8B pointed by HL
	srl	(hl)
	inc	hl
	ld	b,7		; Use B
R1LOOP	rr	(hl)
	inc	hl
	djnz	R1LOOP
	pop	hl
	jr	NC,R1OUT
	ld	a,0x80
	or	a,(hl)
	ld	(hl),a
R1OUT	ret			; HL restored on exit
	;; 
SUBSTIT	ld	hl,S
	ld	de,S+32
	call	XORSTA
	ld	hl,S+32
	ld	de,S+24
	call	XORSTA
	ld	hl,S+16
	ld	de,S+8
	call	XORSTA
	ld	ix,TSTORE	; Compute T
	ld	de,S
	ld	hl,S+8
	call	TSUBST
	call	TSUBST
	call	TSUBST
	call	TSUBST
	ld	hl,S
	call	TSUBST
	;;
	ld	hl,S
	ld	de,TSTORE+8
	call	XORSTA
	call	XORSTA
	call	XORSTA
	call	XORSTA
	ld	de,TSTORE
	call	XORSTA
	;;
	ld	hl,S+8
	ld	de,S
	call	XORSTA
	ld	hl,S
	ld	de,S+32
	call	XORSTA
	ld	hl,S+24
	ld	de,S+16
	call	XORSTA
	ld	b,8
	ld	hl,S+16
FFLOOP	ld	a,(hl)
	xor	a,0xFF
	ld	(hl),a
	inc	hl
	djnz FFLOOP
	ret
	;; 
XORSTA	ld	b,8		; S[hl] ^= S[de]
XORLOOP	ld	a,(de)
	xor	a,(hl)
	ld	(hl),a
	inc	de
	inc	hl
	djnz	XORLOOP
	ret
	;; 
TSUBST	ld	b,8		; T[i] = S[i]^FF & S[i+1%5]
TSLOOP	ld	a,(de)
	xor	a,0xFF
	and	a,(hl)
	ld	(ix),a
	inc	ix
	inc	de
	inc	hl
	djnz	TSLOOP
	ret
	;; 

OUTTAG	ld	hl,STR3
	call	2f0aH
	ld	de,TAG
	jr	SHCUT
	;; 
OUTCIT	ld	hl,STR1
	call	2f0aH
	ld	de,CIPHER
	jr	SHCUT
	;; 
OUTSTA	ld	hl, STR2
	call	2f0aH
	ld	de,S		; Print 5x64 bits state
	call	OUTLN
	call	OUTLN
	call	OUTLN
SHCUT	call	OUTLN
	call	OUTLN
	ret
	;; 
OUTLN	ld	b,4		; Print 1x64 bits line
OUTW	ld	a,(de)		; Print 2 bytes
	ld	h,a
	inc	de
	ld	a,(de)
	ld	l,a
	inc 	de
	call	OUTHEX
	ld	a,0x20
	call	033AH
	djnz	OUTW
	ld	a,0x0D
	call	033AH
	ret
	;; 
OUTHEX	ld	c,h		; Print HL in hex
	call	OUTH8
	ld	a,0x20
	call	033AH
	ld 	c,l
	call	OUTH8
	ret
OUTH8	ld	a,c		; Print C in hex
	and	a,0xF0
	rrca
	rrca
	rrca
	rrca
	call	CONV8
	ld	a,c
	and	0x0F
CONV8	or	a
	daa
	add	a,0xF0
	adc	a,0x40
	call	033AH
	ret
	

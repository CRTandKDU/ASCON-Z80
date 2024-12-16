	org 	7000H
START	call 	01c9H
	xor	a
	ld	(409cH),a
	ld	hl, MSG
	call	2f0aH
	;; 
	call	INITV		; Set up init value
	call	OUTSTA
	ld	a,12
	ld	c,0xF0		; Round constant init for 12
	call	PERMUT		; Perform A rounds
	call	POSTINI		; Terminate initialization
	;;
	call	ADATA		; Process associated data
	;;
	call	PLTEXT		; Process plain text
	;; 
	call	FINALZ		; Finalization
	;; 
	ld	a,0x0D
	call	0033H
	ld	a,0x0D
	call	0033H
	call	OUTCIT		; Print ciphertext
	ld	a,0x0D
	call	0033H
	call	OUTSTA		; Print state
	ld	a,0x0D
	call	0033H
	call	OUTTAG		; Print tag
	ld	a,0x0D
	call	0033H
	;;
	;; 
	jp	06ccH		; Jump to BASIC
	;;
include ascon_out.asm
include ascon_init.asm	
include ascon_perm.asm
include ascon_data.asm
include ascon_plain.asm	
include ascon_final.asm
	;; 
MSG	defb	'ASCON Z80',0x0D,0
S	dc	40,0x0		; 5 64-bit integers
TSTORE	dc	40,0x0		; 5 64-bit integers temp
KLEN	defb	16*8		; Key size in bits
RATE	defb	16		; In bytes
AROUND	defb	12
BROUND	defb	8
KEY	defs	16		; Key 128 bits
NONCE	defs	16		; Nonce 128 bits
VERS	defb	1
	;; Associated data, padded to a multiple of RATE bytes
ASSOC	defb	0,0,1,'NOCSA',0,0,0,0,0,0,0,0
ALEN	defb	16
	;; Plain text (8b max for now) same convention
PLAIN	defb	0,0,1,'nocsa',0,0,0,0,0,0,0,0	
PLEN	defb	5
CIPHER	dc	16,0x0
TAG	dc	16,0x0
	;;
	end START		; Use ASCON<SPACE> to SYSTEM-load

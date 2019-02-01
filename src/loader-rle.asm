	org #a000

; ------------------------------------------------
; main program:

start:
	di	
	ld hl,#C000	; Clear the screen
	ld bc,#4000	
	ld (hl),0
	ld e,l
	ld d,h
	inc	de
	ldir

    ld bc,#7f00   ; Gate array port
    ld a,#8c      ; Mode and ROM selection + set screen 0
    out (c),a     ; Send it

    ; set the border to black
	ld bc,#7f10  	; Gate Array port + select border
	ld a,#54		; select color (black)
	out	(c),c
	out	(c),a

	ld hl,palette_100
	call set_palette

	ld ix,#C000		; load the loading screen
	ld de,16336		; size to load
	ld a,#ff		; synchronization byte
	call topoload

	ld ix,#040
	ld de,32605		; size of the binary to load
	ld a,#ff		; synchronization byte
	call topoload

	jp #40			; run the game!!!


; ------------------------------------------------
; Changes the color palette for MODE 0
; hl : palette pointer (16 colors)
set_palette:
    xor a
palette_loop:
    push af
    ; set pen "a" to hardware color "palette[a]":
    di
    ld bc,#7f00   ;Gate Array port
    out (c),a     ;Send pen number
    ld a,(hl)     ;Pen colour (and Gate Array function)
    out (c),a     ;Send it
    pop af
    inc hl
    inc a
    cp 16
    jr nz,palette_loop
    ret

palette_100:
    db 84, 68, 92, 78, 88, 76, 67, 85, 94, 75, 64, 69, 91, 79, 87, 71	; v3 RLE

rle_count_buffer:
	db 0

; ------------------------------------------------
; This is a modified version of the loader used by TOPO SOFT
; Source code taken from:
; Input:
; - IX = start
; - DE = length (D must not be #ff)
; - A = sync byte expected
;
; Interrupts must be disabled
;
; Output:
; - carry clear - load ok
; - carry set, zero set - time up
; - carry set, zero reset - if esc pressed

topoload:
	inc     d					;; reset the zero flag (D cannot hold #ff)
	ex      af,af'				;; A register holds sync byte. 
	dec     d					;; restore D

	exx
	;; we need B' to be so we can write to gate-array i/o port for colour change when loading

	ld      bc,#7f00+#10		;; Gate-Array + border
	out 	(c),c				;; select pen index to change while loading (#10 is border)
	ld c,#54					;; set to black
	out (c),c
	exx

	ld      bc,#f40e			;; select AY register 14 (for reading keyboard)
	out     (c),c

	ld      bc,#f600+#c0+#10	;; "AY write register" and enable tape motor
	out     (c),c

	ld      c,#10				;; "AY inactive" and enable tape motor (register is latched into AY)
	out     (c),c

	ld      bc,#f792			;; set PPI port A to read (so we can read keyboard data)
	out     (c),c				;; this will also write 0 to port C and port A on CPC.

	ld      bc,#f600+#40+#10+#8	;; tape motor enable, "AY read register", select keyboard row 8
								;; (keys on this row: z, caps lock, a, tab, q, esc, 2, 1)
								;; we are only interested in ESC
	out     (c),c

	;; make an initial read of cassette input
	ld      a,#f5			;; PPI port B
	in      a,(#00)			;; read port (tape read etc)
	and     #80				;; isolate tape read data

	ld      c,a
	cp      a				;; set the zero flag
l8107: 
	ret nz 					;; returns if esc key is pressed (was RET NZ)
l8108: 
	call    l817b
	jr      nc,l8107

	;; the wait is meant to be almost one second
	ld      hl,#415
l8110: 
	djnz    l8110
	dec     hl
	ld      a,h
	or      l
	jr      nz,l8110
	;; continue if only two edges are found within this allowed time period
	call    l8177
	jr      nc,l8107

	;; only accept leader signal
l811c: 
	ld      b,#9c
	call    l8177
	jr      nc,l8107
	ld      a,#b9
	cp      b
	jr      nc,l8108
	inc     h
	jr      nz,l811c

	;; on/off parts of sync pulse
l812b: 
	ld      b,#c9
	call    l817b
	jr      nc,l8107
	ld      a,b
	cp      #d1
	jr      nc,l812b
l8137: 
	call    l817b
	ret     nc

	ld      h,#00			;; parity matching byte (checksum)
	ld      b,#b0			;; timing constant for flag byte and data
	jr      l815d

l8145: 
	ex      af,af'			;; fetch the flags
	jr      nz,l814d		;; jump if we are handling first byte
	;; L = data byte read from cassette
	;; store to RAM
	push af
	ld a,(rle_count_buffer)
	or a
	jr nz,write_to_mem_rle_loop
	ld a,l	
	cp #ff - 14
	jr nc, write_to_mem_rle_start
	ld (ix),l
	inc ix			;; increase destination
	jr write_to_mem_done
write_to_mem_rle_start:
	sub #ff - 14
	ld (rle_count_buffer),a
	jr write_to_mem_done
write_to_mem_rle_loop:
	ld      (ix),l
	inc     ix			;; increase destination
	dec a
	jr nz,write_to_mem_rle_loop
	ld (rle_count_buffer),a
write_to_mem_done:
	pop af
	jr      l8159

l814d: 
	rr      c				;; keep carry in safe place
							;; NOTE: Bit 7 is cassette read previous state
							;; We need to do a right shift so that cassette read moves into bit 6,
							;; our stored carry then goes into bit 7
	xor     l				;; check sync byte is as we expect
	ret     nz

	ld      a,c				;; restore carry flag now
	rla     				;; bit 7 goes into carry restoring it, bit 6 goes back to bit 7 to restore tape input value
	ld      c,a
	inc     de			;; increase counter to compensate for it's decrease
	jr      l8159

l8159: 
	dec     de			;; decrease counter
	ex      af,af'		;; save the flags

	ld      b,#b2		;; timing constant
l815d: 
	ld      l,#01		;; marker bit (defines number of bits to read, and finally becomes value read)
l815f: 
	call    l8177
	ret     nc

	ld      a,#c3		;; compare the length against approx 2,400T states, resetting the carry flag for a '0' and setting it for a '1'
	cp      b
	rl      l			;; include the new bit in the register
	ld      b,#b0		;; set timing constant for next bit
	jr      nc,l815f

	;; L = data byte read
	;; combine with checksum
	ld      a,h
	xor     l
	ld      h,a

	;; DE = count
	ld      a,d
	or      e
	jr      nz,l8145

	exx
	ld c,#54						;; make border black
	out (c),c
	exx

	ld      bc,#f782				;; set PPI port A for output
	out     (c),c
	ld      bc,#f600				;; tape motor off, "AY inactive"
	out     (c),c

	;; H = checksum byte
	;; H = 0 means checksum ok
	ld      a,h
	cp      #01
	;; return with carry flag set if the result is good
	;; carry clear otherwise
	ret     


	;;------------------------------------------------------------
l8177: 
	call l817b			;; in effect call ld-edge-1 twice returning in between if there is an error
	ret nc

	;; wait 358T states before entering sampling loop
l817b: 
	ld a,#16			;; [2]
l817d: 
	dec a				;; [1]
	jr nz,l817d		;; ([3]+[1])*#15+[2]

	and a
l8181: 
	inc b				;; count each pass
	ret z				;; return carry reset and zero set if time up.

	;; read keyboard
	ld a,#f4			;; PPI port A 
	in a,(00h)			;; read port and read keyboard through AY register 14
	and #04				;; isolate state of bit 2 (ESC key)
							;; bit will be 0 if key is pressed
	xor #04				;; has key been pressed? 
	ret nz				;; quit (carry reset, zero reset)

	ld a,#f5			;; PPI port B
	in a,(#00)			;; read port (tape read etc)
	xor c
	and #80				;; isolate tape read
	jr z,l8181
	ld a,c				;; effectively toggle bit 7 of C
	cpl     				;; which is the tape read state we want to see next
	ld c,a

	exx     				;; swap to alternative register set so that we can change colour
	;; this sets colour and gives us the multi colour border
	ld a,r				;; get R register
	and #1f					;; ensure it is in range of colour value
	or #40					;; bit 7 = 0, bit 6 = 1
	out (c),a				;; write colour value
	nop						;; this is to ensure the number of cycles is the same
							;; compared to the replaced instructions
							;; (timings from toposoft loader)
	exx     
	scf     
	ret     

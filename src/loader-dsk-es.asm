;; Adapted from: http://www.cpcwiki.eu/index.php/Programming:An_example_loader

scr_set_mode:		equ #bc0e
scr_set_border:		equ #bc38
scr_set_ink:		equ #bc32	
cas_in_open:		equ #bc77
cas_in_direct:		equ #bc83
cas_in_close:		equ #bc7a
mc_start_program:	equ #bd16
kl_rom_walk:		equ #bccb

;;---------------------------------------------------------------------------


	org #a000

;;------------------------------------------------------------------------
;; store the drive number the loader was run from
	ld hl,(#be7d)
	ld a,(hl)
	ld (drive+1),a

;;------------------------------------------------------------------------
	ld c,#ff					;; disable all roms
	ld hl,start					;; execution address for program
	call mc_start_program		;; start it

;;------------------------------------------------------------------------

start:
	call kl_rom_walk			;; enable all roms 

;;------------------------------------------------------------------------
;; when AMSDOS is enabled, the drive reverts back to drive 0!
;; This will restore the drive number to the drive the loader was run from
drive:
 	ld a,0
	ld hl,(#be7d)
	ld (hl),a

	xor a
	call scr_set_mode
	ld hl,colour_palette
	call setup_colors

;;--------------------------------------------------------------------
;; sequence:
;; 1. load file
;; 2. decompress data (if compressed)
;; 3. relocate data (if required)
;; 
;; NOTE:
;; If data should be relocated to &A600-&BFFF then this must be done last
;; otherwise the firmware jumpblock will be corrupted and no more files can be loaded.
;;
;; If we have data to load which must be relocated we can do the following:
;; 1. set colors to black
;; 2. load data to screen area (not seen because all colors are the same)
;; 3. relocate data to destination address
;;
;; Normal load sequence:
;; - screen
;; - main file
;; - extra file to relocate to firmware jumpblock area
;; - execute program


;;--------------------------------------------------------------------
;; load block
	ld b,end_filename_img-filename_img
	ld hl,filename_img
	call load_block

	ld b,end_filename1-filename1
	ld hl,filename1
	call load_block

	ld b,end_filename2-filename2
	ld hl,filename2
	call load_block

	jp #40			; run the game!!!


;;------------------------------------------------------------------------
;; B = length of filename
;; HL = address of filename
load_block:
	ld de,#c000
	call cas_in_open
	ex de,hl		; load file to location stored in the file header
	call cas_in_direct
	call cas_in_close
	ret



;;------------------------------------------------------------------------
;; setup colors
;;
;; HL = address of palette
;; 
;; order: pen 0, pen 1,...,pen15,border
setup_colors:
	ld b,16			  ;; 16 colors
	xor a			  ;; start with pen 0

do_colors:
	push bc
	push af
	ld c,(hl)		  ;; color value
	inc hl
	ld b,c			  ;; B=C so colors will not flash
	push hl
	;; A = pen number
	;; B,C = color
	call scr_set_ink		  ;; set color for pen
	pop hl
	pop af
	pop bc
	;; increment pen number
	inc a
	djnz do_colors

	;; set border color
	ld c,(hl)
	ld b,c
	call scr_set_border	

	ret


;;------------------------------------------------------------------------
colour_palette:
;	db 0,4,#10,#b,6,#1a,#18,#d,#c,#12,1,#b,4,#f,3,6,0

	db  0,  1,  2,  3,  4,  6,  7, 11, 12, 13, 15, 16, 17, 23, 25, 26, 0
;    db 84, 68, 85, 92, 88, 76, 69, 87, 94, 64, 78, 71, 79, 91, 67, 75	; v3 raw


;;------------------------------------------------------------------------
filename_img:
	db "screen.bin"
end_filename_img:


filename1:
	db "ph2es-b1.bin"
end_filename1:

filename2:
	db "ph2es-b2.bin"
end_filename2:

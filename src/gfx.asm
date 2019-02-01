; ------------------------------------------------
; These functions set the registers of CRTC to change the horizontal resolution
; Code inspired by this: http://cpctech.cpc-live.com/docs/specscrn.html
set_256px_screen_width:
    ;; set width of screen in characters
    ld bc,#bc01
    out (c),c
    ld bc,#bd00+32
    out (c),c

    ;; set horizontal position of screen so that it is centered 
    ld bc,#bc02
    out (c),c
    ld bc,#bd00+42
    out (c),c

    ; This is self-modifying code, I know, I know, it's not good, but it's the easiest solution...
    ld hl,draw_sprite_variable_size_to_screen_ptr_to_selfmodify_offset+1
    ld (hl),SCREEN_WIDTH_IN_BYTES_256px
    ld bc,2*SCREEN_WIDTH_IN_BYTES_256px
    ld (draw_score_board_ptr_to_selfmodify_offset+1),bc

    ret

set_320px_screen_width:
    ;; set width of screen in characters
    ld bc,#bc01
    out (c),c
    ld bc,#bd00+40
    out (c),c

    ;; set horizontal position of screen so that it is centered 
    ld bc,#bc02
    out (c),c
    ld bc,#bd00+46
    out (c),c

    ; This is self-modifying code, I know, I know, it's not good, but it's the easiest solution...
    ld hl,draw_sprite_variable_size_to_screen_ptr_to_selfmodify_offset+1
    ld (hl),SCREEN_WIDTH_IN_BYTES_320px
    ld bc,2*SCREEN_WIDTH_IN_BYTES_320px
    ld (draw_score_board_ptr_to_selfmodify_offset+1),bc

    ret


; ------------------------------------------------
; Arguments:
; - hl: sprite to paint
; - de: video memory address of the top-left pixel (assuming only even x coordinate positions)
; - c: width (in bytes)
; - b: height
draw_sprite_variable_size_to_screen:
draw_sprite_variable_size_to_screen_loop_y:
    push bc
    ld b,c
    push de
draw_sprite_variable_size_to_screen_loop_x:
;    ldi

    ld a,(hl)
    or a
    jr z,draw_sprite_variable_size_to_screen_loop_x_donotdraw
    ld (de),a
draw_sprite_variable_size_to_screen_loop_x_donotdraw:
    inc hl
    inc de

    djnz draw_sprite_variable_size_to_screen_loop_x
    pop de
    ld a,d
    add a,#08
    ld d,a
    sub #C0
    jr nc, draw_sprite_variable_size_to_screen_loop_next_line
draw_sprite_variable_size_to_screen_ptr_to_selfmodify_offset:
    ld bc, #c000 + SCREEN_WIDTH_IN_BYTES_320px
    ex de,hl
    add hl,bc
    ex de,hl
draw_sprite_variable_size_to_screen_loop_next_line:
    pop bc
    djnz draw_sprite_variable_size_to_screen_loop_y
    ret


; ------------------------------------------------
; Arguments:
; This is the reverse of the previous function (except hardcoded for 8x16 pixel sprites, and 256px mode)
; - hl: video memory address of the top-left pixel (assuming only even x coordinate positions)
; - de: RAM address to save this sprite to
capture_sprite_from_screen:
    ld b,16
capture_sprite_from_screen_loop_y:
    push bc
    ld b,4
    push hl
capture_sprite_from_screen_loop_x:
    ld a,(hl)
    ld (de),a
capture_sprite_from_screen_loop_x_donotdraw:
    inc hl
    inc de

    djnz capture_sprite_from_screen_loop_x
    pop hl
    ld a,h
    add a,#08
    ld h,a
    sub #C0
    jr nc, capture_sprite_from_screen_loop_next_line
    ld bc, #c000 + SCREEN_WIDTH_IN_BYTES_256px
    add hl,bc
capture_sprite_from_screen_loop_next_line:
    pop bc
    djnz capture_sprite_from_screen_loop_y
    ret


; ------------------------------------------------
; Flips a sprite horizontally (assuming it's width is a mulitple of 2 pixels)
; - hl: sprite to flip
; - c: width (in bytes)
; - b: height
;flip_sprite:
;flip_sprite_loop_y:
;    push bc
;    push hl
;    ld b,c
;    srl b   ; b = b/2
;
;    push bc
;    push hl
;    ld b,0
;    dec c
;    add hl,bc
;    ld d,h
;    ld e,l  ; de = hl + (width-1)
;    pop hl
;    pop bc
;
;flip_sprite_loop_x:
;    ; flip the bytes from hl to de
;    ld a,(hl)
;    and #55
;    sla a
;    ld ixl,a
;    ld a,(hl)
;    and #aa
;    srl a
;    or ixl
;    ld ixl,a
;
;    ld a,(de)
;    and #55
;    sla a
;    ld ixh,a
;    ld a,(de)
;    and #aa
;    srl a
;    or ixh
;    ld (hl),a
;    ld a,ixl
;    ld (de),a
;
;    inc hl
;    dec de
;    djnz flip_sprite_loop_x
;    pop hl
;    pop bc
;    ld a,c
;    ADD_HL_A
;    djnz flip_sprite_loop_y
;    ret


; ------------------------------------------------
; Flips a 16x8 sprite horizontally
; - hl: sprite to flip
flip_sprite_16x8:
    ld b,16
flip_sprite_loop_y:
    push bc
    ld d,h
    ld e,l  
    inc e
    inc e
    inc e ; de = hl + (width-1)
    ld b,2
flip_sprite_loop_x:
    ; flip the bytes from hl to de
    ld a,(hl)
    and #55
    sla a
    ld ixl,a
    ld a,(hl)
    and #aa
    srl a
    or ixl
    ld ixl,a

    ld a,(de)
    and #55
    sla a
    ld ixh,a
    ld a,(de)
    and #aa
    srl a
    or ixh
    ld (hl),a
    ld a,ixl
    ld (de),a

    inc l
    dec e
    djnz flip_sprite_loop_x
    inc l
    inc l
    pop bc
    djnz flip_sprite_loop_y
    ret


; ------------------------------------------------
; Offset sprite by 1 pixel to the right
; - hl: original sprite
; - de: target sprite
offset_sprite_by_1px:
    ld b,16
offset_sprite_by_1px_y_loop:
    push bc
    ld c,0
    ld b,4
offset_sprite_by_1px_x_loop:
    ld a,(hl)
    and #aa
    srl a
    or c
    ld (de),a
    ld a,(hl)
    and #55
    sla a
    ld c,a
    inc hl
    inc de
    djnz offset_sprite_by_1px_x_loop
    pop bc
    djnz offset_sprite_by_1px_y_loop
    ret
    

; ------------------------------------------------
; Draws an 8x16 sprite
; - time: setting breakpoints in first line and last "ret": 514
; Arguments:
; - hl: sprite to paint
; - de: double buffer address of the top-left pixel (assuming only even x coordinate positions)
draw_sprite:
    ld a,16
draw_sprite_loop_y:
    ldi     ; (de) <- (hl), bc--
    ldi
    ldi
    ldi
    ld bc,64-4
    ex de,hl
    add hl,bc
    ex de,hl
    dec a
    jr nz,draw_sprite_loop_y
	ret


; ------------------------------------------------
; Arguments:
; - hl: sprite to paint
; - de: double buffer address of the top-left pixel (assuming only even x coordinate positions)
; modifies af,bc,de,hl
; Note: the arguments of this function are inverted (this the ex de,hl), just for convenince in the code that calls it
draw_sprite_0_transparent:
    ex de,hl
    ld b,16
draw_sprite_0_transparent_loop_y:
    push bc

    ld a,(de)
    or a
    jr z,draw_sprite_0_transparent_donotdraw1
    ld (hl),a
draw_sprite_0_transparent_donotdraw1:
    inc e
    inc hl

    ld a,(de)
    or a
    jr z,draw_sprite_0_transparent_donotdraw2
    ld (hl),a
draw_sprite_0_transparent_donotdraw2:
    inc e
    inc hl

    ld a,(de)
    or a
    jr z,draw_sprite_0_transparent_donotdraw3
    ld (hl),a
draw_sprite_0_transparent_donotdraw3:
    inc e
    inc hl

    ld a,(de)
    or a
    jr z,draw_sprite_0_transparent_donotdraw4
    ld (hl),a
draw_sprite_0_transparent_donotdraw4:
    inc e
    inc hl

    ld bc,64-4
    add hl,bc
    pop bc
    djnz draw_sprite_0_transparent_loop_y
;    ex de,hl   ; we don't really need to restore de and hl
	ret


; ------------------------------------------------
; hl: double buffer ptr
; de: video memory ptr
copy_tile_from_double_buffer_to_video_memory_256px:
    ld a,8
copy_tile_from_double_buffer_to_video_memory_loop_y:
    ldi     ; (de) <- (hl), bc--
    ldi
    ldi
    ldi
    ld bc,64 - 4  ; update double buffer ptr
    add hl,bc
    ld bc,#0800 - 4 
    ex de,hl
    add hl,bc
    ex de,hl
    dec a
    jr nz,copy_tile_from_double_buffer_to_video_memory_loop_y
    ld bc,SCREEN_WIDTH_IN_BYTES_256px - (#0800 * 8)
    ex de,hl
    add hl,bc
    ex de,hl
    ld a,8
copy_tile_from_double_buffer_to_video_memory_loop_y2:
    ldi     ; (de) <- (hl), bc--
    ldi
    ldi
    ldi
    ld bc,64 - 4  ; update double buffer ptr
    add hl,bc
    ld bc,#0800 - 4
    ex de,hl
    add hl,bc
    ex de,hl
    dec a
    jr nz,copy_tile_from_double_buffer_to_video_memory_loop_y2
    ret


; ------------------------------------------------
; This function is just called at the beginning of each screen to draw the initial frame, so, it does not need to 
; be very optimized.
copy_double_buffer_to_screen_256px:
    ld hl,double_buffer
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET
    ld bc,#8040 ; c = 64, b = 128
copy_second_buffer_to_screen_loop_y:
    push bc
    ld b,0
    push de
    ldir 
    pop de
    ld a,d
    add a,#08
    ld d,a
    sub #C0
    jr nc, copy_second_buffer_to_screen_loop_next_line
    ld bc, #c000+SCREEN_WIDTH_IN_BYTES_256px
    ex de,hl
    add hl,bc
    ex de,hl
copy_second_buffer_to_screen_loop_next_line:
    pop bc
    djnz copy_second_buffer_to_screen_loop_y
    ret


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
    ei
    pop af
    inc hl
    inc a
    cp 16
    jr nz,palette_loop
    ret
    

; ------------------------------------------------
; draws a whole sentence to screen
; - b: color to be used for the letter (in mode 0 encoding)
; - c: length of the sentence
; - hl: sentence to draw
; - de: video memory address of the top-left pixel (assuming only even x coordinate positions)
draw_alphabet_sentence:
    ld a,c
draw_alphabet_sentence_loop:
    push af
    push hl
    push de
    push bc
    ld c,(hl)
    call draw_alphabet_letter
    pop bc
    pop de
    pop hl
    pop af
    inc de
    inc de
    inc hl
    dec a
    jr nz,draw_alphabet_sentence_loop
    ret


; ------------------------------------------------
; draws a letter from the alphabet to screen
; - b: color to be used for the letter (in mode 0 encoding)
; - c: which letter to draw
; - de: video memory address of the top-left pixel (assuming only even x coordinate positions)
draw_alphabet_letter:
    ld a,c
    cp 33
    jp p,draw_alphabet_letter_number
    push de
    call decode_alphabet_letter
    pop de
    ld hl,alphabet_decoding_buffer
    ld bc,2 + 8*256
    jp draw_sprite_variable_size_to_screen
draw_alphabet_letter_number:
    sub 33
    jr draw_digit


; ------------------------------------------------
; Decodes an alphabet letter to draw it in the screen
; The result will be stored at alphabet_decoding_buffer
; - b: color to be used for the letter (in mode 0 encoding)
; - c: which letter to decode
decode_alphabet_letter:
    ld hl,alphabet
    ld de,alphabet_decoding_buffer
    push bc
    ld b,0
    add hl,bc
    add hl,bc
    add hl,bc
    pop bc
    ld a,3
decode_alphabet_letter_loop2:
    push af
    ld c,(hl)
    ld a,4
decode_alphabet_letter_loop1:
    push af
    xor a
    srl c
    jr nc,decode_alphabet_letter_zero
decode_alphabet_letter_one:
    add a,b
    jr decode_alphabet_letter_done
decode_alphabet_letter_zero:
    add a,#40   ; black
decode_alphabet_letter_done:
    add a,a
    srl c
    jr nc,decode_alphabet_letter_zero2
decode_alphabet_letter_one2:
    add a,b
    jr decode_alphabet_letter_done2
decode_alphabet_letter_zero2:
    add a,#40   ; black
decode_alphabet_letter_done2:
    ld (de),a
    inc de
    pop af
    dec a
    jr nz,decode_alphabet_letter_loop1
    inc hl
    pop af
    dec a
    jr nz,decode_alphabet_letter_loop2
    ld a,#c0
    ld (de),a
    inc de
    ld (de),a
    inc de
    ld (de),a
    inc de
    ld (de),a
    ret


; ------------------------------------------------
; Draws a 16-bit number as a 4 digit decimal number to screen
; - hl: number
; - de: video address of the right-most digit
draw_number:
    ld b,4
draw_number_loop:
    push bc
    push de
    call divide_by_10
    ld a,l ; remainder
    pop de  ; restore the video memory address
    push bc ; save the quotient
    push de
    call draw_digit
    pop de
    pop hl  ; quotient to hl
    dec de  ; next digit
    dec de
    pop bc
    djnz draw_number_loop
    ret

; this is SUPER slow, but it doesn't matter, and it's very small in space (which does matter!)
; bc = hl/e
divide_by_10:
    ld a,10
    ld bc,-1
    ld de,10
divide_by_10_loop:
    sbc hl,de
    inc bc
    jr nc,divide_by_10_loop
    add hl,de   ; remainder in hl
    ret


; ------------------------------------------------
; Draws a single digit number to screen
; - a: number
; - de: video address
draw_digit:
    ld hl,HUD_numbers_decompression_buffer
    ld bc,12
    or a
    jr z,draw_digit_loop1_done
draw_digit_loop1:
    add hl,bc
    dec a
    jr nz,draw_digit_loop1
draw_digit_loop1_done: ; hl = HUD_numbers_decompression_buffer + a*(2*6)
    ld bc,6*256+2
    jp draw_sprite_variable_size_to_screen



; ------------------------------------------------
; clears all the video memory
clear_screen:
    ld hl,VIDEO_MEMORY
    ld de,VIDEO_MEMORY+1
    ld bc,(16384-1)-48  ; we subtract 48bytes, since that is not used video memory, and player info is stored there
    xor a
    ld (hl),a
    ldir
    ret


; ------------------------------------------------
; clears all the video memory when we are in 256 pixel mode (preserving the hidden areas)
clear_screen_256px:
    ld hl,VIDEO_MEMORY
    ld de,VIDEO_MEMORY+1
    ld b,8
clear_screen_256px_loop:
    push bc
    push hl
    push de
    ld bc,SCREEN_WIDTH_IN_BYTES_256px*25-1
    xor a
    ld (hl),a
    ldir
    pop hl
    ld bc,#0800
    add hl,bc
    ex de,hl
    pop hl
    add hl,bc
    pop bc
    djnz clear_screen_256px_loop
    ret


; ------------------------------------------------
; flashes the screen to color "a" for "b" times
; - b: number of flashes
; - d: color to flash to
do_b_flashes:
    push bc
    call set_uniform_palette
    ld b,24
    call wait_b_halts
    ld hl,palette_100
    call set_palette
    ld b,24
    call wait_b_halts
    pop bc
    djnz do_b_flashes
    ret


set_uniform_palette:
    xor a
uniform_palette_loop:
    push af
    ; set pen "a" to hardware color "palette[a]":
    di
    ld bc,#7f00   ;Gate Array port
    out (c),a     ;Send pen number
    out (c),d     ;Send it
    ei
    pop af
    inc a
    cp 16
    jr nz,uniform_palette_loop
    ret


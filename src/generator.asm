; ------------------------------------------------
; This function is called at each frame when the player is in the pedal generator room
update_pedal_generator:
	; 1) check if the player is on top of the pedal generator
	ld a,(player_x)
	cp 6
	jp m,update_pedal_generator_clear_message
	cp 14
	jp p,update_pedal_generator_clear_message
	ld a,(player_y)
	cp 64
	jr nz,update_pedal_generator_clear_message

	; the player is on top of the generator:
	; 2) is the generator activated with the wheel already?
	ld a,(player_generator_state)
	bit 0,a
	jr nz,update_pedal_generator_start_pedaling

	; 3) check if the player has the wheel
    ld a,(player_inventory+ITEM_WHEEL-1)
    or a
    jr nz,update_pedal_generator_use_wheel

	ld a,(player_generator_state)
	bit 1,a
	ret nz	; if the player was already on top, no need to redraw

    ; 4) display message that you need the wheel:
;    ld bc,256*#55 + 20    ; color 15 (white) + length 20
;    ld hl,menu_line1_spaces
;    ld de,VIDEO_MEMORY+20+1*80
;    call draw_alphabet_sentence
    ld bc,256*#55 + 19    ; color 15 (white) + length 19
    ld hl,youneedthecog_text
    ld de,VIDEO_MEMORY+11+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 19    ; color 15 (white) + length 19
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+11+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence

    ; mark that the player was on top of the generator
    ld hl,player_generator_state
	ld a,(hl)
	or #02
	ld (hl),a
	ret

update_dracula_clear_message:
update_pedal_generator_clear_message:
    ld hl,player_generator_state
	ld a,(hl)
	bit 1,a
	ret z	; if the player was not on top, no need to clear the text
	and #fd
	ld (hl),a

update_dracula_clear_message2:
update_pedal_generator_clear_message2:
    ld hl,dirty_tiles
    ld (hl),2
    ld de,dirty_tiles+1
    ld bc,31
    ldir
	ret

update_pedal_generator_use_wheel:
	ld a,ITEM_WHEEL-1
	call score_board_remove_item
    ld hl,player_generator_state
	ld a,(hl)
	or #01
	ld (hl),a

update_pedal_generator_start_pedaling:
    ; 4) display message to start pedaling:
;    ld bc,256*#55 + 17    ; color 15 (white) + length 17
;    ld hl,menu_line1_spaces
;    ld de,VIDEO_MEMORY+20+1*80
;    call draw_alphabet_sentence
    ld bc,256*#55 + 17    ; color 15 (white) + length 17
    ld hl,pedalinstructions_text
    ld de,VIDEO_MEMORY+15+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 17    ; color 15 (white) + length 17
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+15+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence

    ; put player on the spot
    ld hl,player_y
    ld (hl),60	; player y
    inc hl
    ld (hl),8	; player x
    inc hl
    ld (hl),1	; player sprite

    ; use this variable as a counter:
    ld hl,player_generator_state
    ld (hl),0

    ; remove the pedal generator temporarily
    ld bc,(current_map_fg+(16*4+1)*2)    
    ld (generator_ptr_buffer),bc
    ld bc,(enemy_sprites/256) + (enemy_sprites%256)*256	; I reversed the bytes, so, I need to do this... oh well...
    ld (current_map_fg+(16*4+1)*2),bc

update_pedal_generator_start_pedaling_loop:
    ld a,(vsyncs_since_last_frame)
    cp 2
    jp m,update_pedal_generator_start_pedaling_loop

    ; draw:
    call restore_background_dirty_tiles ; draw background dirty tiles from previous iteration
;    call draw_enemies
    call draw_player
;    call draw_items ; items are usually not updated, but locks require a palette rotation, which is handled here
    call restore_foreground_dirty_tiles_256px ; draw foreground dirty tiles from this or previous iteration + copy result to video memory

    ; update
;    call update_enemies
    call update_keyboard_buffers
;    call update_player
;    call update_items

    ld a,(keyboard_press)
    bit KEYBOARD_ESC_BIT,a
    call z,game_pause

    ld b,a
    ld hl,player_generator_state
    ld a,(hl)

	cp 32
	jp m,update_pedal_generator_start_pedaling_loop_pedaling
	jr nz,update_pedal_generator_start_pedaling_loop_jumping
update_pedal_generator_start_pedaling_loop_first_frame_of_jump:
    ; restore the pedal generator tile
    ld bc,(generator_ptr_buffer)
    ld (current_map_fg+(16*4+1)*2),bc
    push hl
    push af
    call play_jump_SFX
    pop af
    pop hl
update_pedal_generator_start_pedaling_loop_jumping:
	inc (hl)	; increment the counter
	bit 0,a
	ld hl,player_sprite
	ld (hl),3
	ld hl,player_y
	jr z,update_pedal_generator_start_pedaling_loop_jumping2
	dec (hl)
update_pedal_generator_start_pedaling_loop_jumping2:
	inc hl
	inc (hl)
	inc (hl)
	ld a,(hl)
	cp 14*8
	jp p,update_pedal_generator_done_pedaling

	jr update_pedal_generator_start_pedaling_loop_continue

update_pedal_generator_start_pedaling_loop_pedaling:
    bit 0,a
    jr z,update_pedal_generator_start_pedaling_loop_need_o
update_pedal_generator_start_pedaling_loop_need_p:
    bit KEYBOARD_RIGHT_BIT,b
    jr nz,update_pedal_generator_start_pedaling_loop_continue
    inc a
    ld (hl),a
    ld hl,player_y
    ld (hl),60	; player y
    ld bc,(enemy_sprites/256) + (enemy_sprites%256)*256	; I reversed the bytes, so, I need to do this... oh well...
    ld (current_map_fg+(16*4+1)*2),bc    
    jr update_pedal_generator_start_pedaling_loop_continue
update_pedal_generator_start_pedaling_loop_need_o:
    bit KEYBOARD_LEFT_BIT,b
    jr nz,update_pedal_generator_start_pedaling_loop_continue
    inc a
    ld (hl),a
    ld hl,player_y
    ld (hl),61	; player y
    ld bc,((enemy_sprites+64)/256) + ((enemy_sprites+64)%256)*256	; I reversed the bytes, so, I need to do this... oh well...
    ld (current_map_fg+(16*4+1)*2),bc    
update_pedal_generator_start_pedaling_loop_continue:

    ld hl,vsyncs_since_last_frame
    dec (hl)
    dec (hl)    ; we decrement it twice, since we want one frame each 2 vsyncs

    ; next game frame:
    ld hl,current_game_frame
    inc (hl)
    jp update_pedal_generator_start_pedaling_loop

update_pedal_generator_done_pedaling:
    ; reset the state of the generator
    ld hl,player_generator_state
    ld (hl),1

    jp update_pedal_generator_clear_message2


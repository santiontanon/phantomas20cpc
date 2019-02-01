; ------------------------------------------------
; This function is called at each frame when the player is in the dracula room
update_dracula:
	; 1) check if the player is near dracula's coffin
	ld a,(player_x)
	cp 48
;   cp 52
	jp m,update_dracula_clear_message
	cp 73
;   cp 69
	jp p,update_dracula_clear_message
	ld a,(player_y)
	cp 81
	jp p,update_dracula_clear_message

	; the player is near dracula's coffin:
	; 2) check if the player has opened all the windows and has all the objects
    call update_dracule_print_messages_of_missing_weapons
    ld hl,player_inventory+ITEM_CROSS-1
    ld a,(hl)
    or a
    ret z
    inc hl
    ld a,(hl)
    or a
    ret z
    inc hl
    ld a,(hl)
    or a
    ret z
    ld a,(player_window_state)
    or a
    ret nz
    jp update_dracula_teleport_to_final_battle


update_dracule_print_messages_of_missing_weapons:
    ld hl,player_dracula_state
    ld a,(hl)
    bit 1,a
    ret nz  ; if the player was already on top, no need to redraw
    ; mark that the player was near dracula
    or #02
    ld (hl),a
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+8+0*SCREEN_WIDTH_IN_BYTES_256px
	ld hl,player_inventory+ITEM_CROSS-1
    ld a,(hl)
    or a
    jr nz,update_dracula_not_missing_item1
        push hl
        ld bc,256*#55 + 23    ; color 15 (white) + length 23
        ld hl,needcross_text
        push de
        call draw_alphabet_sentence
        pop de
        ex de,hl
        ld bc,SCREEN_WIDTH_IN_BYTES_256px
        add hl,bc
        ex de,hl
        pop hl
update_dracula_not_missing_item1:
    inc hl
    ld a,(hl)
    or a
    jr nz,update_dracula_not_missing_item2
        push hl
        ld bc,256*#55 + 23    ; color 15 (white) + length 23
        ld hl,needstake_text
        push de
        call draw_alphabet_sentence
        pop de
        ex de,hl
        ld bc,SCREEN_WIDTH_IN_BYTES_256px
        add hl,bc
        ex de,hl
        pop hl
update_dracula_not_missing_item2:
    inc hl
    ld a,(hl)
    or a
    jr nz,update_dracula_not_missing_item3
        ld bc,256*#55 + 23    ; color 15 (white) + length 23
        ld hl,needhammer_text
        push de
        call draw_alphabet_sentence
        pop de
        ex de,hl
        ld bc,SCREEN_WIDTH_IN_BYTES_256px
        add hl,bc
        ex de,hl
update_dracula_not_missing_item3:
    ld a,(player_window_state)
    or a
    ret z
update_dracula_missing_windows:
    ld bc,256*#55 + 21    ; color 15 (white) + length 21
    ld hl,closewindows_text
    jp draw_alphabet_sentence


draw_phantomas_dialogue_face
    ; 16*8 x 19*8
    ld a,(dracula_tiles_ptrs+(3*4+2)*2)
    ld h,a
    ld a,(dracula_tiles_ptrs+(3*4+2)*2+1)
    ld l,a
    ;ld hl,(dracula_tiles_ptrs+(3*4+2)*2)
    ;ld hl,#c000 + 1*4 + 19*SCREEN_WIDTH_IN_BYTES_256px
    ld de,#c000 + 0*4 +  0*SCREEN_WIDTH_IN_BYTES_256px
    ;jr draw_phantomas_dialogue_face_entry_point
    ld bc,#1004
    jp draw_sprite_variable_size_to_screen


draw_dracula_dialogue_face:
    ; 16*8 x 19*8
    ld a,(dracula_tiles_ptrs+(4*4+2)*2)
    ld h,a
    ld a,(dracula_tiles_ptrs+(4*4+2)*2+1)
    ld l,a
    ;ld hl,(dracula_tiles_ptrs+(4*4+2)*2)
    ;ld hl,#c000 + 14*4 + 19*SCREEN_WIDTH_IN_BYTES_256px
    ld de,#c000 + 15*4 +  0*SCREEN_WIDTH_IN_BYTES_256px
    ld bc,#1004
    jp draw_sprite_variable_size_to_screen
;draw_phantomas_dialogue_face_entry_point:
;    ld b,2
;draw_dracula_dialogue_face_loop1:
;    push bc
;    push hl
;    push de
;    ld b,8
;draw_dracula_dialogue_face_loop2:
;    push bc
;    ldi
;    ldi
;    ldi
;    ldi
;    ld bc,#0800-4
;    add hl,bc
;    ex de,hl
;    add hl,bc
;    ex de,hl
;    pop bc
;    djnz draw_dracula_dialogue_face_loop2
;    pop de
;    pop hl
;    ld bc,SCREEN_WIDTH_IN_BYTES_256px
;    add hl,bc
;    ex de,hl
;    add hl,bc
;    ex de,hl
;    pop bc
;    djnz draw_dracula_dialogue_face_loop1
;    ret


; ------------------------------------------------
; When the player has accomplished all the tasks on the game and reaches the final coffin,
; this function is called to start the final battle!
update_dracula_teleport_to_final_battle:
    pop af  ; simulate a "ret" (since we came to "update_dracula" with a "call")
    call StopPlayingMusic
	ld hl,SFX_door_open
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority	

	; a couple of flashes
	ld b,5
	ld d,#4b	; flash to whites
	call do_b_flashes

    ld a,3	; final battle
    ld (current_map),a

    ld hl,castle_map+(MAP_WIDTH*1+6)  ; teleport to the final battle room
    ld (current_map_ptr),hl
    ld a,RESPAWN_FROM_LEFT
    ld (player_respawn_direction),a
    ld a,1
    ld (player_respawning),a
    xor a
    ld (player_state),a
    ld (player_sprite),a

    ; save the sprites of the tools in the scoreboard, in case we need to restore them when we die:
    ld hl, VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 11*4  ; pointer to the video memory address where the tools are
    ld de, item_sprites
    call capture_sprite_from_screen

    ld hl, VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 12*4  ; pointer to the video memory address where the second tool is
    ld de, item_sprites+64
    call capture_sprite_from_screen

    ; this is the label to which we will jump if we lose a life during the final battle
init_game_loop_dracula:
    ld c,FADE_IN_OUT_SPEED
    call fade_out
    call load_map_and_setup_for_game_loop

    ; reset the tools, in case we had used some of them:
    ld de, VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 11*4  ; pointer to the video memory address where the tools are
    ld hl, item_sprites
    ld bc,16*256 + 4
    call draw_sprite_variable_size_to_screen
    ld de, VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 12*4  ; pointer to the video memory address where the second tool is
    ld hl, item_sprites+64  ; second tool
    ld bc,16*256 + 4
    call draw_sprite_variable_size_to_screen

    ; load the necessary enemies:
    ld de,enemy_sprites
    ld hl,vampire_compressed
	call load_vampire_sprites
	ld de,enemy_sprites+64*12
    ld hl,laser_vertical_compressed
	call load_laser_sprites

    ld hl,dracula_state1
    xor a
    ld (hl),a
    dec hl
    ld (hl),a
    dec hl
    ld (hl),a

;   IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_ENDING
;	    ld (hl),4	;; to make it so that we only need to hit the item once!
;	ENDIF

    ; store the pointers to the dracula tiles (and clear the tiles in the screen):
    ld b,6
    ld hl,current_map_bg+(1*16+12)*2
    ld de,dracula_tiles_ptrs
init_game_loop_dracula_loop:
	push bc
    ld bc,8
    ldir
    ld bc,(16-4)*2
    add hl,bc
    pop bc
    djnz init_game_loop_dracula_loop

    call clear_dracula

    ; set dracula to it's initial state:
    call draw_dracula_bottom
	ld hl,dracula_tiles_ptrs+(4*4+3)*2	; set the cross item as the first one to be used
	call dracula_set_item_to_use

    ; redraw the map:
    call draw_current_map ; draw it to the back buffer
    call copy_double_buffer_to_screen_256px   ; copy the copy of the map in the double buffer to screen
    call restore_background_draw_player_restore_foreground

    ld c,FADE_IN_OUT_SPEED
    call fade_in

    ; jump to init_game_loop_dracula_intro_dialogue_loop_done if it's not the first time
    ld a,(already_seen_final_battle_intro)
    or a
    jp nz,init_game_loop_dracula_intro_dialogue_loop_done

    ld a,5
init_game_loop_dracula_intro_dialogue_loop:
    push af

    dec a
    jp z,init_game_loop_dracula_intro_dialogue_loop_d5
    dec a
    jr z,init_game_loop_dracula_intro_dialogue_loop_d4
    dec a
    jr z,init_game_loop_dracula_intro_dialogue_loop_d3
    dec a
    jr z,init_game_loop_dracula_intro_dialogue_loop_d2

init_game_loop_dracula_intro_dialogue_loop_d1:
    ; show message:
    ld bc,256*#55 + 28    ; color 15 (white) + length 28
    ld hl,draculaintro_text1
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 30    ; color 15 (white) + length 30
    ld hl,draculaintro_text2
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    call draw_dracula_dialogue_face
    jr init_game_loop_dracula_space_loop

init_game_loop_dracula_intro_dialogue_loop_d2:
    ; show message:
    ld bc,256*#55 + 30    ; color 15 (white) + length 30
    ld hl,draculaintro_text3
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 29    ; color 15 (white) + length 29
    ld hl,draculaintro_text4
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 27    ; color 15 (white) + length 27
    ld hl,draculaintro_text5
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+2*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    call draw_phantomas_dialogue_face
    jr init_game_loop_dracula_space_loop

init_game_loop_dracula_intro_dialogue_loop_d3:
    ; show message:
    ld bc,256*#55 + 30    ; color 15 (white) + length 30
    ld hl,draculaintro_text6
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 28    ; color 15 (white) + length 28
    ld hl,draculaintro_text7
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 9    ; color 15 (white) + length 9
    ld hl,draculaintro_text8
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+2*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    call draw_phantomas_dialogue_face
    jr init_game_loop_dracula_space_loop

init_game_loop_dracula_intro_dialogue_loop_d4:
    ; show message:
    ld bc,256*#55 + 3    ; color 15 (white) + length 3
    ld hl,draculaintro_text9
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+52+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    call draw_dracula_dialogue_face
    jr init_game_loop_dracula_space_loop

init_game_loop_dracula_intro_dialogue_loop_d5:
    ; show message:
    ld bc,256*#55 + 3    ; color 15 (white) + length 3
    ld hl,draculaintro_text9
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+4+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    call draw_phantomas_dialogue_face

    ; wait for space/esc to be pressed
init_game_loop_dracula_space_loop:
	halt
    call update_keyboard_buffers
    ld a,(keyboard_press)
    bit KEYBOARD_SPACE_BIT,a
    jr z,init_game_loop_dracula_space_loop_done
    bit KEYBOARD_ESC_BIT,a
    jr nz,init_game_loop_dracula_space_loop
init_game_loop_dracula_space_loop_done:

    call update_dracula_clear_message2
    call restore_background_draw_player_restore_foreground

    pop af
    dec a
    jp nz,init_game_loop_dracula_intro_dialogue_loop

init_game_loop_dracula_intro_dialogue_loop_done:
    ld a,1
    ld (already_seen_final_battle_intro),a  ; do not show these messages again if you die

    ; stop heartbeats and play a song again:
    ld a,(sound_mode)
    or a
    jr nz,game_loop_dracula
    call StopPlayingMusic
    ld hl,ingame_song_compressed
    ld de,music_buffer
    call decompress
    ld a,9  ; tempo
    call play_song

game_loop_dracula:
    ld a,(vsyncs_since_last_frame)
    cp 2
    jp m,game_loop_dracula

    ; draw:
    call restore_background_dirty_tiles ; draw background dirty tiles from previous iteration
    call draw_enemies
    call draw_player
;    call draw_items ; items are usually not updated, but locks require a palette rotation, which is handled here
    call restore_foreground_dirty_tiles_256px ; draw foreground dirty tiles from this or previous iteration + copy result to video memory

    ; update
    call update_enemies
    call update_keyboard_buffers
    call update_player
;    call update_items

    ld a,(keyboard_press)
    bit KEYBOARD_ESC_BIT,a
    call z,game_pause

    ld hl,vsyncs_since_last_frame
    dec (hl)
    dec (hl)    ; we decrement it twice, since we want one frame each 2 vsyncs

    ; lose a life if you go down
    ld a,(player_y)
    cp 112
    jp p,player_life_lost_dec_life

    ; if dracula touches you, you lose a life
    ld a,(dracula_state2)
    and #02	; in states 0 and 1, it can kill you
    jr nz,game_loop_dracula_cannot_kill_you
    ld a,(player_x)
    cp 12*8+2
    jp p,player_life_lost_dec_life
;    jp m,game_loop_dracula_cannot_kill_you
;    cp 15*8-5
;    jp m,player_life_lost_dec_life
game_loop_dracula_cannot_kill_you:

	; if you reach the item location, teleport back, and require next item:
    ld a,(player_x)
    cp 14*8+6
    jp m,game_loop_not_at_item
    ld a,(player_y)
    cp 5*16

    call z,game_loop_dracula_player_touched_item
game_loop_not_at_item:

    ; update dracula:
    ld hl,dracula_state1
    inc (hl)
    ld b,(hl)	; we save dracula_state1
    dec hl	; dracula_state2
    ld a,(hl)
    or a
    jr z,game_loop_dracula_state0
    dec a
    jr z,game_loop_dracula_state1
;    dec a
;    jr z,game_loop_dracula_state2
game_loop_dracula_state2:
	ld a,b	; restore dracula_state1

	; spawn lightnings
	push hl
	push af
;	cp 127-32
;	jp z,dracula_remove_bats
	cp 140
	jp z,dracula_spawn_lightning
	cp 180
	jp z,dracula_spawn_lightning
	cp 204
	jp z,dracula_remove_bats
	cp 220
	jp z,dracula_spawn_lightning
dracula_bats_removed:
dracula_spawn_lightning_spawned:
	pop af
	pop hl
	cp 255
	jr nz,game_loop_dracula_no_state_change
	ld (hl),0
	inc hl ; dracula_state1
	ld (hl),0
	call draw_dracula_bottom
	ld hl,n_enemies
	ld (hl),0
	; check if we need to respawn the next item:
	ld hl,dracula_state3
	ld a,(hl)
	push af
	cp 1
	call z,game_loop_dracula_set_item2
	pop af
	cp 3
	call z,game_loop_dracula_set_item3
	jr game_loop_dracula_no_state_change
game_loop_dracula_state1:
	ld a,b	; restore dracula_state1
	cp 128+32	; move dracula when bats are half way
;	cp 255	; this one waits for a whole bat cycle
	jr nz,game_loop_dracula_no_state_change
	ld (hl),2
	inc hl ; dracula_state1
	ld (hl),127	; to make state 2 be shorter
	call draw_dracula_top
	; remove bats
;	ld hl,n_enemies
;	ld (hl),1	; we still leave the lightning
	jr game_loop_dracula_no_state_change
game_loop_dracula_state0:
	ld a,b	; restore dracula_state1
	cp 63
	jr nz,game_loop_dracula_no_state_change
	ld (hl),1
	inc hl ; dracula_state1
	ld (hl),84 ; to make state 1 be shorter
	call draw_dracula_bottom_arm
	; spawn bats:
	ld hl,dracula_bat_spawn_data
	ld de,n_enemies
	ld bc,dracula_bat_spawn_data_end - dracula_bat_spawn_data
	ldir
;	jr game_loop_dracula_no_state_change
game_loop_dracula_no_state_change:

	; flash when dracula moves
	ld a,(dracula_state1)
	cp 256-8
	jr c,game_loop_dracula_no_flash
	and #02
	jr z,game_loop_dracula_flash_white
    ld hl,palette_100
    call set_palette
    jr game_loop_dracula_no_flash
game_loop_dracula_flash_white:
    ld hl,palette_white
    call set_palette
game_loop_dracula_no_flash:

    ; next game frame:
    ld hl,current_game_frame
    inc (hl)
    jp game_loop_dracula


game_loop_dracula_player_touched_item:
	ld hl,dracula_state3
	ld a,(hl)
	cp 1
	ret z
	cp 3
	ret z
	; increase state
	inc a
	ld (hl),a

	push af
	; SFX and flash:
	ld hl,SFX_door_open
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority	
	ld b,5
	ld d,#4c	; flash to red
	call do_b_flashes
	call game_loop_dracula_clear_item

    ; remove item from inventory:
    pop af
    push af
    srl a   ; we divide the state by 2, so now we have 0, 1 or 2
    ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 11*4  ; pointer to the video memory address where the tools are
    or a
    jr z,game_loop_dracula_player_touched_item_remove_tool_loop_done
game_loop_dracula_player_touched_item_remove_tool_loop:
    inc de
    inc de
    inc de
    inc de
    dec a
    jr nz,game_loop_dracula_player_touched_item_remove_tool_loop
game_loop_dracula_player_touched_item_remove_tool_loop_done:
    ld a,(dracula_tiles_ptrs+8*5+4)
    ld h,a
    ld a,(dracula_tiles_ptrs+8*5+5)
    ld l,a
    ld bc,16*256 + 4
    call draw_sprite_variable_size_to_screen

    ; make music faster, and higher pitch:
    ld hl,Music_tempo
    dec (hl)
    dec (hl)
    ld hl,MUSIC_transpose
    inc (hl)

	pop af
	cp 5
	ret nz


	; we have killed dracula!!!!! 
	; increase score KILL_DRACULA_SCORE for killing dracula + REMAINING_LIFE_SCORE for each extra life
    ld hl,(player_score)
    ld de,KILL_DRACULA_SCORE
    add hl,de
    ld de,REMAINING_LIFE_SCORE
    ld a,(player_lives)
    dec a
    jr z,game_loop_dracula_player_lifes_score_loop_done
    ld b,a
game_loop_dracula_player_lifes_score_loop:
    add hl,de
    djnz game_loop_dracula_player_lifes_score_loop
game_loop_dracula_player_lifes_score_loop_done:

    ld de,REMAINING_HEALTH_SCORE
    ld a,(player_health)
    dec a
    jr z,game_loop_dracula_player_health_score_loop_done
    ld b,a
game_loop_dracula_player_health_score_loop:
    add hl,de
    djnz game_loop_dracula_player_health_score_loop
game_loop_dracula_player_health_score_loop_done:

    ld (player_score),hl
    call redraw_scoreboard_score
    jp ending_sequence

game_loop_dracula_clear_item: 
	ld hl,current_map_bg	; clear the item
	jp dracula_set_item_to_use

game_loop_dracula_set_item2:
	ld hl,dracula_state3
	ld (hl),2
	ld hl,dracula_tiles_ptrs+(3*4+3)*2	; set the cross item as the first one to be used
	jp dracula_set_item_to_use
;	xor a
;	ld (player_x),a
;	ld a,6*16
;	ld (player_y),a
;	jp game_loop_not_at_item

game_loop_dracula_set_item3:
	ld hl,dracula_state3
	ld (hl),4
	ld hl,dracula_tiles_ptrs+(2*4+3)*2	; set the cross item as the first one to be used
	jp dracula_set_item_to_use


clear_dracula:
    ld b,6
    ld hl,current_map_bg+(1*16+12)*2
    ld a,(dracula_tiles_ptrs+4)
    ld d,a
    ld a,(dracula_tiles_ptrs+5)
    ld e,a
clear_dracula_loop:
	push bc
	ld b,3
clear_dracula_loopb:
	ld (hl),d
	inc hl
	ld (hl),e
	inc hl
	djnz clear_dracula_loopb
    ld bc,(16-3)*2
    add hl,bc
    pop bc
    djnz clear_dracula_loop

    ; set the proper dirty tiles:
    ld hl,dirty_tiles+1*16+13
    ld a,2
    ld b,6
clear_dracula_loop2:
    ld (hl),a
    inc hl
    ld (hl),a
    inc hl
    push bc
    ld bc,14
    add hl,bc
    pop bc
    djnz clear_dracula_loop2
    ret


draw_dracula_top:
	call clear_dracula
    ld de,current_map_bg+(1*16+13)*2
    ld hl,dracula_tiles_ptrs
draw_dracula_top_entry_point:
    ld b,3
draw_dracula_top_loop:
	push bc
    ld bc,4
    ldir
    inc hl
    inc hl
    inc hl
    inc hl
    ld bc,(16-2)*2
    ex de,hl
    add hl,bc
    ex de,hl
    pop bc
    djnz draw_dracula_top_loop
    ret


draw_dracula_bottom:
	call clear_dracula
    ld de,current_map_bg+(4*16+13)*2
    ld hl,dracula_tiles_ptrs+8*3
	jr draw_dracula_top_entry_point


draw_dracula_bottom_arm:
	call draw_dracula_bottom
    ld de,current_map_bg+(4*16+14)*2
    ld hl,dracula_tiles_ptrs+8*0+6
	ldi
	ldi
    ld de,current_map_bg+(5*16+14)*2
    ld hl,dracula_tiles_ptrs+8*1+6
	ldi
	ldi
	ret


dracula_set_item_to_use:
;	ld hl,dracula_tiles_ptrs+(4*4+3)*2
	ld de,current_map_bg+(5*16+15)*2
	ldi
	ldi
	; clear the two spots above, just in case
    ld a,(dracula_tiles_ptrs+4)
    ld d,a
    ld a,(dracula_tiles_ptrs+5)
    ld e,a
    ld hl,current_map_bg+(1*16+15)*2
    ld a,4
dracula_set_item_to_use_loop:
    ld (hl),d
    inc hl
    ld (hl),e
    ld bc,31
    add hl,bc
    dec a
    jr nz,dracula_set_item_to_use_loop
    ; set all dirty
    ld a,5
    ld bc,16
	ld hl,dirty_tiles+1*16+15
dracula_set_item_to_use_loop2:
	ld (hl),2
	add hl,bc
	dec a
	jr nz,dracula_set_item_to_use_loop2
;	ld hl,dirty_tiles+2*16+15
;	ld (hl),2
;	ld hl,dirty_tiles+3*16+15
;	ld (hl),2
;	ld hl,dirty_tiles+4*16+15
;	ld (hl),2
;	ld hl,dirty_tiles+5*16+15
;	ld (hl),2
	ret

dracula_remove_bats:
	; remove bats
	ld hl,n_enemies
	ld (hl),1	; we still leave the lightning
	jp dracula_bats_removed

dracula_spawn_lightning:
	; spawn lightning:
;	ld hl,dracula_lightning_spawn_data
;	ld de,n_enemies
;	ld bc,dracula_lightning_spawn_data_end - dracula_lightning_spawn_data
;	ldir
	ld hl,enemies
	ld (hl),ENEMY_STATE_VLASER_HIDDEN
	ld a,(player_x)
	ld (enemies+3),a
	srl a
	ld l,a
	ld h,0
	ld bc,double_buffer
	add hl,bc
	ld (enemies+5),hl
	ld hl,current_game_frame
	ld (hl),64-8	; make the lightning show almost immediately (player has 8 frames to get out of the way)
	jp dracula_spawn_lightning_spawned


; (10 bytes each enemy) state, lower movement bound, upper movement bound, x, y, video mem address (dw), sprites ptr (dw), animation type
; video mem address = double_buffer + x/2 + y*64
dracula_bat_spawn_data:
	db 4	; n_enemies
	db ENEMY_STATE_NONE, 0,128, 120, 0	; we put an "ENEMY_STATE_NONE", since those are basically ignored
	dw double_buffer + 120/2 + (0)*120, enemy_sprites+64*12
	db ENEMY_LASER_VERTICAL	; v laser

	db ENEMY_STATE_WAVE_LEFT+3, 4,120, 120, 2*16+4
	dw double_buffer + 120/2 + (2*16+4)*64, enemy_sprites
	db ENEMY_ANIMATION_STYLE_VAMPIRE	; bat 1

	db ENEMY_STATE_WAVE_LEFT+2, 20,120, 104, 4*16
	dw double_buffer + 104/2 + (4*16)*64, enemy_sprites
	db ENEMY_ANIMATION_STYLE_VAMPIRE	; bat 2

	db ENEMY_STATE_WAVE_LEFT+1, 56,120, 100, 6*16-8
	dw double_buffer + 100/2 + (6*16-8)*64, enemy_sprites
	db ENEMY_ANIMATION_STYLE_VAMPIRE	; bat 3
dracula_bat_spawn_data_end:


;dracula_lightning_spawn_data:
;	db 1	; n_enemies
;	db ENEMY_STATE_VLASER_HIDDEN, 0,112, 64, 0
;	dw double_buffer + 64/2 + (0)*64, enemy_sprites+64*12
;	db ENEMY_LASER_VERTICAL	; v laser
;dracula_lightning_spawn_data_end:


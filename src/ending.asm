ending_sequence:
	; 1) stop music, start heart beat sound and clear the room of enemies
	call StopPlayingMusic
    
	; reset player position, so that it starts wherever we want:
	xor a
	ld hl,player_y
	ld (hl),80	
	inc hl
	ld (hl),116	; player_y
	ld b,4
ending_sequence_init_loop:
	inc hl
	ld (hl),a	; player_sprite, player_state_timer, player_state, player_invincibility
	djnz ending_sequence_init_loop

	ld (n_enemies),a

	call restore_background_draw_player_restore_foreground

    ld bc,300
    call wait_bc_halts	;; small pause (1 second)

    ld hl,heartbeat_song_compressed
    ld de,music_buffer
    call decompress
    ld a,1  ; tempo
    call play_song

	; 2) vanish effect + SFX:
	call ending_sequence_vanish

	; 3) text: "me has vencido, bla bla, si yo me derrumbo tu caerás conmigo""
    ; show message:
    ld bc,256*#55 + 31    ; color 15 (white) + length 31
    ld hl,draculaending_text1
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 29    ; color 15 (white) + length 29
    ld hl,draculaending_text2
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+2+1*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence

    ld bc,300*4-18	; this weird number is so that it coincides with the ending of a "heart beat" cycle
    call wait_bc_halts	;; 4 seconds

    call StopPlayingMusic

	; 4) screen shake, and shaking noises
	ld a,3
ending_sequence_shaking_loop:
	push af
    ld bc,300
    call wait_bc_halts	;; 1 seconds

    ; SFX:
	ld hl,SFX_collapse
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority	

    ; screen shake:
    ld a,6
ending_sequence_shaking_loop2:
	call offset_screen_up_4pixels
    ld b,6
    call wait_b_halts
	call offset_screen_up_0pixels
    ld b,6
    call wait_b_halts
    dec a
    jr nz,ending_sequence_shaking_loop2

	pop af
	dec a
	jr nz,ending_sequence_shaking_loop

	; Phantomas runs away!
	ld hl,ending_replay_buffer1
	call ending_sequence_automatic_phantomas_control

	ld hl,ending_replay_room2
	call ending_sequence_replay_room	

	ld hl,ending_replay_room3
	call ending_sequence_replay_room	

	ld hl,ending_replay_room4
	call ending_sequence_replay_room	

	ld hl,ending_replay_room5
	call ending_sequence_replay_room	

	ld hl,ending_replay_room6
	call ending_sequence_replay_room	

	ld hl,ending_replay_room7
	call ending_sequence_replay_room	

ending_sequence_replays_done:

	; fade out
    ld c,FADE_IN_OUT_SPEED
    call fade_out

    call clear_screen_256px

	; load the final screen:
    ld hl,final_plt
    ld de,double_buffer
    call decompress

    ld iy,16
    ld ix,double_buffer
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET
    ld b,8
    call draw_score_board_entrypoint

	; fade in
    ld c,FADE_IN_OUT_SPEED
    call fade_in

    ld bc,150*2
    call wait_bc_halts	;; 1 second

    ; castle crumbles:
    xor a
    ld (vsyncs_since_last_frame),a
    ld b,64*4	; we need to scroll down the castle 64 pixels (it goes down 1 every 4 loops)
ending_sequence_castle_crumble_loop:
    ld a,(vsyncs_since_last_frame)
    or a
    jr z,ending_sequence_castle_crumble_loop
    xor a
    ld (vsyncs_since_last_frame),a

	push bc
	ld a,(current_game_frame)
	and #03
	call z,scroll_castle_down
	call ending_sequence_shaking_and_lighning
	pop bc
	djnz ending_sequence_castle_crumble_loop

	call offset_screen_up_0pixels

	; phantomas walks right-to-left, and then left-to-right:
	ld a,16*6
	ld (player_y),a
	ld a,128-10
	ld (player_x),a
	; we set the collision masl, so that phantomas can walk uninterrupted from right to left
	xor a
	ld hl,map_collision_mask+16*6
	ld de,map_collision_mask+16*6+1
	ld (hl),a
	ld bc,15
	ldir
	xor COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK+COLLISION_BOTTOM_LEFT_MASK+COLLISION_BOTTOM_RIGHT_MASK
	ld hl,map_collision_mask+16*7
	ld de,map_collision_mask+16*7+1
	ld (hl),a
	ld bc,15
	ldir
	; we set an empty background so that when phantomas walk, the original background doesn't get redrawn:
	; this basically copies the bottom line of the bg (which is empty on that screen) to the one above
	ld hl,current_map_bg+16*7*2
	ld de,current_map_bg+16*6*2
	ld bc,16*2
	ldir
	ld hl,ending_replay_buffer_final_Scene
	call ending_sequence_automatic_phantomas_control

	;; clear phantomas:
    call restore_background_dirty_tiles ; draw background dirty tiles from previous iteration
    call restore_foreground_dirty_tiles_256px ; draw foreground dirty tiles from this or previous iteration + copy result to video memory

	call offset_screen_up_0pixels
    ld hl,palette_100
    call set_palette

    ld bc,300*1
    call wait_bc_halts	;; 1 second

    ; final text:
    ld bc,256*#55 + 32    ; color 15 (white) + length 32
    ld hl,finalending_text1
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+0*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence

    ; music starts playing:
    ld hl,menu_song_compressed
    ld de,music_buffer
    call decompress
    ld a,9  ; tempo
    call play_song

    ld bc,300*2
    call wait_bc_halts	;; 2 seconds

    ; game is over!
	jp game_over


scroll_castle_down:
	
	ld hl,VIDEO_MEMORY+VIDEO_MEM_OFFSET+6*#0800 + 4*4 + 9*SCREEN_WIDTH_IN_BYTES_256px
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+7*#0800 + 4*4 + 9*SCREEN_WIDTH_IN_BYTES_256px

	ld b,8
scroll_castle_down_loop2:
	push bc	
	push hl
	push de
	ld b,7
scroll_castle_down_loop1:
	push bc
	ld bc,8*4
	push hl
	push hl
	ldir
	pop de
	pop hl
	ld bc, -#0800
	add hl,bc
	pop bc
	djnz scroll_castle_down_loop1

	ld bc,(VIDEO_MEMORY+VIDEO_MEM_OFFSET+7*#0800 + 4*4 + 8*SCREEN_WIDTH_IN_BYTES_256px) - (VIDEO_MEMORY+VIDEO_MEM_OFFSET+(-1)*#0800 + 4*4 + 9*SCREEN_WIDTH_IN_BYTES_256px)	; correct the adderss of HL
	add hl,bc
	ld bc,8*4
	ldir
	pop de
	pop hl
	ld bc,-SCREEN_WIDTH_IN_BYTES_256px
	add hl,bc
	ex de,hl
	add hl,bc
	ex de,hl
	pop bc
	djnz scroll_castle_down_loop2

	ret


ending_sequence_replay_room:
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	push hl
	ex de,hl
    ld (current_map_ptr),hl	
	call load_current_map
	xor a
	ld (n_enemies),a
	pop hl
	; set phantomas position:
	ld de,player_y
	ldi
	ldi
	push hl
    call draw_current_map ; draw it to the back buffer
    call copy_double_buffer_to_screen_256px   ; copy the copy of the map in the double buffer to screen
    pop hl
;	jr ending_sequence_automatic_phantomas_control


ending_sequence_automatic_phantomas_control:
	ld a,(hl)
	cp #ff
	jp z,StopPlayingMusic
	ld b,a
	inc hl
	ld c,(hl)
	inc hl

ending_sequence_automatic_phantomas_control_loop:
	ld a,(vsyncs_since_last_frame)
    cp 2
    jp m,ending_sequence_automatic_phantomas_control_loop
	push hl
	push bc
	call restore_background_draw_player_restore_foreground
    pop bc
    ; update the player key:
    ld a,c	; "c" has the current key press
    push bc
    call update_keyboard_buffers2    
    call update_player
    ld hl,vsyncs_since_last_frame	; we only decrement it one here, since we want this part to go 2x speed
    dec (hl)

    call ending_sequence_shaking_and_lighning

    pop bc
    pop hl
    ; 'b' has the number of frames that we want to keep that key pressed
    dec b
    jp nz,ending_sequence_automatic_phantomas_control_loop
    jp ending_sequence_automatic_phantomas_control


ending_sequence_shaking_and_lighning:
    ld hl,current_game_frame
    inc (hl)
    ; screen shaking:
    ld a,(hl)
    and #3f
    cp 12
    jp p,ending_sequence_automatic_phantomas_control_loop_no_shaking
    or a
    jr nz,ending_sequence_automatic_phantomas_control_loop_no_SFX
    push af
    ; SFX:
	ld hl,SFX_collapse
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority	
    pop af
ending_sequence_automatic_phantomas_control_loop_no_SFX:
	and #01
	jr nz,ending_sequence_automatic_phantomas_control_loop_shake_down
    ; screen shake:
ending_sequence_automatic_phantomas_control_loop_shake_up:
	call offset_screen_up_4pixels
	jr ending_sequence_automatic_phantomas_control_loop_no_shaking
ending_sequence_automatic_phantomas_control_loop_shake_down:
	call offset_screen_up_0pixels
ending_sequence_automatic_phantomas_control_loop_no_shaking:

	; lightning:
    ld a,(current_game_frame)
    and #03
    ret nz
    ld hl,palette_100
    call set_palette
    ld a,(current_game_frame)
    and #08
    ret z
    ld a,r
    and #07
    ret nz
;    ld a,(current_game_frame)
;    and #04
;    jr z,ending_sequence_automatic_phantomas_control_loop_lightning2
    ld hl,palette_lightning1
;    jr ending_sequence_automatic_phantomas_control_loop_lightning
;ending_sequence_automatic_phantomas_control_loop_lightning2:
;    ld hl,palette_lightning2
;ending_sequence_automatic_phantomas_control_loop_lightning:
    jp set_palette



ending_sequence_vanish_start_offsets:
	db -1,-7,-3,-11

ending_sequence_vanish:
	; - each 4 rows of pixels (in horizontal blocks of 8): 
	; - start at pixel positions: 8, 16, 12, 20 (anything >=8 is ignored)
	; - for 16 cycles paint the corresponding pixel black, and decrease counter by 1 (After 20 cycles, it should be all black)
	; - make it go slow, so it's dramatic

	ld c,24
	ld de,double_buffer+13*4+16*64
ending_sequence_vanish_loop2:
	xor a
	push de
ending_sequence_vanish_loop1:
	push af
	and #03
	ld hl,ending_sequence_vanish_start_offsets
	ADD_HL_A
	ld a,(hl)	; start offset
	add a,c
	cp 8
	jp p,ending_sequence_vanish_skip
	cp 0
	jp m,ending_sequence_vanish_skip
	; paint pixel black
	push de
	ADD_DE_A
	xor a
	ld (de),a
	pop de
ending_sequence_vanish_skip:
	ld hl,64
	add hl,de
	ex de,hl
	pop af
	inc a
	cp 48
	jr nz,ending_sequence_vanish_loop1

	push bc

	ld hl,double_buffer  +13*4 +16*64
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET +13*4 +SCREEN_WIDTH_IN_BYTES_256px*2
	call copy_tile_from_double_buffer_to_video_memory_256px
	ld hl,double_buffer  +13*4 +16*64 +4
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET +13*4 +SCREEN_WIDTH_IN_BYTES_256px*2  +4
	call copy_tile_from_double_buffer_to_video_memory_256px

	ld hl,double_buffer  +13*4 +(16*64)*2
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET +13*4 +SCREEN_WIDTH_IN_BYTES_256px*4
	call copy_tile_from_double_buffer_to_video_memory_256px
	ld hl,double_buffer  +13*4 +(16*64)*2 +4
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET +13*4 +SCREEN_WIDTH_IN_BYTES_256px*4      +4
	call copy_tile_from_double_buffer_to_video_memory_256px

	ld hl,double_buffer  +13*4 +(16*64)*3
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET +13*4 +SCREEN_WIDTH_IN_BYTES_256px*6
	call copy_tile_from_double_buffer_to_video_memory_256px
	ld hl,double_buffer  +13*4 +(16*64)*3 +4
	ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET +13*4 +SCREEN_WIDTH_IN_BYTES_256px*6      +4
	call copy_tile_from_double_buffer_to_video_memory_256px

	ld b,48
	call wait_b_halts
	pop bc

	pop de
	dec c
	jr nz,ending_sequence_vanish_loop2
	ret


offset_screen_up_4pixels:
	di
	ld bc,#bc05
	out (c),c
	ld bc,#bd00+4
	out (c),c
	ld bc,#bc04
	out (c),c
	ld bc,#bd00+37
	out (c),c
	ei
	ret

offset_screen_up_0pixels:
	di
	ld bc,#bc05
	out (c),c
	ld bc,#bd00+0
	out (c),c
	ld bc,#bc04
	out (c),c
	ld bc,#bd00+38
	out (c),c
	ei
	ret

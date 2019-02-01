    include "constants.asm"


; ------------------------------------------------
; main program:
    org #0040
init:
    ; the very first thing is to decompress files that will be overwritten by RAM:
    di
    ; push the stack all the way to the end of the memory space
    ld sp,VIDEO_MEMORY  

    ld hl,player_compressed
    ld de,player_sprites
    call load_player_sprites

    ld hl,scoreboard_addons_gfx_compressed
    ld de,HUD_heart_decompression_buffer
    call decompress

    ld hl,compressed_text
    ld de,text_start
    call decompress

    ; unload CPC interrupts:
    ld hl,interrupt_callback
    ld (#0039),hl

    ; Clear the music variables before the new interrupt starts:
    call StopPlayingMusic
;    ei ;; StopPlayingMusic will already execute an "ei"
   
    ; set screen mode 0    
    di
    ld bc,#7f00   ; Gate array port
    ld a,#8c      ; Mode and ROM selection + set screen 0
    out (c),a     ; Send it

    ; set the border to black
    ld bc,#7f00   ; Gate Array port
    ld a,#10      ; select border
    out (c),a    
    ld a,#54      ; select color (black)
    out (c),a    
    ei

    call set_320px_screen_width
    jp main_menu


restart:
    ld hl,palette_0
    call set_palette
    call clear_screen

    call move_stuff_to_unused_video_memory
    call set_256px_screen_width

    ; draw the scoreboard:
    ld ix,scoreboard_tilemap
    IF SCOREBOARD_MODE = SCOREBOARD_V1
        ld iy,14+4*256
        ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 17*SCREEN_WIDTH_IN_BYTES_256px + 4
    ENDIF
    IF SCOREBOARD_MODE = SCOREBOARD_V2
        ld iy,16+3*256
        ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 17*SCREEN_WIDTH_IN_BYTES_256px
    ENDIF
    call draw_score_board

    ; save the inventory background:
    ld ix,scoreboard_tilemap+4+1*16
    ld a,(ix)
    call load_compressed_map_tile
    ld de,HUD_inventory_background_buffer
    ld bc,64
    ldir

    call mark_all_maps_unvisited

    ld (current_map),a  ; we start in the castle
    ld (already_seen_final_battle_intro),a  ; reset the final battle state
    ld de,player_struct_pointer+1
    ld hl,player_struct_pointer
    ld (hl),a
    ld bc,(player_struct_end-player_struct_pointer)-1
    ldir ; clear the player data
    inc a
    ld (need_to_fade_in),a
    ld a,1
    ld (player_lives),a
    ld (player_respawning),a
    ld a,5
    ld (player_health),a
    ld a,6
    ld (player_window_state),a

    IF GAME_COMPILATION_MODE = 0
        ld hl,castle_map+(MAP_WIDTH*8)  ; normal way the game should start
    ENDIF
    IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_ENDING
        ld hl,castle_map+(MAP_WIDTH*1+4)  ; to start by Dracula
    ENDIF
    IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_PEDAL
        ld hl,catacombs_map+(MAP_WIDTH*1+9)
        ld a,2
        ld (current_map),a  ; we start in the graveyard
    ENDIF
    IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_WHEEL
        ld hl,catacombs_map+(MAP_WIDTH*1+1)
        ld a,1
        ld (current_map),a  ; we start in the catacombs
    ENDIF
    IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_BLOCKS
        ld hl,catacombs_map+(MAP_WIDTH*3+0)
        ld a,1
        ld (current_map),a  ; we start in the catacombs
    ENDIF

;    ld hl,castle_map+(MAP_WIDTH*4+4)
;    ld hl,castle_map+(MAP_WIDTH*4+2)  ; to start by the cross
;    ld hl,castle_map+(MAP_WIDTH*9+2)  ; to start by the catacombs

    ; START IN THE CATACOMBS:
;    ld hl,catacombs_map 
;    ld hl,catacombs_map+(MAP_WIDTH*3+4) 
;    ld hl,catacombs_map+(MAP_WIDTH*3+6) ; to start in the key to the graveyard
;    ld hl,catacombs_map+(MAP_WIDTH*3) ; to start in the stake room
;    ld hl,catacombs_map+(MAP_WIDTH*4+5) ; to start in the hammer room
;    ld a,1
;    ld (current_map),a  ; we start in the catacombs

    ; START IN THE GRAVEYARD:
;    ld hl,catacombs_map+(MAP_WIDTH*3+7)
;    ld hl,catacombs_map+(MAP_WIDTH*1+9)
;    ld a,2
;    ld (current_map),a  ; we start in the graveyard

    ld (current_map_ptr),hl

;    ld hl,player_inventory+ITEM_GATE_KEY-1
;    ld (hl),1
;    ld hl,player_inventory+ITEM_TRIANGLE_KEY-1
;    ld (hl),1
;    ld hl,player_inventory+ITEM_SQUARE_KEY-1
;    ld (hl),1
;    ld hl,player_inventory+ITEM_ROUND_KEY-1
;    ld (hl),1
    IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_PEDAL
        ld hl,player_inventory+ITEM_WHEEL-1
        ld (hl),1
    ENDIF
;    ld hl,player_inventory+ITEM_CROSS_KEY-1
;    ld (hl),1
;    ld hl,player_inventory+ITEM_MAP_KEY-1
;    ld (hl),1
;    ld hl,player_inventory+ITEM_BIBLE_KEY-1
;    ld (hl),1

    IF GAME_COMPILATION_MODE = GAME_COMPILATION_MODE_ENDING
        ld hl,player_lock_state+ITEM_GATE_KEY-1
        ld (hl),1
        ld hl,player_lock_state+ITEM_TRIANGLE_KEY-1
        ld (hl),1
        ld hl,player_lock_state+ITEM_SQUARE_KEY-1
        ld (hl),1
        ld hl,player_lock_state+ITEM_ROUND_KEY-1
        ld (hl),1
        ld hl,player_lock_state+ITEM_CROSS_KEY-1
        ld (hl),1
        ld hl,player_lock_state+ITEM_MAP_KEY-1
        ld (hl),1
        ld hl,player_lock_state+ITEM_BIBLE_KEY-1
        ld (hl),1
        ld hl,player_inventory+ITEM_CROSS-1
        ld (hl),1
        ld hl,player_inventory+ITEM_STAKE-1
        ld (hl),1
        ld hl,player_inventory+ITEM_HAMMER-1
        ld (hl),1
        xor a 
        ld (player_window_state),a
    ENDIF

    ; Start the game with some invincibility    
    ld hl,player_invincibility
    ld (hl),INVINCIBILITY_TIME/2

init_game_loop:
    call load_map_and_setup_for_game_loop

game_loop:
    ld a,(vsyncs_since_last_frame)
    cp 2
    jp m,game_loop

    ; draw:
    call restore_background_dirty_tiles ; draw background dirty tiles from previous iteration
    call draw_enemies
    call draw_player
    call draw_items ; items are usually not updated, but locks require a palette rotation, which is handled here
    call restore_foreground_dirty_tiles_256px ; draw foreground dirty tiles from this or previous iteration + copy result to video memory

    ; update
    call update_enemies
    call update_keyboard_buffers
    call update_player
    call update_items

    ; pedal generator
    ld hl,(current_map_ptr)
    ld a,l
    push af
    cp (catacombs_map+(MAP_WIDTH*1+9))%256
    call z,update_pedal_generator
    pop af
    cp (castle_map+(MAP_WIDTH*0+4))%256 
    call z,update_dracula

    ld a,(keyboard_press)
    IF SPACE_TO_RESPAWN = 1
        bit KEYBOARD_SPACE_BIT,a
        jp z,player_life_lost
    ENDIF
    bit KEYBOARD_ESC_BIT,a
    call z,game_pause

    ld hl,vsyncs_since_last_frame
    dec (hl)
    dec (hl)    ; we decrement it twice, since we want one frame each 2 vsyncs

    ld a,(player_tried_to_change_screen)
    or a
    call nz,check_for_room_change

    ; next game frame:
    ld hl,current_game_frame
    inc (hl)
    jp game_loop


; ------------------------------------------------
; loads a room, and sets everything up to start playing that room
load_map_and_setup_for_game_loop:
    call load_current_map

    ; clear the dirty tiles table:
    ld de,dirty_tiles+1
    ld hl,dirty_tiles
    ld (hl),0
    ld bc,16*8-1
    ldir

    call redraw_lives_and_health
    call redraw_windows_state
    call redraw_scoreboard_score

    ; transfer a fresh copy of the map to video memory:
    call draw_current_map ; draw it to the back buffer
    call copy_double_buffer_to_screen_256px   ; copy the copy of the map in the double buffer to screen
    call restore_background_dirty_tiles ; draw background dirty tiles from previous iteration
    call draw_enemies

    ld hl,player_respawning
    ld a,(hl)
    ld (hl),0
    or a
    jr z,init_game_loop_no_respawn
    ld a,(player_respawn_direction)
    or a
    jp z,find_respawn_position_left
    dec a
    jp z,find_respawn_position_right
    dec a
    jp z,find_respawn_position_top
    dec a
    jp find_respawn_position_bottom
init_game_loop_respawn_done:
    call play_current_game_song

init_game_loop_no_respawn:
    call draw_player
    call restore_foreground_dirty_tiles_256px ; draw foreground dirty tiles from this or previous iteration + copy result to video memory

    ld a,(need_to_fade_in)
    or a
    jr z,init_game_loop_no_respawn_no_fade_in
    ld c,FADE_IN_OUT_SPEED
    call fade_in
    xor a
    ld (need_to_fade_in),a
init_game_loop_no_respawn_no_fade_in:

    xor a
    ld (current_game_frame),a
    ld a,#ff
    ld (keyboard_state),a
    ld (keyboard_press),a

    xor a
    ld (vsyncs_since_last_frame),a
    ld (player_generator_state),a   ; reset generator and dracula state (they are the same variable)
    ret


game_pause:
    ; pause music:
    di
    call clear_PSG_volume
    ld a,(MUSIC_play)
    push af ; we save the current state of music play
    ld a,(SFX_procedural_playing)
    push af ; we save the current procedural SFX playing
    xor a
    ld (MUSIC_play),a
    ld (SFX_procedural_playing),a
    ei
    ld hl,SFX_item_pickup
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority

    ; draw pause dialog
    ld bc,256*#55 + 11    ; color 15 (white) + length 11
    ld hl,pause_frame
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+21+3*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#11 + 11    ; color 12 (rosa) + length 11
    ld hl,pause_text
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+21+4*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 11    ; color 15 (white) + length 11
    ld hl,pause_text2
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+21+5*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 11    ; color 15 (white) + length 11
    ld hl,pause_frame
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+21+6*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence

game_pause_loop:
    halt
    call update_keyboard_buffers
    ld a,(keyboard_press)
    bit KEYBOARD_ESC_BIT,a
    jr z,game_pause_unpaused    
    bit KEYBOARD_Q_BIT,a
    jr z,game_quit_from_pause 
    jr game_pause_loop    
game_pause_unpaused:
    ; set some tiles to dirty, to remove the text
    ld hl,dirty_tiles+16
    ld (hl),2
    ld de,dirty_tiles+17
    ld bc,47
    ldir

    ; resume music:
    pop af ; we restore the current procedural instrument
    ld (SFX_procedural_playing),a
    pop af ; we restore the current state of music play
    ld (MUSIC_play),a
    xor a
    ld (vsyncs_since_last_frame),a
    ret

game_quit_from_pause:
    pop af ; we restore the current procedural instrument
    ld (SFX_procedural_playing),a
    pop af ; we restore the current state of music play
    ld (MUSIC_play),a
    pop af  ; simulate a ret
    jp game_quit


game_over:
    ; draw game over text
    ld bc,256*#55 + 14    ; color 15 (white) + length 14
    ld hl,gameover_frame
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+18+3*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 14    ; color 15 (white) + length 14
    ld hl,gameover_text
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+18+4*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 14    ; color 15 (white) + length 14
    ld hl,gameover_text2
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+18+5*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ld bc,256*#55 + 14    ; color 15 (white) + length 14
    ld hl,gameover_frame
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+18+6*SCREEN_WIDTH_IN_BYTES_256px
    call draw_alphabet_sentence
    ; draw score:
    ld hl,(player_score)
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+34+5*SCREEN_WIDTH_IN_BYTES_256px+6 ; +6 since we start drawing from the right digit, to the left
    call draw_number

game_over_loop:
    halt
    call update_keyboard_buffers
    ld a,(keyboard_press)
    cp #ff
    jr z,game_over_loop    


game_quit:
    ; for now just restart:
    ld c,FADE_IN_OUT_SPEED
    call fade_out
    call StopPlayingMusic

    call move_stuff_back_from_unused_video_memory
    call set_320px_screen_width

    jp main_menu


player_life_lost_dec_life:
    ld hl,player_lives
    dec (hl)
player_life_lost:
    call StopPlayingMusic
    ld b,8
player_life_lost_loop:
    push bc
    ld hl,SFX_death
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority
    ld b,6*9    ; the length of the SFX
    call wait_b_halts
    pop bc
    ld hl,player_health   
    bit 0,b
    jr z,player_life_lost_loop_odd
player_life_lost_loop_even:
    ld (hl),5
    jr player_life_lost_loop2
player_life_lost_loop_odd:
    ld (hl),0
player_life_lost_loop2:
    push bc
    call redraw_lives_and_health
    pop bc
    djnz player_life_lost_loop
    ld a,(player_lives)
    or a
    jp z,game_over

    ; check for special respawn rooms
    ld hl,(current_map_ptr)
    ld a,l
    cp (castle_map+MAP_WIDTH*9)%256
    jr z,player_life_lost_respawn_one_room_up
    cp (castle_map+MAP_WIDTH*9+1)%256
    jr z,player_life_lost_respawn_one_room_up
    cp (catacombs_map+MAP_WIDTH*4)%256
    jr z,player_life_lost_respawn_one_room_down

player_life_lost_after_respawn_check:
    ld hl,player_state
    ld (hl),PLAYER_STATE_IDLE_RIGHT
    ld a,1
    ld (player_respawning),a
    ld a,(current_map)
    cp 3    ; if we are in the final battle
    jp z,init_game_loop_dracula
    ld c,FADE_IN_OUT_SPEED
    call fade_out
    ld a,1
    ld (need_to_fade_in),a
    jp init_game_loop

player_life_lost_respawn_one_room_up:
    ld bc,MAP_WIDTH
    xor a
    sbc hl,bc
    ld (current_map_ptr),hl
    ld a,RESPAWN_FROM_BOTTOM
    ld (player_respawn_direction),a    
    jr player_life_lost_after_respawn_check

player_life_lost_respawn_one_room_down:
    ld bc,MAP_WIDTH
    add hl,bc
    ld (current_map_ptr),hl
    ld a,RESPAWN_FROM_TOP
    ld (player_respawn_direction),a    
    jr player_life_lost_after_respawn_check


play_current_game_song:
    ld a,(sound_mode)
    or a
    ret nz
    ld a,(current_map)
    or a
    jp z,play_current_game_song_castle
    dec a
    jp z,play_current_game_song_catacombs
    dec a
    jp z,play_current_game_song_graveyard
    ; heartbeat (dracula battle) song:
    ld a,(already_seen_final_battle_intro)
    or a
    ret nz
    ld hl,heartbeat_song_compressed
    ld de,music_buffer
    call decompress
    ld a,1  ; tempo
    jr play_current_game_song2
play_current_game_song_graveyard:
    ; graveyard song:
    ld hl,menu_song_compressed
    jr play_current_game_song3
play_current_game_song_catacombs:
    ; catacombs song:
    ld hl,ingame2_song_compressed
    ld de,music_buffer
    call decompress
    ld a,18  ; tempo
    jp play_current_game_song2
play_current_game_song_castle:
    ; castle song:
    ld hl,ingame_song_compressed
play_current_game_song3:
    ld de,music_buffer
    call decompress
    ld a,9  ; tempo
play_current_game_song2:
    jp play_song
 

; ------------------------------------------------
; My interrupt handler to replace ISR 7
interrupt_callback:
    push bc
    push af
    ld b,#f5
    in a,(c)
    rra     
    jr nc,interrupt_callback_not_vsync
    
    ; we are in a vsync, do whatever we need to do once per game frame:
    ld bc,vsyncs_since_last_frame
    ld a,(bc)
    cp 4
    jp p,interrupt_callback_do_not_increment_vsyncs
    inc a
    ld (bc),a
interrupt_callback_do_not_increment_vsyncs:
    call update_sound

interrupt_callback_not_vsync:
    pop af
    pop bc
    ei
    ret


; ------------------------------------------------
; Source code from: http://www.cpcwiki.eu/index.php/Synchronising_with_the_CRTC_and_display
;vsync:
;    ld b,#f5            ;; PPI port B input
;vsync_loop:
;    in a,(c)            ;; [4] read PPI port B input
;                        ;; (bit 0 = "1" if vsync is active,
;                        ;;  or bit 0 = "0" if vsync is in-active)
;    rra                 ;; [1] put bit 0 into carry flag
;    jp nc,vsync_loop    ;; [3] if carry not set, loop, otherwise continue
;    ret


;-----------------------------------------------
; waits a given number of "halts"
; b - number of halts
wait_b_halts:
    halt
    djnz wait_b_halts
    ret


;-----------------------------------------------
; waits a given number of "halts"
; bc - number of halts
wait_bc_halts:
    halt
    dec bc
    xor a
    or b
    or c
    jr nz,wait_bc_halts
    ret


;-----------------------------------------------
; decompresses the graphics necessary to draw the scoreboard, and draws it to video memory
draw_score_board:
    ld b,iyh
draw_score_board_entrypoint:
    ld hl,last_decompressed_tile
    ld (hl),1   ; some value that cannot match
draw_score_board_loop_y:    
    push bc
    ld b,iyl
    push de
    push iy
draw_score_board_loop_x:
    ld a,(ix)
    or a
    jr z,draw_score_board_loop_x_skip_tile  
    push bc
    push de
    ld hl,last_decompressed_tile
    dec a
    and #f0
    cp (hl)
    ld a,(ix)
    jr z,draw_score_board_loop_x_same_tile
    push af
    dec a
    and #f0
    ld (hl),a
    pop af    
    call load_compressed_map_tile
    jr draw_score_board_loop_x_tile_loaded
draw_score_board_loop_x_same_tile:
    dec a
    call load_compressed_map_tile2
draw_score_board_loop_x_tile_loaded:    
    ld bc,16*256+4
    pop de
    push de
    call draw_sprite_variable_size_to_screen
    pop de
    pop bc
draw_score_board_loop_x_skip_tile:
    inc de
    inc de
    inc de
    inc de
    inc ix
    djnz draw_score_board_loop_x
    pop iy
    pop de
draw_score_board_ptr_to_selfmodify_offset:
    ld hl,2*SCREEN_WIDTH_IN_BYTES_256px
    add hl,de
    ex de,hl
    pop bc
    djnz draw_score_board_loop_y
    ret

load_compressed_map_tile:
    dec a   ; since tile 0 is "no tile"
    push af
    push ix
    ; get the appropriate tile bank, and decompress it
    and #f0
    srl a
    srl a
    srl a
    ld hl,tiles_compressed_ptr_tbl
    ADD_HL_A    ; hl = (tiles_compressed_ptr_tbl+2*(a>>4))
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld de,tile_bank_decompression_buffer
    call decompress  ; we now have the appropriate tile bank, decompressed in enemy_sprites
    pop ix
    pop af
load_compressed_map_tile2:
    and #0f ; index of the tile in the decompressed bank
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,tile_bank_decompression_buffer
    add hl,bc   ; pointer to the tile to draw
    ret


;-----------------------------------------------
; updates the score in the scoreboard
redraw_scoreboard_score:
    ld a,(loading_map)  ; if we are loading a map, do not update the score, since it'll be wrong!
    or a
    ret nz
    ld hl,(player_score)
;    ld de,VIDEO_MEMORY+43+5*SCREEN_WIDTH_IN_BYTES_256px+6 ; +6 since we start drawing from the right digit, to the left
    ld de,VIDEO_MEMORY+VIDEO_MEM_OFFSET+5*2048 + 34+19*SCREEN_WIDTH_IN_BYTES_256px + 6 ; +6 since we start drawing from the right digit, to the left
    jp draw_number


;-----------------------------------------------
; updates the number of lives and health of the player on the scoreboard:
redraw_lives_and_health:
    ; update lives:
    ld a,(player_lives)
;    ld de,VIDEO_MEMORY + 6*2048 + (16+4)*SCREEN_WIDTH_IN_BYTES_256px + 8+15 ; address of the top-left of the lives counter
    ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 5*2048 + (16+3)*SCREEN_WIDTH_IN_BYTES_256px + 9 ; address of the top-left of the lives counter
    call draw_digit

    ; update health:
    ld a,(player_health)
    ld hl,HUD_heart_decompression_buffer
    ld bc,27
    or a
    jr z,redraw_lives_and_health_loop2_done
redraw_lives_and_health_loop2:
    add hl,bc
    dec a
    jr nz,redraw_lives_and_health_loop2
redraw_lives_and_health_loop2_done: ; hl = HUD_numbers_decompression_buffer + a*(3*9)
;    ld de,VIDEO_MEMORY + 4*2048 + (16+4)*SCREEN_WIDTH_IN_BYTES_256px + 8+18 ; address of the top-left of the lives counter
    ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 3*2048 + (16+3)*SCREEN_WIDTH_IN_BYTES_256px + 12 ; address of the top-left of the lives counter
    ld bc,9*256+3
    jp draw_sprite_variable_size_to_screen


;-----------------------------------------------
; updates the windows state on the scoreboard:
redraw_windows_state:
    ld a,(player_window_state)
    ld hl,HUD_numbers_decompression_buffer
    ld bc,12
    or a
    jr z,redraw_windows_state_loop1_done
redraw_windows_state_loop1:
    add hl,bc
    dec a
    jr nz,redraw_windows_state_loop1
redraw_windows_state_loop1_done: ; hl = HUD_numbers_decompression_buffer + a*(2*6)
;    ld de,VIDEO_MEMORY + 6*2048 + (16+5)*SCREEN_WIDTH_IN_BYTES_256px + 8+33 ; address of the top-left of the lives counter
    ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 5*2048 + (16+3)*SCREEN_WIDTH_IN_BYTES_256px + 25 ; address of the top-left of the lives counter
    ld bc,6*256+2
    jp draw_sprite_variable_size_to_screen


;-----------------------------------------------
; adds an item to the score board inventory:
; - a: item to add
; - this assumes that the item to add is the first item in the current map
score_board_add_item:
    inc a
    push af
    ld hl,HUD_inventory_slot_content
;    ld de,VIDEO_MEMORY + 19*SCREEN_WIDTH_IN_BYTES_256px + 36  ; pointer to the video memory address to draw the item to
    ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 16  ; pointer to the video memory address to draw the item to
    ld a,(hl)
    or a
    jr z,score_board_add_item_found_slot
    inc hl
    inc de  
    inc de
    inc de
    inc de
score_board_add_item_found_slot:
    pop af
    ld (hl),a
    ld hl,item_sprites  ; assume it's the first item
    ld bc,16*256 + 4
    jp draw_sprite_variable_size_to_screen


;-----------------------------------------------
; removes an item to the score board inventory:
; input:
; - a: item to remove
score_board_remove_item:
    inc a
    ld hl,HUD_inventory_slot_content
;    ld de,VIDEO_MEMORY + 19*SCREEN_WIDTH_IN_BYTES_256px + 36  ; pointer to the video memory address to draw the item to
    ld de,VIDEO_MEMORY + VIDEO_MEM_OFFSET + 19*SCREEN_WIDTH_IN_BYTES_256px + 16  ; pointer to the video memory address to draw the item to
    cp (hl)
    jr z,score_board_remove_item_found_slot
    inc hl
    inc de  
    inc de
    inc de
    inc de
score_board_remove_item_found_slot:
    xor a
    ld (hl),a
    ld hl,HUD_inventory_background_buffer
    ld bc,16*256 + 4
    jp draw_sprite_variable_size_to_screen


;-----------------------------------------------
; fades the palette in:
; parameters:
; - c: unmber of waits
fade_in:
    ld hl,palette_33
    push bc
    call set_palette
    pop bc
    ld b,c
    call wait_b_halts
    ld hl,palette_66
    push bc
    call set_palette
    pop bc
    ld b,c
    call wait_b_halts
    ld hl,palette_100
    jp set_palette


;-----------------------------------------------
; fades the palette out:
; parameters:
; - c: unmber of waits
fade_out:
    ld hl,palette_66
    push bc
    call set_palette
    pop bc
    ld b,c
    call wait_b_halts
    ld hl,palette_33
    push bc
    call set_palette
    pop bc
    ld b,c
    call wait_b_halts
    ld hl,palette_0
    jp set_palette


;-----------------------------------------------
check_for_room_change:
    ld hl,player_tried_to_change_screen
    ld a,(hl)
    ld (hl),0
    dec a
    jr z,check_for_room_change_left
    dec a
    jr z,check_for_room_change_up
    dec a
    jr z,check_for_room_change_right
;    dec a
;    jr z,check_for_room_change_down
;check_for_room_change_down:
    ld a,(player_y)
    cp 112
    jp p,move_one_screen_down
    ret
check_for_room_change_right:
    ld a,(player_x)
    cp 120
    jp p,move_one_screen_to_the_right
    ret
check_for_room_change_up:
    ld a,(player_y)
    cp 1
    jp m,move_one_screen_up
    ret
check_for_room_change_left:
    ld a,(player_x)
    cp 1
    jp m,move_one_screen_to_the_left
    ret


;-----------------------------------------------
move_one_screen_to_the_right:
    ; stop the walking sound:
    ld hl,SFX_procedural_playing
    ld a,(hl)
    cp SFX_PRIORITY_WALK
    jp nz,move_one_screen_to_the_right_no_walking_sfx
    ld (hl),0
move_one_screen_to_the_right_no_walking_sfx:

    ld hl,(current_map_ptr)

    ; check if we are entering the graveyard
    ld a,l
    cp (catacombs_map+MAP_WIDTH*3+6)%256
    call z,move_one_screen_right_enter_graveyard

    inc hl
    ld a,(hl)   ; we get the map ID
    or a
    ret z
    ld a,RESPAWN_FROM_LEFT
    ld (player_respawn_direction),a
    xor a
move_one_screen_to_the_right2:
    ld (player_x),a
    ld (current_map_ptr),hl

    pop af  ; simulate a "ret"
    jp init_game_loop

move_one_screen_right_enter_graveyard:
    ld a,2
move_one_screen_right_enter_graveyard_entrypoint:
    ld (current_map),a
    ld (need_to_fade_in),a
    ; fade out
    ld c,FADE_IN_OUT_SPEED*2
    call fade_out
    call StopPlayingMusic
    ld b,0  ; wait for about 1 second
    call wait_b_halts
    ; change music
    call play_current_game_song
    ld hl,(current_map_ptr)
    ret


;-----------------------------------------------
move_one_screen_to_the_left:
    ; stop the walking sound:
    ld hl,SFX_procedural_playing
    ld a,(hl)
    cp SFX_PRIORITY_WALK
    jp nz,move_one_screen_to_the_left_no_walking_sfx
    ld (hl),0
move_one_screen_to_the_left_no_walking_sfx:

    ld hl,(current_map_ptr)

    ; check if we are entering the catacombs
    ld a,l
    cp (catacombs_map+MAP_WIDTH*3+7)%256
    call z,move_one_screen_left_enter_catacombs

    dec hl
    ld a,(hl)   ; we get the map ID
    or a
    ret z
    ld a,RESPAWN_FROM_RIGHT
    ld (player_respawn_direction),a
    ld a,120
    jr move_one_screen_to_the_right2

move_one_screen_left_enter_catacombs:
    ld a,1
    jr move_one_screen_right_enter_graveyard_entrypoint


;-----------------------------------------------
move_one_screen_down:
    ld hl,(current_map_ptr)

    ; check if we are entering the catacombs
    ld a,l
    cp (castle_map+MAP_WIDTH*9+2)%256
    jr z,move_one_screen_down_enter_catacombs

    ld bc,MAP_WIDTH
    add hl,bc
move_one_screen_down_entry_point:
    ld a,(hl)   ; we get the map ID
    or a
    ret z
    ld a,RESPAWN_FROM_TOP
    ld (player_respawn_direction),a
    xor a
move_one_screen_down2:
    ld (player_y),a
    ld (current_map_ptr),hl
    pop af  ; simulate a "ret"
    jp init_game_loop

move_one_screen_down_enter_catacombs:
    ld a,1
    ld (current_map),a
    ld (need_to_fade_in),a
    ; fade out
    ld c,FADE_IN_OUT_SPEED*2
    call fade_out
    call StopPlayingMusic
    ld b,0  ; wait for about 1 second
    call wait_b_halts
    ; put the player in the right position:
;    ld a,9*8
;    ld (player_x),a
    ; change music
    call play_current_game_song
    ld hl,catacombs_map
    jr move_one_screen_down_entry_point




;-----------------------------------------------
move_one_screen_up:
    ld hl,(current_map_ptr)

    ; check if we are entering the castle
    ld a,l
    cp catacombs_map%256
    jr z,move_one_screen_up_enter_castle

    ; special case of dracula room, which can only be accessed through the middle:
    ld a,l
    cp (castle_map+4+MAP_WIDTH)%256
    jr nz,move_one_screen_up_not_special_case
    push hl
    ld hl,player_state_timer
    ld a,(hl)
    cp 2
    jp p,move_one_screen_up_no_jump_adjust
    inc (hl)  ; make jump shorter so that player doesn't make it all the way to the coffin in one jump
move_one_screen_up_no_jump_adjust:
    pop hl
    ld a,(player_x)
    cp 7*8
    ret m
    cp 8*8+1
    ret p
move_one_screen_up_not_special_case:
    ld bc,MAP_WIDTH
    xor a
    sbc hl,bc
move_one_screen_up_entry_point:
    ld a,(hl)   ; we get the map ID
    or a
    ret z
    ld a,RESPAWN_FROM_BOTTOM
    ld (player_respawn_direction),a
    ld a,112
    jr move_one_screen_down2

move_one_screen_up_enter_castle:
    ld a,1
    ld (need_to_fade_in),a
    xor a
    ld (current_map),a
    ; fade out
    ld c,FADE_IN_OUT_SPEED*2
    call fade_out
    call StopPlayingMusic
    ; pause:
    ld b,0  ; wait for about 1 second
    call wait_b_halts
    ; put the player in the right position:
    ld a,11*8
    ld (player_x),a
    xor a   ; PLAYER_STATE_IDLE_RIGHT
    ld (player_state),a
    ; change music
    call play_current_game_song
    ld hl,castle_map+MAP_WIDTH*9+2
    ld a,RESPAWN_FROM_BOTTOM
    ld (player_respawn_direction),a
    ld a,6*16   ; new player y
    jp move_one_screen_down2


restore_background_draw_player_restore_foreground:
    call restore_background_dirty_tiles ; draw background dirty tiles from previous iteration
    call draw_player
    jp restore_foreground_dirty_tiles_256px ; draw foreground dirty tiles from this or previous iteration + copy result to video memory


;    include "deexo.asm"
    include "pletter.asm"
    include "keyboard.asm"
    include "player.asm"
    include "enemies.asm"
    include "items.asm"
    include "generator.asm"
    include "dracula.asm"
    include "gfx.asm"
    include "maps.asm"
    include "collision.asm"
    include "sound.asm"
    include "menu.asm"
    include "ending.asm"

; The indexes of this map are: "group number + 1"*4 + "map index inside the group"
castle_map:
    include "map/castlemap.asm"

catacombs_map:
    include "map/catacombsmap.asm"

end_of_castle_catacombs_maps:

;-----------------------------------------------
; DATA:
    include "palette.asm"
palette_white:
;    db #4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b
palette_lightning1:
    db #4b,#4b,#54,#54,#4b,#4b,#54,#54,#4b,#4b,#54,#54,#4b,#4b,#54,#54
;palette_lightning2:
;    db #4f,#4f,#54,#54,#4f,#4f,#54,#54,#4f,#4f,#54,#54,#4f,#4f,#54,#54

; compressed graphics
;scoreboard_gfx_compressed:
;    incbin "compressedgfx/scoreboard.plt"
;    incbin "compressedgfx/scoreboard-tiles.plt"

menu_plt:
    incbin "compressedgfx/menu-bgfg.plt"

scoreboard_tilemap:
    include "compressedgfx/scoreboard.asm"

final_plt:
    incbin "compressedgfx/final.plt"

;tiles_compressed:
;    incbin "compressedgfx/tiles.plt"

tiles_compressed_ptr_tbl:
    dw tiles_0_compressed
    dw tiles_1_compressed
    dw tiles_2_compressed
    dw tiles_3_compressed
    dw tiles_4_compressed
    dw tiles_5_compressed
    dw tiles_6_compressed
    dw tiles_7_compressed
    dw tiles_8_compressed
    dw tiles_9_compressed
    dw tiles_10_compressed
    dw tiles_11_compressed
    dw tiles_12_compressed
    dw tiles_13_compressed
    dw tiles_14_compressed
;    dw tiles_15_compressed

tiles_0_compressed:
    incbin "compressedgfx/tiles/tiles-0.plt"
tiles_1_compressed:
    incbin "compressedgfx/tiles/tiles-1.plt"
tiles_2_compressed:
    incbin "compressedgfx/tiles/tiles-2.plt"
tiles_3_compressed:
    incbin "compressedgfx/tiles/tiles-3.plt"
tiles_4_compressed:
    incbin "compressedgfx/tiles/tiles-4.plt"
tiles_5_compressed:
    incbin "compressedgfx/tiles/tiles-5.plt"
tiles_6_compressed:
    incbin "compressedgfx/tiles/tiles-6.plt"
tiles_7_compressed:
    incbin "compressedgfx/tiles/tiles-7.plt"
tiles_8_compressed:
    incbin "compressedgfx/tiles/tiles-8.plt"
tiles_9_compressed:
    incbin "compressedgfx/tiles/tiles-9.plt"
tiles_10_compressed:
    incbin "compressedgfx/tiles/tiles-10.plt"
tiles_11_compressed:
    incbin "compressedgfx/tiles/tiles-11.plt"
tiles_12_compressed:
    incbin "compressedgfx/tiles/tiles-12.plt"
tiles_13_compressed:
    incbin "compressedgfx/tiles/tiles-13.plt"
tiles_14_compressed:
    incbin "compressedgfx/tiles/tiles-14.plt"
;tiles_15_compressed:
;    incbin "compressedgfx/tiles/tiles-15.plt"

items_compressed:
    incbin "compressedgfx/items.plt"

vampire_compressed:
    incbin "compressedgfx/vampire.plt"
spider_compressed:
    incbin "compressedgfx/spider.plt"
arrow_compressed:
    incbin "compressedgfx/arrow.plt"
arrows_down_compressed:
    incbin "compressedgfx/arrows-down.plt"
barrel_compressed:
    incbin "compressedgfx/barrel.plt"
trap_compressed:
    incbin "compressedgfx/trap.plt"
skull_compressed:
    incbin "compressedgfx/skull.plt"
fire_compressed:
    incbin "compressedgfx/fire.plt"
bubble_compressed:
    incbin "compressedgfx/bubble.plt"
cross_compressed:
    incbin "compressedgfx/cross.plt"
star_compressed:
    incbin "compressedgfx/star.plt"
franken_compressed:
    incbin "compressedgfx/franken.plt"
ghost_compressed:
    incbin "compressedgfx/ghost.plt"
laser_horizontal_compressed:
    incbin "compressedgfx/laser-horizontal.plt"
laser_vertical_compressed:
    incbin "compressedgfx/laser-vertical.plt"
spikeball_compressed:
    incbin "compressedgfx/spikeball.plt"
brickwall_compressed:
    incbin "compressedgfx/brickwall.plt"
redskull_compressed:
    incbin "compressedgfx/redskull.plt"
;bullet_compressed:
;    incbin "compressedgfx/bullet.plt"
generator_compressed:
    incbin "compressedgfx/generator.plt"

movingplatform_compressed:
    incbin "compressedgfx/movingplatform.plt"
button_pressed_compressed:
    incbin "compressedgfx/button-pressed.plt"
window_open_compressed:
    incbin "compressedgfx/window-open.plt"

; SFX and music:
    include "sfx.asm"
ingame_song_compressed:
    incbin "music/ingame2.plt"
ingame2_song_compressed:
    incbin "music/ingame3.plt"
menu_song_compressed:
    incbin "music/menusong.plt"
heartbeat_song_compressed:
    incbin "music/heartbeat.plt"

; Alphabet:
alphabet:
    incbin "compressedgfx/alphabet.bin"

; text:
compressed_text:
;    incbin "text/text-english.plt"
    incbin "text/text-spanish.plt"

; these are the sequence of keystrokes to control the main character during the ending sequence
; the format is: 
; - # of frames with that key, and then the key
; - a #ff indicates end of sequence, and we move on to the next room
ending_replay_buffer1:
    db 1,~KEYBOARD_LEFT_MASK
    db 25,~(0)
    db 2,~KEYBOARD_RIGHT_MASK
    db 25,~(0)
    db 1,~KEYBOARD_LEFT_MASK
    db 25,~(0)
    db 1,~KEYBOARD_UP_MASK
    db 25,~(0)
    db 20,~KEYBOARD_LEFT_MASK
    db 24,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db 4,~KEYBOARD_LEFT_MASK
    db 24,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db 1,~KEYBOARD_LEFT_MASK
    db 45,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db #ff

ending_replay_room2:
    dw castle_map+(MAP_WIDTH*0+4)  ; room with dracula's coffin
    db 80,60    ; player_y, player_x
ending_replay_buffer2:
    db 16,~(0)
    db #ff

ending_replay_room3:
    dw castle_map+(MAP_WIDTH*3+4)
    db 0,104    ; player_y, player_x
ending_replay_buffer3:
    db 16,~(0)
    db 8,~KEYBOARD_RIGHT_MASK
    db 16,~(0)
    db 96,~KEYBOARD_LEFT_MASK
    db #ff

ending_replay_room4:
    dw castle_map+(MAP_WIDTH*7+4)
    db 0,64    ; player_y, player_x
ending_replay_buffer4:
    db 24,~KEYBOARD_LEFT_MASK
    db 24,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db 12,~KEYBOARD_LEFT_MASK
    db 25,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db #ff

ending_replay_room5:
    dw castle_map+(MAP_WIDTH*8+2)
    db 64,120    ; player_y, player_x
ending_replay_buffer5:
    db 48,~KEYBOARD_LEFT_MASK
    db 24,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db 32,~KEYBOARD_LEFT_MASK
    db 19,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db #ff

ending_replay_room6:
    dw castle_map+(MAP_WIDTH*8+1)
    db 64,120    ; player_y, player_x
ending_replay_buffer6:
    db 42,~KEYBOARD_LEFT_MASK
    db 16,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db 16,~(0)
    db 4,~(KEYBOARD_UP_MASK)
    db 66,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db #ff

ending_replay_room7:
    dw castle_map+(MAP_WIDTH*8+0)
    db 96,120    ; player_y, player_x
ending_replay_buffer7:
    db 28,~KEYBOARD_LEFT_MASK
    db 92,~(KEYBOARD_LEFT_MASK+KEYBOARD_UP_MASK)
    db #ff

ending_replay_buffer_final_Scene:
    db 70,~KEYBOARD_LEFT_MASK
    db 16,~(0)
    db 1,~KEYBOARD_RIGHT_MASK
    db 16,~(0)
    db 1,~KEYBOARD_LEFT_MASK
    db 16,~(0)
    db 70,~KEYBOARD_RIGHT_MASK
    db #ff


map_group_pointers:
    dw map_group_0
    dw map_group_1
    dw map_group_2
    dw map_group_3
    dw map_group_4
    dw map_group_5
    dw map_group_6
    dw map_group_7
    dw map_group_8
    dw map_group_9
    dw map_group_10
    dw map_group_11
    dw map_group_12
    dw map_group_13
    dw map_group_14
    dw map_group_15
    dw map_group_16
    dw map_group_17
    dw map_group_18
    dw map_group_19
    dw map_group_20
    dw map_group_21

    include "autoVideoMemoryUsage.asm"

; compressed files that will be decompressed right away, and then overwritten:
; data_to_overwrite_with_RAM:

scoreboard_addons_gfx_compressed:
    incbin "compressedgfx/scoreboard-addons.plt"

player_compressed:
    incbin "compressedgfx/player.plt"


; ------------------------------------------------
; THIS function is here, since it's not needed after sprites are loaded, and thus, it can be overwritten by RAM!
; hl: compressed sprites
; de: target memory address of decompressed sprites
load_player_sprites:
    push de

        push de
            call decompress  ; first decompress everything
        pop de

        ; offxet by 1 px sprites 2, 4, 6 and 8
        ld h,d
        ld l,e
        ld bc,64
        add hl,bc
        ex de,hl

        ld b,5
    load_player_sprites_loop1:
        push bc
            push de
            push hl
                call offset_sprite_by_1px
            pop hl
            pop de

            ld bc,128
            add hl,bc
            ex de,hl
            add hl,bc
            ex de,hl
        pop bc
        djnz load_player_sprites_loop1

    ; here hl points to the beginning of the 11th sprite
    ex de,hl
    pop hl  ; we recover the initial address of "de", which was pointing at the first sprite

    ; we start by copying all the sprites before flipping them
    ld bc,64*10
    push de
    ldir
    pop hl

    ; flip all 10 sprites
    ld b,10
load_player_sprites_loop2:
    push bc
    push hl
    call flip_sprite_16x8
    pop hl
    ld bc,64
    add hl,bc
    pop bc
    djnz load_player_sprites_loop2
    ret


end_of_binary_in_memory:

;-----------------------------------------------

; data to put in the unused areas of the video memory:
; this has to be data that can be erased when we do a clear screen call
    org video_mem_unused_area0
current_map_ptr:    ds virtual 2
loading_map:        ds virtual 1    ; this is 0 during normal play, and 1 when we are loading the map
current_map:        ds virtual 1
need_to_fade_in:    ds virtual 1
; (4 bytes each item) type, x, y, sprite_index (sprite ptr will be item_sprites + sprite_index*64)
n_items:            ds virtual 1
items:              ds virtual MAX_ITEMS*ITEM_STRUCT_SIZE
; 26 bytes


    org video_mem_unused_area1
player_food_state:  ds virtual NUMBER_OF_FOODS
player_lock_state:  ds virtual NUMBER_OF_LOCKS
player_dracula_state:
player_generator_state: ds virtual 1    ; bit 0, used wheel or not, bit 1, player on top of it or not in previous frame
; 48 bytes

    org video_mem_unused_area2
player_falling_block_state: ds NUMBER_OF_FALLING_BLOCKS
player_lives:       ds virtual 1    ; I could have it in a single variable, but then the code to handle it uses more than the byte I save
player_health:      ds virtual 1
player_window_state:ds virtual 1
player_respawn_direction:   ds virtual 1
player_respawning:  ds virtual 1
; 48 bytes

    org video_mem_unused_area3
player_inventory:   ds virtual PLAYER_INVENTORY_SIZE
player_switch_state:  ds virtual NUMBER_OF_SWITCHES
HUD_inventory_slot_content: ds virtual 2
; 28 bytes 

    org video_mem_unused_area4
HUD_inventory_background_buffer:    ds virtual 64

;    org data_to_overwrite_with_RAM 
    org first_usable_RAM_space_during_gameplay

start_of_RAM:

n_enemies:          ds virtual 1
                        ; (10 bytes each enemy) state, lower movement bound, upper movement bound, x, y, video mem address (dw), sprites ptr (dw), animation type
enemies:            ds virtual MAX_ENEMIES*ENEMY_STRUCT_SIZE

; IMPORTANT: these needs to be 256-aligned!!!
    ds virtual ((($-1)/#100)+1)*#100-$
dirty_tiles:        ds virtual 16*8     ; 128 bytes
map_collision_mask: ds virtual 16*8     ; 128 bytes
; IMPORTANT: these needs to be 256-aligned!!!
; for each of the 16x8 positions in the map: bg tile ptr, fg tile ptr
current_map_bg:        ds virtual 16*8*2    ; 256 bytes
current_map_fg:        ds virtual 16*8*2    ; 256 bytes

; all sprites 64-byte aligned:
;    ds virtual ((($-1)/#40)+1)*#40-$
enemy_sprites:              ds virtual MAX_DIFFERENT_ENEMY_SPRITES*64   ; 2176 bytes
item_sprites:               ds virtual MAX_DIFFERENT_ITEMS*64           ; 128 bytes

tiles:                      ds virtual MAX_DIFFERENT_TILES_PER_ROOM*64  ; 3008 bytes
end_of_tiles:
double_buffer:              ds virtual 64*128   ; this is used in the main menu, but it's clear of the area we are overwriting
tile_bank_decompression_buffer:     equ double_buffer + 3*1024  ; this is only used for drawing the menu, and te scoreboard

player_sprites:             ds virtual 64*20   ; 5 sprites + 1 px offsets * 2 directions

; Variables only used while in the main menu (so, we can overwrite the double buffer):
menu_bg: equ double_buffer
menu_fg: equ double_buffer+80
enemy_sprites_main_menu:    equ double_buffer + 4*1024          ; this is only used during the menu

; Variables only used while loading a map or rendering menu/score_board (so, we can overwrite the double buffer):
next_enemy_sprite_ptr:      equ double_buffer
enemy_sprite_types:         equ double_buffer+2 
next_tile_ptr:              equ enemy_sprite_types+MAX_DIFFERENT_ENEMY_TYPES*3
map_decompression_buffer:   equ next_tile_ptr+2

; since in neither the generator room nor the dracula room we use all the tiles
; I can reuse the end of the memory reserved for tiles for these variables:
generator_ptr_buffer:       equ end_of_tiles-2 ; to temporarily store the pointer to the pedal generator tile and restore it later
dracula_tiles_ptrs:         equ end_of_tiles-48   ; to store the pointers to the tiles to draw dracula
dracula_state1:             equ end_of_tiles-49
dracula_state2:             equ end_of_tiles-50
dracula_state3:             equ end_of_tiles-51 ; which item is next

HUD_heart_decompression_buffer:     ds virtual 6*3*9
HUD_numbers_decompression_buffer:   ds virtual 120

; Zone to decompress text in different languages:
pause_frame:
gameover_frame:
text_start:
menu_line1_spaces: ds 20    ; "                    "
pause_text: ds 11    ; "   pause   "
pause_text2: ds 11    ; " q to quit "
gameover_text: ds 14    ; "  game  over  "
gameover_text2: ds 14    ; "  score:      "
menu_line0: ds 3    ; "2.0"
menu_line1: ds 13    ; "space to play"
menu_line2: ds 30    ; "1986 dinamic, 2018 pakete soft"
menu_line3: ds 31    ; "code and music santiago ontanon"
menu_line4: ds 21    ; "graphics jordi sureda"
menu_line5: ds 28    ; "in memoriam emilio salgueiro"
menu_1_for_options: ds 11    ; "o: options "
menu_1_redefine_keys: ds 19    ; "1: redefine keys   "
menu_1_redefine_keys_left: ds 20    ; "press a key for left"
menu_1_redefine_keys_right: ds 21    ; "press a key for right"
menu_1_redefine_keys_up: ds 18    ; "press a key for up"
menu_2_sound_mode_2.0: ds 18    ; "2: sound mode 2.0 "
menu_2_sound_mode_original: ds 22    ; "2: sound mode classic "
youneedthecog_text: ds 19    ; "  you need the cog "
pedalinstructions_text: ds 17    ; " pedal with  o,p "
closewindows_text: ds 21    ; "  close all windows  "
needcross_text: ds 23    ; " you need the cross    "
needstake_text: ds 23    ; " you need the stake    "
needhammer_text: ds 23    ; " you need the hammer   "
draculaintro_text1: ds 28    ; "at last! we face each other!"
draculaintro_text2: ds 30    ; "i was waiting for you, belmont"
draculaintro_text3: ds 30    ; "?? wtf is that about belmont? "
draculaintro_text4: ds 29    ; "i'm just a pro thief who had "
draculaintro_text5: ds 27    ; "an incident with the police"
draculaintro_text6: ds 30    ; "i was caught stealing in earth"
draculaintro_text7: ds 28    ; "gamma. i'm here to regain my"
draculaintro_text8: ds 9    ; "freedom! "
draculaintro_text9: ds 3    ; "..."
draculaending_text1: ds 31    ; "unthinkable... you defeated me!"
draculaending_text2: ds 29    ; " but if i fall, so will you! "
finalending_text1: ds 32    ; "at last! the vampire was slain!!"

alphabet_decoding_buffer:   ds virtual 16   ; here we reconstruct each letter that needs to be drawn
current_game_frame:         ds virtual 1
vsyncs_since_last_frame:    ds virtual 1    ; used to syncronize the game speed
; keyboard buffer:
keyboard_press:     ds virtual 1   ; 4 lowest bits are O,P,Q,A (1 if pressed in this frame, but not the previous)
keyboard_state:     ds virtual 1   ; 4 lowest bits are O,P,Q,A (1 if pressed)
menu_state:         ds virtual 1    ; whether we are in the main menu (0), options (1), redefning keys (2,3,4,5,6,7)
already_seen_final_battle_intro:    ds virtual 1    ; if you die in the final battle, the intro text should not be shown again

last_decompressed_tile:     ds virtual 1

; sound variables:
Music_tempo:                        ds virtual 1
beginning_of_sound_variables_except_tempo:
MUSIC_play:                         ds virtual 1
MUSIC_tempo_counter:                ds virtual 1
MUSIC_instruments:                  ds virtual 3
MUSIC_channel3_instrument_buffer:   ds virtual 1    ;; this stores the instrument of channel 3, which is special, since SFX might overwrite it
MUSIC_start_pointer:                ds virtual 2  
SFX_pointer:                        ds virtual 2
MUSIC_pointer:                      ds virtual 2
MUSIC_repeat_stack_ptr:             ds virtual 2    ; 15
MUSIC_repeat_stack:                 ds virtual 4*3  ; 27
MUSIC_instrument_envelope_ptr:      ds virtual 3*2  ; 33
SFX_priority:                       ds virtual 1  ; the SFX from the game have more priority than those triggered by music
SFX_jump_start_period:              ds virtual 2
SFX_jump_timer:                     ds virtual 1
MUSIC_transpose:                    ds virtual 1
MUSIC_time_step_required:           ds virtual 1    ; 39
SFX_procedural_playing:               ds virtual 1    
end_of_sound_variables:
player_struct_pointer:
player_y:           ds virtual 1
player_x:           ds virtual 1
player_sprite:      ds virtual 1
player_state_timer: ds virtual 1
player_state:       ds virtual 1
player_tried_to_change_screen:  ds virtual 1
player_invincibility:   ds virtual 1
player_score:       ds virtual 2
player_struct_end:

music_buffer:               ds virtual 413

end_of_RAM:

;-----------------------------------------------
; A couple of useful macros for adding 16 and 8 bit numbers

ADD_HL_A: MACRO 
    add a,l
    ld l,a
    jr nc, $+3
    inc h
    ENDM

ADD_DE_A: MACRO 
    add a,e
    ld e,a
    jr nc, $+3
    inc d
    ENDM    

ADD_HL_A_VIA_BC: MACRO
    ld b,0
    ld c,a
    add hl,bc
    ENDM


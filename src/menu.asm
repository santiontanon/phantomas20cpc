
; this is here, so that it is loaded already initialized, and we can change it later
sound_mode:
    db 0

main_menu:
;    jp ending_sequence_replays_done
    ld hl,palette_0
    call set_palette
    call clear_screen

    ld hl,menu_plt
    ld de,double_buffer
    call decompress

    ; draw the scoreboard:
    call draw_menu_title

    ld bc,256*#15 + 3    ; color 14 (yellow) + length 3
    ld hl,menu_line0
    ld de,VIDEO_MEMORY+60+7*SCREEN_WIDTH_IN_BYTES_320px+1*2048
    call draw_alphabet_sentence

    ; options string:
    ld bc,256*#55 + 11    ; color 15 (white) + length 11
    ld hl,menu_1_for_options
    ld de,VIDEO_MEMORY+29+16*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence


    ld bc,256*#55 + 30    ; color 15 (white) + length 30
    ld hl,menu_line2
    ld de,VIDEO_MEMORY+10+19*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld bc,256*#55 + 31    ; color 15 (white) + length 31
    ld hl,menu_line3
    ld de,VIDEO_MEMORY+9+20*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld bc,256*#55 + 21    ; color 15 (white) + length 21
    ld hl,menu_line4
    ld de,VIDEO_MEMORY+19+21*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld bc,256*#55 + 28    ; color 15 (white) + length 28
    ld hl,menu_line5
    ld de,VIDEO_MEMORY+12+22*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence

    ; store fire background:
    ld hl,menu_bg+2+2*20
    ld a,(hl)
    call load_compressed_map_tile
    ld de,enemy_sprites_main_menu+16*64
    ld bc,64
    ldir
    ld hl,menu_fg+2+2*20
    ld a,(hl)
    call load_compressed_map_tile
    ld de,enemy_sprites_main_menu+17*64
    ld bc,64
    ldir

    ; load fire sprites:
    ld hl,fire_compressed
    ld de,enemy_sprites_main_menu
    call load_fire_sprites

    ld hl,menu_song_compressed
    ld de,music_buffer
    call decompress
    ld a,9  ; tempo
    call play_song

    ld c,FADE_IN_OUT_SPEED
    call fade_in

    xor a
    ld (current_game_frame),a
    ld (menu_state),a

main_menu_loop:
    ld a,(vsyncs_since_last_frame)
    cp 2
    jp m,main_menu_loop
    ld hl,vsyncs_since_last_frame
    dec (hl)
    dec (hl)    ; we decrement it twice, since we want one frame each 2 vsyncs

    ; restore fire background:
    ld hl,enemy_sprites_main_menu+16*64
    ld de,VIDEO_MEMORY+8+6*SCREEN_WIDTH_IN_BYTES_320px
    ld bc,16*256+4
    push bc
    push hl
    call draw_sprite_variable_size_to_screen
    pop hl
    pop bc
    ld de,VIDEO_MEMORY+68+6*SCREEN_WIDTH_IN_BYTES_320px
    call draw_sprite_variable_size_to_screen
    ld hl,enemy_sprites_main_menu+17*64
    ld de,VIDEO_MEMORY+8+6*SCREEN_WIDTH_IN_BYTES_320px
    ld bc,16*256+4
    push bc
    push hl
    call draw_sprite_variable_size_to_screen
    pop hl
    pop bc
    ld de,VIDEO_MEMORY+68+6*SCREEN_WIDTH_IN_BYTES_320px
    call draw_sprite_variable_size_to_screen

    ; draw fire sprite:
    ld hl,current_game_frame
    ld a,(hl)
    and #06
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,enemy_sprites_main_menu
    add hl,bc
    ld bc,16*256+4
    ld de,VIDEO_MEMORY+6+6*SCREEN_WIDTH_IN_BYTES_320px
    push bc
    push hl
    call draw_sprite_variable_size_to_screen
    pop hl
    pop bc
    ld de,VIDEO_MEMORY+8+6*SCREEN_WIDTH_IN_BYTES_320px
    push bc
    push hl
    call draw_sprite_variable_size_to_screen
    pop hl
    pop bc
    ld de,VIDEO_MEMORY+66+6*SCREEN_WIDTH_IN_BYTES_320px
    push bc
    push hl
    call draw_sprite_variable_size_to_screen
    pop hl
    pop bc
    ld de,VIDEO_MEMORY+68+6*SCREEN_WIDTH_IN_BYTES_320px
    call draw_sprite_variable_size_to_screen

    ld hl,current_game_frame
    inc (hl)

    ld a,(menu_state)
    or a
    jr z,main_menu_state_0
    dec a
    jr z,main_menu_state_options
    dec a
    jr z,main_menu_redefine_wait_until_no_key_pressed
    dec a
    jr z,main_menu_state_redefine_left
    dec a
    jr z,main_menu_redefine_wait_until_no_key_pressed
    dec a
    jr z,main_menu_state_redefine_right
    dec a
    jr z,main_menu_redefine_wait_until_no_key_pressed
    dec a
    jr z,main_menu_state_redefine_up

main_menu_state_redefine_up:
    call find_pressed_key
    or a
    jp z,main_menu_loop
    ; key pressed!
    ld hl,redefined_keys+4
    ld (hl),e
    inc hl
    ld (hl),a
    jp main_menu_loop_switch_to_options

main_menu_state_redefine_right:
    call find_pressed_key
    or a
    jp z,main_menu_loop
    ; key pressed!
    ld hl,redefined_keys+2
    ld (hl),e
    inc hl
    ld (hl),a
    jp main_menu_loop_switch_to_next_key_to_redefine

main_menu_state_redefine_left:
    call find_pressed_key
    or a
    jp z,main_menu_loop
    ; key pressed!
    ld hl,redefined_keys
    ld (hl),e
    inc hl
    ld (hl),a
    jp main_menu_loop_switch_to_next_key_to_redefine

main_menu_redefine_wait_until_no_key_pressed:
    call find_pressed_key
    or a
    jr z,main_menu_loop_switch_to_next_key_to_redefine
    jp main_menu_loop

main_menu_state_options:
    call update_keyboard_buffers
    ld a,(keyboard_press)
    bit KEYBOARD_ESC_BIT,a
    jp z,main_menu_loop_switch_to_0
    bit KEYBOARD_SPACE_BIT,a
    jp z,main_menu_loop_switch_to_0
    bit KEYBOARD_1_BIT,a
    jp z,main_menu_loop_switch_to_next_key_to_redefine
    bit KEYBOARD_2_BIT,a
    jp z,main_menu_loop_switch_sfx
    jp main_menu_loop


main_menu_state_0:
    ld a,(current_game_frame)
    and #08
    jr z,main_menu_state_0_clear_space
main_menu_state_0_draw_space:
    ld bc,256*#55 + 13    ; color 15 (white) + length 13
    ld hl,menu_line1
    ld de,VIDEO_MEMORY+27+13*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    jr main_menu_state_0_draw_space_done
main_menu_state_0_clear_space:
    ld bc,256*#55 + 13    ; color 15 (white) + length 13
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+27+13*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
main_menu_state_0_draw_space_done:
;    call update_keyboard_buffers
    call update_keyboard_buffers_o_instead_of_1
    ld a,(keyboard_press)
    bit KEYBOARD_SPACE_BIT,a
    jp z,main_menu_loop_game_start
    bit KEYBOARD_1_BIT,a
    jp z,main_menu_loop_switch_to_options
    jp main_menu_loop


main_menu_loop_switch_to_next_key_to_redefine:
    ld bc,256*#55 + 21    ; color 15 (white) + length 21
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+21+14*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld hl,menu_state
    inc (hl)
    ld a,(hl)
    cp 2
    jr z,main_menu_loop_switch_to_next_key_to_redefine_left
    cp 3
    jr z,main_menu_loop_switch_to_next_key_to_redefine_left
    cp 4
    jr z,main_menu_loop_switch_to_next_key_to_redefine_right
    cp 5
    jr z,main_menu_loop_switch_to_next_key_to_redefine_right
main_menu_loop_switch_to_next_key_to_redefine_up:
    ld bc,256*#55 + 18    ; color 15 (white) + length 18
    ld hl,menu_1_redefine_keys_up
    ld de,VIDEO_MEMORY+21+14*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    jp main_menu_loop
main_menu_loop_switch_to_next_key_to_redefine_right:
    ld bc,256*#55 + 21    ; color 15 (white) + length 21
    ld hl,menu_1_redefine_keys_right
    ld de,VIDEO_MEMORY+21+14*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    jp main_menu_loop
main_menu_loop_switch_to_next_key_to_redefine_left:
    ld bc,256*#55 + 20    ; color 15 (white) + length 20
    ld hl,menu_1_redefine_keys_left
    ld de,VIDEO_MEMORY+21+14*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    jp main_menu_loop

main_menu_loop_switch_sfx:
    ld a,(sound_mode)
    xor #01
    ld (sound_mode),a
main_menu_loop_switch_to_options:
    ld bc,256*#55 + 13    ; color 15 (white) + length 13
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+27+13*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld bc,256*#55 + 19    ; color 15 (white) + length 19
    ld hl,menu_1_redefine_keys
    ld de,VIDEO_MEMORY+21+14*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld bc,256*#55 + 23    ; color 15 (white) + length 23
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+21+16*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld a,(sound_mode)
    or a
    jr nz,main_menu_loop_switch_to_options_sound_original
    ld bc,256*#55 + 18    ; color 15 (white) + length 13
    ld hl,menu_2_sound_mode_2.0
    jr main_menu_loop_switch_to_options_sound_done
main_menu_loop_switch_to_options_sound_original:
    ld bc,256*#55 + 22    ; color 15 (white) + length 22
    ld hl,menu_2_sound_mode_original
main_menu_loop_switch_to_options_sound_done:
    ld de,VIDEO_MEMORY+21+16*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld a,1
    ld (menu_state),a
    jp main_menu_loop

main_menu_loop_switch_to_0:
    ld bc,256*#55 + 19    ; color 15 (white) + length 19
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+21+14*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ld bc,256*#55 + 23    ; color 15 (white) + length 23
    ld hl,menu_line1_spaces
    ld de,VIDEO_MEMORY+21+16*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    ; options string:
    ld bc,256*#55 + 11    ; color 15 (white) + length 11
    ld hl,menu_1_for_options
    ld de,VIDEO_MEMORY+29+16*SCREEN_WIDTH_IN_BYTES_320px
    call draw_alphabet_sentence
    xor a
    ld (menu_state),a
    jp main_menu_loop


main_menu_loop_game_start:
    ld c,FADE_IN_OUT_SPEED
    call fade_out	
    call StopPlayingMusic
	jp restart

draw_menu_title:
    ld iy,20+4*256
    ld ix,menu_bg
    ld de,VIDEO_MEMORY + 2*SCREEN_WIDTH_IN_BYTES_320px
    push iy
    push de
    call draw_score_board
    pop de
    pop iy
    ld ix,menu_fg
    jp draw_score_board

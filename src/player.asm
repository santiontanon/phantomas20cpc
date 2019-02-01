; ------------------------------------------------
; mark the dirty tiles:
; input:
; - c: x coordinate
; - e: y coordinate
mark_sprite_dirty_tiles:
    ; dirty tile is: (x >> 2) + (y & #f0)
    ld a,c  ; x
    srl a
    srl a
    srl a
    ld b,a
    ld a,e  ; y
    and #f0
    add a,b
    ld h,dirty_tiles/256
    ld l,a
    ld a,c  ; x
    and #07
    jp nz,mark_sprite_dirty_tiles_two_h_dirty_tiles
mark_sprite_dirty_tilesr_one_h_dirty_tiles:
    ld a,e  ; y
    and #0f
    jr nz,mark_sprite_dirty_tiles_one_h_two_v_dirty_tiles
    ld (hl),2
    ret
mark_sprite_dirty_tiles_one_h_two_v_dirty_tiles:
    ld (hl),2
    ld bc,16
    add hl,bc
    ld (hl),2
    ret
mark_sprite_dirty_tiles_two_h_dirty_tiles:
    ld a,e  ; y
    and #0f
    jr nz,mark_sprite_dirty_tiles_two_h_two_v_dirty_tiles
    ld (hl),2
    inc l
    ld (hl),2
    ret
mark_sprite_dirty_tiles_two_h_two_v_dirty_tiles:
    ld a,2
    ld (hl),a
    inc l
    ld (hl),a
    ld bc,15
    add hl,bc
    ld (hl),a
    inc l
    ld (hl),a
    ret


; ------------------------------------------------
draw_player:
    ld hl,player_invincibility
    ld a,(hl)
    or a
    jr z,draw_player_not_invincible
    dec (hl)
    and #02
    ret nz  ; if we are invincible, flash the character
draw_player_not_invincible:
    ld hl,player_x
    ld c,(hl)   ; x
    dec hl
    ld e,(hl)   ; y
    call mark_sprite_dirty_tiles
	ld a,(player_x)
	ld c,a
    ld b,0
    srl c       ; bc = x/2    
    ld a,(player_y)
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl   ; hl = y*64
    add hl,bc   ; hl = x/2 + y*64
    ld bc,double_buffer
    add hl,bc   ; hl = double_buffer + x/2 + y*64
    ex de,hl
	ld hl,player_sprites
    ld a,(player_sprite)
    ld bc,128
    or a
    jr z,draw_player_sprite_calculated
draw_player_sprite_loop:
    add hl,bc
    dec a
    jr nz,draw_player_sprite_loop
draw_player_sprite_calculated:
    ld iy,player_struct_pointer
    ld a,(iy+4) ; player state
    xor (iy+1)  ; player_x
    and #01     
    jp z,draw_sprite_0_transparent
    ld bc,64
    add hl,bc   ; we switch to the sprite offset by 1 pixel
    jp draw_sprite_0_transparent


; ------------------------------------------------
update_player_collision_with_enemy
    pop af  ; restore the stack
    ld hl,player_health
    ld c,(hl)
    dec c
;    ld a,(ix)
;    cp ENEMY_STATE_FALLING_BLOCK
    ld a,(ix+9) ; animation type (it happens that all enemies with animation time NONE kill you on contact!)
    cp ENEMY_ANIMATION_STYLE_NONE
    jr nz,update_player_collision_with_enemy_not_falling_block
    ld c,0   ; falling blocks take a whole life out!
update_player_collision_with_enemy_not_falling_block:
    ld a,c
    ld (hl),a
    or a
    jr nz,update_player_collision_with_enemy_no_life_lost
    ; lose a life:
    ld a,5
    ld (hl),a
;    dec hl
;    dec (hl)    ; decrement the number of lives
;    ld a,(hl)   ; lives
;    or a
;    jr z,update_player_collision_with_enemy_player_dead
;    dec a
;    ld (hl),a
    pop af  ; simulate ret
    jp player_life_lost_dec_life

update_player_collision_with_enemy_no_life_lost:
    call redraw_lives_and_health

    ld hl,player_invincibility
    ld (hl),INVINCIBILITY_TIME
    ld hl,SFX_playerhit
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority
    jr update_player_invincible

;update_player_collision_with_enemy_player_dead:
;    pop af  ; simulate ret
;    jp game_quit


; ------------------------------------------------
update_player:
    ld iy,player_struct_pointer

    ; check for collision with enemies:
    ld a,(player_invincibility)
    or a
    jr nz,update_player_invincible

    ld a,(n_enemies)
    or a
    jr z,update_player_invincible
    ld ix,enemies
update_player_enemy_collision_loop:
    push af
    call enemy_collision_with_player
    jr z,update_player_collision_with_enemy
    ld bc,ENEMY_STRUCT_SIZE
    add ix,bc
    pop af
    dec a
    jr nz,update_player_enemy_collision_loop

update_player_invincible:
    ld a,(iy+4) ; player state
    or a
    jr z,update_player_idle_right
    dec a
    jr z,update_player_idle_left
    dec a
    jp z,update_player_falling_right
    dec a
    jp z,update_player_falling_left
    dec a
    jp z,update_player_walking_right
    dec a
    jp z,update_player_walking_left
    dec a
    jr z,update_player_jumping_right
;    dec a
;    jr z,update_player_jumping_left

update_player_jumping_left:
    ld (iy+2),8 ; player sprite
update_player_jumping_right_entry_point:
    ld a,(iy+3) ; timer
    cp 3
    push af
    call m,update_player_move_up
    pop af
    cp 7
    push af
    call m,update_player_move_up
    pop af
    cp 10
    push af
    call m,update_player_move_up
    pop af
    cp 14
    jp p,update_player_switch_to_falling
    inc (iy+3)
    call update_player_move_air_control
    ld a,(keyboard_state)
    bit KEYBOARD_UP_BIT,a
    jr nz,update_player_cancel_jump_early
    ret
update_player_cancel_jump_early:
    ld a,(iy+3)
    cp 10
    ret p
    ld (iy+3),10
    ret
update_player_move_air_control:
    ld a,(keyboard_state)
    bit KEYBOARD_LEFT_BIT,a
    push af
    call z,update_player_move_left
    pop af
    bit KEYBOARD_RIGHT_BIT,a
    jp z,update_player_move_right
    ret

update_player_jumping_right:
    ld (iy+2),3 ; player sprite
    jr update_player_jumping_right_entry_point

update_player_idle_left:
    ld (iy+2),5 ; player sprite
    jr update_player_idle_left_entry_point
update_player_idle_right:
    ld (iy+2),0 ; player sprite
update_player_idle_left_entry_point:
    call update_player_check_collision_below
    jr z,update_player_switch_to_falling
    ld a,(keyboard_state)
    bit KEYBOARD_LEFT_BIT,a
    jp z,update_player_switch_to_walking_left
    bit KEYBOARD_RIGHT_BIT,a
    jr z,update_player_switch_to_walking_right
    ld a,(keyboard_press)
    bit KEYBOARD_UP_BIT,a
    jr z,update_player_switch_to_jumping
    ret

update_player_switch_to_falling:
    ld (iy+3),0 ; timer
    ld a,(iy+4)
    and #01
    add a,PLAYER_STATE_FALLING_RIGHT
    ld (iy+4),a
    call play_fall_SFX
    ret

update_player_switch_to_jumping:
    ld (iy+3),0 ; timer
    ld a,(iy+4)
    and #01
    push af
    add a,PLAYER_STATE_JUMPING_RIGHT
    ld (iy+4),a
    call play_jump_SFX
    pop af
    or a
    jp z,update_player_jumping_right ; we do it right away, to minimize perception delay when pressing the jump key
    jp update_player_jumping_left

update_player_switch_to_idle_pop_af:
    pop af
update_player_switch_to_idle:
    ld a,(iy+4)
    and #01
    add a,PLAYER_STATE_IDLE_RIGHT
    ld (iy+4),a
    and #01
    jp z,update_player_idle_right
    jp update_player_idle_left

update_player_switch_to_walking_left:
    ld (iy+4),PLAYER_STATE_WALKING_LEFT
    jp update_player_walking_left
update_player_switch_to_walking_right:
    ld (iy+4),PLAYER_STATE_WALKING_RIGHT
    jp update_player_walking_right

update_player_falling_left:
    ld (iy+2),9 ; player sprite
    jr update_player_falling_left_entry_point
update_player_falling_right:
    ld (iy+2),4 ; player sprite
update_player_falling_left_entry_point:
    call update_player_move_down
    jr nz,update_player_switch_to_idle
    call update_player_move_air_control
    inc (iy+3)
    ld a,(iy+3) ; timer
    cp 4
    ret m
    push af
    call update_player_move_down
    jr nz,update_player_switch_to_idle_pop_af
    pop af
    cp 8
    ret m
    call update_player_move_down
    jr nz,update_player_switch_to_idle
    ret

update_player_walking_right:
    call play_walk_SFX
    ld a,(current_game_frame)
    bit 2,a
    jr z,update_player_walking_right_2ndframe
    bit 3,a
    jr z,update_player_walking_right_1stframeb
    ld (iy+2),0 ; player sprite
    jr update_player_walking_right_animdone
update_player_walking_right_1stframeb:
    ld (iy+2),2 ; player sprite
    jr update_player_walking_right_animdone
update_player_walking_right_2ndframe:
    ld (iy+2),1 ; player sprite
update_player_walking_right_animdone:
    call update_player_check_collision_below
    jp z,update_player_switch_to_falling
    ; check keyboard:
    ld a,(keyboard_press)
    bit KEYBOARD_LEFT_BIT,a
    jp nz,update_player_walking_right_no_O
    bit KEYBOARD_RIGHT_BIT,a
    jp nz,update_player_switch_to_walking_left
update_player_walking_right_no_O:
    ld a,(keyboard_state)
    bit KEYBOARD_RIGHT_BIT,a
    jp nz,update_player_switch_to_idle
    ld a,(keyboard_press)
    bit KEYBOARD_UP_BIT,a
    jp z,update_player_switch_to_jumping
    jp update_player_move_right

update_player_walking_left:
    call play_walk_SFX
    ld a,(current_game_frame)
    bit 2,a
    jr z,update_player_walking_left_2ndframe
    bit 3,a
    jr z,update_player_walking_left_1stframeb
    ld (iy+2),5 ; player sprite
    jr update_player_walking_left_animdone
update_player_walking_left_1stframeb:
    ld (iy+2),7 ; player sprite
    jr update_player_walking_left_animdone
update_player_walking_left_2ndframe:
    ld (iy+2),6 ; player sprite
update_player_walking_left_animdone:
    call update_player_check_collision_below
    jp z,update_player_switch_to_falling
    ; check keyboard:
    ld a,(keyboard_press)
    bit KEYBOARD_RIGHT_BIT,a
    jp nz,update_player_walking_left_no_P
    bit KEYBOARD_LEFT_BIT,a
    jp nz,update_player_switch_to_walking_right
update_player_walking_left_no_P:
    ld a,(keyboard_state)
    bit KEYBOARD_LEFT_BIT,a
    jp nz,update_player_switch_to_idle
    ld a,(keyboard_press)
    bit KEYBOARD_UP_BIT,a
    jp z,update_player_switch_to_jumping
    jp update_player_move_left

update_player_check_collision_below:
    ld c,(iy+1) ; player x
    ld b,(iy)   ; player y
    inc b
    inc b
update_player_check_collision_below_entry2:
    push bc
    call sprite_collision_with_map
    pop bc
    ret nz
    ; check collision with platforms or barrels:
    push iy
    ld iy,enemies
    ld a,(n_enemies)
    or a
    jr z,update_player_check_collision_below_done_checking_enemies
update_player_check_collision_below_enemies_loop:
    push af
    ld a,(iy+9)
    cp ENEMY_ANIMATION_STYLE_BARREL
    jr z,update_player_check_collision_below_collidable_enemy
    cp ENEMY_ANIMATION_STYLE_PLATFORM
    jr z,update_player_check_collision_below_collidable_enemy
    jr update_player_check_collision_below_non_collidable_enemy
update_player_check_collision_below_collidable_enemy:
    ld a,(iy+4) ; enemy y
    sub 14
    cp b
    jr z,update_player_check_collision_below_collidable_enemy_collision
    dec a
    cp b
    jr nz,update_player_check_collision_below_non_collidable_enemy
update_player_check_collision_below_collidable_enemy_collision:
    ld a,(iy+3) ; enemy x
    sub c
    cp 6
    jp p,update_player_check_collision_below_non_collidable_enemy
    cp -5
    jp m,update_player_check_collision_below_non_collidable_enemy
    ; enemy collision:
    pop af
    pop iy
    or 1    ; mark the collision
    ret     ; nz
update_player_check_collision_below_non_collidable_enemy
    pop af
    push bc
    ld bc,ENEMY_STRUCT_SIZE
    add iy,bc
    pop bc
    dec a
    jr nz,update_player_check_collision_below_enemies_loop
update_player_check_collision_below_done_checking_enemies:
    pop iy
    ret ; z

update_player_move_left_init_iy:
    ld iy,player_struct_pointer
update_player_move_left:
    ld c,(iy+1)    ; player_x
    ld a,c
    cp 2
    jp p,update_player_move_left_no_screen_change
    ld (iy+5),1     ; player_tried_to_change_screen
update_player_move_left_no_screen_change:
    ld b,(iy)
    dec c
    call sprite_collision_with_map
    ret nz
    ; no collision!
    dec (iy+1)
    ret

update_player_move_right_init_iy:
    ld iy,player_struct_pointer
update_player_move_right:
	ld c,(iy+1)    ; player_x
    ld a,c
    cp 119
    jp m,update_player_move_right_no_screen_change
    ld (iy+5),3     ; player_tried_to_change_screen
update_player_move_right_no_screen_change:
	ld b,(iy)
    inc c
	call sprite_collision_with_map
	ret nz
	; no collision!
    inc (iy+1)
	ret


update_player_move_up:
    ld b,(iy)    ; player_y
    ld a,b
    cp 2
    jp p,update_player_move_up_no_screen_change
    ld (iy+5),2     ; player_tried_to_change_screen
update_player_move_up_no_screen_change:
    ld c,(iy+1)
    dec b
    dec b
    call sprite_collision_with_map
    ret nz
    ; no collision!
    dec (iy)
    dec (iy)
    xor a ; z flag (no collision)
    ret


update_player_move_up_one_init_iy:
    ld iy,player_struct_pointer
    ld b,(iy)    ; player_y
    ld c,(iy+1)
    dec b
    call sprite_collision_with_map
    ret nz
    ; no collision!
    dec (iy)
    ret


update_player_move_down:
    ld b,(iy)    ; player_y
    ld a,b
    cp 110
    jp m,update_player_move_down_no_screen_change
    ld (iy+5),4     ; player_tried_to_change_screen
update_player_move_down_no_screen_change:
    ld c,(iy+1)
    inc b
    call update_player_check_collision_below_entry2
    ret nz
    ; no collision!
    inc (iy)
    inc b
    call update_player_check_collision_below_entry2
    ret nz
    ; no collision!
    inc (iy)
    xor a ; z flag (no collision)
    ret


update_player_move_down_one_init_iy:
    ld iy,player_struct_pointer
    ld b,(iy)    ; player_y
    ld c,(iy+1)
    inc b
    call update_player_check_collision_below_entry2
    ret nz
    ; no collision!
    inc (iy)
    ret


; ------------------------------------------------
; Find a safe respawn positino after dying (one function per direction of etrance to the room)
find_respawn_position_left:
    ld c,0
find_respawn_position_left_x_loop:
    ld b,128-32
find_respawn_position_left_y_loop:
    call find_respawn_position_check
    jr z,find_respawn_position_found
    ld a,b
    sub 8
    ld b,a
    jr nz,find_respawn_position_left_y_loop
    ld a,c
    add a,8
    ld c,a
    cp 128
    jr nz,find_respawn_position_left_x_loop
    ; we should never arrive here!
;    ret

find_respawn_position_check:
    push bc
    call sprite_collision_with_map
    pop bc
    ret nz
    push bc
    ld a,b
    add a,8
    ld b,a
    call sprite_collision_with_map
    pop bc
    jr z,find_respawn_position_check_not_good
    xor a ; good respawn position!
    ret
find_respawn_position_check_not_good:
    or 1    
    ret

find_respawn_position_found:
    ld a,c
    ld (player_x),a
    ld a,b
    ld (player_y),a    
    jp init_game_loop_respawn_done

find_respawn_position_right:
    ld c,128-8
find_respawn_position_right_x_loop:
    ld b,128-32
find_respawn_position_right_y_loop:
    call find_respawn_position_check
    jr z,find_respawn_position_found
    ld a,b
    sub 8
    ld b,a
    jr nz,find_respawn_position_right_y_loop
    ld a,c
    sub 8
    ld c,a
    jr nz,find_respawn_position_right_x_loop
    ; we should never arrive here!
    jr find_respawn_position_found

find_respawn_position_top:
    ld b,0
find_respawn_position_top_y_loop:
    ld c,0
find_respawn_position_top_x_loop:
    call find_respawn_position_check
    jr z,find_respawn_position_found
    ld a,c
    add a,8
    ld c,a
    cp 128
    jr nz,find_respawn_position_top_x_loop
    ld a,b
    add a,8
    ld b,a
    cp 128-16
    jr nz,find_respawn_position_top_y_loop
    ; we should never arrive here!
    jr find_respawn_position_found

find_respawn_position_bottom:
    ld b,128-32
find_respawn_position_bottom_y_loop:
    ld c,0
find_respawn_position_bottom_x_loop:
    call find_respawn_position_check
    jr z,find_respawn_position_found
    ld a,c
    add a,8
    ld c,a
    cp 128
    jr nz,find_respawn_position_bottom_x_loop
    ld a,b
    sub 8
    ld b,a
    jr nz,find_respawn_position_bottom_y_loop
    ; we should never arrive here!
    jr find_respawn_position_found

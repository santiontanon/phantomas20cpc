; ------------------------------------------------
draw_enemies:
    ld a,(n_enemies)
    or a
    ret z
    ld ix,enemies
draw_enemies_loop:
    push af
    call draw_enemy
    pop af
    ld bc,ENEMY_STRUCT_SIZE
    add ix,bc
    dec a
    jr nz,draw_enemies_loop
    ret


; ------------------------------------------------
update_enemies:
    ld a,(n_enemies)
    or a
    ret z
    ld ix,enemies
update_enemies_loop:
    push af
    call update_enemy
    pop af
    ld bc,ENEMY_STRUCT_SIZE
    add ix,bc
    dec a
    jr nz,update_enemies_loop
    ret


; ------------------------------------------------
; Draws an enemy to the screen:
; Arguments: ix: pointer to the enemy
draw_enemy:
    ld a,(ix)
    cp ENEMY_STATE_VLASER_SHOWING
    jp z,draw_enemy_vlaser
    cp ENEMY_STATE_HLASER_SHOWING
    jp z,draw_enemy_hlaser
    cp ENEMY_INVISIBLE_STATES
    ret p       ; if we don't need to render this enemy, then just return
    ld c,(ix+3)
    ld e,(ix+4)
    call mark_sprite_dirty_tiles

    ; draw the enemy:
    ld d,(ix+6) ; video mem address
    ld e,(ix+5)

    ld h,(ix+8) ; sprite ptr
    ld l,(ix+7)

    ; choose animation frame:
    ld a,(ix+9)   ; we load the animation type
    or a
    jr z,draw_enemy_vampire_animation
    dec a
    jr z,draw_enemy_vampire_vertical_animation
    dec a
    jr z,draw_enemy_arrow_animation
    dec a
    jr z,draw_enemy_barrel_animation
    dec a
    jr z,draw_enemy_trap_animation
    dec a
    jr z,draw_enemy_fire_animation
    dec a
    jr z,draw_enemy_bubble_animation
    dec a
    jr z,draw_enemy_star_animation
    dec a
    jr z,draw_enemy_platform_animation
    dec a
    ;jr z, draw_enemy_switch_animation
    ret z
draw_enemy_none_animation:
    jp draw_sprite_0_transparent

;draw_enemy_switch_animation:
;    ret

;draw_enemy_laser_animation:
;    jp draw_sprite_0_transparent

draw_enemy_platform_animation:
draw_enemy_1px_offset_check:
    ld a,c  ; we still have the "x" coordinate here
    and #01
    jp z,draw_sprite_0_transparent
draw_enemy_platform_animation_arroy_entry_point:
    ld bc,64
    add hl,bc   ; we switch to the sprite offset by 1 pixel
    jp draw_sprite_0_transparent

draw_enemy_arrow_animation:
    ld a,(ix)
    bit 2,a
    jp z,draw_sprite_0_transparent
    jr draw_enemy_platform_animation_arroy_entry_point

draw_enemy_vampire_vertical_animation:
    push bc
    ld a,(ix+4)  ; y coordinate
    jr draw_enemy_vampire_animation_vertical_entry_point


draw_enemy_vampire_animation:
    push bc
    ld a,(ix+3)  ; x coordinate
draw_enemy_vampire_animation_vertical_entry_point:
    srl a
    call draw_enemy_3_frame_animation
    ld a,(ix)
    bit 2,a
    jr z,draw_enemy_vampire_animation_right
    ld bc,128*3
    add hl,bc
    pop bc
    inc c   ; we need to offset the stored x by one so that the 1px offset sprites work when going leftwards
    jr draw_enemy_1px_offset_check
draw_enemy_vampire_animation_right:
    pop bc
    jr draw_enemy_1px_offset_check

draw_enemy_barrel_animation:
    push bc
    ld a,c  ; x coordinate
    srl a
    srl a
    and #03
draw_enemy_barrel_animation_before_loop:
    or a
    jr z,draw_enemy_barrel_animation_loop_done
    ld bc,64
draw_enemy_barrel_animation_loop:
    add hl,bc
    dec a
    jr nz,draw_enemy_barrel_animation_loop
draw_enemy_barrel_animation_loop_done:
    pop bc
    jp draw_sprite_0_transparent

draw_enemy_trap_animation:
    push bc
    ld a,(current_game_frame)
    call draw_enemy_3_frame_animation
    pop bc
    jp draw_enemy_1px_offset_check

draw_enemy_fire_animation:
    ld a,(current_game_frame)
    srl a
    and #03
    push bc
    jr draw_enemy_barrel_animation_before_loop


draw_enemy_bubble_animation:
    push bc
    call draw_enemy_6_frame_animation
    jr draw_enemy_barrel_animation_before_loop

draw_enemy_star_animation:
    push bc
    call draw_enemy_6_frame_animation
    call draw_enemy_3_frame_animation_no_last_frame
    pop bc
    jp draw_enemy_1px_offset_check


draw_enemy_3_frame_animation:
    srl a
    and #03
    cp 3
    jr nz,draw_enemy_3_frame_animation_no_last_frame
    ld a,1
draw_enemy_3_frame_animation_no_last_frame:
    or a
    ret z
    ld bc,128
draw_enemy_3_frame_animation_loop:
    add hl,bc
    dec a
    jr nz,draw_enemy_3_frame_animation_loop
    ret


draw_enemy_6_frame_animation:
    ld a,(current_game_frame)
    srl a
    push de
    ; a = c mod d (to do modulo 6):
    ld c,a
    ld d,6
    ld b,8
    xor a
draw_enemy_6_frame_animation_l1:
    sla c
    rla
    cp d
    jr c,draw_enemy_6_frame_animation_l2
    inc c
    sub d
draw_enemy_6_frame_animation_l2:
    djnz draw_enemy_6_frame_animation_l1
    pop de
    ret


draw_enemy_vlaser:
    ld a,(current_game_frame)
    ld d,(ix+6) ; initial video mem address
    ld e,(ix+5)
    ld h,(ix+8) ; sprite ptr
    ld l,(ix+7)
    exx
        ld c,(ix+3) ; x
        ld e,(ix+1) ; initial y
draw_enemy_vlaser_loop:
        push af
        and #07
        jr nz,draw_enemy_vlaser_skip
        ; draw sprite:
        push bc
        call mark_sprite_dirty_tiles
        pop bc
    exx
    push de
    push hl
    call draw_sprite_0_transparent
    pop hl
    pop de
    exx
draw_enemy_vlaser_skip:
        ld a,16
        add a,e
        cp (ix+2)   ; check if we reached the end
        jp p,draw_enemy_vlaser_done
        ld e,a
    exx
    ld bc,16*16*4
    ex de,hl
    add hl,bc
    ex de,hl
    exx
        pop af
        inc a
        jr draw_enemy_vlaser_loop


draw_enemy_hlaser:
    ld a,(current_game_frame)
    ld d,(ix+6) ; initial video mem address
    ld e,(ix+5)
    ld h,(ix+8) ; sprite ptr
    ld l,(ix+7)
    exx
        ld c,(ix+1) ; initial x
        ld e,(ix+4) ; y
draw_enemy_hlaser_loop:
        push af
        and #07
        jr nz,draw_enemy_hlaser_skip
        ; draw sprite:
        push bc
        call mark_sprite_dirty_tiles
        pop bc
    exx
    push de
    push hl
    call draw_sprite_0_transparent
    pop hl
    pop de
    exx
draw_enemy_hlaser_skip:
        ld a,8
        add a,c
        cp (ix+2)   ; check if we reached the end
        jp p,draw_enemy_hlaser_done
        ld c,a
    exx
    inc de
    inc de
    inc de
    inc de
    exx
        pop af
        inc a
        jr draw_enemy_hlaser_loop
draw_enemy_vlaser_done:
draw_enemy_hlaser_done:
        pop af  ; restore the stack
    exx
    ret

; ------------------------------------------------
; Update cycle of an enemy:
; Arguments: ix : pointer to the enemy
update_enemy:
    ld a,(ix)
    and #03
    ld b,a  ; save the speed of the enemy
    ld a,(ix)
    srl a
    srl a
    or a
    jp z,update_enemy_right
    dec a
    jp z,update_enemy_left
    dec a
    jp z,update_enemy_down
    dec a
    jp z,update_enemy_up
    dec a
    jp z,update_enemy_down_arrow
    dec a
    jp z,update_stationary_showing
    dec a
    jp z,update_enemy_left_arrow
    dec a
    jp z,update_enemy_right_arrow
    dec a
    jp z,update_enemy_hlaser
    dec a
    jp z,update_enemy_vlaser
    dec a
    jp z,update_enemy_fallingblock
    dec a   ; nothing to do with the "instadead" blocks..., so we skip them
    ret z
    dec a
    jp z,update_enemy_wave_right
    dec a
    jp z,update_enemy_wave_left
    dec a
    jp z,update_enemy_waiting_right
    dec a
    jp z,update_enemy_waiting_left
    dec a
    jp z,update_enemy_waiting_down
    dec a
    jp z,update_stationary_hidden
    dec a
    jp z,update_hlaser_hidden
    dec a
    jr z,update_vlaser_hidden
    dec a
;    jr z,update_generator  ; nothing to update on the generator
    ret z
    dec a
    jr z,update_switch_vertical
    dec a
    jr z,update_switch_horizontal
    dec a
    jr z,update_switch_horizontal
    ret ; if we make it here it's that we have a ENEMY_STATE_NONE
update_switch_horizontal:
update_switch_vertical:
    ld a,(ix+2)
    or a
    ret nz
    call enemy_collision_with_player_y
    ret nz
    ; press the button!!
update_switch_press_switch:
    ld hl,(player_score)
    ld bc,PRESS_SWITCH_SCORE
    add hl,bc
    ld (player_score),hl
    call redraw_scoreboard_score

    ; change the foreground sprite:
    ld a,(ix+3)  ; x
    srl a
    srl a
    srl a
    ld b,a
    ld a,(ix+4)  ; y
    and #f0
    add a,b
    ld h,current_map_fg/256 ; current_map_fg are 256 aligned
    add a,a
    ld l,a  
    ld d,(ix+8)
    ld e,(ix+7)
    ld a,(ix)
    sub ENEMY_STATE_SWITCH_HORIZONTAL
    add a,a
    add a,a
    add a,a
    add a,a ; a = 0 if horizontal, 64 if vertical, and 128 if horizontal-right
    push hl
    ld l,a
    ld h,0
    add hl,de
    ex de,hl
    pop hl
    ld (hl),d
    inc hl
    ld (hl),e

    ; mark the dirty tile:
    ld h,dirty_tiles/256
    ld l,c  ; c still has the offset for the dirty_tiles table
    ld a,4
    ld (hl),a

    ld (ix+2),1   ; make the button inactive

    ; mark switch as activated
    ld hl,player_switch_state
    ld b,0
    ld c,(ix+1)
    add hl,bc
    ld (hl),1

    ld a,(loading_map)
    or a
    jr nz,update_switch_press_switch_no_sfx
    ld hl,SFX_switch
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority
update_switch_press_switch_no_sfx:
    ld a,c  ; the switch ID
    jp check_for_open_windows
    ; ret

update_vlaser_hidden:
    ld c,ENEMY_STATE_VLASER_SHOWING
update_vlaser_hidden_entry_point:
    ld a,(current_game_frame)
    bit 6,a
    ret z
    ld (ix),c
    ret 

update_enemy_vlaser:
    ld c,ENEMY_STATE_VLASER_HIDDEN
    jr update_enemy_vlaser2
update_enemy_hlaser:
    ld c,ENEMY_STATE_HLASER_HIDDEN
update_enemy_vlaser2:
    ld a,(current_game_frame)
    and #07
    jr nz,update_stationary_showing_entry_point
    ld hl,SFX_laser
    ld a,SFX_PRIORITY_LOW
    call play_SFX_with_priority
update_stationary_showing_entry_point:
    ld a,(current_game_frame)
    bit 6,a
    ret nz
    ld (ix),c
    ret    

update_hlaser_hidden:
    ld c,ENEMY_STATE_HLASER_SHOWING
    jr update_vlaser_hidden_entry_point


update_stationary_hidden:
    ld c,ENEMY_STATE_STATIONARY_SHOWING
    jp update_vlaser_hidden_entry_point

update_stationary_showing:
    ld c,ENEMY_STATE_STATIONARY_HIDDEN
    jr update_stationary_showing_entry_point


update_enemy_fallingblock:
    ld a,(ix+2)
    or a
    ret z   ; this means it has already reached the bottom
    ld a,(ix+1)
    bit 7,a
    jr nz,update_enemy_fallingblock_falling
    ; check if the falling rock final position is the same as the start position
;    ld a,(ix+4)
;    cp (ix+2)
;    ret z   ; this one does not need to fall! (it's not a moving one!)
    ; detect if the player is in-line:
    ld a,(player_x)
    ld b,(ix+3)
    add a,7
    cp b
    ret m
    sub 16
    cp b
    ret p
    ld a,(ix+1)
    or #80  ; mark it's falling
    ld (ix+1),a

    ; play SFX:
    ld hl,SFX_falling_rock
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority
update_enemy_fallingblock_falling:
    ld a,(ix+4)
    cp (ix+2)
    jr z,update_enemy_fallingblock_falling_done
    call update_enemy_falling_block_move_down
    call update_enemy_falling_block_move_down
    
    ; update the permanent storage for this:
    call update_enemy_fallingblock_permanent_pointer
    ld a,(ix+4)
    ld (hl),a
    ret
update_enemy_fallingblock_falling_done:
    ld (ix+2),0 ; reached the bottom
    ; update the collision mask
    ; collision offset is: (y/16)*16+x/8
    ld c,(ix+3)
    srl c
    srl c
    srl c
    ld a,(ix+4)
    and #f0
    add a,c
    ld h,map_collision_mask/256
    add a,128   ; since map_collision_mask starts 128 bytes later
    ld l,a
    ; check if the rock is at half-height:
    ld a,(ix+4)
    and #0f
    jr z,update_enemy_fallingblock_falling_done_whole_tile
    ld (hl),COLLISION_BOTTOM_LEFT_MASK+COLLISION_BOTTOM_RIGHT_MASK
    ld bc,16
    add hl,bc
    ld (hl),COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK
    jr update_enemy_fallingblock_kill_player_after_complete_fall
update_enemy_fallingblock_falling_done_whole_tile:
    ld (hl),COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK+COLLISION_BOTTOM_LEFT_MASK+COLLISION_BOTTOM_RIGHT_MASK
update_enemy_fallingblock_kill_player_after_complete_fall:
    ld iy,player_struct_pointer
    ld c,(iy+1) ; player x
    ld b,(iy)   ; player y
    call sprite_collision_with_map
    ret z
    ; player needs to be killed, since when the block fell, it is trapped!
    jp player_life_lost_dec_life
    
update_enemy_falling_block_move_down:
    inc (ix+4)
    ld h,(ix+6)
    ld l,(ix+5)
    ld de,64
    add hl,de
    ld (ix+6),h
    ld (ix+5),l
    ret
update_enemy_fallingblock_permanent_pointer:
    ld a,(ix+1)
    and #3f
    ld hl,player_falling_block_state
    ld b,0
    ld c,a
    add hl,bc
    ret


update_enemy_waiting_left:
    ld c,ENEMY_STATE_LEFT_ARROW
update_enemy_waiting_right_entry_point:
    ld a,b  ; only if b == 0, arrow fires
    or a
    jr z,update_enemy_waiting_left_ready
    ld a,(current_game_frame)
    and #07 ;; b decreases once every 8 game cycles
    ret nz
    dec b   ;; decrease b, and update the state
    ld a,(ix)
    and #fc ; clear the counter
    add a,b
    ld (ix),a
    ret
update_enemy_waiting_left_ready:
update_enemy_waiting_right_ready:
    ; detect if the player is in-line:
    ld a,(player_y)
    ld b,(ix+4)
    add a,15
    cp b
    ret m
    sub 23
    cp b
    ret p
update_enemy_waiting_down_ready_entry_point:
    ld hl,SFX_fire_arrow
    ld a,SFX_PRIORITY_LOW
    call play_SFX_with_priority
    ld (ix),c
    ret
update_enemy_waiting_right:
    ld c,ENEMY_STATE_RIGHT_ARROW
    jr update_enemy_waiting_right_entry_point


update_enemy_waiting_down:
    ld a,b  ; only if b == 0, arrow fires
    or a
    jr z,update_enemy_waiting_down_ready
    ld a,(current_game_frame)
    and #07 ;; b decreases once every 8 game cycles
    ret nz
    dec b   ;; decrease b, and update the state
    ld a,ENEMY_STATE_WAITING_DOWN
    add a,b
    ld (ix),a
    ret
update_enemy_waiting_down_ready:
    ; detect if the player is in-line:
    ld a,(player_x)
    ld b,(ix+3)
    add a,7
    cp b
    ret m
    sub 11
    cp b
    ret p
    ld c,ENEMY_STATE_DOWN_ARROW
    jr update_enemy_waiting_down_ready_entry_point

update_enemy_left_arrow:
    ld iyl,ENEMY_STATE_WAITING_LEFT+3
    ld a,(ix+3)
    cp 2
    jp m,update_enemy_reset_left_arrow
    sub 2
    ld (ix+3),a
    ld d,(ix+6)
    ld e,(ix+5)
    dec de
update_enemy_right_arrow_entry_point:
update_enemy_down_arrow_entry_point:
    ld (ix+6),d
    ld (ix+5),e
    ld c,(ix+3)
    ld b,(ix+4)
    call thin_sprite_collision_with_map
    ret z
;    jr update_enemy_reset_left_arrow
update_enemy_reset_left_arrow:
update_enemy_reset_right_arrow:
update_enemy_reset_down_arrow:
    ld c,(ix+1)
    ld b,(ix+2)   ; get the x, y start position
    ld a,iyl
    ld (ix),a
    ld (ix+3),c   ; reset the x, y position
    ld (ix+4),b
    call calculate_sprite_pointer
    ld (ix+6),h
    ld (ix+5),l
    ret

update_enemy_right_arrow:
    ld iyl,ENEMY_STATE_WAITING_RIGHT+3
    ld a,(ix+3)
    cp 120
    jp p,update_enemy_reset_right_arrow
    add a,2
    ld (ix+3),a
    ld d,(ix+6)
    ld e,(ix+5)
    inc de
    jr update_enemy_right_arrow_entry_point

update_enemy_down_arrow:
    ld iyl,ENEMY_STATE_WAITING_DOWN+3
    ld a,(ix+4)
    cp 104
    jp p,update_enemy_reset_down_arrow
    add a,3
    ld (ix+4),a
    ld d,(ix+6)
    ld e,(ix+5)
    ld hl,64*3
    add hl,de
    ex de,hl
    jr update_enemy_down_arrow_entry_point

update_enemy_down:
    call adjust_enemy_move_speed    
    ld c,(ix+2)  ;; get upper bound
    ld a,(ix+4)  ;; get y
    cp c
    jp p,update_enemy_turn_up_down
    ld h,(ix+6)
    ld l,(ix+5)
update_enemy_down_loop:
    push bc
    push hl
    call update_enemy_need_to_move_player
    push af
    inc (ix+4)
    pop af
    call z,update_player_move_down_one_init_iy
    pop hl
    pop bc   
    ld de,64
    add hl,de
    djnz update_enemy_down_loop
update_enemy_up_entry_point:
;    ld (ix+4),a
    ld (ix+5),l
    ld (ix+6),h
    ret

update_enemy_up:
    call adjust_enemy_move_speed    
    ld c,(ix+1)  ;; get lower bound
    ld a,(ix+4)  ;; get y
    cp c
    jp m,update_enemy_turn_up_down
    ld h,(ix+6)
    ld l,(ix+5)
update_enemy_up_loop:
    push bc
    push hl
    call update_enemy_need_to_move_player
    push af
    dec (ix+4)
    pop af
    call z,update_player_move_up_one_init_iy
    pop hl
    pop bc   
    ld de,-64
    add hl,de
    djnz update_enemy_up_loop
    jr update_enemy_up_entry_point

update_enemy_right:
    call adjust_enemy_move_speed
    ld a,(ix+2)  ;; get upper bound
    ld c,(ix+3)  ;; get x
    cp c
    jp m,update_enemy_turn_left_right
    ld d,(ix+6)
    ld e,(ix+5)
update_enemy_right_loop:
    push bc
    call update_enemy_need_to_move_player
    call z,update_player_move_right_init_iy
    pop bc
    inc c
    bit 0,c
    jr nz,update_enemy_right_loop_skip_change_pointer
    inc de
update_enemy_right_loop_skip_change_pointer:
    djnz update_enemy_right_loop
update_enemy_left_entry_point:
    ld (ix+3),c
    ld (ix+6),d
    ld (ix+5),e
    ret

update_enemy_left:
    call adjust_enemy_move_speed
    ld a,(ix+1)  ;; get lower bound
    ld c,(ix+3)  ;; get x
    cp c
    jp p,update_enemy_turn_left_right
    ld d,(ix+6)
    ld e,(ix+5)
update_enemy_left_loop:
    push bc
    call update_enemy_need_to_move_player
    call z,update_player_move_left_init_iy
    pop bc
    dec c
    bit 0,c
    jr z,update_enemy_left_loop_skip_change_pointer
    dec de
update_enemy_left_loop_skip_change_pointer:
    djnz update_enemy_left_loop
    jr update_enemy_left_entry_point


update_enemy_turn_left_right:
update_enemy_turn_up_down:
    ld a,(ix)
    xor #04
    ld (ix),a
    jp update_enemy


sine_movement_table:
;    db 0,1,1,2,3, 2,1,1,0, 0,4+1,4+1,4+2, 4+3,4+2,4+1,0
    db 0,1,1,2,2, 2,1,1,0, 0,4+1,4+1,4+2, 4+2,4+2,4+1,0

update_enemy_wave_right:
    call update_enemy_right
;update_enemy_wave_left_entry_point:
;    ld a,(current_game_frame) 
    ld a,(ix+3) ;; x
update_enemy_wave_left_entry_point:
    and #0f
    ld hl,sine_movement_table
    ADD_HL_A
    ld a,(hl)
    or a
    ret z
    ld h,(ix+6)
    ld l,(ix+5)
    bit 2,a
    jp z,update_enemy_wave_up
    jp update_enemy_wave_down

update_enemy_wave_up:
    and #03
    ld b,a
    ld de,-64
update_enemy_wave_up_loop:
    dec (ix+4)
    add hl,de
    djnz update_enemy_wave_up_loop
    jp update_enemy_up_entry_point

update_enemy_wave_down:
    and #03
    ld b,a
    ld de,64
update_enemy_wave_down_loop:
    inc (ix+4)
    add hl,de
    djnz update_enemy_wave_down_loop
    jp update_enemy_up_entry_point


update_enemy_wave_left:
    call update_enemy_left
    ld a,(ix+3) ;; x
    ld b,a
    ld a,15
    sub b
    jr update_enemy_wave_left_entry_point


; z: if we need to move the player
; nz: if we do not
update_enemy_need_to_move_player:
    ld a,(ix+9) ; animation type
    cp ENEMY_ANIMATION_STYLE_PLATFORM
    ret nz
    ld c,(ix+4) ; enemy y
    ld a,(player_y)
    add a,16
    cp c
    ret nz
    jr enemy_collision_with_player_x


adjust_enemy_move_speed:
    bit 0,b
    jr z,adjust_enemy_move_speed_adjusted
    ld a,(current_game_frame)
    and #01
    jr z,adjust_enemy_move_speed_adjusted
    dec b
    jr z,adjust_enemy_move_speed_zero_speed
adjust_enemy_move_speed_adjusted:
    bit 1,b
    ret z
    dec b
    ret
adjust_enemy_move_speed_zero_speed:
    pop af  ; we simulate 2 rets, to prevent enemy from moving
    ret


; ------------------------------------------------
; input:
; - ix: ptr to enemy
; output:
; - z: if collision
; - nz: if we do not
enemy_collision_with_player:
    ld a,(ix)
    cp ENEMY_STATE_VLASER_SHOWING
    jp z,enemy_collision_with_player_vlaser
    cp ENEMY_STATE_HLASER_SHOWING
    jp z,enemy_collision_with_player_hlaser
    and #fc
    cp ENEMY_INVISIBLE_STATES
    jp p,enemy_collision_with_player_no_collision
    ld a,(ix+9)
    ld b,a  ; we save it for later
    cp ENEMY_ANIMATION_STYLE_PLATFORM
    jr z,enemy_collision_with_player_no_collision
    cp ENEMY_ANIMATION_STYLE_ARROW
    jr z,enemy_collision_with_player_narrow_collision
    cp ENEMY_ANIMATION_STYLE_LASER
    jr z,enemy_collision_with_player_narrow_collision
    cp ENEMY_ANIMATION_STYLE_FIRE
    jr z,enemy_collision_with_player_narrow_collision
    cp ENEMY_ANIMATION_STYLE_STAR
    jr z,enemy_collision_with_player_narrow_collision
    cp ENEMY_ANIMATION_STYLE_TRAP
    jr z,enemy_collision_with_player_narrow_collision_bottom

enemy_collision_with_player_y:
    ld c,(ix+4) ; enemy y
    ld a,(player_y)
    sub c
    cp 12
    jp p,enemy_collision_with_player_no_collision
    cp -11
    jp m,enemy_collision_with_player_no_collision

enemy_collision_with_player_x:
    ld c,(ix+3) ; enemy x
    ld a,(player_x)
    sub c
    cp 6
    jp p,enemy_collision_with_player_no_collision
    cp -5
    jp m,enemy_collision_with_player_no_collision
    ; collision!
    xor a    ; z
    ret
enemy_collision_with_player_no_collision:
    or 1    ; nz
    ret    

enemy_collision_with_player_vlaser:
    ; check y:
    ld a,(player_y)
    cp (ix+1)  ; laser top y
    jp m,enemy_collision_with_player_no_collision
    cp (ix+2)  ; laser bottom y
    jp p,enemy_collision_with_player_no_collision
    jr enemy_collision_with_player_fire_x

enemy_collision_with_player_narrow_collision_bottom:
    ld c,(ix+4) ; enemy y
    ld a,(player_y)
    sub c
    cp 12
    jp p,enemy_collision_with_player_no_collision
    cp -5
    jp m,enemy_collision_with_player_no_collision
    jr enemy_collision_with_player_x

enemy_collision_with_player_narrow_collision:
    ld c,(ix+4) ; enemy y
    ld a,(player_y)
    sub c
    cp 6
    jp p,enemy_collision_with_player_no_collision
    cp -11
    jp m,enemy_collision_with_player_no_collision
    bit 0,b ; b has anim type, and it happens that the even numbers use regular x collision
    jr z,enemy_collision_with_player_x
enemy_collision_with_player_fire_x:
    ld a,(player_x)
    sub (ix+3) ; enemy x
    cp 6
    jp p,enemy_collision_with_player_no_collision
    cp -1
    jp m,enemy_collision_with_player_no_collision
    ; collision!
    xor a    ; z
    ret

enemy_collision_with_player_hlaser:
    ; check x:
    ld a,(player_x)
    cp (ix+1)  ; laser left x
    jp m,enemy_collision_with_player_no_collision
    cp (ix+2)  ; laser right x
    jp p,enemy_collision_with_player_no_collision
    ; check y:
    ld a,(player_y)
    sub (ix+4) ; enemy y
    cp 6
    jp p,enemy_collision_with_player_no_collision
    cp -11
    jp m,enemy_collision_with_player_no_collision
    ; collision!
    xor a    ; z
    ret     

; ------------------------------------------------
; input: 
; - b = y
; - c = x
; output:
; - hl: sprite pointer in the double_buffer
calculate_sprite_pointer:
    ld l,b
    ld b,0
    srl c       ; bc = x/2    
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl   ; hl = y*64
    add hl,bc   ; hl = x/2 + y*64
    ld bc,double_buffer
    add hl,bc   ; hl = double_buffer + x/2 + y*64
    ret


; ------------------------------------------------
; hl: compressed sprites
; de: target memory address of decompressed sprites
load_franken_sprites:
load_skull_sprites:
load_spider_sprites:
load_vampire_sprites:
    push de
        call load_trap_sprites
        ; here hl points to the beginning of the 7th sprite
        ex de,hl
    pop hl  ; we recover the initial address of "de", which was pointing at the first sprite

    ; we start by copying all the 6 sprites before flipping them
    ld bc,64*6  
    push de
    ldir
    pop hl

    ; flip all 6 sprites
    ld b,6
load_vampire_sprites_loop2:
    push bc
    push hl
    call flip_sprite_16x8
    pop hl
    ld bc,64
    add hl,bc
    pop bc
    djnz load_vampire_sprites_loop2

    ld (next_enemy_sprite_ptr),hl
    ret


load_ghost_sprites:
load_trap_sprites:
    ld iyl,3
load_star_sprites_entry_point:
load_movingplatform_sprites_entry_point:
    push iy
    push de
        call decompress  ; first decompress everything
    pop de
    pop iy

    ; offxet by 1 px the even sprites
    ld h,d
    ld l,e
    ld bc,64
    add hl,bc
    ex de,hl

    ld b,iyl
load_trap_sprites_loop1:
    push bc
        call offset_sprite_by_1px
        ld bc,64
        add hl,bc
        ex de,hl
        add hl,bc
        ex de,hl
    pop bc
    djnz load_trap_sprites_loop1
    ld (next_enemy_sprite_ptr),hl
    ret        

load_star_sprites:
    ld iyl,6
    jr load_star_sprites_entry_point

load_arrow_sprites:
    push de
        push de
            call decompress
        pop de
        ld h,d
        ld l,e
        ld bc,64
        add hl,bc
        ex de,hl
        push de
            ldir
        pop hl
        call flip_sprite_16x8
    pop hl
    ld bc,64*2
    add hl,bc
    ld (next_enemy_sprite_ptr),hl
    ret

load_brickwall_sprites:
load_spikeball_sprites:
load_redskull_sprites:
load_laser_sprites:
load_arrows_down_sprites:
;load_bullet_sprites:
    ld bc,64
    push bc
    jr load_barrel_sprites_entry_point

load_generator_sprites:
    ld bc,2*64
    push bc
    jr load_barrel_sprites_entry_point

load_switch_sprites:
    ld bc,3*64
    push bc
    jr load_barrel_sprites_entry_point

load_fire_sprites:
load_barrel_sprites:
    ld bc,4*64
    push bc
    jr load_barrel_sprites_entry_point

load_static_trap_sprites:
load_cross_sprites:
load_bubble_sprites:
    ld bc,6*64
    push bc
load_barrel_sprites_entry_point:
    push de
    call decompress  ; just decompress everything
    pop hl
    pop bc
    add hl,bc
    ld (next_enemy_sprite_ptr),hl
    ret

load_movingplatform_sprites:
    ld iyl,1
    jr load_movingplatform_sprites_entry_point    

end_of_enemy_code:

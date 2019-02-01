; ------------------------------------------------
; handles the palette rotation of locks
palette_loop_table:
	db #05,#10,#11,#14,#15,#41,#44,#45
draw_items:
    ld a,(n_items)
    or a
    ret z
    ld ix,items
    ld a,(ix)
    or a	; empty item (e.g., already taken)
    ret z	; we assume the lock is always the first item in a room

    cp ITEM_GATE_LOCK
    ret m
    cp ITEM_FOOD1
    ret p

    ; mark the tile as dirty:
    ; dirty tile is: (x >> 3) + (y & #f0)
    ld a,(ix+1)   ; x
    srl a
    srl a
    srl a
    ld b,a
    ld a,(ix+2)   ; y
    and #f0
    add a,b
    ld h,dirty_tiles/256
    ld l,a
    ld (hl),2

    ; calculate the pointer of the item sprite:
    ld hl,item_sprites
    ld a,(ix+3)
    or a
    jr z,draw_items_loop_first_sprite
    ld hl,item_sprites+64
draw_items_loop_first_sprite:

    ld a,(current_game_frame)
    srl a
    and #07
    ld de,palette_loop_table
    ADD_DE_A
    ld a,(de)
    ld c,a	; color to use this frame

    ; palette rotation:
    ld b,64
draw_items_palette_loop:
    ; left-pixel
    ld a,(hl)
    ld d,a
    and #aa	; we ignore the lower bit, if the result is != 0, we know we need to rotate the color
    jr z,draw_items_palette_loop_right_pixel
    cp #80	; black
    jr z,draw_items_palette_loop_right_pixel
    ld a,d
    and #55	; we get rid of the left-pixel
    sla c	
    or c
    srl c	; restore c
    ld (hl),a
    ld d,a

draw_items_palette_loop_right_pixel:
    ; right pixel:
    ld a,d
    and #55	; we ignore the lower bit, if the result is != 0, we know we need to rotate the color
    jr z,draw_items_palette_loop_next
    cp #40	; black
    jr z,draw_items_palette_loop_next
    ld a,d
    and #aa	; we get rid of the right-pixel
    or c
    ld (hl),a

draw_items_palette_loop_next:
	inc hl
    djnz draw_items_palette_loop

    ; there is only one lock per room at most, so, after this, we can return
    ret


; ------------------------------------------------
; checks if the player has interacted with any item
update_items:
    ld a,(n_items)
    or a
    ret z
    ld hl,items
    ld b,a
update_items_loop:
    ld a,(hl)
    or a	; empty item (e.g., already taken)
    jr z,update_items_next_item

    ; check x range:
    inc hl
    ld c,(hl)	; item x
    ld a,(player_x)
    sub c
    cp 6
    jp p,update_items_next_item_one_inc
    cp -5
    jp m,update_items_next_item_one_inc

    ; check y range:
    inc hl
    ld c,(hl)	; item y
    ld a,(player_y)
    sub c
    cp 14
    jp p,update_items_next_item_two_incs
    cp -13
    jp m,update_items_next_item_two_incs

    ; collision!!
    dec hl
    dec hl
    jr player_touched_item	; we can safely jump, rather than call, since there are never two items one on top of another

update_items_next_item:
	inc hl	; assumes that ITEM_STRUCT_SIZE = 4
update_items_next_item_one_inc:
	inc hl
update_items_next_item_two_incs:
	inc hl
	inc hl
    djnz update_items_loop
	ret


; ------------------------------------------------
; player touched an item such as a key, a lock, or food
player_touched_item:
	ld a,(hl)
	dec a
	cp ITEM_WHEEL
	jp m,player_touched_item_take
	cp ITEM_HAMMER 
	jp m,player_touched_item_take_special
	cp ITEM_FOOD1-1
	jp p,player_touched_item_food
	
	; it's a lock:
	sub ITEM_GATE_LOCK-ITEM_GATE_KEY	; get the index of the necessary key
	ld b,a ; save the lock idx
	ld de,player_inventory
	ADD_DE_A
	ld a,(de)
	or a
	ret z	; we don't have the right key

	; open a lock!!!
	ld a,b ; retrieve the lock idx
	push af
	push hl
    ; remove the item from the score_board
    call score_board_remove_item
    pop hl
    pop af
    push hl
	call open_lock_effect

    ld hl,(player_score)
    ld bc,OPEN_LOCK_SCORE
    add hl,bc
    ld (player_score),hl
    call redraw_scoreboard_score

	ld hl,SFX_door_open
	ld a,SFX_PRIORITY_HIGH
	call play_SFX_with_priority
	pop hl
	jp player_touched_item_clear_item

player_touched_item_food:
	ld b,a	; save the item type for later
	push hl
	ld hl,player_lives
	ld a,(hl)
	cp MAX_LIVES
	jr z,player_touched_item_food_max_lives	; we are maxed out of lives
	inc (hl)	; add 1 life

	; mark the food as taken:
player_touched_item_food_mark:
	ld hl,player_food_state
	ld a,b	; we retrieve the item type
	sub ITEM_FOOD1-1
	srl a
	jr nc,player_touched_item_food1
player_touched_item_food2:
	ADD_HL_A
	ld a,(hl)
	or #02	; ITEM_FOOD2 uses bit 2
	ld (hl),a
	jr player_touched_item_food_marked
player_touched_item_food1:
	ADD_HL_A
	ld a,(hl)
	or #01	; ITEM_FOOD1 uses bit 1
	ld (hl),a
player_touched_item_food_marked:

player_touched_item_food_marked2:
	call redraw_lives_and_health

	ld hl,SFX_item_pickup
	ld a,SFX_PRIORITY_HIGH
	call play_SFX_with_priority
	pop hl

	jr player_touched_item_clear_item
player_touched_item_food_max_lives:
	ld hl,player_health
	ld a,(player_health)
	cp 5
	jr z,player_touched_item_food_max_lives_max_health
	ld (hl),5
	jr player_touched_item_food_mark
player_touched_item_food_max_lives_max_health:
	pop hl
	ret

player_touched_item_take_special:
	push hl
	push af
	ld hl,player_inventory
	ADD_HL_A
	ld (hl),1	; item taken:
	pop af

	; add the item to the score board in its special position:
	; - this assumes that the item to add is the first item in the current map
    sub ITEM_CROSS-1
    push af
;    ld de,VIDEO_MEMORY + 23*SCREEN_WIDTH_IN_BYTES_256px + 20  ; pointer to the video memory address to draw the item to
    ld de,VIDEO_MEMORY + 19*SCREEN_WIDTH_IN_BYTES_256px + 44  ; pointer to the video memory address to draw the item to
    or a
player_touched_item_take_special_loop:
    jr z,player_touched_item_take_special_loop_end
    inc de
    inc de
    inc de
    inc de
    dec a
    jr player_touched_item_take_special_loop
player_touched_item_take_special_loop_end:
    pop af

    ld hl,item_sprites  ; assume it's the first item
    ld bc,16*256 + 4
    call draw_sprite_variable_size_to_screen

    ld hl,(player_score)
    ld bc,SPECIAL_ITEM_PICKUP_SCORE
    add hl,bc
    ld (player_score),hl
    call redraw_scoreboard_score	

	ld hl,SFX_item_pickup
	ld a,SFX_PRIORITY_HIGH
	call play_SFX_with_priority

	pop hl
	jr player_touched_item_clear_item


player_touched_item_take:
	push hl
	; add the item to the score board:
	push af
	call score_board_add_item
	pop af
	ld hl,player_inventory
	ADD_HL_A
	ld (hl),1	; item taken:

    ld hl,(player_score)
    ld bc,SPECIAL_KEY_PICKUP_SCORE
    add hl,bc
    ld (player_score),hl
    call redraw_scoreboard_score	

	ld hl,SFX_item_pickup
	ld a,SFX_PRIORITY_HIGH
	call play_SFX_with_priority
	pop hl

player_touched_item_clear_item:
	; clear the item:
    xor a
    ld (hl),a  

    ; clear the item graphic:
    push hl
    push hl
    pop ix
    call calculate_item_foreground_pointer
    xor a
    ld (hl),a
    inc de
    ld (hl),a
    pop hl
	ret


; ------------------------------------------------
; given an item pointed to by "ix" 
; it calculates (in "hl"), the pointer where it will be draws in the current map foreground
calculate_item_foreground_pointer:
    ld c,(ix+1)   ; x
    inc hl
    srl c
    srl c
    srl c       ; c = x/8
    ld a,(ix+2)   ; y
    and #f0
    add a,c
	ld h,current_map_fg/256
	add a,a
	ld l,a	; hl = current_map + 2 + (x/8 + *y/16)*16)*2
;    ld hl,current_map_fg
;    ld d,0
;    ld e,a
;    add hl,de
;    add hl,de   
    ret


; ------------------------------------------------
; removes items that have already been picked up, or locks that have already been open 
check_items_after_loading_map:
    ld hl,items
    ld a,(n_items)
    or a
    ret z
    ld b,a
check_items_after_loading_map_loop:
	ld a,(hl)
	dec a
	cp PLAYER_INVENTORY_SIZE
	jp m,check_items_after_loading_map_inventory
	cp ITEM_FOOD1-1
	jp p,check_items_after_loading_map_food
check_items_after_loading_map_lock:
	sub ITEM_GATE_LOCK-ITEM_GATE_KEY	; get the index of the lock
	ld de,player_lock_state
	ADD_DE_A
	ld a,(de)
	or a
	jr z,check_items_after_loading_map_done_with_item
	ld a,(hl)
	sub (ITEM_GATE_LOCK-ITEM_GATE_KEY)+1	; get the index of the lock again
	ld (hl),0	; remove item from the screen
	; it's a lock, so, we need to execute its effect:
	push hl
	push bc
	call open_lock_effect
	pop bc
	pop hl
check_items_after_loading_map_done_with_item:
	inc hl
	inc hl
	inc hl
	inc hl
    djnz check_items_after_loading_map_loop
    ret

check_items_after_loading_map_inventory:
	ld de,player_inventory
	ADD_DE_A
	ld a,(de)
	or a
	jr z,check_items_after_loading_map_done_with_item
	ld (hl),0	; remove item from the screen
	jr check_items_after_loading_map_done_with_item

check_items_after_loading_map_food:
	sub ITEM_FOOD1-1
	srl a
	jr nc,check_items_after_loading_map_food1
check_items_after_loading_map_food2:
	ld de,player_food_state
	ADD_DE_A
	ld a,(de)
	and #02	; ITEM_FOOD2 uses bit 2
	jr z,check_items_after_loading_map_done_with_item
	ld (hl),0	; remove item from the screen
	jr check_items_after_loading_map_done_with_item
check_items_after_loading_map_food1:
	ld de,player_food_state
	ADD_DE_A
	ld a,(de)
	and #01	; ITEM_FOOD2 uses bit 1
	jr z,check_items_after_loading_map_done_with_item
	ld (hl),0	; remove item from the screen
	jr check_items_after_loading_map_done_with_item


; ------------------------------------------------
; renders the items to the foreground of the current map when maps are loaded
render_items_to_foreground:
    ld ix,items
    ld a,(n_items)
    or a
render_items_to_foreground_loop:
    ret z
    push af
    ld a,(ix)   ; item_type
    or a	; item was removed
    jr z,render_items_to_foreground_tile_ptr_computed
    call calculate_item_foreground_pointer
    ld a,(ix+3)	; item sprite
    ld de,item_sprites	; we subtract 64, since the first item is '1'
    or a
    jr z,render_items_to_foreground_first_sprite
    ld de,item_sprites+64
render_items_to_foreground_first_sprite:   
    ld (hl),d
    inc hl
    ld (hl),e
render_items_to_foreground_tile_ptr_computed:
	ld bc,4
	add ix,bc
    pop af
    dec a
    jr render_items_to_foreground_loop


; ------------------------------------------------
; checks if any switch is already pressed when entering a room, and presses it
check_fallingblocks_switches_and_windows:
    ld a,(n_enemies)
    or a
    ret z
    ld ix,enemies
check_switches_and_windows_loop:
    push af
    ; check if switch is pressed:
    ld a,(ix)
    cp ENEMY_STATE_SWITCH_VERTICAL
    jr z,check_switches_and_windows_loop_is_switch
    cp ENEMY_STATE_SWITCH_HORIZONTAL
	jr z,check_switches_and_windows_loop_is_switch
    cp ENEMY_STATE_SWITCH_HORIZONTAL_RIGHT
	jr z,check_switches_and_windows_loop_is_switch
	cp ENEMY_STATE_FALLING_BLOCK
	jr z,check_fallingblocks_switches_and_windows_loop_is_fallingblock
	jr check_switches_and_windows_loop_not_a_switch
check_switches_and_windows_loop_is_switch:
	ld hl,player_switch_state
	ld c,(ix+1)
	ld b,0
	add hl,bc
	ld a,(hl)
	or a
    jr z,check_switches_and_windows_loop_not_a_switch
    call update_switch_press_switch
check_switches_and_windows_loop_not_a_switch:
    pop af
    ld bc,ENEMY_STRUCT_SIZE
    add ix,bc
    dec a
    jr nz,check_switches_and_windows_loop
	ret
check_fallingblocks_switches_and_windows_loop_is_fallingblock:
    call update_enemy_fallingblock_permanent_pointer
    ld a,(hl)
    or a
    jr z,check_switches_and_windows_loop_not_a_switch   ; this means, we haven't stored the state yet
    push af
    ld a,(ix+1)
    or #80  ; mark it's falling
    ld (ix+1),a    
    pop af
update_enemy_fallingblock_restore_state_loop:
    cp (ix+4)
    jr z,check_switches_and_windows_loop_not_a_switch
    call update_enemy_falling_block_move_down
    jr update_enemy_fallingblock_restore_state_loop


; ------------------------------------------------
; checks whether a window needs to be open
check_for_open_windows:
	; map 6-7: 0, 1, 2
	; map 6-6: 3, 4, 5
	; map 4-4: 6, 7
	; map 5-3: 8, 9
	; map 2-4: 10, 11, 12
	; map 4-2: 13, 14
	cp 3
	jp m,check_for_open_windows_6_7
	cp 6
	jp m,check_for_open_windows_6_6
	cp 8
	jp m,check_for_open_windows_4_4
	cp 10
	jp m,check_for_open_windows_5_3
	cp 13
	jp m,check_for_open_windows_2_4
	; cp 15	
	; jp m,check_for_open_windows_4_2
	; ret

check_for_open_windows_4_2:
	ld bc,4 + 16*4
	xor a
	ld hl,player_switch_state+13
	jr check_for_open_windows_2_switches

check_for_open_windows_6_7:
	ld bc,3 + 3*16
	xor a
	ld hl,player_switch_state
check_for_open_windows_3_switches:
	add a,(hl)
	inc hl
	add a,(hl)
	inc hl
	add a,(hl)
	cp 3
	ret nz
	; open the window!
	call check_for_open_window_generic
check_for_open_windows_decrease_counter:
	ld a,(loading_map)
	or a
	ret nz
	ld hl,player_window_state
	dec (hl)
    ld hl,SFX_door_open
    ld a,SFX_PRIORITY_HIGH
    call play_SFX_with_priority
	jp redraw_windows_state

check_for_open_windows_6_6:
	ld bc,8 + 4*16
	xor a
	ld hl,player_switch_state+3
	jr check_for_open_windows_3_switches

check_for_open_windows_4_4:
	ld bc,8 + 2*16
	xor a
	ld hl,player_switch_state+6
check_for_open_windows_2_switches:
	add a,(hl)
	inc hl
	add a,(hl)
	cp 2
	ret nz
	; open the window!
	call check_for_open_window_generic
	jr check_for_open_windows_decrease_counter

check_for_open_windows_5_3:
	ld bc,9 + 16
	xor a
	ld hl,player_switch_state+8
	jr check_for_open_windows_2_switches

check_for_open_windows_2_4:
	ld bc,8 + 16
	xor a
	ld hl,player_switch_state+10
	jr check_for_open_windows_3_switches

check_for_open_window_generic:
	push bc
    ld hl,(player_score)
    ld bc,OPEN_WINDOW_SCORE
    add hl,bc
    ld (player_score),hl
    call redraw_scoreboard_score

	ld de,end_of_tiles-64*4
	ld hl,window_open_compressed
	push ix
	call decompress
	pop ix
	pop bc
	ld hl,current_map_fg
	add hl,bc
	add hl,bc
	ld (hl),(end_of_tiles-64*4)/256
	inc hl
	ld (hl),(end_of_tiles-64*4)%256
	inc hl
	ld (hl),(end_of_tiles-64*3)/256
	inc hl
	ld (hl),(end_of_tiles-64*3)%256
	ld de,16*2 - 3
	add hl,de
	ld (hl),(end_of_tiles-64*2)/256
	inc hl
	ld (hl),(end_of_tiles-64*2)%256
	inc hl
	ld (hl),(end_of_tiles-64*1)/256
	inc hl
	ld (hl),(end_of_tiles-64*1)%256
	ld a,2
	ld hl,dirty_tiles
	add hl,bc
	ld (hl),a
	inc hl
	ld (hl),a
	ld de,16 - 1
	add hl,de
	ld (hl),a
	inc hl
	ld (hl),a
	ret


; ------------------------------------------------
; Effect of opening the locks
; input: a : lock number
open_lock_effect:
	ld hl,player_lock_state
	ld b,0
	ld c,a
	add hl,bc
	ld (hl),1	; set the lock to open!

	or a	; ITEM_GATE_KEY
	jr z,open_gate_lock
	dec a	; ITEM_TRIANGLE_KEY
	jr z,open_triangle_lock
	dec a	; ITEM_SQUARE_KEY
	jr z,open_square_lock
	dec a	; ITEM_ROUND_KEY
	jr z,open_round_lock
	dec a	; ITEM_CROSS_KEY
	jr z,open_cross_lock
	dec a	; ITEM_MAP_KEY
	jr z,open_map_lock
;	dec a	; ITEM_BIBLE_KEY
;	jr z,open_bible_lock
;	ret

open_bible_lock:
	ld a,(15 + 4*16)*2
	ld iyl,COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK
	jr open_lock_moving_1_tile_up

open_map_lock:
	ld a,(11 + 4*16)*2
	ld iyl,COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK
	jr open_lock_moving_1_tile_up

open_cross_lock:
	ld a,(12 + 4*16)*2
	ld iyl,COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK
	jr open_lock_moving_1_tile_up
	ret

open_square_lock:
;	ld a,(0 + 0*16)*2
	xor a
	ld iyl,COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK+COLLISION_BOTTOM_LEFT_MASK+COLLISION_BOTTOM_RIGHT_MASK
	jr open_lock_moving_1_tile_up


open_triangle_lock:
	ld a,(4 + 1*16)*2
	ld iyl,COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK
	jr open_lock_moving_1_tile_up


open_round_lock:
	ld a,(15 + 0*16)*2
	ld iyl,COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK

open_lock_moving_1_tile_up:
	; move the column up:
	ld d,current_map_fg/256
	ld e,a
	ld h,current_map_fg/256
	add a,16*2
	ld l,a
	ldi
	ldi
	ld e,a
	add a,16*2
	ld l,a
	ldi
	ldi
	; clear the space below:
	ld l,a
	ld (hl),0
	inc hl
	ld (hl),0

	; clear the space below:
	ld h,current_map_bg/256
	sub 16*2
	ld l,a
	ld (hl),tiles/256
	inc hl
	ld (hl),tiles%256	

	; fix the collision mask:
	add a,16*2
	srl a
	ld h,map_collision_mask/256
	ld l,a
	set 7,l	; map_collision_mask is 128 off
	ld (hl),0
	sub 16
	ld l,a
	set 7,l	; map_collision_mask is 128 off
	ld c,iyl
	ld (hl),c

	; redraw the changed tiles:
	ld h,dirty_tiles/256
	sub 16
	ld l,a
	ld a,2
	ld de,16
	ld (hl),a
	add hl,de
	ld (hl),a
	add hl,de
	ld (hl),a
	ret


open_gate_lock:
	; move the column up:
	ld de,current_map_fg + (11 + 1*16)*2
	ld hl,current_map_fg + (11 + 3*16)*2
	ldi
	ldi
	ld e,(11 + 2*16)*2
	ld l,(11 + 4*16)*2
	ldi
	ldi
	ld e,(11 + 3*16)*2
	ld l,(11 + 5*16)*2
	ldi
	ldi
	ld e,(11 + 4*16)*2
	ld l,(11 + 6*16)*2
	ldi
	ldi
	; clear the space below:
	xor a
	ld (current_map_fg + (11 + 5*16)*2),a
	ld (current_map_fg + (11 + 5*16)*2+1),a
	ld (current_map_fg + (11 + 6*16)*2),a
	ld (current_map_fg + (11 + 6*16)*2+1),a
	; add a background to the newly created gap:
	ld hl,current_map_bg + (11 + 4*16)*2
	ld (hl),tiles/256
	inc hl
	ld (hl),tiles%256
	ld l,(11 + 5*16)*2
	ld (hl),tiles/256
	inc hl
	ld (hl),tiles%256
	; fix the collision mask:
	ld (map_collision_mask + 11 + 6*16),a
	ld (map_collision_mask + 11 + 5*16),a
	ld hl,map_collision_mask + 11 + 4*16
	ld (hl),COLLISION_TOP_LEFT_MASK+COLLISION_TOP_RIGHT_MASK
	; redraw the changed tiles:
	ld a,2
	ld hl,dirty_tiles + 11 + 1*16
	ld de,16
	ld b,6
open_gate_lock_dirty_loop:	
	ld (hl),a
	add hl,de
	djnz open_gate_lock_dirty_loop
	ret



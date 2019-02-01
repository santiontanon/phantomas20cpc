; ------------------------------------------------ 
; marks all the castle maps as unvisited
mark_all_maps_unvisited:
    ld hl,castle_map
    ld b,end_of_castle_catacombs_maps-castle_map
mark_all_maps_unvisited_loop:
    ld a,(hl)
    and #7f
    ld (hl),a
    inc hl
    djnz mark_all_maps_unvisited_loop
    ret


; ------------------------------------------------ 
; decompresses the map currently pointed to by "current_map_ptr", and makes it ready for use in-game:
load_current_map:
    ld hl,loading_map
    ld (hl),1

    ; decompress and encode the map:
    ld hl,(current_map_ptr)
    ld a,(hl)

    ; check if we have visited it, and mark it (increasing score if not)
    bit 7,a
    jr nz,load_current_map_already_visited

    ; mark the room as visited
    or #80
    ld (hl),a

    ld hl,(player_score)
    ld bc,NEW_ROOM_SCORE
    add hl,bc
    ld (player_score),hl    

load_current_map_already_visited:
    and #7f ; remove the flag that marks if we have visited it or not
    push af
    and #fc
    srl a
    ld b,0
    ld c,a
    ld hl,map_group_pointers-2  ; -2 since the groups start numbered in 1 (so that 0 means no map)
    add hl,bc
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl    ; hl now has the pointer of the map group to decompress
    ld de,map_decompression_buffer
    call decompress
    pop af

    and #03 ; a now has the index of the map to decompress within the group
    ld hl,map_decompression_buffer
    ld bc,128
    or a
load_current_map_find_map_in_group_loop:
    jr z,load_current_map_find_map_in_group_loop_done
    add hl,bc
    dec a
    jr load_current_map_find_map_in_group_loop
    ; we now have hl pointing at the background of the map to load
load_current_map_find_map_in_group_loop_done:

    call generate_current_map_table
    call calculate_map_collision_mask

    ; clear the enemy sprite table:
    ld hl,enemy_sprites
    ld (next_enemy_sprite_ptr),hl
    ld hl,enemy_sprite_types
    ld de,enemy_sprite_types+1    
    xor a
    ld (hl),a
    ld bc,MAX_DIFFERENT_ENEMY_TYPES*3-1
    ldir

    ; decode the items:
    ; skip the items/enemies of the previous maps in the group
    ld hl,(current_map_ptr)
    ld a,(hl)
    and #03  ; a now has the index of the map to decompress within the group

    ld hl,map_decompression_buffer+256*MAPS_PER_GROUP
    or a
load_current_map_items_map_in_group_loop:
    jr z,load_current_map_items_map_in_group_found
    push af
    ld b,0
    ld c,(hl)   ; n items
    inc hl
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    ld c,(hl)   ; n enemies
    inc hl
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    pop af
    dec a
    jr load_current_map_items_map_in_group_loop

load_current_map_items_map_in_group_found:
    ld a,(hl)   ; n items
    inc hl
    ld (n_items),a
    or a
    jr z,items_loaded
    push hl
    push af
    ld hl,items_compressed
    ld de,enemy_sprites    ; decompress them temporarily
    call decompress
    pop af
    pop hl
    ld de,items
load_map_items_loop:    
    push de
    pop ix
    ldi
    ldi
    ldi
    ldi

    ; copy 64 bytes from    enemy_sprites + item_type*64    to    item_sprites + item_sprite*64
    push hl
    push de
    push af    
    ld a,(ix)
    cp ITEM_FOOD1
    jp m,load_map_items_loop_no_food
    bit 0,a
    jr z,load_map_items_loop_food2
    ld a,ITEM_FOOD1
    jr load_map_items_loop_no_food
load_map_items_loop_food2:
    ld a,ITEM_FOOD2
load_map_items_loop_no_food:

    dec a   ; items start at 1
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,enemy_sprites
    add hl,bc
    ld de,item_sprites
    ld a,(ix+3)
    or a
    jr z,load_map_items_loop_load_item_in_sprite0
    ld de,item_sprites+64
load_map_items_loop_load_item_in_sprite0:
    ld bc,64
    ldir
    pop af
    pop de
    pop hl

    dec a
    jr nz,load_map_items_loop
items_loaded:

    ; decode the enemies:
    ld de,enemies
    ld a,(hl)
    inc hl
    ld (n_enemies),a
    or a
load_map_enemies_loop:    
    jp z,enemies_loaded
    push af
    ldi ; state 0
    ldi ; lower movement bound
    ldi ; upper movement bound
    ld a,(hl)
    ldi ; x
    ld b,0
    ld c,a
    sra c       ; bc = x/2
    ld a,(hl)
    inc hl
    ld (de),a   ; y (we don't use ldi, for not messing up with BC)
    inc de
    
    push hl   
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
    ld a,l
    ld (de),a
    inc de
    ld a,h
    ld (de),a
    inc de
    pop hl

    ld a,(hl)     ; enemy type:
    ld iyl,a
    ld c,1        ; if c == 1 later on, we will not load the enemy sprites
    inc hl
    push hl

    ; find a place to store it:
    ; - DE now points to the place where we need to store that pointer
    ; 1) look to see if we have it already loaded:
    ld ix,enemy_sprite_types
    ld b,MAX_DIFFERENT_ENEMY_TYPES
load_map_enemies_find_type_loop:
    ld a,(ix)
    or a
    jr z,load_map_enemies_load_type ; we haven't found it
    cp iyl
    jr z,load_map_enemies_found ; found!
    inc ix
    inc ix
    inc ix
    djnz load_map_enemies_find_type_loop
    ; we should never reach here!

load_map_enemies_load_type:
    ld hl,(next_enemy_sprite_ptr)
    ld a,iyl
    ld (ix),a ; enemy type
    ld (ix+1),l
    ld (ix+2),h
    ld c,0    ; indicate that we need to load the enemy sprites
    
load_map_enemies_found:
    ld a,(ix+1)
    ld (de),a
    inc de
    ld a,(ix+2)
    ld (de),a
    inc de

    ; now we just need to set the animation type, and if c == 0 load the sprites
    push hl
    push bc
    ld hl,enemy_load_data_bat
    ld b,0
    ld c,iyl   ; iyl has the enemy type
    dec c
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    push hl
    pop iy  ; iy = enemy_load_data_bat_vertical + enemy_type*5
    pop bc
    pop hl

    ld a,(iy)
    ld (de),a
    ld a,c
    or a
    ; if 0, we need to load the sprite!
    jr nz,load_map_enemy_done
    push de
    ex de,hl
    ld l,(iy+1)
    ld h,(iy+2)
    ld a,(iy+3)
    ld (load_map_enemy_generic_to_modify+1),a
    ld a,(iy+4)
    ld (load_map_enemy_generic_to_modify+2),a
load_map_enemy_generic_to_modify:
    call #ffff  ; self-modifying code
    pop de

load_map_enemy_done:
    inc de
    pop hl
    pop af
    dec a
    jp load_map_enemies_loop
enemies_loaded:
    ld hl,(player_score)    ; this functions can artificially increase player score (since it reopens windows, etc.), so, we store/restore it
    push hl
    call check_fallingblocks_switches_and_windows
    call check_items_after_loading_map
    call render_items_to_foreground
    pop hl
    ld (player_score),hl    ; this functions can artificially increase player score (since it reopens windows, etc.), so, we store/restore it
    ld hl,loading_map
    ld (hl),0    
    ret


enemy_load_data_bat:
    db ENEMY_ANIMATION_STYLE_VAMPIRE
    dw vampire_compressed
    dw load_vampire_sprites
enemy_load_data_bat_vertical:
    db ENEMY_ANIMATION_STYLE_VAMPIRE_VERTICAL
    dw vampire_compressed
    dw load_vampire_sprites
enemy_load_data_spider:
    db ENEMY_ANIMATION_STYLE_VAMPIRE
    dw spider_compressed
    dw load_spider_sprites
enemy_load_data_arrow_left_right:
    db ENEMY_ANIMATION_STYLE_ARROW
    dw arrow_compressed
    dw load_arrow_sprites
enemy_load_data_barrel:
    db ENEMY_ANIMATION_STYLE_BARREL
    dw barrel_compressed
    dw load_barrel_sprites
enemy_load_data_trap:
    db ENEMY_ANIMATION_STYLE_TRAP
    dw trap_compressed
    dw load_trap_sprites
enemy_load_data_skull:
    db ENEMY_ANIMATION_STYLE_VAMPIRE
    dw skull_compressed
    dw load_skull_sprites
load_map_enemy_fire:
    db ENEMY_ANIMATION_STYLE_FIRE
    dw fire_compressed
    dw load_fire_sprites
load_map_enemy_bubble:
    db ENEMY_ANIMATION_STYLE_BUBBLE
    dw bubble_compressed
    dw load_bubble_sprites
load_map_enemy_cross:
    db ENEMY_ANIMATION_STYLE_BUBBLE
    dw cross_compressed
    dw load_cross_sprites
load_map_enemy_star:
    db ENEMY_ANIMATION_STYLE_STAR
    dw star_compressed
    dw load_star_sprites
load_map_enemy_franken:
    db ENEMY_ANIMATION_STYLE_VAMPIRE
    dw franken_compressed
    dw load_franken_sprites
load_map_enemy_platform:
    db ENEMY_ANIMATION_STYLE_PLATFORM
    dw movingplatform_compressed
    dw load_movingplatform_sprites
enemy_load_data_static_trap:
    db ENEMY_ANIMATION_STYLE_TRAP
    dw trap_compressed
    dw load_static_trap_sprites
enemy_load_data_ghost:
    db ENEMY_ANIMATION_STYLE_TRAP
    dw ghost_compressed
    dw load_ghost_sprites
enemy_load_data_arrow_down:
    db ENEMY_ANIMATION_STYLE_ARROW
    dw arrows_down_compressed
    dw load_arrows_down_sprites    
load_map_enemy_laser_vertical:
    db ENEMY_ANIMATION_STYLE_LASER
    dw laser_vertical_compressed
    dw load_laser_sprites
load_map_enemy_laser_horizontal:
    db ENEMY_ANIMATION_STYLE_LASER
    dw laser_horizontal_compressed
    dw load_laser_sprites
load_map_enemy_switch:
    db ENEMY_ANIMATION_STYLE_SWITCH
    dw button_pressed_compressed
    dw load_switch_sprites
load_map_enemy_spikeball:
    db ENEMY_ANIMATION_STYLE_NONE
    dw spikeball_compressed
    dw load_spikeball_sprites
load_map_enemy_brickwall:
    db ENEMY_ANIMATION_STYLE_NONE
    dw brickwall_compressed
    dw load_brickwall_sprites
;load_map_enemy_bullet:
;    db ENEMY_ANIMATION_STYLE_NONE
;    dw bullet_compressed
;    dw load_bullet_sprites
load_map_enemy_redskull:
    db ENEMY_ANIMATION_STYLE_NONE
    dw redskull_compressed
    dw load_redskull_sprites
load_map_enemy_generator:
    db ENEMY_ANIMATION_STYLE_NONE
    dw generator_compressed
    dw load_generator_sprites


; ------------------------------------------------
; - Compiles the current map from "background" and "foreground" into "current_map" for efficient rendering
; - Decompresses the necessary tiles on to the "tiles" buffer
; - hl points at the map withing the group to load
generate_current_map_table:
    ; make a copy of the map fg, so that we can calculate the collision mask later (since this function is destructive)
;    ld hl,map_decompression_buffer
;    push hl
;        ld de,enemy_sprites + 16*64
;        ld bc,128
;        ldir
;    pop hl
    push hl
        ld bc,128*MAPS_PER_GROUP
        add hl,bc
        ld de,enemy_sprites + 16*64
        ld bc,128
        ldir

        ; clear the current map:
        xor a
        ld hl,current_map_bg
        ld de,current_map_bg+1
        ld (hl),a
        ld bc,16*8*2*2-1
        ldir

        ld hl,tiles
        ld (next_tile_ptr),hl
    pop ix

    ld a,2  ; we loop twice, once for the background, and one for the foreground
    ld hl,current_map_bg
generate_current_map_table_fg_bg_loop:
    push af
    push ix
    ld b,16*8  ; map size
generate_current_map_table_loop:
    ld a,(ix)
    or a
    call nz,generate_current_map_table_fill_tile_address
;    jr nz,generate_current_map_table_fill_tile_address
;generate_current_map_table_fill_tile_address_done:
    inc hl
    inc hl
    inc ix
    djnz generate_current_map_table_loop

    pop ix
    pop af
    ld bc,128*MAPS_PER_GROUP
    add ix,bc
    dec a
    jr nz,generate_current_map_table_fg_bg_loop
    ret

generate_current_map_table_fill_tile_address:
    dec a   ; since tile 0 is "no tile"
    push bc
    push ix
    push hl
    ; get the appropriate tile bank, and decompress it
    and #f0
    ld iyh,a
    srl a
    srl a
    srl a
    ld hl,tiles_compressed_ptr_tbl
    ADD_HL_A    ; hl = (tiles_compressed_ptr_tbl+2*(a>>4))
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld de,enemy_sprites
    push iy
    call decompress  ; we now have the appropriate tile bank, decompressed in enemy_sprites
    pop iy

    ; clear 32 bytes after the map copy (to be used as a temporary buffer for tile addresses)
    xor a
    ld hl,enemy_sprites + 16*64 + 256
    ld de,enemy_sprites + 16*64 + 256 + 1
    ld (hl),a
    ld bc,31
    ldir

    pop hl
    pop ix
    pop bc

    push bc
    push ix
    push hl
generate_current_map_table_fill_tile_address_loop
    ld a,(ix)
    or a    ; empty tile
    jr z,generate_current_map_table_fill_tile_address_loop_no_copy
    dec a
    ld e,a
    and #f0
    cp iyh  ; tile in the currently decompressed bank
    jr nz,generate_current_map_table_fill_tile_address_loop_no_copy
    ld a,e  ; e still has the tile #
    and #0f
    ld d,0
    ld e,a
    push hl
        ld hl,enemy_sprites + 16*64 + 256
        add hl,de
        add hl,de   ; hl = pointer to the tile pointer buffer
        ld a,(hl)
        or a
        jr nz,generate_current_map_table_fill_tile_address_loop_already_copied_tile

        push hl
            ; it's a new tile, get the pointer to it
            ld h,0
            ld l,e  ; e still has the tile # % 16
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            add hl,hl
            ld de,enemy_sprites
            add hl,de   ; hl points to the tile we want

            push bc
            ; copy it to the next available free tile:
            ld de,(next_tile_ptr)
            push de
            ld bc,64
            ldir
            ld (next_tile_ptr),de
            pop de  ; we recover the pointer to the beginning of the tile
            pop bc
        pop hl

        ld (hl),d
        inc hl
        ld (hl),e ; we store the new ptr in the ptr buffer
        jr generate_current_map_table_fill_tile_address_loop_already_copied_tile_have_ptr

generate_current_map_table_fill_tile_address_loop_already_copied_tile:
        ld d,(hl)
        inc hl
        ld e,(hl) ; de has the pointer to the tile now
generate_current_map_table_fill_tile_address_loop_already_copied_tile_have_ptr:
    pop hl
    ld (hl),d
    inc hl
    ld (hl),e
    inc hl
    ld (ix),0
    inc ix
    djnz generate_current_map_table_fill_tile_address_loop
    jr generate_current_map_table_fill_tile_address_loop_done
generate_current_map_table_fill_tile_address_loop_no_copy:
    inc hl
    inc hl
    inc ix
    djnz generate_current_map_table_fill_tile_address_loop

generate_current_map_table_fill_tile_address_loop_done:
    pop hl
    pop ix
    pop bc
    ;jp generate_current_map_table_fill_tile_address_done
    ret


; ------------------------------------------------
; Draws the current map to the double buffer
draw_current_map:
    ld ixl,8  ; map height
    ld bc,current_map_bg
    ld de,double_buffer
draw_current_map_loop_y:
    ld ixh,16  ; map width
draw_current_map_loop_x:
    push de
    call draw_current_map_draw_tile_bg
    pop de
    dec c  ; backtrack the advances made while drawing the bg
    dec c
    inc b   ; jump to fg
    push de
    call draw_current_map_draw_tile_fg
    pop de  ; move back to bg
    dec b
    inc e   ; we only need to incremenr e, since double_buffer is 64 aligned
    inc e
    inc e
    inc e
    dec ixh
    jr nz,draw_current_map_loop_x   
    ld e,double_buffer%256  ; this can be done since double_buffer is 64 aligned, and from one row to the next, we add 1024
    ld a,4
    add a,d
    ld d,a
    dec ixl
    jr nz,draw_current_map_loop_y
    ret

draw_current_map_draw_tile_bg:
    ld a,(bc)
    inc c
    or a
    jr z,draw_current_map_loop_no_bg
    ld h,a
    ld a,(bc)
    ld l,a      ; hl = bg tile address
    push bc
    call draw_sprite
    pop bc
draw_current_map_loop_no_bg:  
    inc c
    ret

draw_current_map_draw_tile_fg:
    ld a,(bc)
    inc c
    or a
    jr z,draw_current_map_loop_no_fg
    ld h,a
    ld a,(bc)  
    ld l,a      ; hl = fg tile address
    push bc
    call draw_sprite_0_transparent
    pop bc
draw_current_map_loop_no_fg:    
    inc c
    ret


; ------------------------------------------------
; Draws all the dirty background tiles from this and the previous iteration on the double buffer
; - uses the ghost registers
restore_background_dirty_tiles:
    ld hl,dirty_tiles

    ld ixl,8
    exx
        ld de,double_buffer
        ld bc,current_map_bg
    exx
restore_background_dirty_tiles_loop_y:
    ld ixh,16
restore_background_dirty_tiles_loop_x:
    ; draw if dirty tile has counter equal to current frame or previous:
    ld a,(hl)
    or a
    jr nz,restore_background_dirty_tiles_redraw
    exx
        inc c  ; update the pointer to the current_map (256-aligned)
        inc c
restore_background_dirty_tiles_redraw_done:
        inc e  ; update the double_buffer pointer
        inc e  ; we only need to incremenr e, since double_buffer is 64 aligned
        inc e
        inc e
    exx
    inc hl
    dec ixh
    jr nz,restore_background_dirty_tiles_loop_x
    exx
        ld e,double_buffer%256  ; this can be done since double_buffer is 64 aligned, and from one row to the next, we add 1024
        ld a,4
        add a,d
        ld d,a
    exx
    dec ixl
    jr nz,restore_background_dirty_tiles_loop_y
    ret

 restore_background_dirty_tiles_redraw:
    exx
        push de
        call draw_current_map_draw_tile_bg
        pop de
        jr restore_background_dirty_tiles_redraw_done


; ------------------------------------------------
; Draws all the dirty foreground tiles from this and the previous iteration on the double buffer
; - uses the ghost registers
restore_foreground_dirty_tiles_256px:
    ld hl,dirty_tiles

    ld c,8
    exx
        ld de,double_buffer
        ld bc,current_map_fg 
        ld hl,VIDEO_MEMORY+VIDEO_MEM_OFFSET         ; video memory where the game screen starts
    exx
restore_foreground_dirty_tiles_loop_y:
    ld b,16
restore_foreground_dirty_tiles_loop_x:
    ; draw if dirty tile has counter equal to current frame or previous:
    ld a,(hl)
    or a
    jr nz,restore_foreground_dirty_tiles_redraw
    exx
        inc c  ; update the pointer to the current_map  (256-aligned)
        inc c
restore_foreground_dirty_tiles_redraw_done:
        inc e  ; update the double_buffer pointer
        inc e  ; we only need to incremenr e, since double_buffer is 64 aligned
        inc e
        inc e
        inc hl  ; video memory pointer
        inc hl
        inc hl
        inc hl
    exx
    inc hl
    djnz restore_foreground_dirty_tiles_loop_x
    exx
        ld a,d
        ld de,VIDEO_MEM_OFFSET+SCREEN_WIDTH_IN_BYTES_256px
        add hl,de
        ld e,double_buffer%256  ; this can be done since double_buffer is 64 aligned, and from one row to the next, we add 1024
        add a,4
        ld d,a
    exx
    dec c
    jr nz,restore_foreground_dirty_tiles_loop_y
    ret

 restore_foreground_dirty_tiles_redraw:
    dec (hl)
    exx
        push hl
        push de
        call draw_current_map_draw_tile_fg
        pop de
        pop hl

        ; copy the resulting tile to video memory:
        push hl
        push de
        push bc
        ex de,hl
        call copy_tile_from_double_buffer_to_video_memory_256px
        pop bc
        pop de
        pop hl

        jr restore_foreground_dirty_tiles_redraw_done

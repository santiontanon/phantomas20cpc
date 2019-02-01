; ------------------------------------------------
; Determines collision, given the coordinates of the player or an enemy
; input:
; - c: x coordinate (in pixels)
; - b: y coordinate (in pixels)
; output:
; - nz flag (I know, I know, "nz" is not a flag)

sprite_collision_with_map:
	inc b
	call point_collision_with_map
	ret nz
	inc c
	inc c
	inc c
	call point_collision_with_map
	ret nz
	inc c
	inc c
	inc c
	call point_collision_with_map
	ret nz
	ld a,c
	sub 6
	ld c,a

	ld a,7
	add a,b
	ld b,a
thin_sprite_collision_with_map:
sprite_collision_with_map_thin_entry_point:
	call point_collision_with_map
	ret nz
	inc c
	inc c
	inc c
	call point_collision_with_map
	ret nz
	inc c
	inc c
	inc c
	call point_collision_with_map
	ret nz
	ld a,c
	sub 6
	ld c,a

	ld a,7
	add a,b
	ld b,a
	call point_collision_with_map
	ret nz
	inc c
	inc c
	inc c
	call point_collision_with_map
	ret nz
	inc c
	inc c
	inc c
;	jr point_collision_with_map	;; no point for this call/ret, since it's the function right below


; ------------------------------------------------
; Determines collision, given the coordinates of a point
; input:
; - c: x coordinate (in pixels)
; - b: y coordinate (in pixels)
; output:
; - nz flag
point_collision_with_map:
	; 1) calculate the collision mask pointer
	ld a,b
    or a
    jp m,point_collision_with_map_collision
	cp 128
    jp p,point_collision_with_map_collision
	and #f0	; we need to divide by 16 and then multiply by 16, so, we just clear the lower bits
	ld l,a
	ld a,c
    or a
    jp m,point_collision_with_map_collision
	cp 128
    jp p,point_collision_with_map_collision
	srl a
	srl a
	srl a
	add a,l
	or #80	;	map_collision_mask starts at a xx80 address
	ld h,map_collision_mask/256
	ld l,a	; hl now has a pointer to the proper top-left collision mask cell

	; 2) calculate the collision mask for the tile in the map
	bit 2,c
	jr nz,point_collision_with_map_right
point_collision_with_map_left:
	bit 3,b
	jr nz,point_collision_with_map_left_down
point_collision_with_map_left_up:
	ld a,COLLISION_TOP_LEFT_MASK
	jr point_collision_with_map_mask_done
point_collision_with_map_left_down:
	ld a,COLLISION_BOTTOM_LEFT_MASK
	jr point_collision_with_map_mask_done
point_collision_with_map_right:
	bit 3,b
	jr nz,point_collision_with_map_right_down
point_collision_with_map_right_up:
	ld a,COLLISION_TOP_RIGHT_MASK
	jr point_collision_with_map_mask_done
point_collision_with_map_right_down:
	ld a,COLLISION_BOTTOM_RIGHT_MASK
point_collision_with_map_mask_done:

	; 3) check collision!
	and (hl)
	ret
point_collision_with_map_collision:
	or 1	; set the nz flag
	ret


; ------------------------------------------------
; calculates the collision mask for the whole current map and puts it into 'map_collision_mask'
calculate_map_collision_mask:
	ld ix,enemy_sprites + 16*64	; pointer to copy of the actual tile IDs made by generate_current_map_table
	ld hl,current_map_fg	; we only care about the fg_pointers
	ld de,map_collision_mask
	ld b,16*8
calculate_map_collision_mask_loop:
	push de
	ld d,(hl)
	inc l	; current_map_fg is 256 aligned, so, only l needs to be increased
	ld e,(hl)
	inc l
	ld a,(ix)
	cp FIRST_COLLIDABLE_FOREGROUND_TILE_INDEX
	jr c,calculate_map_collision_mask_loop_no_tile
;	call generate_tile_collision_mask
	GENERATE_TILE_COLLISION_MASK_FAST
	ld a,c
calculate_map_collision_mask_loop_set_tile:
	pop de
	ld (de),a
	inc e	; map_collision_mask is 128 aligned
	inc ix
	djnz calculate_map_collision_mask_loop
	ret
calculate_map_collision_mask_loop_no_tile:
	xor a
	jr calculate_map_collision_mask_loop_set_tile

; ------------------------------------------------
; given a 8x16 tile, this function calculates it's collision mask
; input:
; - de: pointer to the tile
; output:
; - c: collision mask
;generate_tile_collision_mask:
; since this is only ever called from one place, I turn it into a MACRO, to save the "call/ret" time and space

; The fast version only checks bytes: 12, 13, 14, 15, 56 and 59
GENERATE_TILE_COLLISION_MASK_FAST: MACRO 
    ld c,0	; temporary mask
    ld a,e
 	add a,12
 	ld e,a
    ld a,(de)
    or a
    jr z,generate_tile_collision_mask_no_collision1
    set COLLISION_TOP_LEFT_BIT,c
generate_tile_collision_mask_no_collision1:
	inc e
    ld a,(de)
    or a
    jr z,generate_tile_collision_mask_no_collision1a
    set COLLISION_TOP_LEFT_BIT,c
generate_tile_collision_mask_no_collision1a:
	inc e
    ld a,(de)
    or a
    jr z,generate_tile_collision_mask_no_collision2a
    set COLLISION_TOP_RIGHT_BIT,c
generate_tile_collision_mask_no_collision2a:
	inc e
    ld a,(de)
    or a
    jr z,generate_tile_collision_mask_no_collision2
    set COLLISION_TOP_RIGHT_BIT,c
generate_tile_collision_mask_no_collision2:
    ld a,e
 	add a,41
 	ld e,a
    ld a,(de)
    or a
    jr z,generate_tile_collision_mask_no_collision3
    set COLLISION_BOTTOM_LEFT_BIT,c
generate_tile_collision_mask_no_collision3:
	inc e
	inc e
	inc e
    ld a,(de)
    or a
    jr z,generate_tile_collision_mask_no_collision4
    set COLLISION_BOTTOM_RIGHT_BIT,c
generate_tile_collision_mask_no_collision4:
	ENDM



;GENERATE_TILE_COLLISION_MASK: MACRO 
;    xor a
;    ld c,0	; temporary mask
;generate_tile_collision_mask_loop:
;    push af
;    ld a,(de)
;    inc e	; we only need to increment "e", since tiles are 64-aligned
;    or a
;    jr z,generate_tile_collision_mask_no_collision
;    pop af
;    bit 1,a
;    jr z,generate_tile_collision_mask_left
;generate_tile_collision_mask_right:
;    bit 5,a
;    jr z,generate_tile_collision_mask_right_up
;generate_tile_collision_mask_right_down:
;	set COLLISION_BOTTOM_RIGHT_BIT,c
;	jr generate_tile_collision_mask_no_collision_no_pop
;generate_tile_collision_mask_right_up:
;	set COLLISION_TOP_RIGHT_BIT,c
;	jr generate_tile_collision_mask_no_collision_no_pop
;generate_tile_collision_mask_left:
;    bit 5,a
;    jr z,generate_tile_collision_mask_left_up
;generate_tile_collision_mask_left_down:
;	set COLLISION_BOTTOM_LEFT_BIT,c
;	jr generate_tile_collision_mask_no_collision_no_pop
;generate_tile_collision_mask_left_up:
;	set COLLISION_TOP_LEFT_BIT,c
;    jr generate_tile_collision_mask_no_collision_no_pop
;generate_tile_collision_mask_no_collision:
;    pop af
;generate_tile_collision_mask_no_collision_no_pop:
;    inc a
;    cp 64
;    jr nz,generate_tile_collision_mask_loop
;generate_tile_collision_mask_done:
;    ret
;	ENDM

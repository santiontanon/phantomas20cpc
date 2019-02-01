; This file is auto-generated to automatically optimize the use of the unused video memory space:


move_stuff_to_unused_video_memory:
    ld hl, map_group_0
    ld de, 52848
    ld (map_group_pointers+0*2), de
    ld bc, 309
    ldir

    ld hl, map_group_1
    ld de, 54896
    ld (map_group_pointers+1*2), de
    ld bc, 327
    ldir

    ld hl, map_group_11
    ld de, 63040
    ld (map_group_pointers+11*2), de
    ld bc, 205
    ldir

    ld hl, map_group_12
    ld de, 50778
    ld (map_group_pointers+12*2), de
    ld bc, 410
    ldir

    ld hl, map_group_13
    ld de, 59008
    ld (map_group_pointers+13*2), de
    ld bc, 376
    ldir

    ld hl, map_group_15
    ld de, 56924
    ld (map_group_pointers+15*2), de
    ld bc, 267
    ldir

    ld hl, map_group_16
    ld de, 60992
    ld (map_group_pointers+16*2), de
    ld bc, 402
    ldir

    ld hl, map_group_17
    ld de, 65088
    ld (map_group_pointers+17*2), de
    ld bc, 421
    ldir

    ld hl, map_group_21
    ld de, 53157
    ld (map_group_pointers+21*2), de
    ld bc, 85
    ldir

    ret

move_stuff_back_from_unused_video_memory:
    ld hl, 52848
    ld de, map_group_0
    ld (map_group_pointers+0*2), de
    ld bc, 309
    ldir

    ld hl, 54896
    ld de, map_group_1
    ld (map_group_pointers+1*2), de
    ld bc, 327
    ldir

    ld hl, 63040
    ld de, map_group_11
    ld (map_group_pointers+11*2), de
    ld bc, 205
    ldir

    ld hl, 50778
    ld de, map_group_12
    ld (map_group_pointers+12*2), de
    ld bc, 410
    ldir

    ld hl, 59008
    ld de, map_group_13
    ld (map_group_pointers+13*2), de
    ld bc, 376
    ldir

    ld hl, 56924
    ld de, map_group_15
    ld (map_group_pointers+15*2), de
    ld bc, 267
    ldir

    ld hl, 60992
    ld de, map_group_16
    ld (map_group_pointers+16*2), de
    ld bc, 402
    ldir

    ld hl, 65088
    ld de, map_group_17
    ld (map_group_pointers+17*2), de
    ld bc, 421
    ldir

    ld hl, 53157
    ld de, map_group_21
    ld (map_group_pointers+21*2), de
    ld bc, 85
    ldir

    ret

; addresses of the unused video memory areas:
video_mem_unused_area0:   equ 50752
video_mem_unused_area1:   equ 52800
video_mem_unused_area2:   equ 54848
video_mem_unused_area3:   equ 56896
video_mem_unused_area4:   equ 58944
video_mem_unused_area5:   equ 60992
video_mem_unused_area6:   equ 63040
video_mem_unused_area7:   equ 65088
; groups not assigned to any unused video memory space:
map_group_10:
    incbin "map/map-group10.plt"
map_group_14:
    incbin "map/map-group14.plt"
map_group_18:
    incbin "map/map-group18.plt"
map_group_19:
    incbin "map/map-group19.plt"
map_group_2:
    incbin "map/map-group2.plt"
map_group_20:
    incbin "map/map-group20.plt"
map_group_3:
    incbin "map/map-group3.plt"
map_group_4:
    incbin "map/map-group4.plt"
map_group_5:
    incbin "map/map-group5.plt"
map_group_6:
    incbin "map/map-group6.plt"
map_group_7:
    incbin "map/map-group7.plt"
map_group_8:
    incbin "map/map-group8.plt"
map_group_9:
    incbin "map/map-group9.plt"
first_usable_RAM_space_during_gameplay:
; groups assigned to some unused video memory space:
map_group_0:
    incbin "map/map-group0.plt"
map_group_1:
    incbin "map/map-group1.plt"
map_group_11:
    incbin "map/map-group11.plt"
map_group_12:
    incbin "map/map-group12.plt"
map_group_13:
    incbin "map/map-group13.plt"
map_group_15:
    incbin "map/map-group15.plt"
map_group_16:
    incbin "map/map-group16.plt"
map_group_17:
    incbin "map/map-group17.plt"
map_group_21:
    incbin "map/map-group21.plt"

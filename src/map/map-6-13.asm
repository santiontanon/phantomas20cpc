    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#00,#00,#49,#49,#49,#49,#49,#49,#49,#01,#01
    db #01,#31,#01,#31,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#49,#01,#01,#49,#01,#49,#31,#49,#01,#01,#01,#01,#01,#01,#01
    db #01,#31,#01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#49,#49
    db #49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#31,#01,#01,#49,#49,#49
    db #49,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#49,#01,#49,#49
    db #49,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#31,#01,#31,#31
    db #31,#31,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #80,#80,#80,#b5,#80,#80,#db,#7b,#b6,#db,#80,#b6,#db,#bd,#7b,#b5
    db #bd,#00,#00,#00,#62,#62,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #bd,#5f,#7d,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#bd
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#b6,#00,#00,#db,#80,#b6,#db,#b6,#b6,#80,#80,#b6,#db,#db,#80
    include "map-6-13-enemies.asm"

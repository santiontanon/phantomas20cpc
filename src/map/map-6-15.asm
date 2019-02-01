    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#01,#01,#01,#01,#01
    db #01,#31,#31,#01,#49,#01,#01,#49,#01,#01,#01,#01,#01,#01,#31,#31
    db #31,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#31,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01
    db #01,#01,#01,#01,#31,#01,#01,#01,#01,#01,#01,#31,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#49,#49
    db #49,#31,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#49
    db #49,#49,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #bd,#7b,#80,#db,#7b,#b5,#b6,#7b,#80,#db,#b5,#00,#00,#00,#db,#bd
    db #db,#00,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80,#00,#80
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80,#00,#00,#00
    db #b5,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80,#00,#00,#00,#80
    db #80,#80,#00,#00,#00,#00,#00,#00,#00,#5f,#80,#00,#00,#00,#80,#bd
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #b5,#00,#00,#00,#00,#00,#00,#00,#00,#00,#c1,#dd,#c2,#c3,#c4,#b5
    db #80,#db,#80,#7b,#b6,#b5,#7b,#80,#7b,#b6,#7b,#db,#b6,#db,#7b,#80
    include "map-6-15-enemies.asm"

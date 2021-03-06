    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#49,#49,#49,#49,#49,#49,#49,#49,#01,#01,#01,#01,#01,#01,#01
    db #01,#49,#31,#01,#01,#31,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#31,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#31,#01,#01,#01,#01,#01,#01,#01
    db #01,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #bd,#00,#00,#00,#7b,#b6,#db,#7b,#7b,#7b,#7b,#b6,#b6,#db,#7b,#bd
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#7b,#80,#b6,#db,#80,#b6,#db,#b6,#7b,#7b,#7b,#7b,#00,#00,#b5
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#bd
    db #00,#00,#00,#00,#00,#00,#00,#00,#b6,#db,#b6,#80,#db,#80,#7b,#80
    db #80,#00,#00,#00,#00,#00,#80,#00,#00,#00,#00,#00,#00,#00,#00,#bd
    db #80,#80,#00,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#7b,#80,#b6,#db,#80,#b6,#db,#b6,#80,#db,#80,#7b,#db,#db,#80
    include "map-5-11-enemies.asm"

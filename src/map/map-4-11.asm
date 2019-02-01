    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49
    db #49,#01,#01,#49,#49,#01,#01,#49,#31,#01,#49,#01,#01,#01,#49,#49
    db #49,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01,#49,#49
    db #01,#01,#01,#31,#31,#01,#01,#49,#01,#01,#49,#49,#49,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#49,#49,#49
; size in bytes: 128
foreground:
    db #bd,#80,#80,#b5,#7b,#b6,#db,#7b,#80,#db,#7b,#b6,#b6,#db,#80,#80
    db #80,#62,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#62,#80
    db #00,#00,#00,#00,#80,#7b,#00,#00,#00,#00,#b6,#80,#00,#00,#00,#b5
    db #00,#00,#00,#00,#80,#00,#00,#00,#00,#00,#00,#b5,#bd,#00,#00,#00
    db #bd,#00,#00,#80,#b5,#00,#00,#00,#00,#00,#00,#00,#80,#00,#00,#00
    db #80,#00,#00,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#b5,#80,#00,#80
    db #b5,#63,#80,#61,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80,#63,#b5
    db #80,#80,#80,#b6,#db,#80,#b6,#db,#b6,#80,#db,#80,#7b,#db,#db,#80
    include "map-4-11-enemies.asm"

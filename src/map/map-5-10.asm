    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49,#49
    db #49,#49,#49,#01,#31,#31,#01,#49,#01,#01,#49,#01,#01,#01,#31,#01
    db #01,#31,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#31,#31,#31,#31,#31,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#31,#01,#01,#01,#01,#49,#01,#01
    db #01,#01,#01,#49,#49,#49,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#31,#31,#31,#31,#31,#31,#31,#31,#31,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #bd,#80,#80,#b5,#7b,#80,#db,#7b,#b6,#db,#7b,#b6,#b6,#db,#7b,#bd
    db #80,#00,#b5,#00,#00,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #80,#61,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#db,#b6,#bd,#b6,#00,#7b,#db,#bd
    db #00,#00,#00,#00,#00,#00,#00,#5f,#00,#00,#00,#00,#00,#00,#70,#80
    db #bd,#db,#bd,#7b,#db,#bd,#b6,#00,#00,#00,#00,#00,#00,#60,#00,#bd
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#00,#00,#00,#db,#80,#b6,#db,#b6,#80,#db,#80,#7b,#db,#db,#80
    include "map-5-10-enemies.asm"
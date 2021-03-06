    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#49,#49,#49,#49,#49,#01,#01,#01,#01,#01,#49,#49
    db #49,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#31,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#49,#01,#01,#31,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#31,#01,#49,#01,#01,#01,#49,#49,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #bd,#80,#80,#b5,#7b,#b6,#db,#7b,#b5,#00,#00,#7b,#b6,#db,#7b,#bd
    db #80,#00,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00,#80
    db #80,#61,#00,#00,#7d,#5f,#5f,#5f,#5f,#5f,#5f,#5a,#00,#00,#00,#b5
    db #80,#00,#00,#00,#7d,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #80,#00,#00,#00,#00,#00,#59,#61,#00,#70,#59,#00,#00,#00,#00,#00
    db #bd,#00,#00,#00,#00,#5a,#00,#00,#00,#00,#00,#5a,#00,#00,#00,#59
    db #80,#61,#00,#70,#5c,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#00,#5b
    db #80,#b6,#db,#80,#5a,#b5,#b6,#db,#00,#00,#b6,#db,#5a,#5b,#5a,#5b
    include "map-2-10-enemies.asm"

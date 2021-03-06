    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#01,#01,#01,#01,#01,#49,#49,#49,#49,#49,#49,#49,#49,#49
    db #01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#49,#49,#49,#49,#49,#01,#49,#01,#01,#01
    db #01,#01,#01,#49,#49,#49,#49,#01,#01,#49,#01,#01,#01,#01,#49,#49
    db #49,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #80,#db,#00,#00,#5a,#5c,#80,#7b,#5e,#b6,#db,#5a,#5b,#5a,#5b,#bd
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #00,#00,#7d,#5f,#00,#00,#00,#00,#00,#00,#00,#80,#db,#bd,#00,#b5
    db #00,#00,#7d,#00,#5f,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #00,#7d,#00,#00,#00,#80,#7b,#b6,#db,#bd,#00,#00,#00,#00,#00,#bd
    db #00,#7d,#00,#7b,#db,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #59,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#b5
    db #5b,#59,#59,#59,#59,#59,#59,#80,#7b,#5e,#b6,#00,#00,#00,#5a,#5b
    include "map-6-14-enemies.asm"

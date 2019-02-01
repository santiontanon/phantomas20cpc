    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01,#05,#01,#05,#01,#01
    db #01,#01,#49,#01,#01,#01,#01,#49,#01,#01,#01,#01,#05,#01,#05,#05
    db #05,#01,#01,#01,#01,#01,#01,#31,#01,#01,#01,#01,#01,#05,#01,#01
    db #01,#49,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01,#01,#01,#05,#05
    db #05,#01,#49,#01,#01,#01,#01,#01,#49,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#31,#49,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #b5,#80,#b6,#00,#00,#80,#db,#7b,#b6,#db,#80,#5e,#5a,#5a,#5a,#5d
    db #bd,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#b5,#00,#00,#00,#00,#5a
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5b
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5a
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #bd,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#bd
    db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80
    db #80,#b6,#db,#b5,#db,#80,#b6,#db,#7b,#b6,#80,#80,#b6,#db,#db,#80
    include "map-7-12-enemies.asm"

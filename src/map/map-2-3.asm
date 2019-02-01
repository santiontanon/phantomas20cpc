    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#06,#06,#05,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#05,#05,#26,#26,#05,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#06,#06,#1a,#08,#1a,#1a,#05,#01,#01,#01
    db #01,#01,#01,#01,#01,#05,#05,#01,#1b,#01,#1b,#01,#01,#05,#01,#01
    db #01,#01,#01,#01,#06,#06,#05,#01,#1b,#01,#1b,#05,#01,#01,#05,#01
    db #01,#01,#01,#05,#05,#01,#01,#01,#1b,#01,#1b,#01,#01,#05,#05,#01
    db #01,#01,#01,#05,#05,#05,#05,#05,#05,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#5d,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#5c,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#5c,#00,#00,#00,#5c,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#5c,#00,#00,#00,#00,#00,#5c,#00,#00,#00
    db #00,#00,#00,#00,#00,#5c,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#00
    db #00,#00,#00,#00,#5c,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00
    db #00,#00,#00,#00,#5a,#59,#5b,#59,#59,#00,#00,#5e,#59,#59,#5b,#00
    include "map-2-3-enemies.asm"

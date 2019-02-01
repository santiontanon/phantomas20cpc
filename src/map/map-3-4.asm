    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#05,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#05,#05
    db #05,#05,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#05,#05
    db #05,#05,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#05,#05
    db #05,#05,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#05,#05
    db #05,#05,#05,#01,#01,#01,#05,#01,#01,#01,#05,#01,#01,#01,#05,#01
    db #01,#01,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05
    db #05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05
    db #05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05,#05
; size in bytes: 128
foreground:
    db #5d,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5a
    db #5a,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c
    db #5c,#61,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5a
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#59,#59,#00,#5c
    db #59,#59,#00,#00,#59,#59,#00,#00,#59,#59,#00,#00,#5a,#5b,#00,#00
    db #5e,#dc,#00,#00,#5e,#dc,#00,#00,#5e,#dc,#00,#00,#5e,#dc,#00,#00
    db #5c,#5c,#59,#59,#5c,#5c,#59,#59,#5c,#5c,#59,#59,#5c,#5c,#59,#59
    db #5a,#5b,#5a,#5b,#5a,#5b,#5a,#5b,#5a,#5a,#5b,#5b,#5a,#5a,#5b,#5b
    include "map-3-4-enemies.asm"

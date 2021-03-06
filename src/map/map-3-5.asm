    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#02,#05,#05,#05,#05,#05,#05,#05,#05,#05,#02,#02,#05,#05
    db #05,#02,#07,#07,#02,#02,#02,#05,#02,#05,#05,#02,#1a,#02,#07,#07
    db #05,#07,#02,#02,#02,#02,#02,#02,#02,#05,#05,#07,#1b,#07,#05,#05
    db #05,#02,#02,#02,#07,#05,#05,#05,#05,#05,#05,#02,#1b,#02,#05,#05
    db #05,#02,#02,#02,#02,#05,#05,#1a,#08,#1a,#05,#07,#1b,#02,#05,#05
    db #05,#05,#05,#05,#05,#05,#05,#1b,#02,#1b,#05,#05,#05,#05,#05,#05
    db #05,#05,#05,#05,#05,#05,#05,#05,#05,#1b,#1b,#1b,#1b,#1b,#1b,#1b
; size in bytes: 128
foreground:
    db #5d,#5a,#5b,#5a,#5b,#5d,#5a,#5b,#5d,#5b,#5a,#5d,#5a,#5b,#5c,#5d
    db #5a,#5b,#b9,#00,#b8,#5a,#5b,#5a,#5b,#5a,#5a,#5b,#00,#00,#67,#5a
    db #60,#00,#b7,#a0,#ba,#34,#35,#36,#00,#34,#35,#36,#00,#68,#69,#5a
    db #00,#00,#00,#00,#00,#00,#39,#00,#00,#00,#39,#00,#00,#6a,#6b,#5a
    db #59,#00,#00,#00,#00,#00,#3b,#59,#59,#59,#3b,#00,#00,#00,#6e,#5a
    db #5b,#00,#00,#5f,#5f,#00,#3b,#00,#00,#00,#3b,#00,#00,#00,#6f,#5a
    db #5b,#00,#00,#00,#00,#00,#3a,#00,#00,#00,#3a,#00,#59,#59,#5c,#5a
    db #60,#59,#59,#59,#59,#59,#59,#00,#00,#00,#59,#59,#5a,#5b,#5b,#60
    include "map-3-5-enemies.asm"

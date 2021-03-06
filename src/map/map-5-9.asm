    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02
    db #02,#05,#02,#05,#03,#06,#0c,#10,#02,#04,#10,#02,#04,#10,#05,#05
    db #05,#05,#03,#06,#0c,#02,#04,#08,#1a,#1d,#08,#1a,#1d,#08,#1a,#1a
    db #03,#06,#0c,#04,#10,#02,#1d,#02,#02,#07,#02,#1b,#07,#07,#1b,#1b
    db #1d,#08,#1a,#1d,#08,#1a,#05,#05,#1b,#05,#02,#1b,#05,#05,#1b,#1b
    db #1b,#1b,#1b,#05,#02,#1b,#05,#02,#1b,#05,#05,#1b,#05,#07,#1b,#1b
    db #1b,#1b,#1b,#1b,#1b,#1b,#05,#05,#1b,#05,#05,#1b,#05,#05,#1b,#1b
    db #1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b
; size in bytes: 128
foreground:
    db #5d,#5a,#5a,#5b,#5d,#00,#00,#5d,#5a,#5b,#5a,#5b,#5a,#5b,#5a,#5d
    db #dc,#00,#00,#00,#00,#5f,#00,#62,#00,#62,#00,#62,#00,#00,#00,#5e
    db #5c,#61,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#67,#00,#5a
    db #00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00,#00,#68,#69,#00,#59
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#6a,#6b,#00,#5e
    db #59,#59,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#6e,#00,#5a
    db #5d,#5a,#5b,#59,#59,#00,#00,#00,#00,#00,#00,#63,#00,#6f,#00,#5d
    db #5a,#5b,#5d,#5a,#59,#59,#59,#5d,#59,#59,#59,#5e,#dc,#5d,#5a,#5b
    include "map-5-9-enemies.asm"

    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#00,#00,#00,#05,#05,#05,#05,#05,#05,#05,#05
    db #05,#10,#07,#04,#10,#07,#05,#01,#01,#01,#03,#06,#0c,#05,#05,#05
    db #05,#08,#1a,#1d,#08,#1a,#01,#01,#01,#01,#07,#07,#01,#07,#07,#05
    db #05,#01,#1b,#1b,#1b,#1b,#03,#06,#0c,#07,#01,#01,#01,#01,#05,#16
    db #16,#05,#1b,#1b,#1b,#1b,#01,#01,#07,#05,#01,#01,#01,#05,#16,#30
    db #01,#01,#1b,#07,#07,#1b,#05,#05,#01,#01,#01,#01,#05,#16,#30,#30
    db #01,#05,#1b,#01,#01,#1b,#01,#01,#01,#01,#01,#05,#16,#30,#30,#30
    db #30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#05,#16,#30,#30,#30,#30
; size in bytes: 128
foreground:
    db #5d,#5b,#5c,#5b,#5a,#5e,#dc,#5c,#00,#00,#5d,#5b,#5b,#5a,#5b,#5d
    db #5c,#00,#00,#00,#00,#3c,#00,#00,#00,#5f,#00,#3c,#00,#00,#00,#5c
    db #5a,#3e,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#70,#59,#00
    db #5c,#00,#00,#b1,#b2,#00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00
    db #5b,#00,#00,#b3,#b4,#61,#00,#00,#00,#00,#00,#70,#59,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00,#00,#00,#00
    db #5c,#5a,#5b,#5c,#59,#59,#5e,#dc,#59,#59,#00,#00,#00,#00,#00,#00
    include "map-6-7-enemies.asm"

    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #30,#30,#30,#30,#30,#14,#30,#30,#30,#30,#30,#30,#30,#01,#07,#07
    db #14,#30,#30,#14,#30,#15,#14,#14,#30,#30,#30,#30,#30,#01,#01,#01
    db #15,#14,#30,#15,#30,#09,#15,#15,#14,#14,#30,#30,#30,#01,#01,#05
    db #01,#15,#14,#09,#12,#01,#01,#09,#15,#15,#14,#14,#14,#14,#01,#01
    db #12,#0b,#09,#0b,#01,#09,#01,#01,#01,#01,#13,#15,#15,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#09,#01,#12,#01,#09,#01,#01,#01,#07,#07
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#00,#5e
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#5a,#5d
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5e,#dc,#00,#59
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00,#5c
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#00,#5c
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#5c,#00,#00,#5a
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#5a,#5b,#5c,#5a,#5b,#5e
    include "map-1-7-enemies.asm"
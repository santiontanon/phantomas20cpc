    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #01,#01,#0a,#09,#0b,#0a,#17,#0b,#0a,#01,#17,#01,#0a,#09,#0b,#0a
    db #01,#17,#0a,#17,#11,#0a,#11,#09,#0a,#17,#0a,#0b,#0a,#17,#11,#0a
    db #01,#11,#0a,#11,#09,#0a,#01,#01,#0a,#17,#0a,#17,#0a,#11,#09,#0a
    db #01,#0b,#0a,#0b,#17,#12,#13,#01,#0b,#11,#0a,#11,#0a,#0a,#17,#12
    db #01,#01,#0a,#01,#01,#01,#01,#09,#01,#01,#0a,#01,#0a,#01,#01,#09
    db #01,#01,#0a,#0b,#12,#13,#01,#01,#01,#01,#0b,#12,#0a,#0b,#12,#13
    db #4b,#48,#0d,#48,#0e,#0d,#0b,#12,#01,#01,#01,#01,#09,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
; size in bytes: 128
foreground:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #61,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#5c,#00,#00
    db #00,#00,#00,#00,#00,#5c,#5c,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#59,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #71,#72,#5b,#71,#72,#71,#5b,#5c,#00,#00,#59,#dc,#5a,#5b,#5e,#dc
    include "map-0-8-enemies.asm"

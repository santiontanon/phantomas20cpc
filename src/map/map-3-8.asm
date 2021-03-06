    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#05,#05,#05,#05,#05,#05
    db #10,#05,#05,#10,#05,#05,#10,#05,#05,#05,#05,#03,#06,#0c,#0c,#0c
    db #08,#1a,#1a,#08,#1a,#1a,#07,#1a,#1a,#03,#06,#06,#04,#10,#10,#10
    db #07,#1b,#05,#07,#1b,#05,#07,#1b,#06,#0c,#02,#07,#1d,#08,#1a,#05
    db #05,#1b,#02,#02,#1b,#03,#06,#0c,#02,#02,#02,#02,#05,#07,#1b,#05
    db #05,#1b,#02,#02,#02,#02,#02,#02,#02,#1d,#08,#1a,#05,#07,#1b,#1b
    db #1b,#1b,#05,#05,#05,#05,#05,#05,#05,#05,#05,#1b,#05,#05,#1b,#1b
    db #1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b,#1b
; size in bytes: 128
foreground:
    db #5a,#5b,#5d,#5a,#5b,#5d,#5a,#5b,#5d,#5c,#00,#00,#5e,#dc,#5a,#5b
    db #00,#34,#35,#36,#34,#35,#36,#34,#35,#36,#00,#00,#40,#3f,#5c,#5d
    db #00,#00,#39,#00,#00,#39,#00,#00,#39,#00,#00,#59,#00,#00,#5e,#dc
    db #00,#00,#3b,#00,#00,#3b,#00,#00,#3b,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#3b,#00,#00,#3a,#00,#00,#3b,#59,#59,#81,#82,#83,#00,#00
    db #59,#00,#3b,#00,#59,#5d,#59,#00,#3a,#00,#00,#84,#85,#86,#00,#59
    db #5c,#00,#3a,#00,#5c,#5e,#dc,#59,#59,#59,#59,#87,#88,#89,#00,#5d
    db #5d,#59,#59,#59,#5a,#5b,#5a,#5b,#5a,#5b,#5a,#5b,#5a,#5b,#59,#5a
    include "map-3-8-enemies.asm"

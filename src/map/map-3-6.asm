    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#00,#00,#05,#05,#05,#05,#05,#05,#05,#05,#05
    db #05,#05,#05,#05,#05,#05,#05,#03,#06,#06,#05,#05,#05,#05,#05,#05
    db #05,#02,#02,#07,#02,#03,#06,#0c,#02,#05,#07,#02,#02,#02,#07,#07
    db #07,#07,#07,#03,#06,#0c,#02,#02,#02,#05,#02,#07,#07,#07,#05,#05
    db #05,#03,#06,#0c,#07,#07,#05,#05,#05,#05,#05,#07,#02,#02,#05,#05
    db #06,#0c,#02,#02,#02,#02,#05,#02,#05,#05,#05,#07,#02,#02,#05,#05
    db #02,#05,#05,#05,#05,#02,#05,#05,#05,#02,#05,#05,#05,#05,#02,#02
    db #02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02
; size in bytes: 128
foreground:
    db #5d,#5a,#5b,#5a,#5b,#5d,#5c,#00,#00,#00,#5d,#5b,#5a,#5b,#5c,#5d
    db #5a,#5b,#5a,#5b,#5b,#5c,#00,#00,#00,#5c,#5f,#5a,#5b,#5b,#5f,#5a
    db #5b,#34,#35,#36,#00,#00,#00,#00,#00,#62,#00,#34,#35,#36,#70,#5a
    db #5b,#00,#39,#00,#00,#00,#00,#59,#00,#00,#00,#00,#39,#00,#00,#5a
    db #60,#00,#3b,#00,#00,#00,#00,#00,#00,#00,#00,#00,#3b,#00,#00,#5a
    db #00,#00,#3b,#00,#59,#59,#00,#00,#00,#59,#59,#00,#3b,#00,#00,#5a
    db #00,#00,#3a,#00,#00,#00,#00,#00,#00,#00,#00,#00,#3a,#00,#70,#60
    db #59,#59,#59,#59,#59,#59,#59,#5d,#59,#59,#59,#59,#59,#59,#59,#59
    include "map-3-6-enemies.asm"

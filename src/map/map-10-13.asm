    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#14
    db #14,#14,#30,#30,#30,#30,#30,#30,#30,#30,#14,#30,#30,#14,#30,#15
    db #15,#15,#14,#14,#30,#30,#14,#30,#30,#14,#15,#14,#30,#15,#30,#09
    db #01,#09,#15,#15,#14,#14,#15,#14,#14,#15,#01,#15,#14,#09,#12,#01
    db #01,#01,#01,#01,#13,#15,#01,#15,#01,#01,#12,#0b,#09,#0b,#01,#01
    db #09,#01,#12,#01,#09,#01,#01,#01,#01,#0b,#01,#01,#01,#01,#01,#01
    db #4b,#48,#0e,#0d,#4a,#48,#4b,#0e,#4b,#48,#0e,#0d,#4a,#4b,#0d,#0e
    db #0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e,#0e
; size in bytes: 128
foreground:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #71,#72,#71,#72,#71,#71,#72,#71,#71,#71,#72,#71,#71,#71,#72,#72
    include "map-10-13-enemies.asm"

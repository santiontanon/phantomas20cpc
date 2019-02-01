    include "../constants.asm"
    org #0000
; size in bytes: 128
background:
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#49,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01
    db #01,#16,#16,#16,#16,#16,#16,#16,#16,#16,#16,#16,#16,#16,#16,#16
    db #16,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30
; size in bytes: 128
foreground:
    db #5b,#80,#bd,#b6,#bd,#b6,#80,#bd,#db,#b6,#b6,#bd,#b6,#7b,#db,#7b
    db #5b,#00,#00,#00,#00,#00,#b5,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #5b,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#70,#59,#00
    db #60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#72,#71,#72,#71,#71
    db #60,#00,#00,#00,#00,#00,#00,#00,#72,#71,#71,#00,#00,#00,#00,#00
    db #60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #5b,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    db #60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    include "map-9-11-enemies.asm"

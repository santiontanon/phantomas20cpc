;-----------------------------------------------
; pletter v0.5c msx unpacker
; call unpack with "hl" pointing to some pletter5 data, and "de" pointing to the destination.
; changes all registers

GETBIT:  MACRO 
    add a,a
    call z,pletter_getbit
    ENDM

GETBITEXX:  MACRO 
    add a,a
    call z,pletter_getbitexx
    ENDM

decompress:
pletter_unpack:
    ld a,(hl)
    inc hl
    exx
    ld de,0
    add a,a
    inc a
    rl e
    add a,a
    rl e
    add a,a
    rl e
    rl e
    ld hl,pletter_modes
    add hl,de
    ld e,(hl)
    ld ixl,e
    inc hl
    ld e,(hl)
    ld ixh,e
    ld e,1
    exx
    ld iy,pletter_loop
pletter_literal:
    ldi
pletter_loop:
    GETBIT
    jr nc,pletter_literal
    exx
    ld h,d
    ld l,e
pletter_getlen:
    GETBITEXX
    jr nc,pletter_lenok
pletter_lus:
    GETBITEXX
    adc hl,hl
    ret c
    GETBITEXX
    jr nc,pletter_lenok
    GETBITEXX
    adc hl,hl
    ret c
    GETBITEXX
    jp c,pletter_lus
pletter_lenok:
    inc hl
    exx
    ld c,(hl)
    inc hl
    ld b,0
    bit 7,c
    jp z,pletter_offsok
    jp ix

pletter_mode6:
    GETBIT
    rl b
pletter_mode5:
    GETBIT
    rl b
pletter_mode4:
    GETBIT
    rl b
pletter_mode3:
    GETBIT
    rl b
pletter_mode2:
    GETBIT
    rl b
    GETBIT
    jr nc,pletter_offsok
    or a
    inc b
    res 7,c
pletter_offsok:
    inc bc
    push hl
    exx
    push hl
    exx
    ld l,e
    ld h,d
    sbc hl,bc
    pop bc
    ldir
    pop hl
    jp iy

pletter_getbit:
    ld a,(hl)
    inc hl
    rla
    ret

pletter_getbitexx:
    exx
    ld a,(hl)
    inc hl
    exx
    rla
    ret

pletter_modes:
    dw pletter_offsok
    dw pletter_mode2
    dw pletter_mode3
    dw pletter_mode4
    dw pletter_mode5
    dw pletter_mode6

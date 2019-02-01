; possible keyboard rows: #40, #41, #42, #43, #44, #45, #46, #47, #48, #49

; Fixed keys:
;	db #45,	#7f 	; SPACE	; bit 7
;	db #48,	#f7 	; Q		; bit 3
;	db #48,	#fb 	; ESC	; bit 2
;	db #48,	#fd 	; 2		; bit 1
;	db #48,	#fe 	; 1		; bit 0

; scancodes of the keys to play the game (can be changed via key redefinition):
redefined_keys:
   db #44, #fb     ; O
   db #43, #f7     ; P
   db #48, #f7     ; Q


;-----------------------------------------------
; systematically scans the keyboard matrix until it finds one key pressed, and returns which key it was
; output:
; - e: keyboard matrix port
; - a: mask
find_pressed_key:
    ld e,#40
    ld a,e
find_pressed_key_loop:
    call read_keyboard_line
    cp #ff
    ret nz
    inc e
    ld a,e
    cp #4a
    jr nz,find_pressed_key_loop
    xor a
    ret


;-----------------------------------------------
; updates the 'keyboard_state' and 'keyboard_press' buffers
update_keyboard_buffers:
    ld a,#48    ; read Q, ESC, 2, 1:
    call read_keyboard_line
    or #f0  ; isolate Q, ESC, 2, 1
    ld e,a

    ld a,#45    ; read SPACE
    call read_keyboard_line
    or #7f  ; isolate SPACE
    and e	; we now have SPACE, Q ESC, 2 and 1
    ld e,a

update_keyboard_buffers_redefined_keys:
    ; read redefined keys:
    ld hl,redefined_keys
    ld a,(hl)
    inc hl
    call read_keyboard_line
    or (hl)
    inc hl
    cp #ff
    jr z,update_keyboard_buffers_key2
    res KEYBOARD_LEFT_BIT,e
update_keyboard_buffers_key2:
    ld a,(hl)
    inc hl
    call read_keyboard_line
    or (hl)
    inc hl
    cp #ff
    jr z,update_keyboard_buffers_key3
    res KEYBOARD_RIGHT_BIT,e
update_keyboard_buffers_key3:
    ld a,(hl)
    inc hl
    call read_keyboard_line
    or (hl)
    cp #ff
    jr z,update_keyboard_buffers_keys_done
    res KEYBOARD_UP_BIT,e
update_keyboard_buffers_keys_done:

update_keyboard_get_joystick_input:
    ; &49   DEL Joy 1 Fire 3 (CPC only) Joy 1 Fire 2    Joy1 Fire 1 Joy1 right  Joy1 left   Joy1 down   Joy1 up
    ld a,#49    ; read joystick status
    call read_keyboard_line
    bit 0,a     ; up
    jr nz,update_keyboard_get_joystick_input_no_up
    res KEYBOARD_UP_BIT,e
update_keyboard_get_joystick_input_no_up:
    bit 4,a     ; button 1
    jr nz,update_keyboard_get_joystick_input_no_button1
    res KEYBOARD_UP_BIT,e
update_keyboard_get_joystick_input_no_button1:
    bit 2,a     ; left
    jr nz,update_keyboard_get_joystick_input_no_left
    res KEYBOARD_LEFT_BIT,e
update_keyboard_get_joystick_input_no_left:
    bit 3,a     ; right
    jr nz,update_keyboard_get_joystick_input_no_right
    res KEYBOARD_RIGHT_BIT,e
update_keyboard_get_joystick_input_no_right:
	ld a,e

update_keyboard_buffers2:
    ld b,a	; this instruction is a bit wasteful, but it's so that we can later call update_keyboard_buffers2 easily
    ld hl,keyboard_state
    ld c,(hl)
    ld (hl),a
    dec hl
    xor c   ; we now have the bits that changed
    cpl 
    or b    ; only those that were just pressed (0), are kept
    ld (hl),a
    ret


; This is for the main menu, where "o" is used to enter the options menu
update_keyboard_buffers_o_instead_of_1:
    ld a,#48    ; read Q, ESC, 2:
    call read_keyboard_line
    or #f1  ; isolate Q, ESC, 2
    ld e,a

    ld a,#45    ; read SPACE
    call read_keyboard_line
    or #7f  ; isolate SPACE
    and e   ; we now have SPACE, Q ESC, 2 and 1
    ld e,a

    ; read 0
    ld a,#44
    call read_keyboard_line
    or #fb
    cp #ff
    jr z,update_keyboard_buffers_redefined_keys
    res KEYBOARD_1_BIT,e
    jr update_keyboard_buffers_redefined_keys



;-----------------------------------------------
; Reads a keyboard row
; code from: http://www.cpcwiki.eu/index.php/Programming:Keyboard_scanning
; input:
; - a: keyboard line
read_keyboard_line:
    di
    ld d,0
    ld bc,#f782 ; PPI port A out /C out 
    out (c),c 
    ld bc,#F40E ; Select Ay reg 14 on ppi port A 
    out (c),c 
    ld bc,#F6C0 ; This value is an AY index (R14) 
    out (c),c 
    out (c),d   ; Validate!! out (c),0
    ld bc,#F792 ; PPI port A in/C out 
    out (c),c 
    dec b 
    out (c),a   ; Send KbdLine on reg 14 AY through ppi port A
    ld b,#F4    ; Read ppi port A 
    IN a,(c)    ; e.g. AY R14 (AY port A) 
    ld bc,#F782 ; PPI port A out / C out 
    out (c),c 
    dec b       ; Reset PPI Write 
    out (c),d   ; out (c),0
    ei
    ret

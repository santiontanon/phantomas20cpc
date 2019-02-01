start_of_sound_code:

;-----------------------------------------------
Instrument_profiles:
SquareWave_instrument_profile:
    db 12
Piano_instrument_profile:
    db 12,11,10,10,9,9,8,8,7,7,6,#ff
;Wind_instrument_profile:
;    db 0,3,6,8,10,11,12, #ff

; This is the complete note table:
;note_period_table:
;  db 7,119,  7,12,  6,167,  6,71,  5,237,  5,152,  5,71,  4,252,  4,180,  4,112,  4,49,  3,244
;  db 3,188,  3,134,  3,83,  3,36,  2,246,  2,204,  2,164,  2,126,  2,90,  2,56,  2,24,  1,250  
;  db 1,222,  1,195,  1,170,  1,146,  1,123,  1,102,  1,82,  1,63,  1,45,  1,28,  1,12,  0,253
;  db 0,239,  0,225,  0,213,  0,201,  0,190,  0,179,  0,169,  0,159,  0,150,  0,142,  0,134,  0,127
;  db 0,119,  0,113,  0,106,  0,100,  0,95,  0,89,  0,84,  0,80,  0,75,  0,71,  0,67,  0,63

; reduced note table, only with the notes used by the songs we use for the game:
;note_period_table:
;  db 6,71,  5,237,  5,152,  4,180,  4,112,  3,244,  3,83,  2,246
;  db 2,204,  2,164,  2,126,  2,90,  2,56,  2,24,  1,250,  1,222
;  db 1,170,  1,146,  1,123,  1,102,  1,82,  1,63,  1,45,  1,28
;  db 1,12,  0,253,  0,239,  0,225,  0,213,  0,201,  0,190,  0,179
;  db 0,169,  0,159,  0,150,  0,142,  0,134,  0,127,  0,119,  0,113
;  db 0,106,  0,100,  0,95,  0,89,  0,84,  0,80,  0,75

note_period_table:
  db 6,71,  5,237,  5,152,  5,71,  4,252,  4,180,  4,112,  4,49
  db 3,244,  3,188,  3,134,  3,83,  3,36,  2,246,  2,204,  2,164
  db 2,126,  2,90,  2,56,  2,24,  1,250,  1,222,  1,195,  1,170
  db 1,146,  1,123,  1,102,  1,82,  1,63,  1,45,  1,28,  1,12
  db 0,253,  0,239,  0,225,  0,213,  0,201,  0,190,  0,179,  0,169
  db 0,159,  0,150,  0,142,  0,134,  0,127,  0,119,  0,113,  0,106
  db 0,100,  0,95,  0,89,  0,84,  0,80,  0,75


;-----------------------------------------------
; starts playing a song 
; arguments: 
; - a: Music_tempo
play_song:
    ld (Music_tempo),a
    call StopPlayingMusic
    di
    ld a,1
    ld hl,music_buffer
    ld (MUSIC_play),a
    ld (MUSIC_pointer),hl
    ld (MUSIC_start_pointer),hl
    ld hl,MUSIC_repeat_stack
    ld (MUSIC_repeat_stack_ptr),hl
    ei
    ret


;-----------------------------------------------
StopPlayingMusic:
    di
    ld hl,beginning_of_sound_variables_except_tempo
    ld b,end_of_sound_variables - beginning_of_sound_variables_except_tempo
    xor a
StopPlayingMusic_loop:
    ld (hl),a
    inc hl
    djnz StopPlayingMusic_loop
    call clear_PSG_volume
    ei
    ret


;-----------------------------------------------
clear_PSG_volume:
    xor a
    ld c,8
    call WRTPSG_CPC
    ld c,9
    call WRTPSG_CPC
    ld c,10
;    jr WRTPSG_CPC   ; no point on jumping, since the function is right below!


;-----------------------------------------------
;; adapted source code from: http://www.cpcwiki.eu/index.php/How_to_access_the_PSG_via_PPI
;; entry conditions:
;; C = register number
;; A = register data
;; assumptions:
;; PPI port A and PPI port C are setup in output mode.
WRTPSG_CPC:
    ld b,#f4            ; setup PSG register number on PPI port A
    out (c),c           ;
    ld bc,#f6c0         ; Tell PSG to select register from data on PPI port A
    out (c),c           ;
    ld bc,#f600         ; Put PSG into inactive state.
    out (c),c           ;
    ld b,#f4            ; setup register data on PPI port A
    out (c),a           ;
    ld bc,#f680         ; Tell PSG to write data on PPI port A into selected register
    out (c),c           ;
    ld bc,#f600         ; Put PSG into inactive state
    out (c),c           ;
    ret


;-----------------------------------------------
; Music player update routine
update_sound:     ; This routine sould be called 50 or 60 times / sec 
    push af  

    ld a,(MUSIC_play)
    or a
    jr z,update_sound_no_music_no_pop_bc_de
    push de
    push bc
    call update_sound_handle_instruments

    ld a,(MUSIC_tempo_counter)
    or a
    jr nz,update_sound_skip
    push ix
    push hl
    ld ix,(MUSIC_repeat_stack_ptr)
    xor a
    ld (MUSIC_time_step_required),a
    ld hl,(MUSIC_pointer)
    call update_sound_internal
    ld (MUSIC_pointer),hl
    ld (MUSIC_repeat_stack_ptr),ix
    pop hl
    pop ix
    ld a,(Music_tempo)
    ld (MUSIC_tempo_counter),a
    jr update_sound_music_done
update_sound_skip:
    dec a
    ld (MUSIC_tempo_counter),a

update_sound_music_done:
    pop bc
    pop de
update_sound_no_music_no_pop_bc_de:
    push bc
    ld a,(SFX_procedural_playing)
    cp SFX_PRIORITY_JUMP
    jp z,SFX_procedural_jump
    cp SFX_PRIORITY_FALL
    jp z,SFX_procedural_fall  
    cp SFX_PRIORITY_WALK
    jp z,SFX_procedural_walk
update_sound_after_original_procedural_sounds:
    ld a,(SFX_priority)
    or a
    jr z,update_sound_no_SFX_pop_BC
    push hl
    push de
    xor a
    ld (MUSIC_time_step_required),a
    ld hl,(SFX_pointer)
    call update_sound_internal
    ld (SFX_pointer),hl
    pop de
    pop hl

update_sound_no_SFX_pop_BC:
    pop bc
    pop af
    ret


;-----------------------------------------------
; Starts playing an SFX
; arguments: 
; - a: SFX priority
; - hl: pointer to the SFX to play
play_SFX_with_priority:
    push hl
    ld l,a
    ld a,(sound_mode)
    or a
    ld a,l
    jr z,play_SFX_with_priority_2.0

play_SFX_with_priority_original:
    ; in original mode, there is no SFX priority, they all get played
    pop hl
    di
    ld (SFX_pointer),hl
    ld (SFX_priority),a
    xor a
    ld (MUSIC_instruments+2),a  ;; reset the instrument in channel 3 to Square wave, so it does not interfere with the SFX
    ei
    ret

play_SFX_with_priority_2.0:
    ld hl,SFX_priority
    cp (hl)
    pop hl
    ret m
    di
    ld (SFX_pointer),hl
    ld (SFX_priority),a
    xor a
    ld (MUSIC_instruments+2),a  ;; reset the instrument in channel 3 to Square wave, so it does not interfere with the SFX
    ei
    ret


; ------------------------------------------------
; starts the SFX for jumping with a frequency depending on the y coordinate of the player
play_jump_SFX:
    ld a,(sound_mode)
    or a
    jr nz,play_jump_SFX_original

play_jump_SFX_2.0:
    ld a,(SFX_priority)
    cp SFX_PRIORITY_HIGH
    ret p   ; if there is another SFX playing with higher priority...
    di
    ld hl,SFX_jump
    ld (SFX_pointer),hl
    ld a,SFX_PRIORITY_HIGH
    ld (SFX_priority),a
    xor a
    ld (MUSIC_instruments+2),a  ;; reset the instrument in channel 3 to Square wave, so it does not interfere with the SFX
    ei
    ret

play_jump_SFX_original:
    ld a,(player_y)
;    ld hl,160
    ld hl,128
    ld b,0
    ld c,a
    add hl,bc
    di
    ld (SFX_jump_start_period),hl
    ld a,SFX_PRIORITY_JUMP
    ld (SFX_procedural_playing),a
    xor a
    ld (SFX_jump_timer),a
    ei
    ret


play_fall_SFX:
    ld a,(sound_mode)
    or a
    ret z
play_fall_SFX_original:
    ld a,(player_y)
;    ld hl,180
    ld hl,144
    ld b,0
    ld c,a
    add hl,bc
    di
    ld (SFX_jump_start_period),hl
    ld a,SFX_PRIORITY_FALL
    ld (SFX_procedural_playing),a
    xor a
    ld (SFX_jump_timer),a
    ei
    ret


play_walk_SFX:
    ld a,(sound_mode)
    or a
    ret z
play_walk_SFX_original:
    ld a,(SFX_procedural_playing)
    cp SFX_PRIORITY_FALL
    ret z
    di
    ld a,SFX_PRIORITY_WALK
    ld (SFX_procedural_playing),a
    xor a
    ld (SFX_jump_timer),a
    ei
    ret


;-----------------------------------------------
; generates the procedural jump SFX, playing over channel 2
; - modifies bc and a
procedural_jump_period_change_tbl:
;    db -6, -5, +6, +6 ,-5, -5, -5, +6
    db -6, -6, +6, +6 ,-6, -6, -6, +6
SFX_procedural_jump:
  ld a,(loading_map)
  or a
  jp z,SFX_procedural_jump_continue ; if we are in between screens, do not play the sfx
  ld c,9
  ld a,0
  call WRTPSG_CPC
  jp update_sound_after_original_procedural_sounds
SFX_procedural_jump_continue:
  ld a,(player_state)
  srl a
  cp PLAYER_STATE_JUMPING_RIGHT/2
  jp z,SFX_procedural_jump_still_jumping
SFX_procedural_jump_stopped_jumping:
;  call update_sound_SFX_END
  xor a
  ld (SFX_procedural_playing),a
  ld c,9
;  ld a,#00
SFX_procedural_jump_stopped_jumping2:
  call WRTPSG_CPC
  jp update_sound_after_original_procedural_sounds
SFX_procedural_jump_still_jumping: 
;  ld c,7
;  ld a,#38
;  call WRTPSG_CPC
  ld c,9
  ld a,#0c
  call WRTPSG_CPC
  push hl
  ld hl,SFX_jump_timer
  ld a,(hl)
  inc (hl)
  and #07
  ld hl,procedural_jump_period_change_tbl
  ld b,0
  ld c,a
  add hl,bc
  ld a,(hl) ; we know how much we need to modify the period
  ld c,a
  add a,a
  sbc a,a
  ld b,a    ; we sign extend "a" into "bc"
  ld hl,(SFX_jump_start_period)
  add hl,bc ; we now have the new period
  ld (SFX_jump_start_period),hl
  ld c,3
  ld a,h
  call WRTPSG_CPC
  ld c,2
  ld a,l
  pop hl
  jr SFX_procedural_jump_stopped_jumping2


;-----------------------------------------------
; generates the procedural jump SFX, playing over channel 2
; - modifies bc and a
SFX_procedural_fall:
  ld a,(loading_map)
  or a
  jp z,SFX_procedural_fall_continue ; if we are in between screens, do not play the sfx
  ld c,9
  ld a,0
  call WRTPSG_CPC
  jp update_sound_after_original_procedural_sounds
SFX_procedural_fall_continue:
  ld a,(player_state)
  srl a
  cp PLAYER_STATE_FALLING_RIGHT/2
  jp z,SFX_procedural_fall_still_falling
SFX_procedural_fall_stopped_falling:
;  call update_sound_SFX_END
  xor a
  ld (SFX_procedural_playing),a
  ld c,9
;  ld a,#00
SFX_procedural_fall_stopped_falling2:
  call WRTPSG_CPC
  jp update_sound_after_original_procedural_sounds
SFX_procedural_fall_still_falling: 
;  ld c,7
;  ld a,#38
;  call WRTPSG_CPC
  ld c,9
  ld a,#0c
  call WRTPSG_CPC
  push hl
  ld hl,SFX_jump_timer
  ld a,(hl)
  inc (hl)
  and #07
  ld hl,procedural_jump_period_change_tbl
  ld b,0
  ld c,a
  add hl,bc
  ld a,(hl) ; we know how much we need to modify the period
  neg 
  ld c,a
  add a,a
  sbc a,a
  ld b,a    ; we sign extend "a" into "bc"
  ld hl,(SFX_jump_start_period)
  add hl,bc ; we now have the new period
  ld (SFX_jump_start_period),hl
  ld c,3
  ld a,h
  call WRTPSG_CPC
  ld c,2
  ld a,l
  pop hl
  jr SFX_procedural_fall_stopped_falling2
  

;-----------------------------------------------
; generates the procedural walk SFX, playing over channel 2
; - modifies bc and a
SFX_procedural_walk:
    ld a,(loading_map)
    or a
    jp z,SFX_procedural_walk_continue ; if we are in between screens, do not play the sfx
    ld c,9
    ld a,0
    call WRTPSG_CPC
    jp update_sound_after_original_procedural_sounds
SFX_procedural_walk_continue:
    ld a,(player_state)
    srl a
    cp PLAYER_STATE_WALKING_RIGHT/2
    jp z,SFX_procedural_walk_still_walking
SFX_procedural_walk_stopped_walking:
    ld a,(SFX_procedural_playing)
    cp SFX_PRIORITY_WALK
    jp nz,update_sound_after_original_procedural_sounds
    xor a
    ld (SFX_procedural_playing),a
    ld c,9
;    ld a,#00
    call WRTPSG_CPC
    jp update_sound_after_original_procedural_sounds
SFX_procedural_walk_still_walking:
    ld a,(current_game_frame)
    and #03
    jp nz,SFX_procedural_walk_silence
;    bit 1,a
    jp nz,SFX_procedural_walk_silence
    ld c,9
    ld a,#0f
    call WRTPSG_CPC
    ld c,2
    ld a,#00
    call WRTPSG_CPC
    ld c,3
    ld a,#08
    call WRTPSG_CPC
    jp update_sound_after_original_procedural_sounds
SFX_procedural_walk_silence:
    ld c,9      
    ld a,#00
    call WRTPSG_CPC
    jp update_sound_after_original_procedural_sounds


update_sound_handle_instruments:
    ld a,(MUSIC_instruments)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE
    jr z,update_sound_handle_instruments_CH2
    ld de,(MUSIC_instrument_envelope_ptr)
    ld a,(de)
    cp #ff
    jr z,update_sound_handle_instruments_CH2
    inc de
    ld (MUSIC_instrument_envelope_ptr),de
    ld c,8
    call WRTPSG_CPC
update_sound_handle_instruments_CH2:
    ld a,(MUSIC_instruments+1)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE
    jr z,update_sound_handle_instruments_CH3
    ld de,(MUSIC_instrument_envelope_ptr+2)
    ld a,(de)
    cp #ff
    jr z,update_sound_handle_instruments_CH3
    inc de
    ld (MUSIC_instrument_envelope_ptr+2),de
    ld c,9
    call WRTPSG_CPC
update_sound_handle_instruments_CH3:
    ld a,(SFX_priority)
    or a
    ret nz  ; if there is an SFX playing, then do not update the instruments in channel 3!
    ld a,(MUSIC_instruments+2)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE 
    ret z
    ld de,(MUSIC_instrument_envelope_ptr+4)
    ld a,(de)
    cp #ff
    ret z
    inc de
    ld (MUSIC_instrument_envelope_ptr+4),de
    ld c,10
    jp WRTPSG_CPC


update_sound_WRTPSG:
    and #0f ; clear all the flags that the command might have
    ld c,a
    ld a,(hl)
    inc hl
    call WRTPSG_CPC                ;; send command to PSG
    jr update_sound_internal_loop     


update_sound_SET_INSTRUMENT:
    ld d,(hl)   ; instrument
    inc hl
    ld a,(hl)   ; channel
    inc hl
    push hl
    cp 2
    jr z,update_sound_SET_INSTRUMENT_not_third_channel
    ld hl,MUSIC_channel3_instrument_buffer
    ld (hl),d
update_sound_SET_INSTRUMENT_not_third_channel:
    ld hl,MUSIC_instruments
    ADD_HL_A
    ld (hl),d
    pop hl
    jr update_sound_internal_loop


update_sound_GOTO:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,(MUSIC_start_pointer)
    add hl,de
    ; clear PSG volumes of channels 1 and 2, to prevent lingering sounds:
    xor a
    ld c,8
    call WRTPSG_CPC
    ld c,9
    call WRTPSG_CPC
    ld (MUSIC_instruments),a
    ld (MUSIC_instruments+1),a
    jr update_sound_internal_loop


update_sound_REPEAT:
    ld a,(hl)
    inc hl
    ld (ix),a
    ld (ix+1),l
    ld (ix+2),h
    inc ix
    inc ix
    inc ix
    jr update_sound_internal_loop


update_sound_END_REPEAT:
    ;; decrease the top value of the repeat stack
    ;; if it is 0, pop
    ;; if it is not 0, goto the repeat point
    ld a,(ix-3)
    dec a
    or a
    jr z,update_sound_END_REPEAT_POP
    ld (ix-3),a
    ld l,(ix-2)
    ld h,(ix-1)
    jr update_sound_internal_loop
update_sound_END_REPEAT_POP:
    dec ix
    dec ix
    dec ix
    jr update_sound_internal_loop


update_sound_command_time_step:
    push af
    ld a,1
    ld (MUSIC_time_step_required),a
    pop af
    ret


update_sound_internal_loop:
    ; check if there is a time step required on the last command
    ld a,(MUSIC_time_step_required)
    or a
    ret nz
update_sound_internal:
    ld a,(hl)
    inc hl 
    ; check if it's a special command:
    bit 6,a
    call nz,update_sound_command_time_step
    bit 7,a
    jp z,update_sound_WRTPSG
    and #3f ; clear all the flags the command might have
    ret z   ; MUSIC_CMD_SKIP command
    dec a   ; MUSIC_CMD_SET_INSTRUMENT
    jr z,update_sound_SET_INSTRUMENT
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH1
    jr z,update_sound_PLAY_INSTRUMENT_CH1
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH2
    jr z,update_sound_PLAY_INSTRUMENT_CH2
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH3
    jr z,update_sound_PLAY_INSTRUMENT_CH3
    dec a   ; MUSIC_CMD_PLAY_SFX_OPEN_HIHAT
    jr z,update_sound_PLAY_SFX_OPEN_HIHAT
    dec a   ; MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT
    jr z,update_sound_PLAY_SFX_PEDAL_HIHAT
    dec a   ; MUSIC_CMD_GOTO
    jr z,update_sound_GOTO
    dec a   ; MUSIC_CMD_REPEAT
    jr z,update_sound_REPEAT
    dec a   ; MUSIC_CMD_END_REPEAT
    jr z,update_sound_END_REPEAT
    dec a   ; MUSIC_CMD_TRANSPOSE_UP
    jr z,update_sound_TRANSPOSE_UP
    dec a   ; MUSIC_CMD_CLEAR_TRANSPOSE
    jr z,update_sound_CLEAR_TRANSPOSE
    ; SFX_CMD_END
;    jp update_sound_SFX_END       ;; if the SFX sound is over, we are done


update_sound_SFX_END:
    xor a
    ld (SFX_priority),a
    ld c,7
    ld a,#38  ;; SFX should reset all channels to tone
    jp WRTPSG_CPC


update_sound_PLAY_SFX_OPEN_HIHAT:
    push hl
    ld hl,SFX_open_hi_hat
update_sound_PLAY_SFX_OPEN_HIHAT_entry:
    ld a,SFX_PRIORITY_MUSIC
    call play_SFX_with_priority
    pop hl
    jp update_sound_internal_loop


update_sound_PLAY_SFX_PEDAL_HIHAT:
    push hl
    ld hl,SFX_pedal_hi_hat
    jr update_sound_PLAY_SFX_OPEN_HIHAT_entry


update_sound_TRANSPOSE_UP:
    ld a,(MUSIC_transpose)
    inc a
update_sound_TRANSPOSE_UP_entry:
    ld (MUSIC_transpose),a
    jp update_sound_internal_loop


update_sound_CLEAR_TRANSPOSE:
    xor a
    jr update_sound_TRANSPOSE_UP_entry


update_sound_PLAY_INSTRUMENT_CH1:
    ld c,1
    jr update_sound_PLAY_INSTRUMENT
update_sound_PLAY_INSTRUMENT_CH2:
    ld c,3
    jr update_sound_PLAY_INSTRUMENT
update_sound_PLAY_INSTRUMENT_CH3:
    ld a,(SFX_priority)
    cp SFX_PRIORITY_LOW
    jp p,update_sound_PLAY_INSTRUMENT_IGNORE
    ld a,(MUSIC_channel3_instrument_buffer)
    ld (MUSIC_instruments+2),a
    ld c,5
update_sound_PLAY_INSTRUMENT:
    ld b,0  ; for later use
    ld a,(hl)   ; note to play
    push hl
    ld hl,MUSIC_transpose
    add a,(hl)
    push bc
    ld hl,note_period_table
    ld c,a
    add hl,bc
    add hl,bc
    pop bc
    ld a,(hl)   ; MSB of the period    
    inc hl
    push bc
    call WRTPSG_CPC
    pop bc
    ld a,(hl)   ; LSB of the period    
    dec c
    push bc
    call WRTPSG_CPC
    pop bc

    ld hl,MUSIC_instruments
    ld a,c  ; here  c == 0, 2 or 4 depending on which channel we are playing
    srl a   ; divide by 2
    ADD_HL_A    ; HL = MUSIC_instruments + channel
    ld a,(hl)   ; we get the instrument
    ld de,Instrument_profiles
    ADD_DE_A    ; we calculate pointer to the instrument envelope
    ld hl,MUSIC_instrument_envelope_ptr
    add hl,bc   ; b should still be 0 here, so, we are just adding c
    ld (hl),e
    inc hl
    ld (hl),d
    pop hl
    ld a,c  ; calculate the volume port: (c/2)+8
    sra a
    add a,8
    ld c,a
    ld a,(de)
    call WRTPSG_CPC 
update_sound_PLAY_INSTRUMENT_IGNORE:
    inc hl
    jp update_sound_internal_loop


end_of_sound_code:

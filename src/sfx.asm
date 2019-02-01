;-----------------------------------------------
; in-game sound effects
;SFX_walk1:
;  db 9,#0c    ;; volume
;  db 2,#00, 3,#07 ;; frequency
;  db MUSIC_CMD_SKIP
;  db 9,#00    ;; silence
;  db SFX_CMD_END   

;SFX_walk2:
;  db 9,#0c    ;; volume
;  db 2,#00, 3,#05 ;; frequency
;  db MUSIC_CMD_SKIP
;  db 9,#00    ;; silence
;  db SFX_CMD_END   


SFX_jump:
  db 7,#38    ;; SFX all channels to tone
  db 10,#0c    ;; volume
  db 4,#00, 5,#02 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#08, 5,#01 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#c0, 5,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_fire_arrow:
  db 7,  #1c  ; noise
  db 10, #0f  ; volume
  db 6+MUSIC_CMD_TIME_STEP_FLAG,  #10  ; noise frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG, #0d
  db 10+MUSIC_CMD_TIME_STEP_FLAG, #0b
  db 10+MUSIC_CMD_TIME_STEP_FLAG, #09
  db 6+MUSIC_CMD_TIME_STEP_FLAG,  #01
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG, #0b
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG, #0d
  db MUSIC_CMD_SKIP
  db 10, #00
  db 7,  #38  ; bring it back to tone
  db SFX_CMD_END   


SFX_item_pickup:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#80, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d    ;; volume

  db 10,#0f    ;; volume
  db 4,#70, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d    ;; volume

  db 10,#0f    ;; volume
  db 4,#60, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d    ;; volume

  db 10,#0f    ;; volume
  db 4,#50, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#02    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END    


SFX_door_open:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#0f    ;; volume
  db 4,#00, 5+MUSIC_CMD_TIME_STEP_FLAG,#06 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0e    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0d    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0c    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0b    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#0a    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#08    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#07    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#06    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#05    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#04    ;; volume
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
  db MUSIC_CMD_SKIP
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80 ;; frequency
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_laser:
  db  7,#b8    ;; SFX all channels to tone
  db 10,#04    ;; volume
  db 4,#00, 5+MUSIC_CMD_TIME_STEP_FLAG,#06   ;; change frequency of channel 3
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c    ;; volume
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0f    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; volume
  db MUSIC_CMD_SKIP
  db 10,#00    ;; silence
  db SFX_CMD_END   


SFX_playerhit:
  db 7,#b8          ;; set channel 3 to tone
  db 10,#0f         ;; channel 3 volume to MAX
  db 4,#00, 5+MUSIC_CMD_TIME_STEP_FLAG,#08   ;; change frequency of channel 3
  db MUSIC_CMD_SKIP ;; 1/50th second delay
  db 5+MUSIC_CMD_TIME_STEP_FLAG,#04          ;; change frequency of channel 3
  db 5+MUSIC_CMD_TIME_STEP_FLAG,#02          ;; change frequency of channel 3
  db 5+MUSIC_CMD_TIME_STEP_FLAG,#01          ;; change frequency of channel 3
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#80, 5, #00  ;; change frequency of channel 3
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#40          ;; change frequency of channel 3
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#20          ;; change frequency of channel 3
  db MUSIC_CMD_SKIP ;; 1/50th second delay
  db 10,#00         ;; channel 3 volume to silence
  db SFX_CMD_END    ;; end SFX
  

SFX_switch:
  db 7,#1c          ;; set channel 3 to noise
  db 10,#0f         ;; channel 3 volume to MAX
  db 6+MUSIC_CMD_TIME_STEP_FLAG,#08         ;; noise frequency
  db MUSIC_CMD_SKIP ;; 1/50th second delay
  db 7,#38         ;; set channel 3 to tone
  db 5,#00         ;; tone frequency
  db 4+MUSIC_CMD_TIME_STEP_FLAG,#40         ;; tone frequency
  db 10,#00         ;; channel 3 volume to silence
  db SFX_CMD_END    ;; end SFX


SFX_death:
  db 7,#38
  db 5, #01, 4, #d0
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0f
  db 4, #b0
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d
  db 4, #90
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b
  db 4, #70
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#09
  db 4, #50
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#06
  db 4, #30
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#03
  db 10,#00         ;; channel 3 volume to silence
  db SFX_CMD_END


SFX_falling_rock:
  db 7,#38
  db 10,#0a
  db 5, #00, 4+MUSIC_CMD_TIME_STEP_FLAG, #40
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#0c
  db 4+MUSIC_CMD_TIME_STEP_FLAG, #48
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#0b
  db 4+MUSIC_CMD_TIME_STEP_FLAG, #50
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#09
  db 4+MUSIC_CMD_TIME_STEP_FLAG, #58
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#07
  db 4+MUSIC_CMD_TIME_STEP_FLAG, #60
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#05
  db 4+MUSIC_CMD_TIME_STEP_FLAG, #68
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db 10,#00         ;; channel 3 volume to silence
  db SFX_CMD_END


SFX_collapse:
    db 7, #18
    db 10, #0c
    db 4, #f4, 5, #01
    db 6+MUSIC_CMD_TIME_STEP_FLAG, #1e 
    db 10, #0d
    db 4, #83, 5+MUSIC_CMD_TIME_STEP_FLAG, #02
    db MUSIC_CMD_SKIP
    db 10, #0f
    db 4, #65, 5+MUSIC_CMD_TIME_STEP_FLAG, #01
    db 4, #f4, 5+MUSIC_CMD_TIME_STEP_FLAG, #01
    db 4, #83, 5+MUSIC_CMD_TIME_STEP_FLAG, #02
    db 4, #ad, 5+MUSIC_CMD_TIME_STEP_FLAG, #01
    db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
    db 10, #0d
    db 4, #f4, 5, #01
    db 6+MUSIC_CMD_TIME_STEP_FLAG, #1e 
    db 4, #83, 5+MUSIC_CMD_TIME_STEP_FLAG, #02
    db 10, #0c
    db MUSIC_CMD_SKIP
    db 4, #65, 5+MUSIC_CMD_TIME_STEP_FLAG, #01
    db 4, #f4, 5+MUSIC_CMD_TIME_STEP_FLAG, #01
    db 10, #0b
    db 4, #83, 5+MUSIC_CMD_TIME_STEP_FLAG, #02
    db 4, #ad, 5+MUSIC_CMD_TIME_STEP_FLAG, #01
    db 10, #0a
    db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
    db 10, #08
    db MUSIC_CMD_SKIP, MUSIC_CMD_SKIP
    db 7, #38
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END

;SFX_collapse_mini:
;    db 7, #18, 10, #0e, 4, #fc, 5, #02
;    db 6, #1b, MUSIC_CMD_SKIP, 4, #3d, 5, #02, MUSIC_CMD_SKIP
;    db 4, #ae, 5, #01, MUSIC_CMD_SKIP, 4, #3d, 5
;    db #02, MUSIC_CMD_SKIP, 4, #ae, 5, #01, MUSIC_CMD_SKIP, 4
;    db #42, 5, #01, MUSIC_CMD_SKIP, 10, #00, 7, #38
;    db SFX_CMD_END

;-----------------------------------------------
; Sound effects used for the percussion in the songs
SFX_open_hi_hat:
  db  7,#1c    ;; noise in channel C, and tone in channels B and A
  db 10,#0a    ;; volume
  db  6+MUSIC_CMD_TIME_STEP_FLAG,#01    ;; noise frequency
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
  db MUSIC_CMD_SKIP
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
  db  7,#38    ;; SFX all channels to tone
  db 10,#00         ;; channel 3 volume to silence
  db SFX_CMD_END      


SFX_pedal_hi_hat:
  db  7,#1c    ;; noise in channel C, and tone in channels B and A
  db 10,#05    ;; volume
  db  6+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; noise frequency
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
  db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
  db  7,#38    ;; SFX all channels to tone
  db 10,#00         ;; channel 3 volume to silence
  db SFX_CMD_END   

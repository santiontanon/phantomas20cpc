  include "../constants.asm"
  org #0000
phantomas2_menu_song:
  db 7,184
phantomas2_menu_song_loop:
  db MUSIC_CMD_REPEAT, 3
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 32
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 34
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 32
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 31
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 29
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 28
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 1
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 45
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 32
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 44
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 45
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 34
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 46
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 45
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 32
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 44
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 33
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 31
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 29
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 28
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_REPEAT, 2
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_SQUARE_WAVE, 0
  db 8, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_PIANO, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 38
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 41
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 44
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 46
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 48
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 46
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1 + MUSIC_CMD_TIME_STEP_FLAG, 45
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 48
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 46
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 45
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 51
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH1, 50
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_SQUARE_WAVE, 0
  db 8, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db 8, 0
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2 + MUSIC_CMD_TIME_STEP_FLAG, 14
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 17
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_INSTRUMENT_CH2, 14
  db MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_PLAY_SFX_OPEN_HIHAT + MUSIC_CMD_TIME_STEP_FLAG
  db MUSIC_CMD_SKIP
  db MUSIC_CMD_TRANSPOSE_UP
  db MUSIC_CMD_END_REPEAT
  db MUSIC_CMD_CLEAR_TRANSPOSE
  db MUSIC_CMD_GOTO
  dw (phantomas2_menu_song_loop - phantomas2_menu_song)
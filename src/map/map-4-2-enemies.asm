items:
	db 0
enemies:
	db 7
	db ENEMY_STATE_SWITCH_HORIZONTAL, 13, 0, 8*1, 16*4, ENEMY_SWITCH
	db ENEMY_STATE_SWITCH_HORIZONTAL_RIGHT, 14, 0, 8*14, 16*2, ENEMY_SWITCH
    db ENEMY_STATE_RIGHT+2, 9*8+1, 12*8,  10*8,16*3,  ENEMY_PLATFORM
    db ENEMY_STATE_RIGHT+1, 8*8+1, 13*8,  10*8,16*2,  ENEMY_BAT
    db ENEMY_STATE_RIGHT+1, 9*8+1, 12*8,  11*8,16*5,  ENEMY_BAT
    db ENEMY_STATE_STATIONARY_SHOWING, 0, 0,  7*8+4,5*16,  ENEMY_FIRE
    db ENEMY_STATE_STATIONARY_SHOWING, 0, 0,  8*8,5*16,  ENEMY_FIRE

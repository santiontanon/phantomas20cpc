items:
	db 0
enemies:
    db 4
    db ENEMY_STATE_RIGHT+2, 8, 3*8+1,  16,16*6,  ENEMY_SPIDER
    db ENEMY_STATE_RIGHT+2, 4*8+1, 6*8,  40,16*4,  ENEMY_TRAP
    db ENEMY_STATE_STATIONARY_SHOWING, 0, 0,  14*8,16*6,  ENEMY_STATIONARY_TRAP
    db ENEMY_STATE_RIGHT+2, 7*8+1, 10*8,  8*8,16*5,  ENEMY_BUBBLE

items:
	db 0
enemies:
	db 3
    db ENEMY_STATE_RIGHT+3, 8+1, 14*8,  10*8,16*4,  ENEMY_GHOST
    db ENEMY_STATE_RIGHT+2, 6*8+1, 9*8,  7*8,16*2,  ENEMY_FRANKEN
    db ENEMY_STATE_UP+2, 1*16+1, 4*16,  11*8,3*16,  ENEMY_BAT_VERTICAL
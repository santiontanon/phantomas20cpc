items:
	db 0
enemies:
	db 3
	db ENEMY_STATE_RIGHT+2, 7*8+1, 14*8,  9*8,16*2,  ENEMY_BAT
	db ENEMY_STATE_RIGHT+2, 10*8+1, 14*8,  11*8,16*5,  ENEMY_BAT
	db ENEMY_STATE_HLASER_HIDDEN, 6*8,13*8, 6*8,16*1+8,  ENEMY_LASER_HORIZONTAL
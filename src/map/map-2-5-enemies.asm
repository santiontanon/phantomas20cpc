items:
	db 0
enemies:
	db 5
	db ENEMY_STATE_RIGHT+2, 5*8+1, 8*8,  6*8,16,  ENEMY_BAT
    db ENEMY_STATE_RIGHT+1, 9*8+1, 13*8,  9*8,16,  ENEMY_PLATFORM
    db ENEMY_STATE_RIGHT+1, 5*8+1, 9*8+4,  7*8,16*3,  ENEMY_PLATFORM
    db ENEMY_STATE_RIGHT+1, 8*8+1, 13*8,  9*8,16*5,  ENEMY_PLATFORM
    db ENEMY_STATE_WAITING_LEFT+3, 110,16*2+8, 110,16*2+8,  ENEMY_ARROW_LEFT_RIGHT

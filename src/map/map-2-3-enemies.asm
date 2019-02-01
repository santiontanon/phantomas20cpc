items:
	db 1
	db ITEM_CROSS, 8*9, 32, 0
enemies:
	db 2
	db ENEMY_STATE_RIGHT+1, 7*8+1, 11*8,  8*8,16*4,  ENEMY_BAT
    db ENEMY_STATE_RIGHT+2, 6*8+1, 12*8,  7*8,16*5,  ENEMY_PLATFORM
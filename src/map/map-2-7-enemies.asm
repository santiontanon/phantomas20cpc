items:
	db 1
	db ITEM_SQUARE_LOCK, 6*8, 16, 0
enemies:
    db 2
    db ENEMY_STATE_UP+2, 1*16+1, 5*16,  10*8,3*16,  ENEMY_BAT_VERTICAL
    db ENEMY_STATE_RIGHT+2, 10*8+1, 14*8,  12*8,16*5,  ENEMY_FRANKEN
    
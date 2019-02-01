items:
  db 2
  db ITEM_FOOD2+2*10, 8, 32, 0
  db ITEM_FOOD2+2*11, 80, 96, 0
enemies:
  db 1
  db ENEMY_STATE_INSTADEAD_BLOCK, 0, 0, 40, 16, ENEMY_SPIKE_BALL

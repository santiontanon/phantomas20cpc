items:
  db 1
  db ITEM_FOOD2+2*30, 112, 96, 0
enemies:
  db 4
  db ENEMY_STATE_RIGHT+3, 8, 96, 72, 16, ENEMY_TRAP
  db ENEMY_STATE_FALLING_BLOCK, 35, 48, 112, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_RIGHT+2, 64, 104, 80, 48, ENEMY_TRAP
  db ENEMY_STATE_RIGHT+2, 32, 104, 88, 96, ENEMY_SPIDER
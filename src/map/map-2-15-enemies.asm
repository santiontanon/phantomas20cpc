items:
  db 1
  db ITEM_FOOD2+2*17, 112, 96, 0
enemies:
  db 7
  db ENEMY_STATE_VLASER_HIDDEN, 24, 80, 56, 24, ENEMY_LASER_VERTICAL
  db ENEMY_STATE_VLASER_HIDDEN, 24, 80, 64, 24, ENEMY_LASER_VERTICAL
  db ENEMY_STATE_WAITING_RIGHT, 12, 56, 12, 56, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_FALLING_BLOCK, 13, 32, 40, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_FALLING_BLOCK, 14, 64, 48, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_RIGHT+2, 72, 120, 88, 32, ENEMY_BAT
  db ENEMY_STATE_RIGHT+3, 8, 104, 80, 96, ENEMY_FRANKEN
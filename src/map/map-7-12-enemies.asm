items:
  db 2
  db ITEM_BIBLE_KEY, 112, 16, 0
  db ITEM_FOOD2+2*12, 104, 96, 1
enemies:
  db 7
  db ENEMY_STATE_FALLING_BLOCK, 8, 96, 40, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_FALLING_BLOCK, 9, 96, 48, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_FALLING_BLOCK, 10, 96, 56, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_FALLING_BLOCK, 11, 96, 64, 16, ENEMY_BRICK_WALL
  db ENEMY_STATE_DOWN+2, 24, 96, 32, 32, ENEMY_PLATFORM
  db ENEMY_STATE_DOWN+2, 48, 96, 88, 48, ENEMY_PLATFORM
  db ENEMY_STATE_RIGHT+2, 96, 112, 112, 48, ENEMY_PLATFORM

items:
  db 1
  db ITEM_FOOD2+2*26, 112, 48, 0
enemies:
  db 4
  db ENEMY_STATE_WAITING_LEFT, 110, 88, 110, 88, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_RIGHT+2, 40, 56, 48, 32, ENEMY_SPIDER
  db ENEMY_STATE_DOWN+2, 48, 80, 32, 64, ENEMY_PLATFORM
  db ENEMY_STATE_RIGHT+3, 24, 112, 96, 96, ENEMY_BUBBLE

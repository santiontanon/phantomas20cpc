items:
  db 2
  db ITEM_FOOD2+2*36, 24, 16, 0
  db ITEM_FOOD2+2*37, 32, 16, 0
enemies:
  db 4
  db ENEMY_STATE_WAITING_RIGHT, 52, 24, 52, 24, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_WAITING_RIGHT, 52, 40, 52, 40, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_RIGHT+1, 8, 24, 24, 64, ENEMY_PLATFORM
  db ENEMY_STATE_RIGHT+2, 72, 96, 80, 96, ENEMY_PLATFORM
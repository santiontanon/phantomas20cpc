items:
  db 1
  db ITEM_WHEEL, 112, 96, 0
enemies:
  db 5
  db ENEMY_STATE_WAITING_RIGHT, 12, 40, 12, 40, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_WAITING_RIGHT, 12, 56, 12, 56, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_WAITING_RIGHT, 12, 104, 12, 104, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_RIGHT+2, 32, 64, 56, 64, ENEMY_PLATFORM
  db ENEMY_STATE_RIGHT+2, 72, 112, 96, 64, ENEMY_PLATFORM
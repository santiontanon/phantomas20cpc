items:
  db 0
enemies:
  db 7
  db ENEMY_STATE_WAITING_DOWN, 104, 24, 104, 24, ENEMY_ARROW_DOWN
  db ENEMY_STATE_WAITING_LEFT, 110, 24, 110, 24, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_WAITING_LEFT, 110, 56, 110, 56, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_WAITING_LEFT, 110, 104, 110, 104, ENEMY_ARROW_LEFT_RIGHT
  db ENEMY_STATE_RIGHT+2, 16, 48, 48, 32, ENEMY_GHOST
  db ENEMY_STATE_DOWN+2, 16, 96, 72, 48, ENEMY_PLATFORM
  db ENEMY_STATE_RIGHT+2, 40, 64, 48, 96, ENEMY_TRAP

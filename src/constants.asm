; ------------------------------------------------
VIDEO_MEMORY:		equ #c000


GAME_COMPILATION_MODE_ENDING: equ 1
GAME_COMPILATION_MODE_PEDAL: equ 2
GAME_COMPILATION_MODE_WHEEL: equ 3
GAME_COMPILATION_MODE_BLOCKS: equ 4
GAME_COMPILATION_MODE_FOOD: equ 5

SCOREBOARD_V1: equ 1
SCOREBOARD_V2: equ 2

SCOREBOARD_MODE: equ SCOREBOARD_V2

GAME_COMPILATION_MODE:	equ 0	; normal
;GAME_COMPILATION_MODE:	equ GAME_COMPILATION_MODE_ENDING	; ending testing
;GAME_COMPILATION_MODE:	equ GAME_COMPILATION_MODE_PEDAL	; for testing the pedal generator
;GAME_COMPILATION_MODE:	equ GAME_COMPILATION_MODE_WHEEL	; just before getting the wheel
;GAME_COMPILATION_MODE:	equ GAME_COMPILATION_MODE_BLOCKS	; 
;GAME_COMPILATION_MODE:	equ GAME_COMPILATION_MODE_FOOD

SPACE_TO_RESPAWN: equ 0
;SPACE_TO_RESPAWN: equ 1

; constants:
VIDEO_MEM_OFFSET:	equ 0	; to move the starting position of the game screen
SCREEN_WIDTH_IN_BYTES_256px:	equ 64
SCREEN_WIDTH_IN_BYTES_320px:	equ 80

MAX_DIFFERENT_TILES_PER_ROOM:	equ 47
MAX_ENEMIES:        			equ 10
MAX_DIFFERENT_ENEMY_SPRITES:	equ 34
MAX_DIFFERENT_ENEMY_TYPES:		equ 6
MAX_DIFFERENT_ITEMS:			equ 2
ENEMY_STRUCT_SIZE:  			equ 10	; (10 bytes each enemy) state, lower movement bound, upper movement bound, x, y, video mem address (dw), sprites ptr (dw), animation type
MAX_ITEMS:						equ 5
ITEM_STRUCT_SIZE:				equ 4

INVINCIBILITY_TIME:				equ 50

PLAYER_INVENTORY_SIZE:		equ 11	; I could use bits for this, but that's save only 8 bytes, 
									; and the code to read the inventory would be longer than that
NUMBER_OF_FOODS:	equ 40
NUMBER_OF_FALLING_BLOCKS:	equ 43
MAX_LIVES:			equ 9
NUMBER_OF_LOCKS:	equ 7
NUMBER_OF_SWITCHES:	equ 15

ITEM_GATE_KEY:		equ 1
ITEM_TRIANGLE_KEY:	equ 2
ITEM_SQUARE_KEY:	equ 3
ITEM_ROUND_KEY:		equ 4
ITEM_CROSS_KEY:		equ 5
ITEM_MAP_KEY:		equ 6
ITEM_BIBLE_KEY:		equ 7
ITEM_WHEEL:			equ 8
ITEM_CROSS:			equ 9
ITEM_STAKE:			equ 10
ITEM_HAMMER:		equ 11
ITEM_GATE_LOCK:		equ 12
ITEM_TRIANGLE_LOCK:	equ 13
ITEM_SQUARE_LOCK:	equ 14
ITEM_ROUND_LOCK:	equ 15
ITEM_CROSS_LOCK:	equ 16
ITEM_MAP_LOCK:		equ 17
ITEM_BIBLE_LOCK:	equ 18
ITEM_FOOD1:			equ 19	; ITEM_FOOD1 + 2*k are burguers
ITEM_FOOD2:			equ 20	; ITEM_FOOD2 + 2*k are chickens

ENEMY_NONE:	    	equ 0
ENEMY_BAT:          equ 1
ENEMY_BAT_VERTICAL: equ 2
ENEMY_SPIDER:       equ 3
ENEMY_ARROW_LEFT_RIGHT:   equ 4
ENEMY_BARREL:       equ 5
ENEMY_TRAP:         equ 6
ENEMY_SKULL:        equ 7
ENEMY_FIRE:			equ 8
ENEMY_BUBBLE:		equ 9
ENEMY_CROSS:		equ 10
ENEMY_STAR:			equ 11
ENEMY_FRANKEN:		equ 12
ENEMY_PLATFORM:		equ 13	; I am handling moving platforms as enemies
ENEMY_STATIONARY_TRAP:        equ 14
ENEMY_GHOST:		equ 15
ENEMY_ARROW_DOWN:   equ 16
ENEMY_LASER_VERTICAL:   equ 17
ENEMY_LASER_HORIZONTAL:   equ 18
ENEMY_SWITCH:		equ 19
ENEMY_SPIKE_BALL:	equ 20
ENEMY_BRICK_WALL:	equ 21
;ENEMY_BULLET:		equ 22
ENEMY_REDSKULL:		equ 22
ENEMY_GENERATOR:	equ 23

; in increments of 4, since the lower 2 bits are the movement speed of the enemy:
ENEMY_STATE_RIGHT:   equ 0
ENEMY_STATE_LEFT:    equ 4
ENEMY_STATE_DOWN:      equ 8
ENEMY_STATE_UP:    equ 12
ENEMY_STATE_DOWN_ARROW:   equ 16
ENEMY_STATE_STATIONARY_SHOWING:    equ 20
ENEMY_STATE_LEFT_ARROW:    equ 24
ENEMY_STATE_RIGHT_ARROW:   equ 28
ENEMY_STATE_HLASER_SHOWING:    equ 32
ENEMY_STATE_VLASER_SHOWING:    equ 36
ENEMY_STATE_FALLING_BLOCK:  equ 40
ENEMY_STATE_INSTADEAD_BLOCK: equ 44	
ENEMY_STATE_WAVE_RIGHT:   equ 48
ENEMY_STATE_WAVE_LEFT:    equ 52
ENEMY_STATE_WAITING_RIGHT:  equ 56
ENEMY_STATE_WAITING_LEFT:   equ 60
ENEMY_STATE_WAITING_DOWN:  equ 64
ENEMY_STATE_STATIONARY_HIDDEN:    equ 68
ENEMY_STATE_HLASER_HIDDEN:    equ 72
ENEMY_STATE_VLASER_HIDDEN:    equ 76
ENEMY_STATE_GENERATOR_INACTIVE:		equ 80
ENEMY_STATE_SWITCH_HORIZONTAL:	equ 84
ENEMY_STATE_SWITCH_VERTICAL:	equ 88
ENEMY_STATE_SWITCH_HORIZONTAL_RIGHT:	equ 92
ENEMY_STATE_NONE:	equ 96	; enemies to be ignored completely

ENEMY_INVISIBLE_STATES:     equ 56

ENEMY_ANIMATION_STYLE_VAMPIRE:	equ 0
ENEMY_ANIMATION_STYLE_VAMPIRE_VERTICAL:	equ 1
ENEMY_ANIMATION_STYLE_ARROW:	equ 2
ENEMY_ANIMATION_STYLE_BARREL:	equ 3
ENEMY_ANIMATION_STYLE_TRAP:		equ 4
ENEMY_ANIMATION_STYLE_FIRE:		equ 5
ENEMY_ANIMATION_STYLE_BUBBLE:	equ 6
ENEMY_ANIMATION_STYLE_STAR:		equ 7
ENEMY_ANIMATION_STYLE_PLATFORM:	equ 8
ENEMY_ANIMATION_STYLE_SWITCH:	equ 9
ENEMY_ANIMATION_STYLE_NONE:		equ 10
ENEMY_ANIMATION_STYLE_LASER:	equ 0	; this value does not matter, since it's never used

MAP_WIDTH:   equ 10

MAPS_PER_GROUP:		equ 4

FIRST_COLLIDABLE_FOREGROUND_TILE_INDEX:	equ 87

COLLISION_TOP_LEFT_BIT:		equ 0
COLLISION_TOP_RIGHT_BIT:	equ 1
COLLISION_BOTTOM_LEFT_BIT:	equ 2
COLLISION_BOTTOM_RIGHT_BIT:	equ 3

COLLISION_TOP_LEFT_MASK:		equ #01
COLLISION_TOP_RIGHT_MASK:		equ #02
COLLISION_BOTTOM_LEFT_MASK:		equ #04
COLLISION_BOTTOM_RIGHT_MASK:	equ #08

KEYBOARD_1_BIT:     	equ 0
KEYBOARD_2_BIT:     	equ 1
KEYBOARD_ESC_BIT:     	equ 2
KEYBOARD_Q_BIT:     	equ 3
KEYBOARD_LEFT_BIT:		equ 4
KEYBOARD_RIGHT_BIT:		equ 5
KEYBOARD_UP_BIT:		equ 6
KEYBOARD_SPACE_BIT:     equ 7

KEYBOARD_LEFT_MASK:		equ #10
KEYBOARD_RIGHT_MASK:	equ #20
KEYBOARD_UP_MASK:		equ #40


FADE_IN_OUT_SPEED:	equ 20
;FADE_IN_OUT_SPEED:	equ 1

PLAYER_STATE_IDLE_RIGHT:	equ 0
PLAYER_STATE_IDLE_LEFT:		equ 1
PLAYER_STATE_FALLING_RIGHT:	equ 2
PLAYER_STATE_FALLING_LEFT:	equ 3
PLAYER_STATE_WALKING_RIGHT:	equ 4
PLAYER_STATE_WALKING_LEFT:	equ 5
PLAYER_STATE_JUMPING_RIGHT:	equ 6
PLAYER_STATE_JUMPING_LEFT:	equ 7

RESPAWN_FROM_LEFT:	equ 0
RESPAWN_FROM_RIGHT:	equ 1
RESPAWN_FROM_TOP:	equ 2
RESPAWN_FROM_BOTTOM:	equ 3


PRESS_SWITCH_SCORE:			equ 5
NEW_ROOM_SCORE: 			equ 10
SPECIAL_KEY_PICKUP_SCORE: 	equ 15
OPEN_LOCK_SCORE: 			equ 20
SPECIAL_ITEM_PICKUP_SCORE: 	equ 25
OPEN_WINDOW_SCORE: 			equ 50
REMAINING_HEALTH_SCORE:		equ 10
REMAINING_LIFE_SCORE:		equ 50
KILL_DRACULA_SCORE:			equ 500

;-----------------------------------------------
; Music related constants:
; instrument codes are the indexes of their first byte in the profile
MUSIC_INSTRUMENT_SQUARE_WAVE:   equ 0
MUSIC_INSTRUMENT_PIANO:         equ 1 
; MUSIC_INSTRUMENT_WIND:          equ 12   

SFX_PRIORITY_MUSIC:				equ 1	; this is the lowest priority
SFX_PRIORITY_LOW:				equ 2
SFX_PRIORITY_JUMP:				equ 3
SFX_PRIORITY_FALL:				equ 4
SFX_PRIORITY_WALK:				equ 5
SFX_PRIORITY_HIGH:				equ 6

MUSIC_CMD_FLAG:					equ #80
MUSIC_CMD_TIME_STEP_FLAG:		equ #40

MUSIC_CMD_SKIP:             	equ #00+MUSIC_CMD_FLAG
MUSIC_CMD_SET_INSTRUMENT:       equ #01+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH1:  equ #02+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH2:  equ #03+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH3:  equ #04+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_OPEN_HIHAT:     	equ #05+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT:    	equ #06+MUSIC_CMD_FLAG
MUSIC_CMD_GOTO:             	equ #07+MUSIC_CMD_FLAG
MUSIC_CMD_REPEAT:           	equ #08+MUSIC_CMD_FLAG
MUSIC_CMD_END_REPEAT:       	equ #09+MUSIC_CMD_FLAG
MUSIC_CMD_TRANSPOSE_UP:			equ #0a+MUSIC_CMD_FLAG
MUSIC_CMD_CLEAR_TRANSPOSE:		equ #0b+MUSIC_CMD_FLAG
SFX_CMD_END:                	equ #0c+MUSIC_CMD_FLAG

;SFX_OPEN_HIHAT:         equ 0
;SFX_PEDAL_HIHAT:        equ 1

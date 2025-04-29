; Use this to hide baserom code.  Will make merging changes from upstream easier
;  IF SUPER_AWAKENING_HIDE
;    ...
;  ENDC
SUPER_AWAKENING_HIDE_CODE = FALSE
SUPER_AWAKENING_GBC_CODE = FALSE

; Enable for development features
SUPER_AWAKENING_DEBUG = TRUE

; Forces dialog to empty text
SUPER_AWAKENING_DEBUG_FAST_DIALOG = FALSE

; If the inventory system allows all items
; TRUE = Select any item in the inventory
; FALSE = Only allow items unlocked from progression
SUPER_AWAKENING_RESTRICT_INVENTORY_ITEMS = TRUE

DEBUG_STARTING_HEARTS = 6*8 ; Value * 8 = Heart Count
DEBUG_MAX_HEARTS = 6


ROOM_HACK_MAGIC_ADDRESS = $4002
ROOM_HACK_MAGIC_VALUE = $F0

SGB_INSTRUMENT_GAMEPLAY_BORDER_FADE_OUT_DELAY = $08
SGB_INSTRUMENT_GAMEPLAY_BORDER_FADE_IN_DELAY = $60
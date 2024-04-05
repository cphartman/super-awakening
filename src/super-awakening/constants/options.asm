; Use this to hide baserom code.  Will make merging changes from upstream easier
;  IF SUPER_AWAKENING_HIDE
;    ...
;  ENDC
SUPER_AWAKENING_HIDE_CODE = FALSE

; Enable for development features
SUPER_AWAKENING_DEBUG = TRUE

SUPER_AWAKENING_DEBUG_FAST_DIALOG = TRUE

; If the inventory system allows all items
; TRUE = Select any item in the inventory
; FALSE = Only allow items unlocked from progression
SUPER_AWAKENING_RESTRICT_INVENTORY_ITEMS = TRUE

DEBUG_STARTING_HEARTS = 4 ; Value * 8 = Heart Count
DEBUG_MAX_HEARTS = 3
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

; Spend rupees to refill an empty bomb, arrow, or powder stack.
; TRUE  = restock when the stack is empty
; FALSE = skip restocking
SUPER_AWAKENING_QUICK_RESTOCK = FALSE

; Screen warp glitch (see the Screen Warp Glitch entry on the Zelda wiki).
; Normally the game checks for a room transition before opening the map,
; so Select does nothing while the screen is scrolling. This patch removes
; that check, so Select opens the map mid-scroll, which can warp you to
; the room you were leaving.
; TRUE  = glitch enabled
; FALSE = check kept (original behavior)
; Can softlock or corrupt saves.
SUPER_AWAKENING_SCREEN_WARP = TRUE

DEBUG_STARTING_HEARTS = 4 ; Value * 8 = Heart Count
DEBUG_MAX_HEARTS = 3
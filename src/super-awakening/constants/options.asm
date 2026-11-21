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

; Hold Select in the start menu to open the save screen.
; Handy since A + B + Start + Select is awkward on a SNES controller.
; TRUE  = hold Select for the number of frames below
; FALSE = only the A + B + Start + Select combo opens it
SUPER_AWAKENING_SELECT_HOLD_SAVE = TRUE
SUPER_AWAKENING_SELECT_HOLD_SAVE_FRAMES = 180 ; About 3 seconds (60 frames per second)

; Hold the shield while charging the sword, like the original game.
; Sword and shield share the B slot here, so normally pressing one
; swaps out the other.
; TRUE  = shield and sword charge work at the same time
; FALSE = pressing one replaces the other
SUPER_AWAKENING_SHIELD_WHILE_CHARGING = TRUE

; What the top of the start menu shows. During gameplay the HUD shows the X and Y items.
; TRUE  = sword (B) and shield (A) while the menu is open
; FALSE = the X and Y items, same as gameplay
SUPER_AWAKENING_MENU_SWORD_SHIELD = TRUE

; Button prompts in the start menu (needs MENU_SWORD_SHIELD).
; TRUE  = A hides/shows the selected item, B swaps the sword and shield buttons,
;         X or Y puts the selected item on that button (its letter is shown next to it)
; FALSE = A and B both hide/show the selected item
SUPER_AWAKENING_MENU_MAPPING = TRUE

DEBUG_STARTING_HEARTS = 4 ; Value * 8 = Heart Count
DEBUG_MAX_HEARTS = 3
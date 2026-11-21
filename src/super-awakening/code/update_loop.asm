; main frame loop
SuperAwakening_UpdateLoop::
include "super-awakening/code/controller_read.asm"
include "super-awakening/code/button_swap.asm"
IF SUPER_AWAKENING_MENU_MAPPING
; The hotkeys write the B/A slots on every button press, which would
; overwrite the sword and shield the menu is showing
ld   a, [wGameplayType]
cp   GAMEPLAY_INVENTORY
jp   z, .skip_weapon_hotkeys
ENDC
include "super-awakening/code/weapon_hotkeys.asm"
.skip_weapon_hotkeys
include "super-awakening/code/controller_remap.asm"
include "super-awakening/code/weapon_change_v2.asm"
include "super-awakening/code/quickdash.asm"
include "super-awakening/code/select_hold_save.asm"

ret
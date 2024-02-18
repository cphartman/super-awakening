wSuperAwakening::
.Weapon_Start::
; This matches the wInventoryItems object, replaces it in DrawInventorySlots
.Weapon4_Value:: ; Sync'd to Weapon_Inventory[Weapon4_Inventory_Index]
  ; Only used for display purpose on the hud
  ds 1

  ; Only used for display purpose on the hud
.Weapon3_Value:: ; Sync'd to Weapon_Inventory[Weapon3_Inventory_Index]
  ds 1


; 0 - Use wInventoryItems in DrawInventorySlots
; 1 - Use wSuperAwakening.Weapon_Start in DrawInventorySlots
.OverrideInventoryDisplaySlots::
  ds 1

/*
; Values that the inventory will cycle through, also used to display on the pause screen
.Weapon_Inventory:
  ds INVENTORY_SLOT_COUNT - 2
*/
.Weapon4_Inventory_Index:
  ds 1

.Weapon3_Inventory_Index:
  ds 1

; Stores the address to use when drawing inventory slots
; Allows A/B to draw from wSuperAwakening and the inventory screen to draw from wInventoryItems
; not used, delete me
.DrawInventorySlots_pointer:
  ds 2

.QuickDash_Timer:
  ds 1

.QuickDash_Direction:
  ds 1

.JoypadState:
  ds 1 ; FFCC

.PressedButtonsMask:
  ds 1 ; FFCB

.JoypadState2:
  ds 1 ; FFCC

.PressedButtonsMask2:
  ds 1 ; FFCB

.Items_Unlocked:
  ds (INVENTORY_MAX+1)

.Items_Hidden:
  ds INVENTORY_SLOT_COUNT - 2

.Dash_Enabled:
  ds 1
.Jump_Enabled:
  ds 1
.Shield_Enabled:
  ds 1

.DemoMode_State:
  ds 1

.DemoMode_SubState:
  ds 1

; For temporarily storing data
.temp1:
  ds 1

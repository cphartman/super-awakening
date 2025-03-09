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
;.DrawInventorySlots_pointer:
;  ds 2

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

.dialog_backup:
  ds 1

.Tutorial_Status:
  ds 1

.Tutotial_FileText:
  ds 11

.Tutorial_ForceQuit:
  ds 1

.SGB_Packet:
.SGB_PacketCommand:
  ds 1
.SGB_PacketDest:
.SGB_PacketDest_Low:
  ds 1
.SGB_PacketDest_High:
  ds 1
.SGB_PacketDest_Bank:
  ds 1
.SGB_PacketLength:
  ds 1
.SGB_PacketData:
  ds 11

.SGB_Delay:
  ds 1

.SGB_SendPosition:
  ds 1

; We need a delay because room change is picked up before the room transition starts
; So when the room loads, a transition occurs and Link is in a new Y position
; This hack delays sending commands
.SGB_SendPosition_Delay:
  ds 1

.PreviousRoom:
  ds 1
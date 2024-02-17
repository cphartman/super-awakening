OVERRIDE_INVENTORY_MAX     equ $09

; [d] - inventory item to give
SuperAwakening_ShouldGiveInventoryItem::
    
    ; Bug:
    ;   Steps: Activate the owl on the sword screen, leave the screen and re-enter, pick up the sword
    ;   Steps: Enter the owl sword screen from the left
    ;   Actual: Link hold shield, game locks
    ;   Fix: It looks like [bc] stores the entity index of the sword pickup event. It needs to be restored
    push bc

    ; Sword and Shield are tracked outside of the inventory
    ld a, d
    cp INVENTORY_SWORD
    jp z, .return_no_item
    
    ld a, d
    cp INVENTORY_SHIELD
    jp z, .return_no_item


.GiveInventoryItem_end
jp .return

.return_no_item
    ; Set the item to empty so it will not be added to inventory
    ld d, 0

.return
    ; Restore bc, see note at start of file
    pop bc

    ld   a, BANK(GiveInventoryItem)
    jp SuperAwakening_Trampoline.returnToBank
    
SuperAwakening_RefreshInventoryItems::
/*
.EquipEmptyWeaponSlot_4
    ; Get weapon4 value
    ld a, [wSuperAwakening.Weapon4_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wInventoryItems.subscreen
    add hl, bc
    ld a, [hl]
    cp 0
    jp nz, .EquipEmptyWeaponSlot_3
    ; Force to slot 1?
    ld a, 0
    ld [wSuperAwakening.Weapon4_Inventory_Index], a

.EquipEmptyWeaponSlot_3
    ; Get weapon3 value
    ld a, [wSuperAwakening.Weapon3_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wInventoryItems.subscreen
    add hl, bc
    ld a, [hl]
    cp 0
    jp nz, .EquipEmptyWeaponSlot_end
    ; Force to slot 0?
    ld a, 1
    ld [wSuperAwakening.Weapon3_Inventory_Index], a

.EquipEmptyWeaponSlot_end
*/
.CheckDuplicateEquippedSlots
    ; Make sure the inventory slots don't point to the same value
    ld a, [wSuperAwakening.Weapon4_Inventory_Index]
    ld b, a
    ld a, [wSuperAwakening.Weapon3_Inventory_Index]
    cp b
    jp nz, .CheckDuplicateEquippedSlots_end
    ; Same slot equipped, increment weapon3 slot index to prevent duplicate
    inc a
    ; Check for overflow
    cp (OVERRIDE_INVENTORY_MAX+1)
    jp nz, .CheckDuplicateEquippedSlots_set
    ld a, 0
.CheckDuplicateEquippedSlots_set
    ld [wSuperAwakening.Weapon3_Inventory_Index], a
.CheckDuplicateEquippedSlots_end

.RefreshInventory
.RefreshInventory_3
    ; Inventory item may have change, so refresh their values and re-draw
    ld a, [wSuperAwakening.Weapon3_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wInventoryItems.subscreen
    add hl, bc
    ld a, [hl] ; Load inventory item at weapon3 index
    ld hl, wSuperAwakening.Weapon3_Value
    ld [hl], a ; Set item at weapon 3 value

    ; Inventory item may have change, so refresh their values and re-draw
    ld a, [wSuperAwakening.Weapon4_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wInventoryItems.subscreen
    add hl, bc
    ld a, [hl] ; Load inventory item at weapon4 index
    ld hl, wSuperAwakening.Weapon4_Value
    ld [hl], a ; Set item at weapon4 value

    ld   a, BANK(GiveInventoryItem)
    jp SuperAwakening_Trampoline.returnToBank
; [d] - inventory item to give
.GiveInventoryItem

.UnlockProgression
    ld b, $00
    ld c, d
    ld hl, wSuperAwakening.Items_Unlocked
    add hl, bc
    ld a, [hl]
    
    ; Check if this item is already unlocked
    cp 0
    jp nz, .GiveInventoryItem_end
    ld [hl], $01

.TryAddToInventory_init

    ; These are invalid inventory items
    ld a, d
    cp INVENTORY_EMPTY
    jp z, .GiveInventoryItem_end
    cp INVENTORY_SWORD
    jp z, .GiveInventoryItem_end
    cp INVENTORY_SHIELD
    jp z, .GiveInventoryItem_end
    cp INVENTORY_PEGASUS_BOOTS
    jp z, .GiveInventoryItem_end

    ld hl, wSuperAwakening.Weapon_Inventory
    ld c, $FF ; counter, offset to -1 for the initial increment
.TryAddToInventory_loop
    ; This should never occur, when will you add more items then can fit in the inventory?
    inc c
    ld a, c
    cp (INVENTORY_MAX-2)
    jp z, .GiveInventoryItem_end

    ld a, [hl]
    cp 0
    jp z, .TryAddToInventory_SetValue
    ldi a, [hl] ; Just used to increment [hl]...
    jp .TryAddToInventory_loop
.TryAddToInventory_SetValue
    ld a, d
    ld [hl], d

.TryAddToInventory_end


.EquipEmptyWeaponSlot
.EquipEmptyWeaponSlot_3
    ; Get weapon3 value
    ld a, [wSuperAwakening.Weapon3_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl]
    cp 0
    jp nz, .EquipEmptyWeaponSlot_4
    ; Force to slot 0?
    ld a, 0
    ld [wSuperAwakening.Weapon3_Inventory_Index], a

.EquipEmptyWeaponSlot_4
    ; Get weapon3 value
    ld a, [wSuperAwakening.Weapon4_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl]
    cp 0
    jp nz, .EquipEmptyWeaponSlot_end
    ; Force to slot 1?
    ld a, 1
    ld [wSuperAwakening.Weapon4_Inventory_Index], a
.EquipEmptyWeaponSlot_end

.CheckDuplicateEquippedSlots
    ; Make sure the inventory slots don't point to the same value
    ld a, [wSuperAwakening.Weapon4_Inventory_Index]
    ld b, a
    ld a, [wSuperAwakening.Weapon3_Inventory_Index]
    cp b
    jp nz, .CheckDuplicateEquippedSlots_end
    ; Same slot equipped, increment weapon4 slot index to prevent duplicate
    inc a
    ; Check for overflow
    cp (OVERRIDE_INVENTORY_MAX+1)
    jp nz, .CheckDuplicateEquippedSlots_set
    ld a, 0
.CheckDuplicateEquippedSlots_set
    ld [wSuperAwakening.Weapon4_Inventory_Index], a
.CheckDuplicateEquippedSlots_end

.RefreshInventory
.RefreshInventory_3
    ; Inventory item may have change, so refresh their values and re-draw
    ld a, [wSuperAwakening.Weapon3_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl] ; Load inventory item at weapon3 index
    ld hl, wSuperAwakening.Weapon3_Value
    ld [hl], a ; Set item at weapon 3 value

    ; Inventory item may have change, so refresh their values and re-draw
    ld a, [wSuperAwakening.Weapon4_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl] ; Load inventory item at weapon4 index
    ld hl, wSuperAwakening.Weapon4_Value
    ld [hl], a ; Set item at weapon4 value


.GiveInventoryItem_end
    ret
    
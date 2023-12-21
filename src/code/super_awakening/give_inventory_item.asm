; [d] - inventory item to give
.GiveInventoryItem
.UnlockProgression
    ld b, $00
    ld c, d
    ld hl, wSuperAwakening.Items_Unlocked
    add hl, bc
    ld [hl], $01

.TryAddToInventory

    ; These are invalid inventory items
    ld a, d
    cp INVENTORY_EMPTY
    jp z, .TryAddToInventory_end
    cp INVENTORY_SWORD
    jp z, .TryAddToInventory_end
    cp INVENTORY_SHIELD
    jp z, .TryAddToInventory_end
    cp INVENTORY_PEGASUS_BOOTS
    jp z, .TryAddToInventory_end

    ld hl, wSuperAwakening.Weapon_Inventory
    ld c, $FF ; counter, offset to -1 for the initial decrement
.InventoryAddCheckLoop
    inc c
    ld a, c
    cp (INVENTORY_MAX-2)
    jp z, .InventoryAddCheckLoop_end

    ld a, [hl]
    cp 0
    jp z, .DoAddToInventory
    ldi a, [hl] ; Just used to increment [hl]...
    jp .InventoryAddCheckLoop

.DoAddToInventory
    ld a, d
    ld [hl], d

    ld a, c
    cp 0
    jp z, .RefreshInventory
    cp 1
    jp z, .RefreshInventory
    jp .InventoryAddCheckLoop_end

.RefreshInventory
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

.InventoryAddCheckLoop_end
.TryAddToInventory_end
    ret
    
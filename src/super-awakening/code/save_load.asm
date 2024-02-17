SuperAwakening_Load::
    /*
    ; inventory index counter
    ld b, $00
    ld c, (INVENTORY_BOMBS-1) ; Start from first item - 1

    ; inventory slot index counter
    ld d, $00
    ld e, $00 ; Start from first item - 1

.load_loop
    ; Increment the index counter
    inc c

    ; Check if we're done with the inventory
    ld a, c
    cp (INVENTORY_MAX+1)
    jp z, .load_loop_end

    ; Load Inventory Item
    ld hl, (wInventoryItems-2)
    add hl, bc
    ld a, [hl]

    ; Check if shield
    cp INVENTORY_SHIELD
    jp z, .load_loop_add_to_progression

    ; Check if boots
    cp INVENTORY_PEGASUS_BOOTS
    jp z, .load_loop_add_to_progression

    ; Check if item is unlocked
    cp 0
    jp z, .load_loop_add_to_progression

.load_loop_add_to_inventory_slot
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, de
    inc e
    ld [hl], a
    jp .load_loop_add_to_progression

.load_loop_add_to_progression
    cp 0
    jp z, .load_loop_add_to_progression_assign
    ld a, 1
.load_loop_add_to_progression_assign
    ld hl, wSuperAwakening.Items_Unlocked
    add hl, bc
    ld [hl], a
    jp .load_loop

.load_loop_end

    ld a, [wSuperAwakening.Weapon_Inventory]
    ld [wSuperAwakening.Weapon4_Value], a
    ld a, [wSuperAwakening.Weapon_Inventory+1]
    ld [wSuperAwakening.Weapon3_Value], a
*/
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

; Save progression items into inventory slots
; Map $02-$0D of wSuperAwakening.Items_Unlocked
; to $00-$0C of wInventoryItems
SuperAwakening_Save::

    ; index counter
    ld b, $00
    ld c, (INVENTORY_BOMBS-1) ; Start from first item - 1
    
.save_loop

    ; Increment the counter
    inc c

    ; Check if we're done with the inventory
    ld a, c
    cp (INVENTORY_MAX+1)
    jp z, .save_loop_end

    ; Load wSuperAwakening.Items_Unlocked
    ld hl, (wSuperAwakening.Items_Unlocked)
    add hl, bc
    ld a, [hl]

    ; Check if item is unlocked
    cp 0
    ld d, c ; store inventory index into [d]
    jp nz, .save_loop_assign
    ld d, 0 ; no item, so put 0 in [d]

    ; Load progression value
.save_loop_assign
    ld hl, (wInventoryItems-2) ; Index starts at $02
    add hl, bc
    ld [hl], d ; [c] is the item index
    jp .save_loop

.save_loop_end
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank
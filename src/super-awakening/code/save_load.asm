SuperAwakening_Load::
    
    ; Loop inventory to check for progression flags
.initialize_progression_flags
    ld c, 0
    ld hl, wInventoryItems.subscreen
        
    .initialize_progression_flags_loop
        ; Loop counter logic
        inc c
        ld a, c
        cp (SUPER_AWAKENING_INVENTORY_SLOT_COUNT+1)
        jp z, .initialize_progression_flags_loop_end

        ; Load the inventory item
        ld a, [hl+]

        ; Check for jump unlock
    .initialize_progression_flags_jump
        cp INVENTORY_ROCS_FEATHER
        jp nz, .initialize_progression_flags_jump_end
        ld a, 1
        ld [wSuperAwakening.Jump_Enabled], a
        jp .initialize_progression_flags_loop
    .initialize_progression_flags_jump_end

        ; Check for dash unlock
    .initialize_progression_flags_dash
        cp INVENTORY_PEGASUS_BOOTS
        jp nz, .initialize_progression_flags_loop
        ld a, 1
        ld [wSuperAwakening.Dash_Enabled], a
        jp .initialize_progression_flags_loop

    .initialize_progression_flags_loop_end
.initialize_progression_flags_end

    ; Initialize weapon index and values
.initalize_weapon_4
    ld a, $00
    ld [wSuperAwakening.Weapon4_Inventory_Index], a
    ld a, [wInventoryItems.subscreen]
    ld [wSuperAwakening.Weapon4_Value], a

.initalize_weapon_3
    ld a, $01
    ld [wSuperAwakening.Weapon3_Inventory_Index], a
    ld a, [wInventoryItems.subscreen+1]
    ld [wSuperAwakening.Weapon3_Value], a

.return
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank

; Save progression items into inventory slots
; Map $02-$0D of wSuperAwakening.Items_Unlocked
; to $00-$0C of wInventoryItems
SuperAwakening_Save::
/*
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
*/
.save_loop_end
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank
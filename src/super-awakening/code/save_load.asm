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

SuperAwakening_Save::
    ; Doesn't do anything right now
.save_loop_end
    ld a, $01
    jp SuperAwakening_Trampoline.returnToBank
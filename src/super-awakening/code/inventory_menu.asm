
SuperAwakening_Inventory::
    ; Handle inventory select code
.awakening_inventory_select:
    
.awakening_inventory_select_next
    ; Check for next pressed
    ldh  a, [hJoypadState]
    and  J_A
    cp J_A
    jp nz, .awakening_inventory_select_next_end

    ; Load inventory address into HL
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Weapon_Inventory
    ld c, a
    ld b, $00
    add  hl, bc
    
; in: reg_a = initial inventory.  
; out: reg_b = final inventory value
; increments until it doesnt match any .Weapon_Inventory values or 0
    ld a, [hl]
    ld [hl], $00 ; clear the inventory value
.awakening_inventory_select_next_loop
    inc a

    cp (INVENTORY_MAX+1); Check for overflow
    jp nz, .awakening_inventory_select_next_loop_test
    ; empty inventory is always valid
    ld b, 0
    jp .awakening_inventory_select_next_loop_end

; test weaponVal
.awakening_inventory_select_next_loop_test
    cp INVENTORY_SWORD
    jp z, .awakening_inventory_select_next_loop

    cp INVENTORY_SHIELD
    jp z, .awakening_inventory_select_next_loop

    cp INVENTORY_PEGASUS_BOOTS
    jp z, .awakening_inventory_select_next_loop

IF SUPER_AWAKENING_RESTRICT_INVENTORY_ITEMS
    ; Check if this item is unlocked
    ld hl, wSuperAwakening.Items_Unlocked
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl] ; Get the unlocked state of the item
    cp $01 ; Test if this item is unlocked
    ld a, c ; Put the target item index back into [a]
    jp nz, .awakening_inventory_select_next_loop
ENDC

    ld b, a ; reg_b holds desired inventory value (not empty)
    ld hl, wSuperAwakening.Weapon_Inventory
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 1
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 2
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 3
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 4
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 5
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 6
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 7
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 8
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 9
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_next_loop ; inventory 10

; store weaponVal
.awakening_inventory_select_next_loop_end
    ; Load inventory address into HL
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Weapon_Inventory
    ld e, a
    ld d, $00
    add  hl, de

    ld  [hl], b ; store incremented weapon value into inventory

.awakening_inventory_select_next_refresh
    ; Redraw this inventory tile
    ld   a, [wInventorySelection]
    inc a
    ld e, a
    inc a
    ld c, a
    ld b, $00
    call SuperAwakening_Trampoline.jumpToDrawInventorySlots

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
 
    ; Refresh A/B inventory tiles
    ld b, $00
    ld c, $01
    ld e, $FF
    call SuperAwakening_Trampoline.jumpToDrawInventorySlots
.awakening_inventory_select_next_refresh_end

.awakening_inventory_select_next_end

.awakening_inventory_select_prev
    ; Check for prev pressed
    ldh  a, [hJoypadState]
    and  J_B
    cp J_B
    jp nz, .awakening_inventory_select_prev_end

    ; Load inventory address into HL
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Weapon_Inventory
    ld c, a
    ld b, $00
    add  hl, bc
    
; in: reg_a = initial inventory.  
; out: reg_b = final inventory value
; increments until it doesnt match any .Weapon_Inventory values or 0
    ld a, [hl]
    ld [hl], $00 ; clear the inventory value
.awakening_inventory_select_prev_loop
    dec a
    ld b, a
    cp $00
    jp z, .awakening_inventory_select_prev_loop_end  ; empty inventory is always valid

    ; Check for out of bounds
    cp $FF
    jp nz, .awakening_inventory_select_prev_loop_test  ; loop
    ld a, INVENTORY_MAX

; test weaponVal
.awakening_inventory_select_prev_loop_test
    cp INVENTORY_SWORD
    jp z, .awakening_inventory_select_prev_loop

    cp INVENTORY_SHIELD
    jp z, .awakening_inventory_select_prev_loop

    cp INVENTORY_PEGASUS_BOOTS
    jp z, .awakening_inventory_select_prev_loop

IF SUPER_AWAKENING_RESTRICT_INVENTORY_ITEMS
    ; Check if this item is unlocked
    ld hl, wSuperAwakening.Items_Unlocked
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl] ; Get the unlocked state of the item
    cp $01 ; Test if this item is unlocked
    ld a, c ; Put the target item index back into [a]
    jp nz, .awakening_inventory_select_prev_loop
ENDC

    ld b, a ; reg_b holds desired inventory value (not empty)
    ld hl, wSuperAwakening.Weapon_Inventory
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 1
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 2
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 3
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 4
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 5
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 6
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 7
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 8
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 9
    ldi a, [hl]
    cp b
    jp z, .awakening_inventory_select_prev_loop ; inventory 10

; store weaponVal
.awakening_inventory_select_prev_loop_end
    ; Load inventory address into HL
    ld   a, [wInventorySelection]
    ld   hl, wSuperAwakening.Weapon_Inventory
    ld e, a
    ld d, $00
    add  hl, de

    ld  [hl], b ; store incremented weapon value into inventory

.awakening_inventory_select_prev_refresh
    ; Redraw this inventory tile
    ld   a, [wInventorySelection]
    inc a
    ld e, a
    inc a
    ld c, a
    ld b, $00
    call SuperAwakening_Trampoline.jumpToDrawInventorySlots

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
 
    ; Refresh A/B inventory tiles
    ld b, $00
    ld c, $01
    ld e, $FF
    call SuperAwakening_Trampoline.jumpToDrawInventorySlots
.awakening_inventory_select_prev_refresh_end

.awakening_inventory_select_prev_end


.awakening_inventory_select_end
    ld a, BANK(InventoryEntryPoint)
    jp SuperAwakening_Trampoline.returnToBank

.awakening_inventory_close

    ld a, BANK(InventoryEntryPoint)
    jp SuperAwakening_Trampoline.returnToBank

.awakening_inventory_open:

    ld a, BANK(InventoryEntryPoint)
    jp SuperAwakening_Trampoline.returnToBank
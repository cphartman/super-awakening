;
; Weapon Hotkeys
; P1_A => Shield => B Slot
; P1_B => Sword => B Slot
; P2_A => Weapon 3 => A Slot
; P2_B => Weapon 4 => A Slot
;

.use_weapon_shield

    ; Check for button input
    ldh  a, [hJoypadState]                    
    and  J_A
    cp J_A
    jp nz, .use_weapon_shield_end

    ; Set weapon Slot B
    ld hl, wInventoryItems.BButtonSlot
    ld [hl], INVENTORY_SHIELD

.use_weapon_shield_end

.use_weapon_sword

    ; Check for button input
    ldh  a, [hJoypadState]                    
    and  J_B
    cp J_B
    jp nz, .use_weapon_sword_end

    ; Check if sword is enabled
    ld  a, [wSwordLevel]
    and a
    ld a, INVENTORY_SWORD ; [a] will be the slot item we set
if SUPER_AWAKENING_RESTRICT_INVENTORY_ITEMS
    jp nz, .use_weapon_2_update_inventory
    ; We don't have a sword level, so set the slot item to empty
    ld a, INVENTORY_EMPTY
ENDC
.use_weapon_2_update_inventory
    ; Set weapon Slot B
    ld hl, wInventoryItems.BButtonSlot
    ld [hl], a

.use_weapon_sword_end

.use_weapon_3
    
    ; Check for button input on weapon3
    ldh  a, [hJoypadState2]                    
    and  J_A
    cp J_A
    jp nz, .use_weapon_3_end

    ; Set weapon Slot A
    ld a, [wSuperAwakening.Weapon3_Value]
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a

.use_weapon_3_end

.use_weapon_4
    
    ; Check for button input on weapon4
    ldh  a, [hJoypadState2]                    
    and  J_B
    cp J_B
    jp nz, .use_weapon_4_end

    ; Set weapon Slot A
    ld a, [wSuperAwakening.Weapon4_Value] ; get inventory index
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a ; load new inventory value

.use_weapon_4_end

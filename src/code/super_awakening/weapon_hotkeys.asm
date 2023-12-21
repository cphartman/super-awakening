;
; Weapon Hotkeys
; P2_Right => Weapon 1 => B Slot
; P2_Down => Weapon 2 => B Slot
; P2_Up => Weapon 3 => A Slot
; P2_Left => Weapon 4 => A Slot
;

.use_weapon_1

    ; Check for button input on weapon1
    ldh  a, [hJoypadState2]                    
    and  J_RIGHT
    cp J_RIGHT
    jp nz, .use_weapon_1_end

    ; Set weapon Slot B
    ld hl, wInventoryItems.BButtonSlot
    ld [hl], INVENTORY_SHIELD

.use_weapon_1_end

.use_weapon_2

    ; Check for button input on weapon2
    ldh  a, [hJoypadState2]                    
    and  J_DOWN
    cp J_DOWN
    jp nz, .use_weapon_2_end

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

.use_weapon_2_end

.use_weapon_3
    
    ; Check for button input on weapon3
    ldh  a, [hJoypadState2]                    
    and  J_UP
    cp J_UP
    jp nz, .use_weapon_3_end

    ; Set weapon Slot A
    ld a, [wSuperAwakening.Weapon3_Value]
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a

.use_weapon_3_end

.use_weapon_4
    
    ; Check for button input on weapon4
    ldh  a, [hJoypadState2]                    
    and  J_LEFT
    cp J_LEFT
    jp nz, .use_weapon_4_end

    ; Set weapon Slot A
    ld a, [wSuperAwakening.Weapon4_Value] ; get inventory index
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a ; load new inventory value

.use_weapon_4_end

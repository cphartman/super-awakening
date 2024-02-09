;
; Change Weapon Hotkeys
; Inventory v2
;
SuperAwakening_ChangeWeapon_v2::
    ; Skip all of this if we're not in the overworld
    ld a, [wGameplayType]
    cp GAMEPLAY_WORLD
    jp nz, return

; Parameters
; change_weapon( Weapon_Number, Button )
MACRO change_weapon
change_weapon_\1: 

    .next_weapon_\1

        ; Check for button press
        ld a, [wSuperAwakening.JoypadState2]
        and \2
        cp \2
        jp nz, .change_weapon_\1_end


        ; while( d < SUPER_AWAKENING_INVENTORY_SLOT_COUNT+1 )
        ld d, 0 
    .next_weapon_\1_loop
        
        ; Exit if we've looped the entire inventory
        inc d
        ld a, d
        cp (SUPER_AWAKENING_INVENTORY_SLOT_COUNT + 1)
        jp z, .next_weapon_\1_loop_abort

        ; Next weapon index
        ld  a, [wSuperAwakening.Weapon\1_Inventory_Index]
        inc a

        ; Check for weapon index overflow
        cp SUPER_AWAKENING_INVENTORY_SLOT_COUNT ; check if we're beyond the inventory max
        jp nz, .next_weapon_\1_test
        ld a, 0

    .next_weapon_\1_test
        ; Store the index to RAM and [bc]
        ld  [wSuperAwakening.Weapon\1_Inventory_Index], a
        ld c, a
        ld b, $00

        ; Check if weapon is hidden in inventory
        ld hl, wSuperAwakening.Items_Hidden
        add hl, bc
        ld a, [hl]
        cp 1
        jp z, .next_weapon_\1_loop

        ; Load weapon from inventory slot
        ld hl, wInventoryItems.subscreen
        add hl, bc
        ld a, [hl]

        ; Skip if there is no weapon in the inventory slot
        cp INVENTORY_EMPTY
        jp z, .next_weapon_\1_loop

        ; Set the weapon and exit
        ld [wSuperAwakening.Weapon\1_Value], a
        jp return

    .next_weapon_\1_end

    .next_weapon_\1_loop_abort
    ; Check if weapon is hidden in inventory
    ld a, [wSuperAwakening.Weapon\1_Inventory_Index]
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Items_Hidden
    add hl, bc
    ld a, [hl]
    cp 0
    jp z, return
    ; Looped the entire inventory back to the orignial index, but the weapon is hidden
    ld a, 0
    ld [wSuperAwakening.Weapon\1_Value], a
    jp return

.change_weapon_\1_end
ENDM

    change_weapon 3,J_RIGHT
    change_weapon 4,J_LEFT


return:
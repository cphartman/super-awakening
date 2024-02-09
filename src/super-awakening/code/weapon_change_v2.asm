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
; change_weapon( Weapon_Number, Button, Other_Weapon_Number )
MACRO change_weapon
change_weapon_\1: 

    .next_weapon_\1

        ; Check for button press
        ld a, [wSuperAwakening.JoypadState2]
        and \2
        cp \2
        jp nz, .change_weapon_\1_end

        ; Check if the orcarina index should be incremented
    .ocarina_\1
        ; Check if we have ocarina equiped
        ld hl, wSuperAwakening.Weapon\1_Value
        ld a, [hl]
        cp INVENTORY_OCARINA
        jp nz, .ocarina_\1_end

        ; Check if we're already on the last song
        ld a, [wSelectedSongIndex]
        cp SONG_SELECTED_INDEX_MAX
        jp z, .ocarina_\1_reset

        ; Increment the song index
        inc a
        ld [wSelectedSongIndex], a

    .ocarina_\1_test_song_2
        ; Check if we're trying to switch to song 2
        cp MANBO_MAMBO_SELECTED_INDEX
        jp nz, .ocarina_\1_test_song_3
        ; Check if we have song 2 unlocked
        ld a, [wOcarinaSongFlags]
        and MANBO_MAMBO_FLAG
        cp MANBO_MAMBO_FLAG
        jp nz, .ocarina_\1_test_song_2_locked
        ; Song is unlocked, we can exit
        jp return

    .ocarina_\1_test_song_2_locked
        ; Song 2 is locked, so see if we can use song 3
        ld a, FROGS_SONG_OF_THE_SOUL_SELECTED_INDEX
        ld [wSelectedSongIndex], a
        
    .ocarina_\1_test_song_3
        ; Check if we have song 3 unlocked
        ld a, [wOcarinaSongFlags]
        and FROGS_SONG_OF_THE_SOUL_FLAG
        cp FROGS_SONG_OF_THE_SOUL_FLAG
        jp nz, .ocarina_\1_reset ; Song 3 not unlocked, reset the song index
        ; Song is unlocked, we can exit
        jp return

    .ocarina_\1_reset
    
    ; check if no songs unlocked
    .ocarina_\1_reset_song_0
        ld a, [wOcarinaSongFlags]
        cp $00
        jp nz, .ocarina_\1_reset_song_1
        ld hl, wSelectedSongIndex
        ld [hl], 0
        jp .ocarina_\1_end
    
    ; Check if song 1 is unlocked
    .ocarina_\1_reset_song_1
        ld a, [wOcarinaSongFlags]
        and BALLAD_OF_THE_WIND_FISH_FLAG
        cp BALLAD_OF_THE_WIND_FISH_FLAG
        jp nz, .ocarina_\1_reset_song_2
        ld hl, wSelectedSongIndex
        ld [hl], BALLAD_OF_THE_WIND_FISH_SELECTED_INDEX
        jp .ocarina_\1_end

    ; Check if song 1 is unlocked
    .ocarina_\1_reset_song_2
        ld a, [wOcarinaSongFlags]
        and MANBO_MAMBO_FLAG
        cp MANBO_MAMBO_FLAG
        jp nz, .ocarina_\1_reset_song_3
        ld hl, wSelectedSongIndex
        ld [hl], MANBO_MAMBO_SELECTED_INDEX
        jp .ocarina_\1_end

    ; If you don't have none, 1 or 2, you must have song 3 (...?)
    .ocarina_\1_reset_song_3
        ld hl, wSelectedSongIndex
        ld [hl], FROGS_SONG_OF_THE_SOUL_SELECTED_INDEX

.ocarina_\1_end

        ; Try to increment the weapon index
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
        ; Store the index to RAM
        ld  [wSuperAwakening.Weapon\1_Inventory_Index], a

        ; Check if this is the same index as the other weapon index
        ld hl, wSuperAwakening.Weapon\3_Inventory_Index
        ld b, [hl]
        cp b
        jp z, .next_weapon_\1_loop

        ; Check if weapon is hidden in inventory
        ld hl, wSuperAwakening.Items_Hidden
        ld c, a ; [a] is the weapon index
        ld b, $00
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

    change_weapon 3,J_RIGHT,4
    change_weapon 4,J_LEFT,3


return:
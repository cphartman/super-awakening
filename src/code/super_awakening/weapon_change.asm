;
; Change Weapon Hotkeys
;
    ; Skip all of this if we're not in the overworld
    ld a, [wGameplayType]
    cp GAMEPLAY_WORLD
    jp nz, .change_weapon4_end

.change_weapon3
.dec_weapon3
    ; Check for both buttons button down
    ld a, [wSuperAwakening.PressedButtonsMask2]
    and (J_RIGHT | J_A)
    cp  (J_RIGHT | J_A)
    jp nz, .dec_weapon3_end

    ; check if a toggled this frame
    ld a, [wSuperAwakening.JoypadState2]
    and J_A
    cp  J_A
    jp z, .dec_weapon3_loop
    
    jp .dec_weapon3_end ; This is a double-hold frame, not a toggle frame, do nothing

    ld d, $00 ; reg_d is a loop counter
.dec_weapon3_loop
    inc d
    ld a, d
    cp $0A
    jp z, .dec_weapon3_end

; next weapon index
    ld  a, [wSuperAwakening.Weapon3_Inventory_Index]
    dec a
    cp $FF ; check if we're wraped below 0
    jp nz, .dec_weapon3_loop_store
    ld a, OVERRIDE_INVENTORY_MAX
; store weaponVal
.dec_weapon3_loop_store
    ld  [wSuperAwakening.Weapon3_Inventory_Index], a
; get weapon val
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl]
; test weaponVal
    ; test weapon 4
    ld hl, wSuperAwakening.Weapon4_Value
    cp [hl] ; Check if this is weapon3
    jp z, .dec_weapon3_loop

    ; Check if this inventory slot is empty
    cp INVENTORY_EMPTY
    jp z, .dec_weapon3_loop

.dec_weapon3_loop_end
    ; a is the new value, b is the new inventory index value
    ; write weapon3 value to display
    ld hl, wSuperAwakening.Weapon3_Value
    ld [hl], a

    jp .change_weapon3_end ; Skip the increment check
.dec_weapon3_end


.inc_weapon3
    ; Check for button press
    ld a, [wSuperAwakening.JoypadState2]
    and J_RIGHT
    cp J_RIGHT
    jp nz, .inc_weapon3_end

; If we already have the ocarina equiped
;   increment the song counter
;       if the song counter overflows
;           reset the song counter
;           do increment the weapon counter
;       else
;          skip increment the weapon conter
.inc_weapon3_ocarina
    ; Check if we have ocarina equiped
    ld hl, wSuperAwakening.Weapon3_Value
    ld a, [hl]
    cp INVENTORY_OCARINA
    jp nz, .inc_weapon3_ocarina_end

    ; Get the ocarina counter
 .inc_weapon3_ocarina_inc_loop
    ; Increment the song index
    ld hl, wSelectedSongIndex
    ld a, [hl]
    inc a
    ld [hl], a

    ; Check if we've overflowed
    cp $03
    jp z, .inc_weapon3_reset_song

    ; Check if we're on song 3
.inc_weapon3_ocarina_validate_song_3
    cp FROGS_SONG_OF_THE_SOUL_SELECTED_INDEX ; song is 0 indexed
    jp nz, .inc_weapon3_ocarina_validate_song_2
    ; Check if we have song 3 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon3_reset_song ; Song 3 not unlocked, continue to next weapon
    jp .inc_weapon3_end ; Song is unlocked, keep the song index

    ; Check if we're on song 2
.inc_weapon3_ocarina_validate_song_2
    cp MANBO_MAMBO_SELECTED_INDEX ; song is 0 indexed
    jp nz, .inc_weapon3_reset_song ; I'm noty sure this case is ever hit?
    ; Check if we have song 2 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and MANBO_MAMBO_FLAG
    cp MANBO_MAMBO_FLAG
    jp nz, .inc_weapon3_ocarina_inc_loop ; Song 3 not unlocked, loop
    jp .inc_weapon3_end ; Song is unlocked, keep the song index

; We will never switch to song 1 in here because it should always start from at least 1

.inc_weapon3_reset_song
    ; We overflowd the song index, reset to the first unlocked song

; check if no songs unlocked
.inc_weapon3_reset_song_0
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    cp $00
    jp nz, .inc_weapon3_reset_song_1
    ld hl, wSelectedSongIndex
    ld [hl], 0
    jp .inc_weapon3_ocarina_end
    
    ; Check if song 0 is unlocked
.inc_weapon3_reset_song_1
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon3_reset_song_2
    ld hl, wSelectedSongIndex
    ld [hl], FROGS_SONG_OF_THE_SOUL_SELECTED_INDEX
    jp .inc_weapon3_ocarina_end

    ; Check if song 1 is unlocked
.inc_weapon3_reset_song_2
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and MANBO_MAMBO_FLAG
    cp MANBO_MAMBO_FLAG
    jp nz, .inc_weapon3_reset_song_3
    ld hl, wSelectedSongIndex
    ld [hl], MANBO_MAMBO_SELECTED_INDEX
    jp .inc_weapon3_ocarina_end

    ; If you don't have none, 1 or 2, you must have song 3 (...?)
.inc_weapon3_reset_song_3
    ld hl, wSelectedSongIndex
    ld [hl], BALLAD_OF_THE_WIND_FISH_SELECTED_INDEX

.inc_weapon3_ocarina_end


    ld d, 0 ; reg_d will be a counter to prevent infinite looping
.inc_weapon3_loop
    inc d
    ld a, d
    cp $0A
    jp z, .inc_weapon3_end
; next weapon index
    ld  a, [wSuperAwakening.Weapon3_Inventory_Index]
    inc a
    cp (OVERRIDE_INVENTORY_MAX+1) ; check if we're beyond the inventory max
    jp nz, .inc_weapon3_loop_store
    ld a, 0
; store weapon index
.inc_weapon3_loop_store
    ld  [wSuperAwakening.Weapon3_Inventory_Index], a
; get weapon val
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl]
; test weapon Val is valid
    ; test weapon 4
    ld hl, wSuperAwakening.Weapon4_Value
    cp [hl] ; Check if this is weapon3
    jp z, .inc_weapon3_loop

    ; Check if this inventory slot is empty
    cp INVENTORY_EMPTY
    jp z, .inc_weapon3_loop
    
.inc_weapon3_loop_end
    ; a is the new value, b is the new inventory index value
    ; write weapon3 value to display
    ld hl, wSuperAwakening.Weapon3_Value
    ld [hl], a

.inc_weapon3_end
.change_weapon3_end


.change_weapon4
.dec_weapon4
    ; Check for both buttons button down
    ld a, [wSuperAwakening.PressedButtonsMask2]
    and (J_LEFT | J_B) 
    cp  (J_LEFT | J_B) 
    jp nz, .dec_weapon4_end

    ; check if b toggled this frame
    ld a, [wSuperAwakening.JoypadState2]
    and J_B
    cp  J_B
    jp z, .dec_weapon4_loop
    
    jp .dec_weapon4_end ; This is a double-hold frame, not a toggle frame, do nothing

    ld d, $00 ; d is a loop counter
.dec_weapon4_loop
    inc d
    ld a, d
    cp $0A
    jp z, .dec_weapon4_end

; next weapon index
    ld  a, [wSuperAwakening.Weapon4_Inventory_Index]
    dec a
    cp $FF ; check if we're wraped below 0
    jp nz, .dec_weapon4_loop_store
    ld a, OVERRIDE_INVENTORY_MAX
; store weaponVal
.dec_weapon4_loop_store
    ld  [wSuperAwakening.Weapon4_Inventory_Index], a
; get weapon val
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl]
; test weaponVal
    ; test weapon 4
    ld hl, wSuperAwakening.Weapon3_Value
    cp [hl] ; Check if this is weapon4
    jp z, .dec_weapon4_loop

    ; Check if this inventory slot is empty
    cp INVENTORY_EMPTY
    jp z, .dec_weapon4_loop

.dec_weapon4_loop_end
    ; a is the new value, b is the new inventory index value
    ; write weapon4 value to display
    ld hl, wSuperAwakening.Weapon4_Value
    ld [hl], a

    jp .change_weapon4_end ; Skip the increment check
.dec_weapon4_end


.inc_weapon4
    ; Check for button press
    ld a, [wSuperAwakening.JoypadState2]
    and J_LEFT
    cp J_LEFT
    jp nz, .inc_weapon4_end

; If we already have the ocarina equiped
;   increment the song counter
;       if the song counter overflows
;           reset the song counter
;           do increment the weapon counter
;       else
;          skip increment the weapon conter
.inc_weapon4_ocarina
    ; Check if we already have ocarina equiped
    ld hl, wSuperAwakening.Weapon4_Value
    ld a, [hl]
    cp INVENTORY_OCARINA
    jp nz, .inc_weapon4_ocarina_end

; We have the orcarina equipped, check for incrementing the song
 .inc_weapon4_ocarina_inc_loop
    ; Increment the song index
    ld hl, wSelectedSongIndex
    ld a, [hl]
    inc a
    ld [hl], a

    ; Check if we've overflowed
    cp $03
    jp z, .inc_weapon4_reset_song

    ; Check if we're on song 3
.inc_weapon4_ocarina_validate_song_3
    cp FROGS_SONG_OF_THE_SOUL_SELECTED_INDEX ; song is 0 indexed
    jp nz, .inc_weapon4_ocarina_validate_song_2
    ; Check if we have song 3 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon4_reset_song ; Song 3 not unlocked, reset song and continue to next
    jp .inc_weapon4_end ; Song is unlocked, keep the song index

    ; Check if we're on song 2
.inc_weapon4_ocarina_validate_song_2
    cp MANBO_MAMBO_SELECTED_INDEX ; song is 0 indexed
    jp nz, .inc_weapon4_reset_song ; I'm noty sure this case is ever hit?
    ; Check if we have song 2 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and MANBO_MAMBO_FLAG
    cp MANBO_MAMBO_FLAG
    jp nz, .inc_weapon4_ocarina_inc_loop ; Song 3 not unlocked, loop
    jp .inc_weapon4_end ; Song is unlocked, keep the song index

    ; Check if we're on song 1
.inc_weapon4_ocarina_validate_song_1
    ; Check if we have song 1 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon4_ocarina_inc_loop ; Song 3 not unlocked, loop
    jp .inc_weapon4_end ; Song is unlocked, keep the song index

.inc_weapon4_reset_song
    ; We overflowd the song index, reset to the first unlocked song

; check if no songs unlocked
.inc_weapon4_reset_song_0
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    cp $00
    jp nz, .inc_weapon4_reset_song_1
    ld hl, wSelectedSongIndex
    ld [hl], 0
    jp .inc_weapon4_ocarina_end

    ; Check if song 1 is unlocked
.inc_weapon4_reset_song_1
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon4_reset_song_2
    ld hl, wSelectedSongIndex
    ld [hl], FROGS_SONG_OF_THE_SOUL_SELECTED_INDEX
    jp .inc_weapon4_ocarina_end

    ; Check if song 2 is unlocked
.inc_weapon4_reset_song_2
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and MANBO_MAMBO_FLAG
    cp MANBO_MAMBO_FLAG
    jp nz, .inc_weapon4_reset_song_3
    ld hl, wSelectedSongIndex
    ld [hl], MANBO_MAMBO_SELECTED_INDEX
    jp .inc_weapon4_ocarina_end

    ; If you don't have 0, 1 or 2, you must have song 3 (...?)
.inc_weapon4_reset_song_3
    ld hl, wSelectedSongIndex
    ld [hl], BALLAD_OF_THE_WIND_FISH_SELECTED_INDEX

.inc_weapon4_ocarina_end


    ld d, 0 ; reg_d is a loop counter
.inc_weapon4_loop
    inc d
    ld a, d
    cp $0A
    jp z, .inc_weapon4_end

; next weapon index
    ld  a, [wSuperAwakening.Weapon4_Inventory_Index]
    inc a
    cp (OVERRIDE_INVENTORY_MAX+1) ; check if we're beyond the inventory max
    jp nz, .inc_weapon4_loop_store
    ld a, 0
; store weapon index
.inc_weapon4_loop_store
    ld  [wSuperAwakening.Weapon4_Inventory_Index], a
; get weapon val
    ld c, a
    ld b, $00
    ld hl, wSuperAwakening.Weapon_Inventory
    add hl, bc
    ld a, [hl]
; test weapon Val is valid
    ; test weapon 4
    ld hl, wSuperAwakening.Weapon3_Value
    cp [hl] ; Check if this is weapon4
    jp z, .inc_weapon4_loop

    ; Check if this inventory slot is empty
    cp INVENTORY_EMPTY
    jp z, .inc_weapon4_loop
    
.inc_weapon4_loop_end
    ; a is the new value, b is the new inventory index value
    ; write weapon4 value to display
    ld hl, wSuperAwakening.Weapon4_Value
    ld [hl], a

.inc_weapon4_end

.change_weapon4_end

SuperAwakening::
.readState

;
; Make sure we're reading controller 1
;
.readState_forceController1
    ; set P14 and P15 both HIGH (deselect both Buttons and Cursor keys)
    ld a, J_DPAD | J_BUTTONS
    ld [rP1], a
    ;  read the lower 4 bits of P1, which indicate the joypad ID
    ld a, [rP1]
    and $0F
    cp $0F ; Check if we're player 1 controler ($0F)
    jp z, .readState_forceController1_end
    ;  The next joypad is automatically selected when P15 goes from LOW (0) to HIGH (1)
    ld a, $10
    ld [rP1], a
    ld a, $20
    ld [rP1], a
    jp .readState_forceController1
.readState_forceController1_end

;
; Read the controller 1
;
.readController1
    ld   a, J_BUTTONS                             ; $2852: $3E $20
    ld   [rP1], a                                 ; $2854: $E0 $00
    ld   a, [rP1]                                 ; $2856: $F0 $00
    ld   a, [rP1]                                 ; $2858: $F0 $00
    cpl                                           ; $285A: $2F
    and  $0F                                      ; $285B: $E6 $0F
    ld   b, a                                     ; $285D: $47
    ld   a, J_DPAD                                ; $285E: $3E $10
    ld   [rP1], a                                 ; $2860: $E0 $00
    ld   a, [rP1]                                 ; $2862: $F0 $00
    ld   a, [rP1]                                 ; $2864: $F0 $00
    ld   a, [rP1]                                 ; $2866: $F0 $00
    ld   a, [rP1]                                 ; $2868: $F0 $00
    ld   a, [rP1]                                 ; $286A: $F0 $00
    ld   a, [rP1]                                 ; $286C: $F0 $00
    ld   a, [rP1]                                 ; $286E: $F0 $00
    ld   a, [rP1]                                 ; $2870: $F0 $00
    swap a                                        ; $2872: $CB $37
    cpl                                           ; $2874: $2F
    and  $F0                                      ; $2875: $E6 $F0
    or   b                                        ; $2877: $B0
    ld   c, a                                     ; $2878: $4F
    ldh  a, [hPressedButtonsMask]                 ; $2879: $F0 $CB
    xor  c                                        ; $287B: $A9
    and  c                                        ; $287C: $A1
    ldh  [hJoypadState], a                        ; $287D: $E0 $CC
    ld   a, c                                     ; $287F: $79
    ldh  [hPressedButtonsMask], a                 ; $2880: $E0 $CB
    ld   a, J_BUTTONS | J_DPAD                    ; $2882: $3E $30
    ld   [rP1], a                                 ; $2884: $E0 $00

;
; Read controller 2
;

.readController2
    ld   a, J_BUTTONS                             ; $2852: $3E $20
    ld   [rP1], a                                 ; $2854: $E0 $00
    ld   a, [rP1]                                 ; $2856: $F0 $00
    ld   a, [rP1]                                 ; $2858: $F0 $00
    cpl                                           ; $285A: $2F
    and  $0F                                      ; $285B: $E6 $0F
    ld   b, a                                     ; $285D: $47
    ld   a, J_DPAD                                ; $285E: $3E $10
    ld   [rP1], a                                 ; $2860: $E0 $00
    ld   a, [rP1]                                 ; $2862: $F0 $00
    ld   a, [rP1]                                 ; $2864: $F0 $00
    ld   a, [rP1]                                 ; $2866: $F0 $00
    ld   a, [rP1]                                 ; $2868: $F0 $00
    ld   a, [rP1]                                 ; $286A: $F0 $00
    ld   a, [rP1]                                 ; $286C: $F0 $00
    ld   a, [rP1]                                 ; $286E: $F0 $00
    ld   a, [rP1]                                 ; $2870: $F0 $00
    swap a                                        ; $2872: $CB $37
    cpl                                           ; $2874: $2F
    and  $F0                                      ; $2875: $E6 $F0
    or   b                                        ; $2877: $B0
    ld   c, a                                     ; $2878: $4F
    ldh  a, [hPressedButtonsMask2]                 ; $2879: $F0 $CB
    xor  c                                        ; $287B: $A9
    and  c                                        ; $287C: $A1
    ldh  [hJoypadState2], a                        ; $287D: $E0 $CC
    ld   a, c                                     ; $287F: $79
    ldh  [hPressedButtonsMask2], a                 ; $2880: $E0 $CB
    ld   a, J_BUTTONS | J_DPAD                    ; $2882: $3E $30
    ld   [rP1], a                                 ; $2884: $E0 $00
.readController2_end

;
; Simulate controller1 buttons from controller2
; Player2 Right/Down => Player 1 B
; Player2 Left/Up => Plater 1 A
;

.map_controller2_to_controller1
    ; Mapping: P2_R, P2_D => P1_B
.update_p1_b_state
    ldh  a, [hJoypadState2]
    and  J_RIGHT | J_DOWN
    cp 0
    jp z, .update_p1_b_state_end
    ld a, [hJoypadState]
    or J_B
    ld hl, hJoypadState
    ld [hl], a
.update_p1_b_state_end

.update_p1_b_mask
    ldh  a, [hPressedButtonsMask2]
    and  J_RIGHT | J_DOWN
    cp 0
    jp z, .update_p1_b_mask_end
    ld a, [hPressedButtonsMask]
    or J_B
    ld hl, hPressedButtonsMask
    ld [hl], a
.update_p1_b_mask_end

.update_p1_a_state_from_up
    ; Check left press
    ldh  a, [hJoypadState2]
    and  J_UP
    cp 0
    jp z, .update_p1_a_state_from_up_end ; Not pressing

    ; Ignore if holding start
    ldh  a, [hPressedButtonsMask2]
    and  J_START
    cp 0
    jp nz, .update_p1_a_state_from_up_end ; Not pressing

    ; Simulate A press
    ld a, [hJoypadState]
    or J_A
    ld hl, hJoypadState
    ld [hl], a
.update_p1_a_state_from_up_end

.update_p1_a_mask_from_up
    ; Check left press
    ldh  a, [hPressedButtonsMask2]
    and  J_UP
    cp 0
    jp z, .update_p1_a_mask_from_up_end ; Not pressing

    ; Ignore if holding start
    ldh  a, [hPressedButtonsMask2]
    and  J_START
    cp 0
    jp nz, .update_p1_a_mask_from_up_end ; Not pressing

    ; Simulate A press
    ld a, [hPressedButtonsMask]
    or J_A
    ld hl, hPressedButtonsMask
    ld [hl], a
.update_p1_a_mask_from_up_end

.update_p1_a_state_from_left
    ; Check left press
    ldh  a, [hJoypadState2]
    and  J_LEFT
    cp 0
    jp z, .update_p1_a_state_from_left_end ; Not pressing

    ; Ignore if holding select, used for inventory decrement
    ldh  a, [hPressedButtonsMask2]
    and  J_SELECT
    cp 0
    jp nz, .update_p1_a_state_from_left_end ; Not pressing

    ; Simulate A press
    ld a, [hJoypadState]
    or J_A
    ld hl, hJoypadState
    ld [hl], a
.update_p1_a_state_from_left_end

.update_p1_a_mask_from_left
    ; Check left press
    ldh  a, [hPressedButtonsMask2]
    and  J_LEFT
    cp 0
    jp z, .update_p1_a_mask_from_left_end ; Not pressing

    ; Ignore if holding select, used for inventory decrement
    ldh  a, [hPressedButtonsMask2]
    and  J_SELECT
    cp 0
    jp nz, .update_p1_a_mask_from_left_end ; Not pressing

    ; Simulate A press
    ld a, [hPressedButtonsMask]
    or J_A
    ld hl, hPressedButtonsMask
    ld [hl], a
.update_p1_a_mask_from_left_end
    nop

.debug
    ldh  a, [hJoypadState]
    cp J_UP
    jp nz, .debug_end

    ;call SuperAwakening_Trampolines.SendUploadCommand_trampoline                       ; $6AE2: $CD $51 $6B
    ;ld   bc, $06                                  ; $6AE5: $01 $06 $00
    ;call WaitForBCFrames                          ; $6AE8: $CD $92 $6B
    jp .debug_end

.debug_end
;
; QuickDash
;
; Quick Dash State
; 0 : Check for init
; 1->HOLD_DELAY
;   * Check if canceled
;       * State = 0
;   * Increment the delay counter
;   * Check for overflow
; HOLD_DELAY->IDLE_DELAY
;   * Check if canceled
;       * State = 0
;   * Increment the delay counter
;   * Check for overflow

.quickdash

    ; Are boots unlocked?
    ld hl, (wSuperAwakening.Items_Unlocked+INVENTORY_PEGASUS_BOOTS)
    ld a, [hl]
    cp $01
    jp nz, .quickdash_end

    ; Are we in quick dash timer?
 .quickdash_check_timer
    ld hl, wSuperAwakening.QuickDash_Timer
    ld a, [hl]
    cp 0
    jp z, .quickdash_start_check ; Check if we should start doing a quickdash
    jp .quickdash_state_select ; We're doing a quick dash, jump to the right state

.quickdash_start_check
    ; Check if we should start quickdash
    ldh  a, [hJoypadState]
    and $0F ; Mask only dpad inputs

    ; Check single direction buttons
    cp J_RIGHT
    jp z, .quickdash_start_check_passed
    cp J_LEFT
    jp z, .quickdash_start_check_passed
    cp J_UP
    jp z, .quickdash_start_check_passed
    cp J_DOWN
    jp z, .quickdash_start_check_passed
    jp .quickdash_end

.quickdash_start_check_passed
    ; Store the pressed Direction
    ld hl, wSuperAwakening.QuickDash_Direction
    ld [hl], a

    ; Start timer and wait until next fame
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], $01
    jp .quickdash_end

.quickdash_state_select
    ld b, DASH_HOLD_DELAY_MAX
    ld hl, wSuperAwakening.QuickDash_Timer
    ld a, [hl]
    sub b 
    jp c, .quickdash_state_hold_delay
    jp .quickdash_state_idle_delay


; Waiting for the initial direction key to lift
.quickdash_state_hold_delay
.quickdash_state_hold_delay_cancel_check
    ; Check if we'reholding the quick dash direction button
    ld hl, wSuperAwakening.QuickDash_Direction
    ld a, [hl]
    ld b, a
    ld  a, [hPressedButtonsMask]
    and $0F ; Mask only dpad inputs
    cp b
    jp z, .quickdash_state_hold_delay_increment

    ; Check if we released all button
    cp 0
    jp z, .quickdash_state_hold_delay_success

    ; Anything else is a reset state from here
    jp .quickdash_reset

.quickdash_state_hold_delay_increment
    ld hl, wSuperAwakening.QuickDash_Timer
    ld a, [hl]
    inc a
    ld [hl], a

    cp DASH_HOLD_DELAY_MAX
    jp z, .quickdash_reset ; holding for too long, reset quickdash
    jp .quickdash_end ; No more logic this frame
.quickdash_state_hold_delay_increment_end
    nop


.quickdash_state_hold_delay_success
    ; Go to DASH_HOLD_DELAY_MAX stage
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], DASH_HOLD_DELAY_MAX
    jp .quickdash_end ; No more logic this frame
.quickdash_state_hold_delay_success_end


; Waiting for the 2nd direction key to be pressed
.quickdash_state_idle_delay
    
    ; Check if we need to cancel
    ld hl, wSuperAwakening.QuickDash_Direction
    ld a, [hl]
    ld b, a
    ld a, [hJoypadState]
    and $0F ; Mask only dpad inputs
    cp b
    jp z, .quickdash_state_idle_delay_success ; Did we press the same button?
    cp 0
    jp z, .quickdash_state_idle_delay_increment
    jp .quickdash_reset ; Some other button pressed

.quickdash_state_idle_delay_increment
    ld hl, wSuperAwakening.QuickDash_Timer
    ld a, [hl]
    inc a
    ld [hl], a

    cp DASH_IDLE_DELAY_MAX
    jp z, .quickdash_reset ; waiting for too long, reset quickdash
    jp .quickdash_end ; No more logic this frame
.quickdash_state_ield_delay_increment_end

.quickdash_state_idle_delay_success
    ; Reset the timer
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], 0
    jp .quickdash_execute

.quickdash_reset
    ; Reset the timer
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], 0
    jp .quickdash_end

.quickdash_execute

    ; Clear the quickdash timer
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], 0

    ; Set weapon Slot A
    ld a, INVENTORY_PEGASUS_BOOTS
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a

    ; Pretend we're running
    ld a, 0
    ld hl, wIsRunningWithPegasusBoots
    ld [hl], a

    ; Pretend we're charged
    ld a, (MAX_PEGASUS_BOOTS_CHARGE-1)
    ld hl, wPegasusBootsChargeMeter
    ld [hl], a

    ; Simulate A press
    ld a, [hPressedButtonsMask]
    or J_A
    ld hl, hPressedButtonsMask
    ld [hl], a

    ; Simulate A press
    ld a, [hJoypadState]
    or J_A
    ld hl, hJoypadState
    ld [hl], a

.quickdash_execute_end
.quickdash_end

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
    ldh a, [hPressedButtonsMask2]
    and (J_START | J_UP)
    cp  (J_START | J_UP)
    jp nz, .dec_weapon3_end

    ; check if left toggled this frame
    ldh a, [hJoypadState2]
    and J_UP
    cp  J_UP
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
    ldh a, [hJoypadState2]
    and J_START
    cp J_START
    jp nz, .inc_weapon3_end

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
    cp $02 ; song is 0 indexed
    jp nz, .inc_weapon3_ocarina_validate_song_2
    ; Check if we have song 3 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon3_ocarina_end ; Song 3 not unlocked, continue to next weapon
    jp .inc_weapon3_end ; Song is unlocked, keep the song index

    ; Check if we're on song 2
.inc_weapon3_ocarina_validate_song_2
    cp $01 ; song is 0 indexed
    jp nz, .inc_weapon3_ocarina_validate_song_1
    ; Check if we have song 2 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and MANBO_MAMBO_FLAG
    cp MANBO_MAMBO_FLAG
    jp nz, .inc_weapon3_ocarina_inc_loop ; Song 3 not unlocked, loop
    jp .inc_weapon3_end ; Song is unlocked, keep the song index

    ; Check if we're on song 1
.inc_weapon3_ocarina_validate_song_1
    ; Check if we have song 1 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon3_ocarina_inc_loop ; Song 3 not unlocked, loop
    jp .inc_weapon3_end ; Song is unlocked, keep the song index

.inc_weapon3_reset_song
    ; We overflowd the song index, reset to the first unlocked song

    ; Check if song 0 is unlocked
.inc_weapon3_reset_song_1
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and $01
    cp $01
    jp nz, .inc_weapon3_reset_song_2
    ld hl, wSelectedSongIndex
    ld [hl], 0
    jp .inc_weapon3_ocarina_end

    ; Check if song 1 is unlocked
.inc_weapon3_reset_song_2
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and $02
    cp $02
    jp nz, .inc_weapon3_reset_song_3
    ld hl, wSelectedSongIndex
    ld [hl], 1
    jp .inc_weapon3_ocarina_end

    ; If you don't have 1 or 2, you must have song 3 (...?)
.inc_weapon3_reset_song_3
    ld [hl], 2

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
    ldh a, [hPressedButtonsMask2]
    and (J_SELECT | J_LEFT) 
    cp  (J_SELECT | J_LEFT)
    jp nz, .dec_weapon4_end

    ; check if left toggled this frame
    ldh a, [hJoypadState2]
    and J_LEFT
    cp  J_LEFT
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
    ldh a, [hJoypadState2]
    and J_SELECT
    cp J_SELECT
    jp nz, .inc_weapon4_end

.inc_weapon4_ocarina
    ; Check if we have ocarina equiped
    ld hl, wSuperAwakening.Weapon4_Value
    ld a, [hl]
    cp INVENTORY_OCARINA
    jp nz, .inc_weapon4_ocarina_end

    ; Get the ocarina counter
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
    cp $02 ; song is 0 indexed
    jp nz, .inc_weapon4_ocarina_validate_song_2
    ; Check if we have song 3 unlocked
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and FROGS_SONG_OF_THE_SOUL_FLAG
    cp FROGS_SONG_OF_THE_SOUL_FLAG
    jp nz, .inc_weapon4_ocarina_end ; Song 3 not unlocked, continue to next weapon
    jp .inc_weapon4_end ; Song is unlocked, keep the song index

    ; Check if we're on song 2
.inc_weapon4_ocarina_validate_song_2
    cp $01 ; song is 0 indexed
    jp nz, .inc_weapon4_ocarina_validate_song_1
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

    ; Check if song 0 is unlocked
.inc_weapon4_reset_song_1
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and $01
    cp $01
    jp nz, .inc_weapon4_reset_song_2
    ld hl, wSelectedSongIndex
    ld [hl], 0
    jp .inc_weapon4_ocarina_end

    ; Check if song 1 is unlocked
.inc_weapon4_reset_song_2
    ld hl, wOcarinaSongFlags
    ld a, [hl]
    and $02
    cp $02
    jp nz, .inc_weapon4_reset_song_3
    ld hl, wSelectedSongIndex
    ld [hl], 1
    jp .inc_weapon4_ocarina_end

    ; If you don't have 1 or 2, you must have song 3 (...?)
.inc_weapon4_reset_song_3
    ld [hl], 2

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

ret

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
    

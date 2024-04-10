
; Ranges for the QuickDash_Timer
; 
; 0-DASH_HOLD_DELAY_MAX is delay to lift the inital direction key up
DASH_HOLD_DELAY_MAX  EQU $10
; DASH_HOLD_DELAY_MAX - DASH_DELAY_MAX is delay to wait for direction key down again
DASH_IDLE_DELAY_MAX  EQU $20

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

SuperAwakening_QuickDash::

    ; Skip all of this if we're not in the overworld
    ld a, [wGameplayType]
    cp GAMEPLAY_WORLD
    jp nz, .quickdash_end

    ; Skip if we're on the game over menu
    ld a, [hGameOverStage]
    cp 0
    jp nz, .quickdash_end


    ; Are boots unlocked?
.test_boots_unlocked
    ld hl, wSuperAwakening.Dash_Enabled
    ld a, [hl]
    cp $01
    jp nz, .test_jump_unlocked
    jp .test_success

    ; Is feather unlocked?
.test_jump_unlocked
    ld hl, wSuperAwakening.Jump_Enabled
    ld a, [hl]
    cp $01
    jp nz, .quickdash_end

.test_success
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
    jp .execute

.quickdash_reset
    ; Reset the timer
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], 0
    jp .quickdash_end


.execute

    ; Clear the quickdash timer
    ld hl, wSuperAwakening.QuickDash_Timer
    ld [hl], 0

    ; Check for quick jump button input
    ldh  a, [hPressedButtonsMask]                    
    and  J_B
    cp J_B
    jp nz, .quickdash_execute

    ; Make sure the shield is equipped for quick jump
    ld a, [wInventoryItems.BButtonSlot]
    cp INVENTORY_SHIELD
    jp nz, .execute_end

.quickjump_execute
    ; Are boots unlocked?
    ld hl, wSuperAwakening.Jump_Enabled
    ld a, [hl]
    cp $01
    jp nz, .quickdash_end

    ; Set weapon Slot A
    ld a, INVENTORY_ROCS_FEATHER
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a
    jp .button_press

.quickdash_execute

    ; Are boots unlocked?
    ld hl, wSuperAwakening.Dash_Enabled
    ld a, [hl]
    cp $01
    jp nz, .quickdash_end

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

.button_press
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

.execute_end
.quickdash_end
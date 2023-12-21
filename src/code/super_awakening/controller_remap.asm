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
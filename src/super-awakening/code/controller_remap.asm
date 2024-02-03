;
; Simulate controller1 buttons from controller2
; Player2 Right/Down => Player 1 B
; Player2 Left/Up => Plater 1 A
;

; Skip all of this if we're not in the overworld
.map_controller2_to_controller1

ld a, [wGameplayType]
cp GAMEPLAY_WORLD
jp nz, .map_controller2_to_controller1_end

; Normally, A/B both map to A, so to trigger Save Dialog you actually need to press A/X or B/Y
; This check skips the button mapping if the user presses the save screen button combo
.check_for_save_button_combo
    ldh  a, [hPressedButtonsMask]
    cp   J_A | J_B | J_START | J_SELECT
    jr   z, .map_controller2_to_controller1_end
.check_for_save_button_combo_end

.map_P1A_to_P1B
    ld hl, hJoypadState
    ld  a, [hl]
    ld b, a
    and  J_A
    cp J_A
    jp nz, .map_P1A_to_P1B_end
    ld a, b
    and (~J_A) ; Mask off A
    or J_B ; Set B
    ld [hl], a
.map_P1A_to_P1B_end

.map_P1A_to_P1B_mask
    ld hl, hPressedButtonsMask
    ld  a, [hl]
    ld b, a
    and  J_A
    cp J_A
    jp nz, .map_P1A_to_P1B_mask_end
    ld a, b
    and (~J_A) ; Mask off A
    or J_B ; Set B
    ld [hl], a
.map_P1A_to_P1B_mask_end

; -----------------------

.map_P2AB_to_P1A
    ld  a, [wSuperAwakening.JoypadState2]
    and  (J_A | J_B)
    cp 0
    jp z, .map_P2AB_to_P1A_end
    ; If left or right is held, dont use item (cycle inventory backwards)
    ld  a, [wSuperAwakening.PressedButtonsMask2]
    and  J_LEFT | J_RIGHT
    cp 0
    jp nz, .map_P2AB_to_P1A_end
    ; Set the new joypad state
    ld hl, hJoypadState
    ld a, [hl]
    or J_A ; Set A
    ld [hl], a
.map_P2AB_to_P1A_end

.map_P2AB_to_P1A_mask
    ld  a, [wSuperAwakening.PressedButtonsMask2]
    and  (J_A | J_B)
    cp 0
    jp z, .map_P2AB_to_P1A_mask_end
     ; If left or right is held, dont use item (cycle inventory backwards)
    ld  a, [wSuperAwakening.PressedButtonsMask2]
    and  J_LEFT | J_RIGHT
    cp 0
    jp nz, .map_P2AB_to_P1A_mask_end
    ; Set the new joypad state
    ld hl, hPressedButtonsMask
    ld a, [hl]
    or J_A ; Set A
    ld [hl], a
.map_P2AB_to_P1A_mask_end

.map_controller2_to_controller1_end
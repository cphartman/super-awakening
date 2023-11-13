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

.update_p1_a_state
    ldh  a, [hJoypadState2]
    and  J_LEFT | J_UP
    cp 0
    jp z, .update_p1_a_state_end
    ld a, [hJoypadState]
    or J_A
    ld hl, hJoypadState
    ld [hl], a
.update_p1_a_state_end

.update_p1_a_mask
    ldh  a, [hPressedButtonsMask2]
    and  J_LEFT | J_UP
    cp 0
    jp z, .update_p1_a_mask_end
    ld a, [hPressedButtonsMask]
    or J_A
    ld hl, hPressedButtonsMask
    ld [hl], a
.update_p1_a_mask_end


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

    ; Set weapon Slot B
    ld hl, wInventoryItems.BButtonSlot
    ld [hl], INVENTORY_SWORD

.use_weapon_2_end

.use_weapon_3
    
    ; Check for button input on weapon3
    ldh  a, [hJoypadState2]                    
    and  J_UP
    cp J_UP
    jp nz, .use_weapon_3_end

    ; Set weapon Slot A
    ld a, [wInventoryItems_override.Weapon3]
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
    ld a, [wInventoryItems_override.Weapon4]
    ld hl, wInventoryItems.AButtonSlot
    ld [hl], a

.use_weapon_4_end

;
; Change Weapon Hotkeys
;
.change_weapon3
.inc_weapon3
    ; Check for button press
    ldh a, [hJoypadState2]
    and J_A
    cp J_A
    jp nz, .inc_weapon3_end ; Check decrement next

    ; Increment weapon
    ld  a, [wInventoryItems_override.Weapon3]
    inc a
    ; Check for overflow
    and $0F ; If this is initialize to $E, it will be F here for 1 frame :/
    cp (INVENTORY_BOOMERANG+1)
    jp nz, .set_weapon_3
    ld a, $00
    jp .set_weapon_3
.inc_weapon3_end
.dec_weapon3
    ; Check for button press
    ldh a, [hJoypadState2]
    and J_START
    cp J_START
    jp nz, .change_weapon3_end ; Done with weapon3 check

    ; Decrement weapon
    ld  a, [wInventoryItems_override.Weapon3]
    dec a
    ; Check for overflow
    cp $FF
    jp nz, .set_weapon_3
    ld a, INVENTORY_BOOMERANG
.dec_weapon_3_end
.set_weapon_3
    ld [wInventoryItems_override.Weapon3], a
.set_weapon_3_end
.change_weapon3_end

.change_weapon4
.inc_weapon4
    ; Check for button press
    ldh a, [hJoypadState2]
    and J_B
    cp J_B
    jp nz, .inc_weapon4_end ; Check decrement next

    ; Increment weapon
    ld  a, [wInventoryItems_override.Weapon4]
    inc a
    ; Check for overflow
    and $0F ; If this is initialize to $E, it will be F here for 1 frame :/
    cp (INVENTORY_BOOMERANG+1)
    jp nz, .set_weapon_4
    ld a, $00
    jp .set_weapon_4
.inc_weapon4_end
.dec_weapon4
    ; Check for button press
    ldh a, [hJoypadState2]
    and J_SELECT
    cp J_SELECT
    jp nz, .change_weapon4_end ; Done with weapon3 check

    ; Decrement weapon
    ld  a, [wInventoryItems_override.Weapon4]
    dec a
    ; Check for overflow
    cp $FF
    jp nz, .set_weapon_4
    ld a, INVENTORY_BOOMERANG
.dec_weapon_4_end
.set_weapon_4
    ld [wInventoryItems_override.Weapon4], a
.set_weapon_4_end
.change_weapon4_end

    ret
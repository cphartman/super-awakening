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
    ld  a, [wSuperAwakening.PressedButtonsMask]                 ; $2879: $F0 $CB
    xor  c                                        ; $287B: $A9
    and  c                                        ; $287C: $A1
    ldh  [hJoypadState], a                        ; $287D: $E0 $CC
    ld  [wSuperAwakening.JoypadState], a                        ; $287D: $E0 $CC
    ld   a, c                                     ; $287F: $79
    ldh  [hPressedButtonsMask], a                 ; $2880: $E0 $CB
    ld  [wSuperAwakening.PressedButtonsMask], a                 ; $2880: $E0 $CB
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
    ld  a, [wSuperAwakening.PressedButtonsMask2]                 ; $2879: $F0 $CB
    xor  c                                        ; $287B: $A9
    and  c                                        ; $287C: $A1
    ld  [wSuperAwakening.JoypadState2], a                        ; $287D: $E0 $CC
    ld   a, c                                     ; $287F: $79
    ld  [wSuperAwakening.PressedButtonsMask2], a                 ; $2880: $E0 $CB
    ld   a, J_BUTTONS | J_DPAD                    ; $2882: $3E $30
    ld   [rP1], a                                 ; $2884: $E0 $00
.readController2_end
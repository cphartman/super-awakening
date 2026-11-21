IF SUPER_AWAKENING_SHIELD_WHILE_CHARGING
; Called from CheckItemsToUse. Sword and shield share the B slot, so if the
; shield button is held while the sword is out, return nz to raise the shield
; too, like having it on A in the original game.
;
; The draw shield sound normally comes from using the shield in B, which doesn't
; happen with the sword out, so it's played here when the shield button is pressed.
SuperAwakening_ShieldWithSword::
    ld   a, [wInventoryItems.BButtonSlot]
    cp   INVENTORY_SWORD
    jr   nz, .no
    ld   a, [wShieldLevel]
    and  a
    jr   z, .no

    ; Shield button bit in the raw state: A, or B when the buttons are swapped
    ld   b, J_A
IF SUPER_AWAKENING_MENU_MAPPING
    ld   a, [wSuperAwakening.ButtonSwap]
    and  a
    jr   z, .shield_button_set
    ld   b, J_B
.shield_button_set
ENDC

    ; Pressed this frame
    ld   a, [wSuperAwakening.JoypadState]
    and  b
    jr   z, .shield_not_pressed
    ld   a, NOISE_SFX_DRAW_SHIELD
    ldh  [hNoiseSfx], a
.shield_not_pressed

    ; Held
    ld   a, [wSuperAwakening.PressedButtonsMask]
    and  b
    jr   .return
.no
    xor  a
.return
    ; Keep the flags for the caller
    ld   a, [wCurrentBank]
    jp   SuperAwakening_Trampoline.returnToBank
ENDC

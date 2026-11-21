;
; Sword and shield buttons swapped from the start menu.
; The game code is written for A = shield and B = sword, so when they are
; swapped we trade the A and B bits of the live joypad state here.
; Only done in the world, so A and B still work as usual in menus.
;
; wSuperAwakening.JoypadState / PressedButtonsMask are NOT swapped: controller_read
; compares the current buttons against that stored copy to find new presses,
; so swapping it would make every held button look newly pressed each frame.
; The raw readers (shield_while_charging.asm, weapon_hotkeys.asm) check the swap themselves.
;
IF SUPER_AWAKENING_MENU_MAPPING
.swap_AB_buttons
    ld   a, [wSuperAwakening.ButtonSwap]
    and  a
    jr   z, .swap_AB_buttons_end
    ld   a, [wGameplayType]
    cp   GAMEPLAY_WORLD
    jr   nz, .swap_AB_buttons_end

    ld   hl, hJoypadState
    call SuperAwakening_SwapAB
    ld   hl, hPressedButtonsMask
    call SuperAwakening_SwapAB
.swap_AB_buttons_end
ENDC

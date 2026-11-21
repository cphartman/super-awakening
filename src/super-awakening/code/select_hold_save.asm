; Hold Select in the start menu to open the save screen.
; Once the time is reached, wSuperAwakening.SelectHold_Save is set. The start
; menu closes itself (bank 20), then ExecuteGameplayHandler (bank 0) opens the
; save screen back in the overworld. The flag is cleared below once the save
; screen is up.
IF SUPER_AWAKENING_SELECT_HOLD_SAVE

.selectHold
    ; Save screen already requested, leave it pending
    ld   a, [wSuperAwakening.SelectHold_Save]
    and  a
    jr   z, .selectHold_count
    ; ...unless we ended up back in a menu (file select, save screen, ...)
    ld   a, [wGameplayType]
    cp   GAMEPLAY_WORLD_MAP
    jr   c, .selectHold_reset
    jr   .selectHold_end

.selectHold_count
    ; Only count while the start menu is open
    ld   a, [wGameplayType]
    cp   GAMEPLAY_INVENTORY
    jr   nz, .selectHold_reset

    ; ...and Select is held
    ldh  a, [hPressedButtonsMask]
    and  J_SELECT
    jr   z, .selectHold_reset

    ; Timer += 1 (16 bit)
    ld   hl, wSuperAwakening.SelectHold_Timer
    ld   a, [hl]
    inc  a
    ld   [hl+], a
    jr   nz, .selectHold_compare
    inc  [hl]

.selectHold_compare
    ; hl points to the high byte
    ld   a, [hl]
    cp   HIGH(SUPER_AWAKENING_SELECT_HOLD_SAVE_FRAMES)
    jr   c, .selectHold_end
    dec  hl
    ld   a, [hl]
    cp   LOW(SUPER_AWAKENING_SELECT_HOLD_SAVE_FRAMES)
    jr   c, .selectHold_end

    ; Held long enough
    ld   a, 1
    ld   [wSuperAwakening.SelectHold_Save], a
    jr   .selectHold_end

.selectHold_reset
    xor  a
    ld   [wSuperAwakening.SelectHold_Timer], a
    ld   [wSuperAwakening.SelectHold_Timer + 1], a
    ld   [wSuperAwakening.SelectHold_Save], a

.selectHold_end

ENDC

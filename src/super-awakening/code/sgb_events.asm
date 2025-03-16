
SuperAwakening_SGB_Events::

.SetEvents:
    ld a, [wSuperAwakening.PreviousRoom]
    ld b, a
    ld a, [hMapRoom]
    cp b
    jp nz, .RoomChanged
    jp .SetEvents_end

.RoomChanged:
    
; Lost woods = $40 -> $74
.LostWoods:
.LostWoods_Check:
    ; Get Room X
    ld a, [hMapRoom]
    and $0F
    ; Check right border
    scf
    ccf
    sbc $04
    jp nc, .LostWoods_Exit

.LostWoods_Check_Top:
    ; Get Room Y
    ld a, [hMapRoom]
    and $F0
    rra
    rra
    rra
    rra
    ld b, a
    ; Check top border
    scf
    ccf
    sbc $04
    jp c, .LostWoods_Exit
.LostWoods_Check_Bottom:
    ; Restore Room Y
    ld a, b
    ; Check bottom border
    scf
    ccf
    sbc $08
    jp nc, .LostWoods_Exit
    jp .LostWoods_Enter
.LostWoods_Check_End:

.LostWoods_Enter:
    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 0
    jp z, .LostWoods_SendEnter
    jp .LostWoods_End
.LostWoods_SendEnter:
    ld a, 1
    ld [wSuperAwakening.SGB_InLostWoods], a
    call SuperAwakening_SGB_LostWoodsStart
    jp .LostWoods_End

.LostWoods_Exit:
    ld a, [wSuperAwakening.SGB_InLostWoods]
    cp 1
    jp z, .LostWoods_SendExit
    jp .LostWoods_End
.LostWoods_SendExit:
    ld a, 0
    ld [wSuperAwakening.SGB_InLostWoods], a
    call SuperAwakening_SGB_LostWoodsStop

.LostWoods_End:

.CheckEnableScreenScroll:
    ld a, [hMapRoom]
    cp $CE
    jp z, .StartScreenScroll
    cp $BE
    jp z, .StartScreenScroll
    cp $BF
    jp z, .StartScreenScroll
    cp $CF
    jp z, .StartScreenScroll

.CheckDisableScreenScroll:
    ld a, [wSuperAwakening.SGB_SendPosition]
    cp 0
    jp nz, .DisableScreenScroll

.Check_end:
    jp .SetEvents_end

.DisableScreenScroll:
    ld a, 0
    ld [wSuperAwakening.SGB_SendPosition], a
    call SuperAwakening_SGB_DisableScreenScroll
    jp .End

.StartScreenScroll:
    ld a, 1
    ld [wSuperAwakening.SGB_SendPosition], a
    ld a, $0F
    ld [wSuperAwakening.SGB_SendPosition_Delay], a
    jp .SetEvents_end

.SetEvents_end:

.CheckEvents:

.CheckEvents_SendScreenScroll:

    ld a, [wSuperAwakening.SGB_SendPosition]
    cp 0
    jp z, .CheckEvents_end

.CheckEvents_SendScreenScroll_Delay:
    ld a, [wSuperAwakening.SGB_SendPosition_Delay]
    cp 0
    jp z, .CheckEvents_SendScreenScroll_Send
    dec a
    ld [wSuperAwakening.SGB_SendPosition_Delay], a
    jp .CheckEvents_SendScreenScroll_end

.CheckEvents_SendScreenScroll_Send:
    call SuperAwakening_SGB_SendScreenScroll
.CheckEvents_SendScreenScroll_end:

.CheckEvents_end:

    ld a, [hMapRoom]
    ld [wSuperAwakening.PreviousRoom], a
.End:
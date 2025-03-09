
SuperAwakening_SGB_Events::

.SetEvents:
    ld a, [wSuperAwakening.PreviousRoom]
    ld b, a
    ld a, [hMapRoom]
    cp b
    jp nz, .RoomChanged
    jp .SetEvents_end

.RoomChanged:
    ld [wSuperAwakening.PreviousRoom], a

.CheckEnableScreenScroll:
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

.End:
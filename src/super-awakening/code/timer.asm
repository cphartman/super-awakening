SuperAwakening_Timer::
 UpdateTimer:
    ; Increment frame count
    ld hl, wSuperAwakening.TimerCounter_Frame
    inc [hl]
    ld a, [hl]
    cp 60
    jr c, .return

    ; Reset frame to 0
    xor a
    ld [hl], a

    ; Increment seconds
    ld hl, wSuperAwakening.TimerCounter_Second
    inc [hl]
    ld a, [hl]
    cp 60
    jr c, .return

    ; Reset seconds to 0
    xor a
    ld [hl], a

    ; Increment minutes
    ld hl, wSuperAwakening.TimerCounter_Minute
    inc [hl]
    ld a, [hl]
    cp 60
    jr c, .return

    ; Reset minutes to 0
    xor a
    ld [hl], a

    ; Increment hours
    ld hl, wSuperAwakening.TimerCounter_Hour
    inc [hl]

.return:
    ret

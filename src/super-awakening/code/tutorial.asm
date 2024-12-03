SuperAwakening_Tutorial::

    ; Force level to load custom room
    ;ld b, $5E
    ;ld c, $76

.return
    ; Restore the rombank
    ld  a, $09
    jp SuperAwakening_Trampoline.returnToBank
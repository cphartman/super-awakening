TUTORIAL_LOCATION_2 = $C2

SuperAwakening_Tutorial::

.check_location_1
    ldh  a, [hMapRoom]  
    cp TUTORIAL_START_LOCATION
    jp nz, .check_location_2
    ld b, HIGH(OverworldD2_Override+1)
    ld c, LOW(OverworldD2_Override+1)
    jp .return
    
.check_location_2
    cp TUTORIAL_LOCATION_2
    jp nz, .return
    ld b, HIGH(OverworldC2_Override+1)
    ld c, LOW(OverworldC2_Override+1)

.return
    ; Restore the rombank
    ld  a, $1A
    jp SuperAwakening_Trampoline.returnToBank
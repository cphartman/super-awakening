

SuperAwakening_InstrumentUpdate:

InstrumentUpdate_GetInstrumentCount:
    ld b, $00
    ld c, $00
    ld hl, wHasInstrument1

InstrumentUpdate_GetInstrumentCount_loop:
    ld a, [hl]
    cp $03
    jp nz, InstrumentUpdate_GetInstrumentCount_loopincrement
    inc b
InstrumentUpdate_GetInstrumentCount_loopincrement:
    inc c
    inc hl
    ld a, c
    cp $08
    jp z, InstrumentUpdate_GetInstrumentCount_end
    jp InstrumentUpdate_GetInstrumentCount_loop
InstrumentUpdate_GetInstrumentCount_end:

SuperAwakening_InstrumentUpdate_end:
    ret
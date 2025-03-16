SGB_DATA_TRN equ $10

; This command will upload the payload
SuperAwakening_SendPayloadCmd::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $00, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

SuperAwakening_SendPayloadCmd_2::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $10, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

SuperAwakening_SendPayloadCmd_3::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $20, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding
/*
SuperAwakening_SendPayloadCmd_4::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $30, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding
    */
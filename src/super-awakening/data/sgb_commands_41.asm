
; This command will jump to our payload from the SGB gameloop
SuperAwakening_SendHookCmd_41::
    sgb_data_send_cmd $0808, $0, 5
    db $5C, $00, $00, $7F   ; jpl 7f0000
    db $60                  ; rts


; This command will upload the payload
SuperAwakening_SendPayloadCmd_7::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $60, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

; This command will upload the payload
SuperAwakening_SendPayloadCmd_8::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $70, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

; This command will upload the payload
SuperAwakening_SendPayloadCmd_9::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $80, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

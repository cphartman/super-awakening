
; This command will jump to our payload from the SGB gameloop
SuperAwakening_SendHookCmd_40::
    sgb_data_send_cmd $0808, $0, 5
    db $5C, $00, $00, $7F   ; jpl 7f0000
    db $60                  ; rts


; This command will upload the payload
SuperAwakening_SendPayloadCmd_4::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $30, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

; This command will upload the payload
SuperAwakening_SendPayloadCmd_5::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $40, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

; This command will upload the payload
SuperAwakening_SendPayloadCmd_6::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $50, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

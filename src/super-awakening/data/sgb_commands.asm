SGB_DATA_TRN equ $10

; This command will jump to our payload from the SGB gameloop
SuperAwakening_SendHookCmd::
    sgb_data_send_cmd $0808, $0, 5
    db $5C, $00, $00, $7F   ; jpl 7f0000
    db $60                  ; rts

; This command will upload the payload
SuperAwakening_SendPayloadCmd::
    sgb_cmd SGB_DATA_TRN, 1
    db $00, $00, $7f        ; Put payload at $7f:0000 in WRAM
    ds 12                   ; padding

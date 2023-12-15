Awakening_Patch_Data:
Awakening_Patch_Data_0:
	sgb_data_send_cmd $0000, $7F, 11
	db $af, $00, $01, $7f, $c5, $00, $f0, $24, $3a, $c5, $00
Awakening_Patch_Data_1:
	sgb_data_send_cmd $000b, $7F, 11
	db $f0, $14, $3a, $c5, $00, $f0, $0f, $3a, $c5, $00, $f0
Awakening_Patch_Data_2:
	sgb_data_send_cmd $0016, $7F, 11
	db $0a, $3a, $c5, $00, $f0, $05, $3a, $c5, $00, $f0, $00
Awakening_Patch_Data_3:
	sgb_data_send_cmd $0021, $7F, 11
	db $8f, $00, $01, $7f, $29, $f0, $09, $04, $8d, $06, $21
Awakening_Patch_Data_4:
	sgb_data_send_cmd $002c, $7F, 11
	db $4c, $34, $00, $01, $02, $01, $00, $00, $5c, $14, $08
Awakening_Patch_Data_5:
	sgb_data_send_cmd $0037, $7F, 11
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

AWAKENING_LOAD_PACKETS = 6

Awakening_Patch_Data:
Awakening_Patch_Data_0:
	sgb_data_send_cmd $0000, $7F, 11
	db $e2, $20, $ad, $11, $0f, $29, $10, $c9, $10, $d0, $10
Awakening_Patch_Data_1:
	sgb_data_send_cmd $000b, $7F, 11
	db $ad, $14, $0f, $09, $01, $8d, $14, $0f, $ad, $11, $0f
Awakening_Patch_Data_2:
	sgb_data_send_cmd $0016, $7F, 11
	db $29, $ef, $8d, $11, $0f, $ad, $11, $0f, $29, $20, $c9
Awakening_Patch_Data_3:
	sgb_data_send_cmd $0021, $7F, 11
	db $20, $d0, $10, $ad, $14, $0f, $09, $02, $8d, $14, $0f
Awakening_Patch_Data_4:
	sgb_data_send_cmd $002c, $7F, 11
	db $ad, $11, $0f, $29, $df, $8d, $11, $0f, $ad, $11, $0f
Awakening_Patch_Data_5:
	sgb_data_send_cmd $0037, $7F, 11
	db $29, $40, $c9, $40, $d0, $10, $ad, $13, $0f, $09, $80
Awakening_Patch_Data_6:
	sgb_data_send_cmd $0042, $7F, 11
	db $8d, $13, $0f, $ad, $11, $0f, $29, $bf, $8d, $11, $0f
Awakening_Patch_Data_7:
	sgb_data_send_cmd $004d, $7F, 11
	db $ad, $12, $0f, $29, $40, $c9, $40, $d0, $10, $ad, $14
Awakening_Patch_Data_8:
	sgb_data_send_cmd $0058, $7F, 11
	db $0f, $09, $80, $8d, $14, $0f, $ad, $12, $0f, $29, $bf
Awakening_Patch_Data_9:
	sgb_data_send_cmd $0063, $7F, 11
	db $8d, $12, $0f, $5c, $0c, $08, $00, $00, $00, $00, $00

AWAKENING_LOAD_PACKETS = 10

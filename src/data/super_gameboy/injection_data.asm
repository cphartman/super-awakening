Awakening_Patch_Data:
Awakening_Patch_Data_0:
	sgb_data_send_cmd $0000, $7F, 11
	db $a9, $04, $8f, $00, $0f, $7f, $5c, $14, $08, $00, $de
Awakening_Patch_Data_1:
	sgb_data_send_cmd $000b, $7F, 11
	db $ad, $be, $ef, $13, $37, $13, $37, $00, $00, $00, $00

AWAKENING_LOAD_PACKETS = 2

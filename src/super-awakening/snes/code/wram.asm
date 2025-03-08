command:
   .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
delayed_command_timer:
   .byte $00
delayed_command:
   .byte $00
   
counter1:
   .byte $00

StartBorderLoad:
   .byte $00

BorderLoadState:
    .byte $00

state_variable_2:
    .byte $00, $00, $00

; Load from SRC=>DEST in chunks the load is split over multiple frames
ChunkLoader_Src:
   .byte $00, $00
ChunkLoader_Dest:
   .byte $00, $00
ChunkLoader_ChunkSize:
   .byte CHUNK_SIZE
ChunkLoader_CurrentChunkSize:
   .byte CHUNK_SIZE, $00
; 0=>ChunkLoader_ChunkCount
ChunkLoader_ChunkIndex:
   .byte $00
ChunkLoader_ChunkCount:
   .byte $00
ChunkLoader_LastChunkSize:
   .byte $00

; Palette Service
PaletteService_State:
   .byte $00

FileMenu_State:
   .byte $00

FileMenu_Counter:
   .byte $00

Border_Original_Palette_Fade_0: 
   .byte $00, $7C, $2A, $1D, $8D, $29, $87, $1D, $09, $26, $8F, $3A, $AB, $45, $F0, $35, $0C, $4E, $4D, $52, $50, $56, $B3, $62, $52, $46, $94, $4E, $56, $45, $F7, $5E
   .byte $00, $7C, $2A, $1D, $8D, $29, $87, $1D, $09, $26, $8F, $3A, $4D, $52, $CB, $4D, $0C, $4E, $AB, $45, $F7, $5E, $B3, $62, $52, $42, $52, $52, $94, $56, $50, $56
   
Border_Original_Palette_Fade_1: 
   .byte $4A, $6D, $11, $32, $53, $3A, $4E, $32, $B0, $36, $F4, $42, $71, $4A, $95, $42, $B2, $52, $D3, $52, $D5, $56, $17, $5F, $D6, $4A, $F7, $52, $39, $4A, $39, $5B
   .byte $4A, $6D, $11, $32, $53, $3A, $4E, $32, $B0, $36, $F4, $42, $D3, $52, $71, $52, $B2, $52, $71, $4A, $39, $5B, $17, $5F, $D6, $4A, $D6, $52, $F7, $56, $D5, $56

Border_Original_Palette_Fade_2: 
   .byte $94, $66, $F7, $46, $18, $4B, $16, $47, $37, $47, $79, $4F, $18, $53, $39, $4F, $38, $57, $58, $57, $59, $57, $7A, $5B, $5A, $53, $7B, $57, $FB, $52, $9C, $5B
   .byte $94, $66, $F7, $46, $18, $4B, $16, $47, $37, $47, $79, $4F, $58, $57, $38, $57, $38, $57, $18, $53, $9C, $5B, $7A, $5B, $5A, $53, $5A, $57, $7B, $57, $59, $57

Border_Original_Palette_Fade_3: 
   .byte $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B
   .byte $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B, $FF, $5B
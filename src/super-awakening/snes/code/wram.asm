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
ChunkLoader_ChunkIndex:
   .byte $00
ChunkLoader_ChunkCount:
   .byte $00
ChunkLoader_LastChunkSize:
   .byte $00
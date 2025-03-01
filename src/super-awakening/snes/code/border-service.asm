seta8


Init:
    ; Backup flags and bank
   PHP
   PHB

   ; Set flags we use
   .i16
   rep #$10        ; X/Y 16-bit
   .a8
   sep #$20        ; A 8-bit

    LDA #^SuperAwakeining_Snes_Wram   ; Load bank byte of foo
    PHA         ; Push it onto the stack
    PLB         ; Pull into DBR (set data bank)

BorderLoad_Check:

    lda BorderLoadState
    cmp #0
    bne BorderLoad_StateCheck
    
    ; No state
    jmp RETURN

BorderLoad_StateCheck:

    LDX BorderLoadState
    LDA JumpTable_Low,X
    STA $00  ; Store low byte
    LDA JumpTable_High,X
    STA $01  ; Store high byte
    LDA JumpTable_Bank,X
    STA $02  ; Store bank byte

    JML [$00]
    ;JMP [state_variable_2&$FFFF]


 JumpTable_Low:
    .byte $00
    .byte <BorderLoad_Stage1
    .byte <BorderLoad_Stage2
    .byte <BorderLoad_Stage3
    .byte <BorderLoad_StagePalette
    .byte <BorderLoad_Stage4
 JumpTable_High:
    .byte $00
    .byte >BorderLoad_Stage1
    .byte >BorderLoad_Stage2
    .byte >BorderLoad_Stage3
    .byte >BorderLoad_StagePalette
    .byte >BorderLoad_Stage4
 JumpTable_Bank:
    .byte $00
    .byte ^BorderLoad_Stage1
    .byte ^BorderLoad_Stage2
    .byte ^BorderLoad_Stage3
    .byte ^BorderLoad_StagePalette
    .byte ^BorderLoad_Stage4

BorderLoad_Stage1:

ConfigureWindow:
    LDA #0
    PHA
    PLB

    ; Configure th3 BG to use the correct tile location offset
    lda #0
    sta $210B

    ; Only shown BG1 and BG3 on the main screen
    lda #5
    sta $212C

    LDA #^SuperAwakeining_Snes_Wram   ; Load bank byte of foo
    PHA         ; Push it onto the stack
    PLB         ; Pull into DBR (set data bank)


    WAIT_FOR_VBLANK
    DMA_COPY (border_file_menu_tiles), (BG_1_TILES), $C0
    jmp NEXT_STATE_AND_RETURN

BorderLoad_Stage2:
    WAIT_FOR_VBLANK
    DMA_COPY (border_file_menu_tiles+$C0), (BG_1_TILES+$60), $C0
    jmp NEXT_STATE_AND_RETURN

BorderLoad_Stage3:
    WAIT_FOR_VBLANK
    DMA_COPY (border_file_menu_tiles+($C0*2)), (BG_1_TILES+($60*2)), $C0

BorderLoad_StagePalette:
    WAIT_FOR_VBLANK
    DMA_PALETTE border_file_menu_palette, $40, $20

InitChunkLoader:
    LDA #$7F
    PHA
    PLB

    ; Init chunked loader
    seta16
    .a16
    lda #(border_file_menu_tilemap&$FFFF)
    sta ChunkLoader_Src
    lda #BG_1_TILEMAP
    sta ChunkLoader_Dest
    seta8
    .a8
    
    lda #CHUNK_SIZE
    sta ChunkLoader_CurrentChunkSize
    lda #0
    sta ChunkLoader_ChunkIndex
    lda #BORDER_FILE_MENU_MAP_CHUNK_COUNT
    sta ChunkLoader_ChunkCount
    lda #BORDER_FILE_MENU_MAP_LAST_CHUNK_SIZE
    sta ChunkLoader_LastChunkSize

    jmp NEXT_STATE_AND_RETURN

BorderLoad_Stage4:

    ; Do chunk load
    WAIT_FOR_VBLANK
    CHUNK_LOAD_DMA
    
ChunkComplete:
    LDA #$7F
    PHA
    PLB

    ; Load complete, increment the chunk index
IncrementChunkIndex:
    seta8
    .a8
    lda ChunkLoader_ChunkIndex
    inc a
    sta ChunkLoader_ChunkIndex
    
CheckAllChunks:
    ; Did we load all the chunks?
    cmp ChunkLoader_ChunkCount
    beq END_STATE_AND_RETURN

IncrementSrc:
    ; Incremement the SRC
    seta16
    .a16
    lda ChunkLoader_Src
    adc ChunkLoader_CurrentChunkSize
    sta ChunkLoader_Src

IncrementDest:
    ; Incremement the DEST
    lda ChunkLoader_Dest
    adc #(CHUNK_SIZE/2)
    sta ChunkLoader_Dest

ChecklLastChunk:
    ; Are we on the last chunk?
    lda ChunkLoader_ChunkIndex
    inc a
    cmp #BORDER_FILE_MENU_MAP_CHUNK_COUNT
    beq ChunkLoad_SetupLastChunk

    jmp RETURN

ChunkLoad_SetupLastChunk:

    lda ChunkLoader_LastChunkSize
    sta ChunkLoader_CurrentChunkSize
    jmp RETURN

END_STATE_AND_RETURN:
    seta8
    .a8
    lda #0
    sta f:BorderLoadState
    jmp RETURN

NEXT_STATE_AND_RETURN:
    lda f:BorderLoadState
    inc a
    sta f:BorderLoadState

RETURN:
    PLB
    PLP

BG_1_TILES = $0000
;BG_1_TILES = $0000
;BG_1_TILEMAP = $3C00
BG_1_TILEMAP = $3800
CLOUD_TILE_SIZE = 144
;TILE_BATCH_SIZE = 144
;TILE_BATCH_COUNT = CLOUD_TILE_SIZE/TILE_BATCH_SIZE


CHUNK_SIZE = $B0
BORDER_FILE_MENU_MAP_SIZE = 1792
BORDER_FILE_MENU_MAP_CHUNK_COUNT = (BORDER_FILE_MENU_MAP_SIZE/CHUNK_SIZE)
BORDER_FILE_MENU_MAP_LAST_CHUNK_SIZE = BORDER_FILE_MENU_MAP_SIZE - (BORDER_FILE_MENU_MAP_SIZE/CHUNK_SIZE)*CHUNK_SIZE
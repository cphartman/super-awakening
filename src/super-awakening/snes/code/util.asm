.macro  DMA_PALETTE SRC, DEST, SIZE, 
    WAIT_FOR_VBLANK

    LDA #0
    PHA
    PLB
    
    seta8
    .a8

    lda #$02
    sta $4300   ; Set DMA mode (word, normal increment)

    LDA #$22
    STA $4301      ; CGRAM Data Write Register ($2122)
    
    lda #$1
    sta $2115

    LDA #DEST
    STA $2121      ; Set CGRAM address

    LDA #<SRC
    STA $4302      ; Low Byte of Source Address
    LDA #>SRC
    STA $4303      ; High Byte of Source Address
    
    LDA #^SRC
    STA $4304      ; Bank Byte of Source Address

    ldy #SIZE
    sty $4305   ; Store size of data block

    lda #$01    ; Initiate DMA transfer (channel 1)
    sta $420B
.endmacro

.macro WAIT_FOR_VBLANK
    .local  WAIT_FOR_VBLANK_LOOP
WAIT_FOR_VBLANK_LOOP:
    lda f:$000022
    cmp #01
    BNE WAIT_FOR_VBLANK_LOOP
.endmacro

.macro  CHUNK_LOAD_DMA

    LDA #0
    PHA
    PLB

    lda #$80
    sta $2115       ; Set VRAM transfer mode to word-access, increment by 1

    lda #$18    ; Set the destination register (VRAM write register)
    sta $4301

    lda #$01
    sta $4300   ; Set DMA mode (word, normal increment)

SetChunkDest: 
    seta16
    .a16

    lda f:ChunkLoader_Dest      ; DEST
    sta $2116       ; $2116: Word address for accessing VRAM.

SetChunkSrc: 
    
    lda f:ChunkLoader_Src  ; SRCOFFSET
    sta $4302        ; Store Data offset into DMA source offset

SetChunkSrcBank: 
    seta8
    .a8

    lda f:ChunkLoader_Src_Bank
    sta $4304       ; Store data Bank into DMA source bank

SetChunkSize: 
    .a8
    seta8
    lda f:ChunkLoader_CurrentChunkSize
    sta $4305   ; Store size of data block

    lda #00
    sta $4306   ; Store size of data block

    lda #$01    ; Initiate DMA transfer (channel 1)
    sta $420B
.endmacro

; Setup all the chunk load variables
.macro CHUNK_LOAD_INIT SRC, DEST, COUNT, LAST_CHUNK_SIZE
    LDA #$7F
    PHA
    PLB

    seta16
    .a16
    lda #(SRC&$FFFF)
    sta ChunkLoader_Src
    lda #DEST
    sta ChunkLoader_Dest
    seta8
    .a8
    
    lda #CHUNK_SIZE
    sta ChunkLoader_CurrentChunkSize
    lda #0
    sta ChunkLoader_ChunkIndex
    lda #COUNT
    sta ChunkLoader_ChunkCount
    lda #LAST_CHUNK_SIZE
    sta ChunkLoader_LastChunkSize
.endmacro

; Method to load the current chunk and incrementing chunk counters
DO_CHUNK_LOAD:
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
    bne IncrementSrc
    rtl

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
    seta8
    .a8
    lda ChunkLoader_ChunkIndex
    inc a
    cmp ChunkLoader_ChunkCount
    beq ChunkLoad_SetupLastChunk
    RTL

ChunkLoad_SetupLastChunk:

    lda ChunkLoader_LastChunkSize
    sta ChunkLoader_CurrentChunkSize
    RTL

;  Call the chunk loader and branch
.macro CHUNK_LOAD_EXECUTE COMPLETE_FALSE, COMPLETE_TRUE
.local JUMP_TO_FALSE
    JSL DO_CHUNK_LOAD

    ; Check if all chunks are loaded
    lda ChunkLoader_ChunkIndex
    cmp ChunkLoader_ChunkCount
    bne JUMP_TO_FALSE
    jmp COMPLETE_TRUE
JUMP_TO_FALSE:
    jmp COMPLETE_FALSE
.endmacro
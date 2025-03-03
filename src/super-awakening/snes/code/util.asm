.macro  DMA_COPY SRC, DEST, SIZE, 
    LDA #0
    PHA
    PLB

    lda #$80
    sta $2115       ; Set VRAM transfer mode to word-access, increment by 1

    lda #$01
    sta $4300   ; Set DMA mode (word, normal increment)

    lda #$18    ; Set the destination register (VRAM write register)
    sta $4301
    
    ldx #DEST      ; DEST
    stx $2116       ; $2116: Word address for accessing VRAM.

    ldx #SRC&$FFFF  ; SRCOFFSET
    stx $4302        ; Store Data offset into DMA source offset

    lda #$7f        ; SRCBANK
    sta $4304       ; Store data Bank into DMA source bank

    ldy #SIZE
    sty $4305   ; Store size of data block

    lda #$01    ; Initiate DMA transfer (channel 1)
    sta $420B
.endmacro

.macro  DMA_PALETTE SRC, DEST, SIZE, 
    LDA #0
    PHA
    PLB

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

    lda #$7f        ; SRCBANK
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
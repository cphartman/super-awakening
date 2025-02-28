seta8


Init:
    PHB         ; Preserve DBR
    LDA #^SuperAwakeining_Snes_Wram   ; Load bank byte of foo
    PHA         ; Push it onto the stack
    PLB         ; Pull into DBR (set data bank)

TEST_COUNTER_INCREMENT:

    LDX counter1
    INC A
    STX counter1

    LDA DoLoad
    
    CMP #1
    BNE RETURN

    LDA #0
    STA DoLoad

TEST_COPY_2:
    

    ; Set VRAM address
    LDA #<$3C80    ; High byte of VRAM address
    STA f:$002116
    LDA #>$3C80    ; Low byte of VRAM address
    STA f:$002117
    
    ; Load size into counter
    setxy16
    LDX #$0008

    LDA #00    

    jsr WaitForVBlank

copy_loop:
    LDA a:tilemap_data, X ; Load from WRAM
    STA f:$002118     ; Store to VRAM
    DEX
    LDA a:tilemap_data, X ; Load from WRAM
    STA f:$002119     ; Store to VRAM
    DEX
    BNE copy_loop
    setxy8



RETURN:
    PLB         ; Restore previous DBR


.scope
; Command Service recieved data from the GB to set up appropriate services

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

FetchCommand:
    lda command
    

RETURN:
    PLB
    PLP

.endscope
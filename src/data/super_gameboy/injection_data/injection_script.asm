; Minimal example of using ca65 to build SNES ROM.

.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.include "snes.inc"

.segment "CODE"
CODE:

   ; Check if we've done init
   lda #$04
   sta $7f0F00
   
   JML $000814

   .byte $DE,$AD,$BE,$EF
   .byte $13,$37,$13,$37
   .byte 0,0,0


.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.include "snes.inc"
.segment "CODE"
CODE:

   ; testing memory writing
   lda #$04
   sta $7f0F00
   
   ; Testing injected label addresses
   JMP @injected_label

@some_data:
   .byte $DE,$AD,$BE,$EF
   .byte $13,$37
   .byte $13,$37

@injected_label:
   JML $000814

   ; EOF marker
   .byte 0,0,0
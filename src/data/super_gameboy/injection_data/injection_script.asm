.p816   ; 65816 processor
.i16    ; X/Y are 16 bits
.a8     ; A is 8 bits

.include "snes.inc"
.segment "CODE"

INJECTION_START:

   .include "map-snes1-to-gb2.asm" 

INJECTION_END:
   JML $00080C

; EOF marker for convert_sfc_to_packets.py
.byte 0,0,0
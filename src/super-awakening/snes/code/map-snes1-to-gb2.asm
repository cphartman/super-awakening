Player2Input = $0F13
Player1Input = $0F11

seta8

INPUT_MAP_R_TO_P2_RIGHT:   
   LDA Player1Input
   AND #KEY_R
   CMP #KEY_R
   BNE INPUT_MAP_R_TO_P2_RIGHT_end
   LDA Player2Input+1
   ORA #KEY_RIGHT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_R_MASK
   STA Player1Input
INPUT_MAP_R_TO_P2_RIGHT_end:


INPUT_MAP_L_TO_P2_LEFT:   
   LDA Player1Input
   AND #KEY_L
   CMP #KEY_L
   BNE INPUT_MAP_L_TO_P2_LEFT_end
   LDA Player2Input+1
   ORA #KEY_LEFT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_L_MASK
   STA Player1Input
INPUT_MAP_L_TO_P2_LEFT_end:

INPUT_MAP_X_TO_P2_A:   
   LDA Player1Input
   AND #KEY_X
   CMP #KEY_X
   BNE INPUT_MAP_X_TO_P2_A_end
   ; Set P2 Bits
   LDA Player2Input
   ORA #KEY_A
   STA Player2Input
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_X_MASK
   STA Player1Input
INPUT_MAP_X_TO_P2_A_end:

INPUT_MAP_Y_TO_P2_B:   
   LDA Player1Input+1
   AND #KEY_Y
   CMP #KEY_Y
   BNE INPUT_MAP_Y_TO_P2_B_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_B
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input+1
   AND #KEY_Y_MASK
   STA Player1Input+1
INPUT_MAP_Y_TO_P2_B_end:

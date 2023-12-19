Player2Input = $0F13
Player1Input = $0F11

seta8

INPUT_MAP_R_TO_P2_START:   
   LDA Player1Input
   AND #KEY_R
   CMP #KEY_R
   BNE INPUT_MAP_R_TO_P2_START_end
   LDA Player2Input+1
   ORA #KEY_START
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_R_MASK
   STA Player1Input
INPUT_MAP_R_TO_P2_START_end:


INPUT_MAP_L_TO_P2_SELECT:   
   LDA Player1Input
   AND #KEY_L
   CMP #KEY_L
   BNE INPUT_MAP_L_TO_P2_SELECT_end
   LDA Player2Input+1
   ORA #KEY_SELECT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_L_MASK
   STA Player1Input
INPUT_MAP_L_TO_P2_SELECT_end:

INPUT_MAP_X_TO_P2_UP:   
   LDA Player1Input
   AND #KEY_X
   CMP #KEY_X
   BNE INPUT_MAP_X_TO_P2_UP_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_UP
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_X_MASK
   STA Player1Input
INPUT_MAP_X_TO_P2_UP_end:

INPUT_MAP_Y_TO_P2_LEFT:   
   LDA Player1Input+1
   AND #KEY_Y
   CMP #KEY_Y
   BNE INPUT_MAP_Y_TO_P2_LEFT_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_LEFT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input+1
   AND #KEY_Y_MASK
   STA Player1Input+1
INPUT_MAP_Y_TO_P2_LEFT_end:

INPUT_MAP_A_TO_P2_RIGHT:   
   LDA Player1Input
   AND #KEY_A
   CMP #KEY_A
   BNE INPUT_MAP_A_TO_P2_RIGHT_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_RIGHT
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input
   AND #KEY_A_MASK
   STA Player1Input
INPUT_MAP_A_TO_P2_RIGHT_end:

INPUT_MAP_B_TO_P2_DOWN:   
   LDA Player1Input+1
   AND #KEY_B
   CMP #KEY_B
   BNE INPUT_MAP_B_TO_P2_DOWN_end
   ; Set P2 Bits
   LDA Player2Input+1
   ORA #KEY_DOWN
   STA Player2Input+1
   ; Unset P1 bits
   LDA Player1Input+1
   AND #KEY_B_MASK
   STA Player1Input+1
INPUT_MAP_B_TO_P2_DOWN_end:
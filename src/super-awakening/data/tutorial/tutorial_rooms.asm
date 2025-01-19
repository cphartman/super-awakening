
Tutorial_Override_1::
  db   ANIMATED_TILES_TIDE ; animation id
  db   $08 ; floor tile
  db   $8A, $50, $1E           ; object
  db   $8A, $60, $1F           ; object
  db   $8A, $70, $1F           ; object
  db   $C2, $00, $03           ; object
  db   $01, $3D                ; object
  db   $82, $02, $2F           ; object
  db   $04, $34                ; object
  db   $C5, $09, $37           ; object
  db   $11, $38                ; object
  db   $22, $FB                ; object
  db   $15, $24                ; object
  db   $20, $3D                ; object
  db   $21, $4E                ; object
  db   $27, $FB                ; object
  db   $C3, $30, $38           ; object
  db   $31, $3B                ; object
  ;db   $43, $C8                ; object
  db   $59, $2E                ; object
  db   $60, $34                ; object
  db   $69, $3E                ; object
  db   $79, $39                ; object

  ; Shipwreck
  db   $43, $23
  

  db   ROOM_END

Tutorial_Override_2::
  db   ANIMATED_TILES_TIDE ; animation id
  db   $08 ; floor tile
  db   $89, $00, $3A           ; object
  db   $09, $37                ; object
  db   $15, $24                ; object
  db   $19, $2E                ; object
  ;db   $23, $C8                ; object
  ;db   $27, $A0                ; object
  ;db   $28, $20                ; object
  db   $29, $39                ; object
  db   $31, $24                ; object
  ;db   $36, $C8                ; hard shell
  ;db   $C2, $37, $20           ; object
  ;db   $C3, $38, $04           ; object
  ;db   $C3, $39, $04           ; object
  ;db   $52, $C8                ; object
  
  ; Ledge jut
  ;db   $56, $36                ; object
  ;db   $57, $3C                ; object
  ;db   $60, $2D                ; object
  ;db   $67, $33                ; object
  ;db   $68, $2F                ; object
  ;db   $69, $3C                ; object
  
  ;db   $70, $32                ; object
  db   $84, $70, $2C           ; object
  db   $74, $2D                ; object
  ;db   $79, $37                ; object

  ; Right tree obstacle
  ;db   $37, $FB                
  
  ; Left tree wall
  db   $2F, $FB                
  db   $4F, $FB                

  ; Sand
  db   $82, $20, $03           

  ; hole
  db   $22, $E8
  db   $32, $E8
  db   $31, $E8

  ; hard shell
  ;db   $31, $C8

  ; Top ledge drop edge
  db   $02, $3F                

  ; Top ledge drop corner
  db   $12, $3B                

  ; Top ledge drop bottom
  db   $82, $10, $3A          

  ; Right wall top
  db   $28, $2B
  db   $29, $2C

  ; Right wall left
  db   $C3, $08, $37

  ; Right wall bottom
  db   $38, $2E
  db   $39, $2F
  db   $48, $39
  db   $49, $3A

  ; Connect bottom corner
  db   $79, $37
  db   $69, $37
  db   $59, $37
  db   $49, $37
  db   $39, $3C

  ; top grass
  db   $C3, $09, $04

  ; Right tree
  db   $57, $FB    

  db   ROOM_END

Tutorial_Override_3:
  db   ANIMATED_TILES_TIDE ; animation id
  db   $03 ; floor tile
  db   $C8, $00, $37           ; object
  db   $85, $05, $3A           ; object
  ;db   $04, $39                ; object
  ;db   $34, $FB                ; object
  db   $39, $FB                ; object
  ;db   $36, $FB                ; object
  db   $59, $FB                ; object
  ;db   $82, $67, $5C           ; object
  ;db   $65, $5C                ; object
  db   $87, $74, $2F           ; object
  db   $73, $3D                ; object
  ;db   $75, $48                ; object
  ;db   $76, $E0                ; stairs
  ;db   $77, $49                ; object

  ; Bottom tree obstacle
  db   $61, $FB       

  ; Top wall bottom
  db   $85, $15, $3A           

  ; Top wall corner
  db   $04, $3E
  db   $14, $39     


  ; Left tree obstacle
  db   $21, $FB

  ; Top rocks
  ;db   $51, $20
  db   $23, $20

  ; Top grass
  db   $C2, $01, $04
  db   $C2, $02, $04
  db   $C2, $03, $04

  ; Middle tree
  db   $36, $FB                ; object

  ; bush
  db   $82, $67, $5C           
  db   $65, $5C                

  db   ROOM_END

Tutorial_Override_4::
  db   ANIMATED_TILES_VILLAGE ; animation id
  db   $04 ; floor tile
  db   $C8, $00, $37           ; object
  db   $00, $3E                ; object
  db   $88, $01, $3A           ; object
  db   $09, $3B                ; object
  db   $30, $2E                ; object
  db   $40, $3E                ; object
  db   $89, $31, $2F           ; object
  db   $89, $41, $3A           ; object
  db   $37, $48                ; object
  db   $C2, $37, $E0           ; object
  db   $39, $49                ; object
  ;db   $34, $48                ; object
  ;db   $35, $43                ; object
  ;db   $36, $49                ; object
  db   $C2, $14, $0B           ; object
  db   $25, $0B                ; object
  db   $63, $36                ; object
  db   $64, $3C                ; object
  db   $74, $2E                ; object
  db   $75, $48                ; object
  db   $76, $4A                ; object
  db   $77, $49                ; object
  db   $82, $78, $2F           ; object

    ; Dash rock
   ;db   $54, $4E

   ; Open chest       
  db   $54, $A1
  db   $55, $A1
  db   $56, $A1

  ; Bottom tree
  db   $58, $F5

  ; Top tree
  db   $19, $F5

  ; Left stairs
  db   $02, $E0

  db   ROOM_END

Tutorial_Override_5::
  db   ANIMATED_TILES_VILLAGE ; animation id
  db   $04 ; floor tile
  db   $C2, $01, $37           ; object
  db   $C2, $00, $0E           ; object
  db   $21, $31                ; object
  db   $20, $2B                ; object
  db   $C5, $30, $37           ; object
  db   $82, $F7, $F5           ; object
  db   $F2, $F5                ; object
  
  ; middle
  /*
  db   $12, $36                ; object
  db   $13, $3C                ; object
  db   $23, $37
  db   $33, $33                ; object
  db   $34, $2F                ; object
  db   $35, $35                ; object
  */

  ;db   $36, $43                ; object
  ;db   $37, $49                ; object
  ;db   $38, $4E                ; object
  ;db   $28, $3D                ; object
  ;db   $29, $2F                ; object
  ;db   $82, $34, $3A           ; object
  ;db   $33, $39                ; object
  ;db   $48, $3B                ; object
  
  db   $70, $2E                ; object
  db   $82, $71, $2F           ; object
  
  ;  Bottom ledge
  db   $73, $49                ; object
  ;db   $74, $43                ; object
  ;db   $75, $49                ; object
  db   $84, $74, $2F           ; object
  db   $79, $4E                ; object
  db   $69, $38
  db   $59, $3D                ; object
  ;db   $69, $2F                ; object
  db   $78, $2F                ; object
  ;db   $14, $D4                ; object
  
  ; Pathway
  ;db   $C2, $05, $0B           ; object
  ;db   $C2, $16, $0B           ; object
  ;db   $56, $0B                ; object
  ;db   $83, $64, $0B           ; object
  
  db   $27, $44                ; object
  db   $55, $44                ; object

  ; Left stairs
  db   $72, $E0

  
  ; Bottom tree
  db   $54, $F5
  db   $23, $F5
  db   $12, $F5

; Right tree
  db   $C2, $19, $F5
  db   $08, $F5

  ; Sign
  db   $48, $D4

    ; hole
  db   $84, $43, $E8
  db   $35, $E8
  db   $53, $E8




  db   ROOM_END
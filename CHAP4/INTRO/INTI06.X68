            ORG     $1000
START       ORI.W   #$0700,SR               ; DISABLE INTS
            MOVE.L  #ISRMOUBU,($64)         ; IRQ1->ISRMOUBU
            MOVE.L  #ISRMOUBD,($68)         ; IRQ2->ISRMOUBD
            MOVE.W  #$0102,D1               ; BUTTON UP->IRQ1
            MOVE.B  #60,D0
            TRAP    #15
            MOVE.W  #$0201,D1               ; BUTTON DOWN->IRQ2
            TRAP    #15
            ANDI.W  #$F8FF,SR               ; ENABLE INTS
.LOOP       BRA     .LOOP
            SIMHALT
ISRMOUBU    MOVEM.L D0/A1,-(A7)             ; THIS ISR PRINTS "BUTTON UP!"
            LEA     .STRING,A1
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0/A1
            RTE
.STRING     DC.B    'BUTTON UP!',0
ISRMOUBD    MOVEM.L D0/A1,-(A7)             ; THIS ISR PRINTS "BUTTON DOWN!"
            LEA     .STRING,A1
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0/A1
            RTE
.STRING     DC.B    'BUTTON DOWN!',0
            END     START
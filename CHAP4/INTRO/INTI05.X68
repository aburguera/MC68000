            ORG     $1000
START       ORI.W   #$0700,SR               ; DISABLE INTS
            MOVE.L  #ISRKEYUP,($64)         ; IRQ1->ISRKEYUP
            MOVE.L  #ISRKEYDN,($68)         ; IRQ2->ISRKEYDN
            MOVE.W  #$0102,D1               ; KEY UP->IRQ1
            MOVE.B  #62,D0
            TRAP    #15
            MOVE.W  #$0201,D1               ; KEY DOWN->IRQ2
            TRAP    #15
            ANDI.W  #$F8FF,SR               ; ENABLE INTS
.LOOP       BRA     .LOOP                   ; INFINITE LOOP
            SIMHALT
ISRKEYDN    MOVEM.L D0/A1,-(A7)             ; THIS ISR JUST PRINTS "KEY DOWN!"
            LEA     .STRING,A1
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0/A1
            RTE
.STRING     DC.B    'KEY DOWN!',0
ISRKEYUP    MOVEM.L D0/A1,-(A7)             ; THIS ISR JUST PRINTS "KEY UP!"
            LEA     .STRING,A1
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0/A1
            RTE
.STRING     DC.B    'KEY UP!',0
            END     START
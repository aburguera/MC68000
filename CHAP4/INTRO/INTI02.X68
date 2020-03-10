            ORG     $1000
START       ORI.W   #$0700,SR
            MOVE.L  #ISR1,($64)
            ANDI.W  #$F8FF,SR
.LOOP       BRA     .LOOP
ISR1        MOVEM.L D0/A0,-(A7)
            ADDQ.B  #1,(COUNTER)
            MOVE.B  (COUNTER),D0
            AND.L   #$03,D0
            LEA     .DATA,A0
            MOVE.B  (A0,D0),(VALUE)
            MOVEM.L (A7)+,D0/A0
            RTE
.DATA       DC.B    10,20,50,30
            DS.W    0
COUNTER     DS.B    1
VALUE       DS.B    1
            DS.W    0
            SIMHALT
            END     START
            ORG     $1000
START       MOVE.B  #2,D0
            JSR     SBR0
            SIMHALT
SBR0        ADD.B   #42,D0
            RTS
            END     START
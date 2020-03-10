            ORG     $1000
SBR1        MOVE.B  #37,D1
            RTS
SBR0        MOVE.B  #42,D0
            RTS
SBR2        MOVE.B  #38,D1
            RTS
START       SIMHALT
            END     START
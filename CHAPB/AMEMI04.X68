            ORG         $1000
START       BSR         SBR0
            SIMHALT
SBR0        MOVE.B      D0,-(A7)
            MOVE.B      #4,D0
            BSR         SBR1
            MOVE.B      (A7)+,D0
            RTS
SBR1        ADD         #5,D0
            RTS
            END         START
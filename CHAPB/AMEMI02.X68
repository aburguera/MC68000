            ORG         $1000
START       LEA         .DATA0,A0
            BSR         SBR0
.LOOP       BRA         .LOOP
.DATA0      DS.B        3
            DS.W        0
SBR0        MOVE.B      #2,D0
            RTS
            END         START
            ORG     $1000
START       MOVE.W  #4,D0
            MOVE.W  #2,D1
            ADD.B   D2,D3
            ADD.W   D3,D4
            ADD.L   D1,D7
            SIMHALT
VAR         DS.W    1
            END     START
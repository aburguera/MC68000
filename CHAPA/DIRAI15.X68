            ORG     $1000
START       MOVE.W  #4,D0
            MOVE.W  #2,D1
            ADD.W   D2,D3
            ADD.W   #2,D3
            ADD.W   #2,(VAR)
            SIMHALT
VAR         DS.W    1
            END     START
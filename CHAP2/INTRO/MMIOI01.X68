            ORG     $1000
START       MOVE.W  ($3000),D0
            CMP.W   #10,D0
            BGT     NOWRITE
            MOVE.W  D0,($3002)
NOWRITE     SIMHALT
            END     START
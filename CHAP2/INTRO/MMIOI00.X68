            ORG     $1000
START       CMP.W   #10,($3000)
            BGT     NOWRITE
            MOVE.W  ($3000),($3002)
NOWRITE     SIMHALT
            END     START
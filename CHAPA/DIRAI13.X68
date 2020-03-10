            ORG     $1000
START       MOVE.W  #4,D0
            MOVE.W  #2,D1
            ADD.W   D0,D1
            SIMHALT
            END     START
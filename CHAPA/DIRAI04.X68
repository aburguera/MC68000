TAG0        EQU     640
TAG1        EQU     480
            ORG     $1000
START       MOVE.L  #TAG0<<16|TAG1,D0
            SIMHALT
            END     START
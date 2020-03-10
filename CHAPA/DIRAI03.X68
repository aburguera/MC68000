TAG0        EQU     640
TAG1        EQU     480
            ORG     $1000
START       MOVE.W  #TAG0,D0
            SWAP    D0
            MOVE.W  #TAG1,D0
            SIMHALT
            END     START
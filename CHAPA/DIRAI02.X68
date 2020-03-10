TAG0        EQU     1000
TAG1        EQU     TAG0+100
            ORG     $1000
START       MOVE.B  #12,D0
TAG2        EQU     START+10
            SIMHALT
            END     START
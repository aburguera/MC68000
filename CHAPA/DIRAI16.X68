SUMRR       MACRO
            ADD.\0  D\1,D\2
            ENDM
            ORG     $1000
START       MOVE.W  #4,D0
            MOVE.W  #2,D1
            SUMRR.B 2,3
            SUMRR.W 3,4
            SUMRR.L 1,7
            SIMHALT
VAR         DS.W    1
            END     START
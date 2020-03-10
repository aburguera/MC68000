SUMD0D1     MACRO
            ADD.W   D0,D1
            ENDM
            ORG     $1000
START       MOVE.W  #4,D0
            MOVE.W  #2,D1
            SUMD0D1
            SIMHALT
            END     START
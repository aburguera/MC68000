SUMRR       MACRO
            ADD.W   D\1,D\2
            ENDM
SUMVR       MACRO
            ADD.W   #\1,D\2
            ENDM
SUMGEN      MACRO
            ADD.W   \1,\2
            ENDM
            ORG     $1000
START       MOVE.W  #4,D0
            MOVE.W  #2,D1
            SUMRR   2,3
            SUMVR   2,3
            SUMGEN  #2,(VAR)
            SIMHALT
VAR         DS.W    1
            END     START
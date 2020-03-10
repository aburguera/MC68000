VAL0        EQU     1000*2
VAL1        EQU     2000+VAL0
            ORG     $1000
START       MOVE.W  #VAL0,D0
            MOVE.W  #VAL1,D0
            MOVE.W  #VAL0+VAL1,D0
            MOVE.B  #123,(VAR)
            BSR     SBR0
            SIMHALT
SBR0        ADD.W   #VAL1-VAL0,D0
            RTS
VAR         DS.B    1
            END    START
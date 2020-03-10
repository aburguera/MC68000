        ORG     $1000
START   MOVE.L  #ISRDIV,($14)
        MOVE.L  #42,D0
        DIVU    #0,D0
        LEA     .STR0,A1
        MOVE.B  #13,D0
        TRAP    #15
        SIMHALT
.STR0   DC.B    'DONE.',0
        DS.W    0
ISRDIV  MOVEM.L  D0/A1,-(A7)
        LEA     .STR1,A1
        MOVE.B  #13,D0
        TRAP    #15
        MOVEM.L (A7)+,D0/A1
        RTE
.STR1   DC.B    'ZERO DIVIDE!',0
        DS.W    0
        END     START
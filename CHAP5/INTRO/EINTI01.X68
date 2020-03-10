        ORG     $1000
START   MOVE.L  #ISRPRI,($20)
        AND.W   #$DFFF,SR
        ORI.W   #$2000,SR
        LEA     .STR0,A1
        MOVE.B  #13,D0
        TRAP    #15
        SIMHALT
.STR0   DC.B    'DONE.',0
        DS.W    0
ISRPRI  MOVEM.L  D0/A1,-(A7)
        LEA     .STR1,A1
        MOVE.B  #13,D0
        TRAP    #15
        MOVEM.L (A7)+,D0/A1
        RTE
.STR1   DC.B    'PRIVILEGE VIOLATION!',0
        DS.W    0
        END     START
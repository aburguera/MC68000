            ORG     $1000
START       LEA     DATA0,A0
            JSR     ADDDATA
            MOVE.L  D0,(DATA1)
            MOVE.W  #10,D2
            JSR     FIBONACCI
            SIMHALT
DATA0       DC.L    10,23,42,1000,201,0
ADDDATA     CLR.L   D0
LOOP0       MOVE.L  (A0)+,D1
            BEQ     END0
            ADD.L   D1,D0
            BRA     LOOP0
END0        RTS
FIBONACCI   CLR.W   D0
            MOVE.W  #1,D1
LOOP1       ADD.W   D1,D0
            ADDQ.W  #1,D1
            DBRA.W  D2,LOOP1
            RTS
DATA1       DS.L    1
            END     START

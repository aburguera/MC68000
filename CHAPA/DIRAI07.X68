            ORG     $1000
START       LEA     .DATA,A0
            JSR     ADDDATA
            MOVE.L  D0,(DATA)
            MOVE.W  #10,D2
            JSR     FIBONACCI
            SIMHALT
.DATA       DC.L    10,23,42,1000,201,0
ADDDATA     CLR.L   D0
.LOOP       MOVE.L  (A0)+,D1
            BEQ     .END
            ADD.L   D1,D0
            BRA     .LOOP
.END        RTS
FIBONACCI   CLR.W   D0
            MOVE.W  #1,D1
.LOOP       ADD.W   D1,D0
            ADDQ.W  #1,D1
            DBRA.W  D2,.LOOP
            RTS
DATA        DS.L    1
            END     START
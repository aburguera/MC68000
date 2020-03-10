            ORG         $1000
START       LEA         .DATA0,A0
            MOVE.B      (A0)+,D0
            MOVE.W      (A0)+,D1
.LOOP       BRA         .LOOP
.DATA0      DC.B        $0A
            DC.W        $F2A5
            DS.W        0
            END         START
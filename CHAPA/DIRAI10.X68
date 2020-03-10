            ORG     $1000
            INCLUDE "DIRAI08.X68"
SBR0        MOVE.B  #42,D0
            RTS
            INCLUDE "DIRAI09.X68"
START       SIMHALT
            END     START
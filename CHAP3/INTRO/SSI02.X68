            ORG     $1000
START       MOVE.L  USP,A6
            MOVE.L  #12,-(A6)
            MOVE.L  #34,-(A7)
            MOVE.L  A6,USP
            SIMHALT
            END     START
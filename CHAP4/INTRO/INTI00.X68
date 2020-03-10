            ORG     $1000

START
            MOVE.W  SR,D0
            AND.W   #$F8FF,D0
            OR.W    #$0400,D0
            MOVE.W  D0,SR

            SIMHALT

            END     START
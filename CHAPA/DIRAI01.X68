            MOVE.W  #2000,D0
            MOVE.W  #4000,D0
            MOVE.W  #6000,D0
            MOVE.B  #123,($1022)
            BSR     $101C
            SIMHALT
            ADD.W   #2000,D0
            RTS
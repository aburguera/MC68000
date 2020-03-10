            ORG     $1000
START       MOVE.B  #32,D0
            MOVE.B  #2,D1
            TRAP    #15                     ; GET MAPPING ADDRESS INTO D1.L
            MOVE.L  D1,A0                   ; TRANSFER IT TO AN ADDRESS REG.
            MOVE.B  #%10000001,(A0)         ; CHANGE LEDS
            SIMHALT
            END     START
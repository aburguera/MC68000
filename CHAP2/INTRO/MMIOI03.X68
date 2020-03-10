            ORG     $1000
START       MOVE.B  #$01,($00E00010)        ; ACTIVATE THE RIGHTMOST LED
            SIMHALT
            END     START
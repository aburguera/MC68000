            ORG     $1000
START       MOVE.B  #32,D0                  ; SPECIFY TASK 32 (GET ADDRESS)
            MOVE.B  #2,D1                   ; SET PARAMETER TO LED ADDRESS
            TRAP    #15                     ; GET IT AND PLACE INTO D1.L
            SIMHALT
            END     START
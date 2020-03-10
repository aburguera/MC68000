            ORG     $1000
START       MOVE.B  #32,D0                  ; SPECIFY TASK 32
            CLR.B   D1                      ; PARAMETER TO SHOW HARDWARE WINDOW
            TRAP    #15                     ; SHOW IT!
            SIMHALT
            END     START
            ORG     $1000
START       ORI.W   #$0700,SR               ; DISABLE INTS
            MOVE.L  #ISRTIM,($64)           ; IRQ1->ISRTIM
            MOVE.B  #32,D0                  ; SELECT TASK 32
            MOVE.B  #6,D1                   ; SELECT SIMULATED TIMER
            MOVE.B  #$81,D2                 ; ENABLE TIMER, USE IRQ1
            MOVE.L  #1000,D3                ; SET PERIOD TO 1SEC
            TRAP    #15
            ANDI.W  #$F8FF,SR               ; ENABLE INTS
.LOOP       BRA     .LOOP
            SIMHALT
ISRTIM      MOVEM.L D0/A1,-(A7)             ; THIS ISR PRINTS "TIC!"
            LEA     .STRING,A1
            MOVE.B  #13,D0
            TRAP    #15
            MOVEM.L (A7)+,D0/A1
            RTE
.STRING     DC.B    'TIC!',0
            END     START
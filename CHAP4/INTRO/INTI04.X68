            ORG     $1000
START       ORI.W   #$0700,SR               ; DISABLE INT
            MOVE.L  #ISR,($64)              ; INSTALL INT1
            ANDI.W  #$F8FF,SR               ; ENABLE INT
.LOOP       BRA     .LOOP                   ; INFINITE LOOP
ISR         MOVEM.L D0-D1/A1,-(A7)          ; SAVE REGISTERS
            MOVE.W  #$FF00,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; CLEAR SCREEN
            MOVE.B  #8,D0
            TRAP    #15                     ; GET TIME IN HUNDREDS OF SECOND
            LEA     .TXT,A1
            MOVE.B  #17,D0
            TRAP    #15                     ; PRINT TEXT AND TIME
            MOVEM.L (A7)+,D0-D1/A1
            RTE
.TXT        DC.B    'TIME SINCE MIDNIGHT ',0
            SIMHALT
            END     START
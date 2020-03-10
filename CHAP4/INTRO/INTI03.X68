            ORG     $1000
START       ORI.W   #$0700,SR               ; DISABLE INT
            MOVE.L  #ISR,($64)              ; INSTALL INT1
            MOVE.L  #ISR,($68)              ; INSTALL INT2
            MOVE.L  #ISR,($6C)              ; INSTALL INT3
            MOVE.L  #ISR,($70)              ; INSTALL INT4
            ANDI.W  #$F8FF,SR               ; ENABLE INT
.LOOP       BRA     .LOOP                   ; INFINITE LOOP
ISR         MOVEM.L D0-D1/A1,-(A7)          ; SAVE REGISTERS
            MOVE.W  #$FF00,D1
            MOVE.B  #11,D0
            TRAP    #15                     ; CLEAR SCREEN
            MOVE.W  SR,D1
            ROR.W   #8,D1
            AND.L   #$00000007,D1           ; GET INT NUM FROM SR
            LEA     .TXT,A1
            MOVE.B  #17,D0
            TRAP    #15                     ; PRINT INT NUM
            MOVEM.L (A7)+,D0-D1/A1          ; RESTORE REGISTERS
            RTE
.TXT        DC.B    'INTERRUPT NUMBER ',0
            SIMHALT
            END     START
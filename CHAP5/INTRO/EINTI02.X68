            ORG     $1000
START       MOVE.L  #ISRTRACE,($24)         ; SET THE TRACE ISR
            ORI.W   #$8000,SR               ; ENABLE TRACE
            CLR.L   D0
.LOOP       ADDQ.L  #1,D0
            BRA     .LOOP
            SIMHALT
ISRTRACE    MOVEM.L D0-D2,-(A7)             ; STORE REGISTERS
            MOVE.L  D0,D2                   ; COPY D0 INTO D2 FOR FURTHER USE
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15                     ; CLEAR SCREEN
            MOVE.L  D2,D1
            MOVE.B  #16,D2
            MOVE.B  #15,D0
            TRAP    #15                     ; PRINT THE ORIGINAL D0 IN HEX
            MOVEM.L (A7)+,D0-D2             ; RESTORE REGISTERS
            RTE
            END     START
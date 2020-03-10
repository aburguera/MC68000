; =============================================================================
; HEADER
; =============================================================================
            ORG     $1000

            INCLUDE "MACRO.X68"             ; MACRO DEFINITIONS
            INCLUDE "SYSTEM.X68"            ; SUBROUTINES
            INCLUDE "SYSVAR.X68"            ; SYSTEM VARS

; =============================================================================
; MAIN PROGRAM
; =============================================================================
START
            ; INITIALIZE ALL REGS TO EASILY IDENTIFIABLE VALUES
            LEA     .INIVAL,A6
            MOVEM.L (A6)+,D0-D7/A0-A5
            MOVE.L  (A6)+,A6

            ; INSTALL EVERYTHING
            BSR     INSTALL

            ; RUN AN EASILY TRACEABLE CODE
.LOOP       ADDQ.L  #1,D0
            ADDQ.L  #1,D1
            ADDQ.L  #1,D2
            ADDQ.L  #1,D3
            ADDQ.L  #1,D4
            ADDQ.L  #1,D5
            ADDQ.L  #1,D6
            ADDQ.L  #1,D7

            ADDQ.L  #1,A0
            ADDQ.L  #1,A1
            ADDQ.L  #1,A2
            ADDQ.L  #1,A3
            ADDQ.L  #1,A4
            ADDQ.L  #1,A5
            ADDQ.L  #1,A6

            MOVE.L  A0,-(A7)
            MOVE.L  (A7)+,A0

            BRA     .LOOP

            ; VALUES USED TO INITIALIZE REGISTERS
.INIVAL     DC.L    $D0D0D0D0
            DC.L    $D1D1D1D1
            DC.L    $D2D2D2D2
            DC.L    $D3D3D3D3
            DC.L    $D4D4D4D4
            DC.L    $D5D5D5D5
            DC.L    $D6D6D6D6
            DC.L    $D7D7D7D7

            DC.L    $A0A0A0A0
            DC.L    $A1A1A1A1
            DC.L    $A2A2A2A2
            DC.L    $A3A3A3A3
            DC.L    $A4A4A4A4
            DC.L    $A5A5A5A5
            DC.L    $A6A6A6A6

            END     START
; =============================================================================
; HEADER
; =============================================================================

            ORG     $1000
            INCLUDE "SUBRTN.X68"
            INCLUDE "VARS.X68"
DISPNUM     EQU     7

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START       BSR     SHOWHWIN
            LEA     SEGMADDR,A0
            BSR     GTHWADDR
            MOVE.L  (BUTADDR), A0
            MOVE.L  (SEGMADDR), A1
.LOOP       MOVE.B  (A0),D0
            NOT     D0
            MOVE.B  D0,DISPNUM*2(A1)
            BRA     .LOOP

            END     START
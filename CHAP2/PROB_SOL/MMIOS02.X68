; =============================================================================
; HEADER
; =============================================================================

            ORG     $1000
            INCLUDE "SUBRTN.X68"
            INCLUDE "VARS.X68"

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START       BSR     SHOWHWIN
            LEA     SEGMADDR,A0
            BSR     GTHWADDR
            MOVE.L  (SEGMADDR), A0
            MOVE.B  #3,D0          ; NUMBER TO DISPLAY
            BSR     WRTSEGM
.LOOP       BRA     .LOOP

; =============================================================================
; SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
WRTSEGM
; DISPLAYS A NUMBER BETWEEN 0 AND 9 IN THE RIGHTMOST 7-SEGMENT DISPLAY
; INPUT    - D0.B: NUMBER TO DISPLAY
;            A0  : DISPLAY SET MAPPING ADDRESS
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1,-(A7)
            AND.L   #$FF,D0
            LEA     .DATA,A1
            MOVE.B  (A1,D0),14(A0)
            MOVEM.L (A7)+,D0/A1
            RTS
.DATA       DC.B    $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F

            END     START
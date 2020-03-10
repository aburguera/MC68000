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
            MOVE.W  #$0207,D0
            BSR     WRTSEGM
.LOOP       BRA     .LOOP

; =============================================================================
; SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
WRTSEGM
; DISPLAYS A NUMBER BETWEEN 0 AND 9 IN THE SPECIFIED 7-SEGMENT DISPLAY
; INPUT    - D0.W: MSB: DISPLAY NUMBER, LSB VALUE (0-9) TO SHOW. A DISPLAY
;                  NUMBER OF 0 MEANS THE RIGHTMOST DISPLAY WHILST A VALUE OF
;                  7 MEANS THE LEFTMOST.
;            A0  : DISPLAY SET MAPPING ADDRESS
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)
            MOVE.W  D0,D1
            AND.L   #$FF,D0
            NOT.W   D1
            LSR.W   #7,D1
            AND.L   #$0E,D1
            LEA     .DATA,A1
            MOVE.B  (A1,D0),(A0,D1)
            MOVEM.L (A7)+,D0-D1/A1
            RTS
.DATA       DC.B    $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F

            END     START
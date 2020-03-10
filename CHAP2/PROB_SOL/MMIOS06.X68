; =============================================================================
; HEADER
; =============================================================================

            ORG     $1000
            INCLUDE "MACROS.X68"
            INCLUDE "MAPHARD.X68"
            INCLUDE "VARS.X68"

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START       MOVE.B  #3,D0                   ; EXAMPLE BCD NUMBERS
            MOVE.B  #9,D1
            PCKBCD  D0,D1                   ; PACK THEM
            DPCKBCD D0,D1                   ; DEPACK THEM
            BSR     SHOWHWIN                ; OPEN HARDWARE WINDOW
            LEA     SEGMADDR,A0
            BSR     GTHWADDR                ; GET MAPPING ADDRESSES
            MOVE.L  (SEGMADDR), A0          ; GET 7-SEGMENT ADDRESS
            AND.W   #$00FF,D0               ; SPECIFY RIGHTMOST DISPLAY
            BSR     WRTSEGM                 ; SHOW D0
            MOVE.B  D1,D0                   ; GET THE SECOND SUMBER
            OR.W    #$0100,D0               ; SPECIFY NEXT DISPLAY
            BSR     WRTSEGM                 ; SHOW IT
            SIMHALT

            END     START
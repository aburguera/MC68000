; =============================================================================
; HEADER
; =============================================================================

            OPT     MEX
            ORG     $1000

            INCLUDE "MACRO.X68"             ; MACRO DEFINITION
            INCLUDE "SYSTEM.X68"            ; SYSTEM ROUTINES
            INCLUDE "SYSVAR.X68"            ; SYSTEM VARIABLES
            INCLUDE "SUBRTN.X68"            ; USER SUBROUTINES
            INCLUDE "VAR.X68"               ; USER VARIABLES

; =============================================================================
; MAIN PROGRAM
; =============================================================================
START
            LEA     RESLTN,A0               ; GET POINTER TO THE INIT DATA
            BSR     INIT                    ; SET WINDOWED AND RESOLUTION
            LEA     DBLOCK0,A0              ; GET POINTER TO POLYGON DATA BLOCK
            BSR     DRAWPOLY                ; DRAW FIRST POLYGON
            LEA     DBLOCK1,A0              ; GET POINTER TO POLYGON DATA BLOCK
            BSR     DRAWPOLY                ; DRAW SECOND POLYGON
.LOOP       BRA     .LOOP                   ; WAIT UNTIL THE END OF TIME

; =============================================================================
; CONSTANT DATA
; =============================================================================
DBLOCK0     DC.L    STAR                    ; POINTER TO THE POLYGON DEFINITION
            DC.W    150                     ; X COORDINATE (PIXELS)
            DC.W    200                     ; Y COORDINATE (PIXELS)
DBLOCK1     DC.L    STAR                    ; POINTER TO THE POLYGON DEFINITION
            DC.W    400                     ; X COORDINATE (PIXELS)
            DC.W    300                     ; Y COORDINATE (PIXELS)
STAR        DC.W    87,138,70,40,141,-29,42 ; POLYGON DEFINITION. SEQUENCE OF
            DC.W    -43,-2,-133,-45,-43     ;  VERTEX COORDINATES (X,Y) TERMI-
            DC.W    -144,-29,-72,40,-89     ;  NATED WITH $FFFF. EACH COORDI-
            DC.W    138,-2,92,87,138,$FFFF  ;  NATE IS A WORD.
RESLTN      DC.L    (640<<16)|480           ; THE RESOLUTION (640X480)

            END     START
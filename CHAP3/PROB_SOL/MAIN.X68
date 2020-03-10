; =============================================================================
; HEADER
; =============================================================================

            OPT     MEX
            ORG    $1000

            INCLUDE "MACRO.X68"             ; MACRO DEFINITION
            INCLUDE "SYSTEM.X68"            ; SYSTEM ROUTINES
            INCLUDE "SYSVAR.X68"            ; SYSTEM VARIABLES
            INCLUDE "SUBRTN.X68"            ; USER SUBROUTINES
            INCLUDE "VAR.X68"               ; USER VARIABLES

; =============================================================================
; CONSTANTS
; =============================================================================
TSTNUM      EQU     1324

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START
            BSR     INSTALL

            LEA     NUMSTR,A0
            MOVE.W  #TSTNUM,D1
            BSR     ITOA

            MOVE.L  #STR2,-(A7)
            MOVE.L  #NUMSTR,-(A7)
            MOVE.L  #TSTSTR,-(A7)
            BSR     STRCAT
            ADD.L   #12,A7

            SINIT   640,480
            SSETPAL PAL
            SLOCATE 25,12
            SPRINT  STR0
            SLOCATE 56,18
            SSETFILL 3
            SPRINT  STR1
            SSETPEN 4
            SDRAWPOL STAR,200,200
            SSETPEN 8
            SDRAWPOL STAR,450,300
            SSETFILL 11
            SLOCATE 0,0
            SPRINT  TSTSTR

.LOOP       BRA     .LOOP

            SIMHALT

; =============================================================================
; CONSTANT DATA
; =============================================================================
STR0        DC.B    'HOLA ',0
STR1        DC.B    'MUNDO',0
STR2        DC.B    'NUMBER:',0
            DS.W    0

STAR        DC.W    87,138,70,40,141,-29,42,-43,-2,-133,-45,-43,-144,-29
            DC.W    -72,40,-89,138,-2,92,87,138,$FFFF
PAL         DC.L    $00000000
            DC.L    $00050505
            DC.L    $0042C821
            DC.L    $0078DC5E
            DC.L    $00ED5554
            DC.L    $00FC767D
            DC.L    $004D52D4
            DC.L    $00F5EB42
            DC.L    $005455FC
            DC.L    $007879FF
            DC.L    $0054C1D4
            DC.L    $0080CEE6
            DC.L    $003BB021
            DC.L    $00BA5BC9
            DC.L    $00CCCCCC
            DC.L    $00FFFFFF

            END     START
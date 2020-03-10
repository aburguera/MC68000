; =============================================================================
; HEADER
; =============================================================================

            INCLUDE "MACRO.X68"
            INCLUDE "CONST.X68"

            ORG     $1000

            INCLUDE "SUBRTN.X68"
            INCLUDE "SYSTEM.X68"
            INCLUDE "SYSVAR.X68"

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START       BSR     INSTALL                 ; INSTALL ISR
.LOOP       BRA     .LOOP                   ; ENDLESS LOOP. FROM NOW ON, EVERY-
                                            ; THING IS INTERRUPT-DRIVEN.
            SIMHALT

            END     START
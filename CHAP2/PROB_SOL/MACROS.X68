; =============================================================================
; MACRO DEFINITION
; =============================================================================

; -----------------------------------------------------------------------------
PCKBCD      MACRO
; PACKS THE BCD NUMBERS IN \1 AND \2 (ONE BYTE EACH) INTO A SINGLE BYTE, WHERE
; \1 OCCUPIES THE LEAST SIGNIFICANT 4 BITS AND \2 OCCUPIES THE MOST SIGNIFICANT
; 4 BITS.
; INPUT    - \1  : NON-PACKED BCD NUMBER
;            \2  : NON-PACKED BCD NUMBER
; OUTPUT   - \1  : PACKED BCD NUMBER
; MODIFIES - \1.B, \2.B
; -----------------------------------------------------------------------------
            IFNE NARG-2
            FAIL ERROR: PCKBCD REQUIRES 2 ARGUMENTS
            MEXIT
            ENDC
            LSL.B   #4,\2
            OR.B    \2,\1
            ENDM

; -----------------------------------------------------------------------------
DPCKBCD     MACRO
; DEPACKS THE BCD NUMBERS IN \1 (4 BITS EACH) INTO TWO BYTES. THE LEAST SIGNI-
; FICANT DIGIT EXPANDS TO ONE BYTE IN \1 AND THE MOST SIGNIFICANT ONE GOES,
; ALSO IN ONE BYTE, TO \2
; INPUT    - \1  : TWO PACKED BCD NUMBERS
; OUTPUT   - \1  : LEAST SIGNIFICANT NUMBER
;          - \2  : MOST SIGNIFICANT NUMBR
; MODIFIES - \1.B, \2.B
; -----------------------------------------------------------------------------
            IFNE NARG-2
            FAIL ERROR: DPCKBCD REQUIRES 2 ARGUMENTS
            MEXIT
            ENDC
            MOVE.B  \1,\2
            AND.B   #$0F,\1
            LSR.B   #4,\2
            ENDM
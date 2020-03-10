; =============================================================================
; MACRO DEFINITION
; =============================================================================

; -----------------------------------------------------------------------------
SINIT       MACRO
; WRAPPER FOR INIT SYSTEM CALL
; INPUT    - \1  : DESIRED RESOLUTION (CONSTANT, LONG, WIDTH_HEIGHT)
; OUTPUT   - OUTPUT WINDOWED AND SET TO SPECIFIED RESOLUTION
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    0
            IFNE NARG-2
            DC.L    (640<<16)|480
            MEXIT
            ENDC
            DC.L    (\1<<16)|\2
            ENDM

; -----------------------------------------------------------------------------
SSETPAL     MACRO
; WRAPPER FOR SET PALETTE SYSTEM CALL.
; INPUT    - \1  : POINTER TO THE PALETTE (CONSTANT)
; OUTPUT   - SYSTEM PALETTE DEFINED.
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    4
            DC.L    \1
            ENDM

; -----------------------------------------------------------------------------
SLOCATE     MACRO
; WRAPPER FOR LOCATE SYSTEM CALL
; INPUT    - \1  : X COORDINATE (BYTE, CONSTANT)
;          - \2  : Y COORDINATE (BYTE, CONSTANT)
; OUTPUT   - COORDINATES FOR NEXT TEXT PRINT SET.
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    2
            DC.W    (\1<<8)|\2
            ENDM

; -----------------------------------------------------------------------------
SPRINT      MACRO
; WRAPPER FOR TEXT PRINT SYSTEM CALL
; INPUT    - \1  : POINTER TO THE ZERO-TERMINATED STRING (CONSTANT)
; OUTPUT   - TEXT PRINTED
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    1
            DC.L    \1
            ENDM

; -----------------------------------------------------------------------------
SSETPEN     MACRO
; WRAPPER FOR SET PEN COLOR SYSTEM CALL
; INPUT    - \1  : PALETTE INDEX (WORD, CONSTANT)
; OUTPUT   - COLOR SET
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    5
            DC.W    \1
            ENDM

; -----------------------------------------------------------------------------
SSETFILL    MACRO
; WRAPPER FOR SET FILL COLOR SYSTEM CALL
; INPUT    - \1  : PALETTE INDEX (WORD, CONSTANT)
; OUTPUT   - COLOR SET
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    6
            DC.W    \1
            ENDM

; -----------------------------------------------------------------------------
SDRAWPOL    MACRO
; WRAPPER FOR DRAW POLYGON SYSTEM CALL
; INPUT    - \1  : POINTER TO THE POLYGON DEFINITION (COORDINATES X,Y IN WORD
;                  FORMAT AND TERMINATED WITH $FFFF
;          - \2  : X TRANSLATION
;          - \3  : Y TRANSLATION
; OUTPUT   - POLYGON DRAWN
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    3
            DC.L    \1
            DC.W    \2,\3
            ENDM

; -----------------------------------------------------------------------------
SJOYPAD     MACRO
; WRAPPER FOR KEYBOARD OPQA SYSTEM CALL
; INPUT    - NONE
; OUTPUT   - D1.L OOPPQQAA (ONE BYTE PER KEY OPQA, ZERO: NOT PRESSED)
; MODIFIES - ONLY THE OUTPUT D1.L
; -----------------------------------------------------------------------------
            TRAP    #0
            DC.W    7
            ENDM
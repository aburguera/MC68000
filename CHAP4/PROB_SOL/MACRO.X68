; =============================================================================
; MACRO
; =============================================================================

; -----------------------------------------------------------------------------
INIDBUF     MACRO
; SETS DOUBLE BUFFER MODE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0.B,D1.B
; -----------------------------------------------------------------------------
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
CLRSCR      MACRO
; CLEARS THE SCREEN (OR THE ACTIVE BUFFER IF IN DOUBLE BUFFER MODE)
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0.B,D1.W
; -----------------------------------------------------------------------------
            MOVE.W  #$FF00,D1
            MOVE.B  #11,D0
            TRAP    #15
            ENDM

; -----------------------------------------------------------------------------
UPDTDBUF    MACRO
; SWAPS THE ACTIVE AND THE VISIBLE SCREEN BUFFERS. ONLY USEABLE IF D.BUFFER
; IS ACTIVE (USING INIDBUF)
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0.B
; -----------------------------------------------------------------------------
            MOVE.B  #94,D0
            TRAP    #15
            ENDM
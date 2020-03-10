; =============================================================================
; HEADER
; =============================================================================

            ORG     $1000

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START       BSR     SHOWHWIN
            LEA     SEGMADDR,A0
            BSR     GTHWADDR
            MOVE.L  (BUTADDR), A0
            MOVE.L  (LEDADDR), A1
.LOOP       MOVE.B  (A0),D0
            NOT.B   D0
            MOVE.B  D0,(A1)
            BRA     .LOOP

; =============================================================================
; SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
SHOWHWIN
; SHOWS THE HARDWARE WINDOW
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            MOVE.B  #32, D0
            CLR.B   D1
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
GTHWADDR
; PUTS THE ADDRESSES WHERE THE 7-SEGMENT DISPLAY, THE LED ARRAY, THE SWITCHES
; AND THE TOGGLE BUTTONS ARE MAPPED IN THE RAM ADDRESSES BEGINNING AT A0 IN
; THE SPECIFIED ORDER.
; INPUT    - A0: ADDRESS TO BEGIN STORING MAPPED HARDWARE ADDRESSES.
; OUTPUT   - ADDRESSES STORED IN RAM.
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1/D0-D2,-(A7)
            LEA     .DATA,A1
            MOVE.W  #3,D2
            MOVE.B  #32,D0
.LOOP       MOVE.B  (A1)+,D1
            TRAP    #15
            MOVE.L  D1,(A0)+
            DBRA.W  D2,.LOOP
            MOVEM.L (A7)+,A0-A1/D0-D2
            RTS

            ; TRAP #15 FUNCTION 32 PARAMETERS
.DATA       DC.B    1,2,3,7
            DS.W    0

; -----------------------------------------------------------------------------
GTHWADDR2
; PUTS THE ADDRESSES WHERE THE 7-SEGMENT DISPLAY, THE LED ARRAY, THE SWITCHES
; AND THE TOGGLE BUTTONS ARE MAPPED IN THE RAM ADDRESSES BEGINNING AT A0 IN
; THE SPECIFIED ORDER. IT PERFORMS THE SAME TASK AS GTHWADDR, AND IT IS JUST
; MEANT TO BE AN EXAMPLE OF STACK STORAGE AND RETRIEVAL.
; INPUT    - A0: ADDRESS TO BEGIN STORING MAPPED HARDWARE ADDRESSES.
; OUTPUT   - ADDRESSES STORED IN RAM.
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.W  D0/D2,-(A7)
            MOVEM.L  A1/D1,-(A7)
            LEA     .DATA,A1
            MOVE.W  #3,D2
            MOVE.B  #32,D0
.LOOP       MOVE.B  (A1)+,D1
            TRAP    #15
            MOVE.L  D1,(A0)+
            DBRA.W  D2,.LOOP
            MOVEM.L (A7)+,A1/D1
            MOVEM.W (A7)+,D0/D2
            RTS

            ; TRAP #15 FUNCTION 32 PARAMETERS
.DATA       DC.B    1,2,3,7
            DS.W    0

; =============================================================================
; VARS
; =============================================================================

SEGMADDR    DS.L    1
LEDADDR     DS.L    1
STCHADDR    DS.L    1
BUTADDR     DS.L    1
            END     START
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
            MOVEM.L D0-D1,-(A7)             ; STORE REGISTERS
            MOVE.B  #32, D0                 ; SPECIFY TASK 32
            CLR.B   D1                      ; SPECIFY SHOW HARDWARE WINDOW
            TRAP    #15                     ; SHOW IT!
            MOVEM.L (A7)+,D0-D1             ; RESTORE REGISTERS
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
            MOVEM.L A0-A1/D0-D2,-(A7)       ; STORE REGISTERS
            LEA     .DATA,A1                ; GET POINTER TO THE PARAM. VECTOR
            MOVE.W  #3,D2                   ; PREPARE LOOP COUNTER TO SIZE-1
            MOVE.B  #32,D0                  ; SPECIFY TASK 32
.LOOP       MOVE.B  (A1)+,D1                ; GET PARAMETER FROM PARAM. VECTOR
            TRAP    #15                     ; GET THE MAPPING ADDRESS
            MOVE.L  D1,(A0)+                ; STORE THE MAPPING ADDRESS
            DBRA.W  D2,.LOOP                ; LOOP FOR ALL PARAMETERS
            MOVEM.L (A7)+,A0-A1/D0-D2       ; RESTORE REGISTERS
            RTS

            ; TRAP #15 FUNCTION 32 PARAMETERS
.DATA       DC.B    1,2,3,7
            DS.W    0
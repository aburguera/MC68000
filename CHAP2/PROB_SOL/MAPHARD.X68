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
            MOVEM.L D0-D1,-(A7)
            MOVE.B  #32, D0
            CLR.B   D1
            TRAP    #15
            MOVEM.L (A7)+,D0-D1
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
WRTSEGM
; DISPLAYS A NUMBER BETWEEN $0 AND $F IN THE SPECIFIED 7-SEGMENT DISPLAY
; INPUT    - D0.W: MSB: DISPLAY NUMBER, LSB VALUE ($0-$F) TO SHOW. A DISPLAY
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
.DATA       DC.B    $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F,$77,$7C,$39,$5E,$79
            DC.B    $71
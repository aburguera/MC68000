; =============================================================================
; HEADER
; =============================================================================

            ORG     $1000
            INCLUDE "MACROS.X68"
            INCLUDE "MAPHARD.X68"

; =============================================================================
; VARS
; =============================================================================

            INCLUDE "VARS.X68"
BUFSEGM     DS.B    9                       ; TEMPORARY STORAGE FOR PWRTSEGM
            DS.W    0

; =============================================================================
; MAIN PROGRAM
; =============================================================================

START
            BSR     SHOWHWIN                ; SHOW THE HARDWARE WINDOW
            LEA     SEGMADDR,A0
            BSR     GTHWADDR                ; GET THE HARDWARE ADDRESSES
            MOVE.L  (SEGMADDR), A0          ; GET THE 7-SEGMENT DISPLAY ADDRESS
            LEA     .ARRAY,A1               ; GET THE ARRAY TO DISPLAY
            BSR     PWRTSEGM                ; DISPLAY IT
            SIMHALT

.ARRAY      DC.B    $04,$48,$15,$16,$23
            DS.W    0

; =============================================================================
; SUBROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
VPCKBCD
; PACKS AN ARRAY OF UNPACKED BCD NUMBERS. THE ARRAY BEGINS WITH A BYTE SPECIFY-
; ING THE LENGTH AND THE SET OF BCD NUMBERS (ONE BYTE EACH). THE FIRST UNPACKED
; VALUE GOES TO THE MOST SIGNIFICANT PART OF THE FIRST PACKED BYTE, THE SECOND
; GOES TO THE LEAST SIGNIFICANT PART AND SO ON. THE OUTPUT ARRAY ALSO BEGINS
; WITH A LENGTH BYTE, WHICH IS THE NUMBER OF BYTES, NOT THE NUMBER OF NUMBERS.
; INPUT    - A0  : POINTER TO THE UNPACKED ARRAY.
;            A1  : POINTER TO THE MEMORY AREA TO WRITE THE PACKED ARRAY.
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A0-A1,-(A7)
            MOVE.B  (A0)+,D2                ; GET THE SOURCE LENGTH
            LSR.B   #1,D2                   ; OUT LEN = SOURCE LEN / 2
            MOVE.B  D2,(A1)+                ; STORE THE OUT LEN
            AND.W   #$00FF,D2               ; BE SURE IT IS THE PROPER WORD
            BEQ     .END                    ; IF IT WAS ZERO, END
            SUBQ    #1,D2                   ; PREPARE FOR DBRA
.LOOP       MOVE.B  (A0)+,D1                ; FUTURE MOST SIGNIFICANT NIBBLE
            MOVE.B  (A0)+,D0                ; FUTURE LEAST SIGNIFICANT NIBBLE
            PCKBCD  D0,D1                   ; PACK
            MOVE.B  D0,(A1)+                ; STORE IT
            DBRA.W  D2,.LOOP                ; LOOP UNTIL END
.END        MOVEM.L (A7)+,D0-D2/A0-A1
            RTS

; -----------------------------------------------------------------------------
VDPCKBCD
; UNPACKS AN ARRAY OF PACKED BCD NUMBERS. THE ARRAY BEGINS WITH A BYTE SPECIFY-
; ING THE LENGTH IN BYTES AND THE SET OF BCD NUMBERS (TWO PER BYTE).
; FOR EACH PACKED BCD, THE MOST SIGNIFICANT DIGIT IS STORED FIRST IN THE OUTPUT
; ARRAY AND THE LEAST SIGNIFICANT DIGIT NEXT.
; INPUT    - A0  : POINTER TO THE PACKED ARRAY.
;            A1  : POINTER TO THE MEMORY AREA TO WRITE THE UNPACKED ARRAY.
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A0-A1,-(A7)
            MOVE.B  (A0)+,D2                ; GET THE SOURCE LEN
            ADD.B   D2,D2                   ; OUT LEN = SOURCE LEN * 2
            MOVE.B  D2,(A1)+                ; STORE THE OUT LEN
            LSR.B   #1,D2                   ; RESTORE IT TO THE NUMBER ITERAT.
            AND.W   #$00FF,D2               ; BE SURE IT IS THE PROPER WORD
            BEQ     .END                    ; IF IT WAS ZERO, NOTHING TO DO
            SUBQ.B  #1,D2                   ; PREPARE FOR DBRA
.LOOP       MOVE.B  (A0)+,D0                ; GET THE PACKED DIGITS
            DPCKBCD D0,D1                   ; UNPACK THEM
            MOVE.B  D1,(A1)+                ; STORE BOTH IN THE CORRECT ORDER
            MOVE.B  D0,(A1)+
            DBRA.W  D2,.LOOP                ; LOOP UNTIL END
.END        MOVEM.L (A7)+,D0-D2/A0-A1
            RTS

; -----------------------------------------------------------------------------
VWRTSEGM
; WRITES AN ARRAY OF 8 UNPACKED BCD DIGITS INTO THE SEVEN SEGMENT DISPLAY SET.
; INPUT    - A0  : DISPLAY MAPPING ADDRESS
;          - A1  : ARRAY TO DISPLAY
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)
            MOVE.B  (A1)+,D1                ; GET THE VECTOR LENGTH
            CMP.B   #8,D1
            BNE     .END                    ; IF THERE AREN'T 8 ITEMS, EXIT
            SUBQ.B  #1,D1                   ; PREPARE FOR DBRA
            AND.W   #$00FF,D1               ; BE SURE IT IS THE PROPER WORD
            MOVE.W  #$0700,D0               ; INIT TO THE RIGHTMOST DISPLAY
.LOOP       MOVE.B  (A1)+,D0                ; GET THE NUMBER
            BSR     WRTSEGM                 ; DISPLAY IT
            SUB.W   #$0100,D0               ; GET TO THE NEXT DISPLAY
            DBRA.W  D1,.LOOP                ; LOOP UNTIL ALL DIGITS ARE SHOWN
.END        MOVEM.L (A7)+,D0-D1/A1
            RTS

; -----------------------------------------------------------------------------
PWRTSEGM
; WRITES AN ARRAY OF 8 PACKED BCD DIGITS INTO THE SEVEN SEGMENT DISPLAY SET.
; INPUT    - A0  : DISPLAY MAPPING ADDRESS
;          - A1  : ARRAY TO DISPLAY
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L A1-A2,-(A7)
            MOVEA.L A0,A2                   ; STORE THE MAPPING ADDRESS
            MOVEA.L A1,A0                   ; PREPARE TO UNPACK
            LEA     BUFSEGM,A1              ; UNPACKED DATA GOES TO THE BUFFER
            BSR     VDPCKBCD                ; DEPACK
            MOVEA.L A2,A0                   ; RESTORE THE MAPPING ADDRESS
            BSR     VWRTSEGM                ; WRITE THE UNPACKED DATA
            MOVEM.L (A7)+,A1-A2
            RTS

            END     START
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
            DS.W    0

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
            CMP.B    #8,D1
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
            LINK    A6,#-10
            MOVEA.L A0,A2                   ; STORE THE MAPPING ADDRESS
            MOVEA.L A1,A0                   ; PREPARE TO UNPACK
            MOVE.L  A7,A1                   ; UNPACKED DATA GOES TO THE BUFFER
            BSR     VDPCKBCD                ; DEPACK
            MOVEA.L A2,A0                   ; RESTORE THE MAPPING ADDRESS
            BSR     VWRTSEGM                ; WRITE THE UNPACKED DATA
            UNLK    A6
            MOVEM.L (A7)+,A1-A2
            RTS

; ------------------------------------------------------------------------------
INSTALL:
; DESCRIPTION : STORES THE HARDWARE MAPPING ADDRESSES FROM SEGMADDR ONWARD
;               IN THE PROPER ORDER. SHOWS THE HARDWARE WINDOW. INSTALLS
;               DEBUGGER AS THE TRACE SERVICE ROUTINE, SWITCHES TO
;               USER MODE AND ENABLES TRACE. RESTORES ALL REGISTERS.
; ------------------------------------------------------------------------------
            MOVE.W  SR,-(A7)                ; STORES SR TO ALLOW RTE LATER
            MOVE.L  A0,-(A7)                ; STORES A0 TO RESTORE IT
            LEA     SEGMADDR,A0
            BSR     GTHWADDR                ; GET HARDWARE ADDRESSES
            BSR     SHOWHWIN                ; SHOW HARDWARE WINDOW
            MOVE.L  #DEBUGGER,($24)         ; INSTALL DEBUGGER
            ORI.W   #$8000,4(A7)            ; PREPARE TRACE
            ANDI.W  #$DFFF,4(A7)            ; PREPARE USER
            MOVE.L  (A7)+,A0                ; RESTORE A0
            RTE                             ; THE RTE MAGIC!

; ------------------------------------------------------------------------------
DEBUGGER
; DESCRIPTION : SERVICE ROUTINE FOR TRACE. LET S7..S0 DENOTE SWITCHES STATE.
;               WORKS AS FOLLOWS:
;               - IF S7, NOTHING IS DONE
;               - IF NOT(S7):
;                 * IF S4, SHOWS THE ADDRESS OF THE NEXT DEBUGGED INSTRUCTION
;                   IN THE 7-SEGMENT DISPLAY.
;                 * IF NOT(S4):
;                   + IF S3, SHOWS THE CONTENTS OF AX, WHERE X IS THE NUMBER
;                     BINARY ENCODED BY S2,S1,S0. AS FOR A7, IT SHOWS
;                     THE CONTENTS OF USP.
;                   + IF NOT(S3), SHOWS THE CONTENTS OF DX, WHERE X IS THE
;                     BNUMBER BINARY ENCODED BY S2,S1,S0.
;               - OTHER SWITCHES COMBINATIONS ARE UNDEFINED.
;               - RESTORES ALL REGISTERS.
; ------------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            MOVE.L  (STCHADDR), A0
            BTST.B  #7,(A0)
            BEQ     .CONT                   ; IF 7 SWITCH=1, DO NOTHING
            MOVE.L  (A7)+,A0
            RTE
.CONT       MOVE.L  (A7)+,A0

            SUBQ.L  #8,A7                   ; STORE DATA IN STACK IN ORDER
            MOVEM.L D0-D7/A0-A6,-(A7)       ; THIS ALSO SERVES TO STORE REGS.
            MOVE.L  USP,A0
            MOVE.L  A0,15*4(A7)             ; STORE USP AFTER THE STORED A6
            MOVE.L  17*4+2(A7),16*4(A7)     ; STORE RET ADDRESS AFTER STORED USP

            CLR.L   D0
            MOVE.L  (STCHADDR), A0
            MOVE.B  (A0),D0                 ; GET THE SWITCH STATUS
            ADD.B   D0,D0
            ADD.B   D0,D0                   ; TIMES 4
            MOVE.L  (A7,D0),D0              ; ACCESS THE DATA STORED IN STACK

            LINK    A6,#-6                  ; GET LOCAL SPACE
            MOVE.L  D0,2(A7)                ; STORE THE NUMBER
            MOVE.B  #4,1(A7)                ; PUT THE DUMMY HEADER 4
            MOVE.L  (SEGMADDR), A0          ; GET THE SEGMEND ADDRESS
            LEA     1(A7),A1                ; GET THE ARRAY ADDRESS
            BSR     PWRTSEGM                ; WRITE IT
            UNLK    A6                      ; RELEASE LOCAL SPACE

            MOVEM.L (A7)+,D0-D7/A0-A6       ; RESTORE REGISTERS
            ADDQ.L  #8,A7                   ; RESTORE STACK
            RTE
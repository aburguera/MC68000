; =============================================================================
; USER ROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
ITOA
; CONVERTS A POSITIVE INTEGER BETWEEN 0 AND 32767 TO A FIVE-DIGIT,
; ZERO-TERMINATED ASCII STRING. THE UNUSED DIGITS TO THE LEFT, IF ANY, ARE
; FILLED WITH THE CHAR '0'.
; INPUT    - A0  : POINTER TO THE SPACE TO STORE THE STRING.
;          - D1.W: THE INTEGER TO CONVERT
; OUTPUT   - THE MEMORY POINTED BY A0 NOW CONTAINS THE STRING.
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A0-A1,-(A7)       ; STORE REGISTERS

            ; LOOP FOR EACH DIGIT
            LEA     .DATA,A1
.LOOP       MOVE.W  (A1)+,D2                ; GET THE DIVISOR
            BNE     .DIGIT                  ; GET DIGIT UNTIL THE 0-TERMINATOR

            ; FINISH
.EXIT       MOVE.B  #0,(A0)                 ; PUT THE STRING TERMINATOR
            MOVEM.L (A7)+,D0-D2/A0-A1       ; RESTORE REGISTERS
            RTS                             ; DONE

            ; CONVERT THE DIGIT (D2: DIVISOR, A0: CHAR POINTER)
.DIGIT      MOVE.B  #'0',D0                 ; INIT WITH '0' (ASCII)
.LOOPD      SUB.W   D2,D1                   ; SUBSTRACT THE DIVISOR
            BLT     .END                    ; IF NEGATIVE, IT'S DONE
.CONT       ADDQ.B  #1,D0                   ; OTHERWISE, INCREASE ASCII DIGIT
            BRA     .LOOPD                  ; AND LOOP
.END        ADD.W   D2,D1                   ; ADD THE DIVISIR TO AVOID NEGATIVE
            MOVE.B  D0,(A0)+                ; STORE THE DIGIT AND ADVANCE A0
            BRA     .LOOP                   ; GO FOR THE NEXT DIGIT
.DATA       DC.W    10000,1000,100,10,1,0   ; 0-TERMINATED DIVISOR ARRAY


; -----------------------------------------------------------------------------
STRCAT
; CREATES A NEW STRING BY CONCATENATING TWO ZERO-TERMINATED STRINGS.
; INPUT    - (A7+12) FIRST STRING POINTER
;          - (A7+8) SECOND STRING POINTER
;          - (A7+4) DESTINATION STRING POINTER
; OUTPUT   - THE DESTINATION STRING IS PROPERLY CREATED
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            ; STORE REGISTERS
            MOVEM.L A0-A2,-(A7)             ; 3 LONG X 4 BYTES = 12 BYTES

            ; GET PARAMETERS FROM STACK
            MOVE.L  16(A7),A2               ; DESTINATION STRING
            MOVE.L  24(A7),A0               ; FIRST STRING
            MOVE.L  20(A7),A1               ; SECOND STRING

            ; COPY FIRST AND SECOND STRINGS
.LOOP0      MOVE.B  (A0)+,(A2)+
            BNE     .LOOP0                  ; LOOP UNTIL ZERO-TERMINATOR
            SUBQ.L  #1,A2                   ; REMOVE THE ZERO-TERMINATOR
.LOOP1      MOVE.B  (A1)+,(A2)+
            BNE     .LOOP1                  ; LOOP UNTIL ZERO-TERMINATOR

            ; RESTORE REGISTERS
            MOVEM.L (A7)+,A0-A2
            RTS

; -----------------------------------------------------------------------------
ITOA2
; CONVERTS A POSITIVE INTEGER BETWEEN 0 AND 32767 TO A FIVE-DIGIT,
; ZERO-TERMINATED ASCII STRING. THE UNUSED DIGITS TO THE LEFT, IF ANY, ARE
; FILLED WITH THE CHAR '0'.
; INPUT    - A0  : POINTER TO THE SPACE TO STORE THE STRING.
;          - D1.W: THE INTEGER TO CONVERT
; OUTPUT   - THE MEMORY POINTED BY A0 NOW CONTAINS THE STRING.
; MODIFIES - NOTHING
; NOTE     - JUST AN ALTERNATE VERSION OF ITOA
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A0-A1,-(A7)       ; STORE REGISTERS

            ; LOOP FOR EACH DIGIT
            LEA     .DATA,A1
.LOOP       MOVE.W  (A1)+,D2                ; GET THE DIVISOR
            BNE     .DIGIT                  ; GET DIGIT UNTIL THE 0-TERMINATOR

            ; FINISH
.EXIT       MOVE.B  #'0',D0                 ; ADD THE LAST DIGIT. THERE IS NO
            ADD.B   D1,D0                   ; NEED TO DIVIDE BY ONE, SO THE
            MOVE.B  D0,(A0)+                ; NUMBER IS ADDED DIRECTLY.
            MOVE.B  #0,(A0)                 ; PUT THE STRING TERMINATOR
            MOVEM.L (A7)+,D0-D2/A0-A1       ; RESTORE REGISTERS
            RTS                             ; DONE

            ; CONVERT THE DIGIT (D2: DIVISOR, A0: CHAR POINTER)

.DIGIT      AND.L   #$0000FFFF,D1           ; PREPARE D1 TO BE USED IN DIVU
            DIVU.W  D2,D1                   ; DIVIDE CURRENT REMAINDER
            MOVE.B  #'0',D0
            ADD.B   D1,D0
            MOVE.B  D0,(A0)+
            SWAP.W  D1
            BRA     .LOOP
.DATA       DC.W    10000,1000,100,10,0     ; 0-TERMINATED DIVISOR ARRAY
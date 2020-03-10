; -----------------------------------------------------------------------------
PRNPNT
; PRINTS THE TWO VALUES OF A 2D POINT IN FORMAT XXXX,YYYY. THE LENGTH OF XXXX
; AND YYYY IS THE SMALLEST POSSIBLE.
; INPUT    - (A7) HIGH 16 BITS Y COORDINATE, LOW 16 BITS X COORDINATE
; OUTPUT   - POINT PRINTED
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0-D2,-(A7)            ; SAVE REGISTERS
            MOVE.L  16(A7),D2               ; GET THE PARAMETER
            CLR.L   D1
            MOVE.W  D2,D1
            MOVE.B  #3,D0
            TRAP    #15                     ; PRINT THE X
            MOVE.B  #',',D1
            MOVE.B  #6,D0
            TRAP    #15                     ; PRINT THE ','
            SWAP.W  D2
            MOVE.W  D2,D1
            MOVE.B  #3,D0
            TRAP    #15                     ; PRINT THE Y
            MOVEM.L (A7)+,D0-D2             ; RESTORE REGISTERS
            RTS

; -----------------------------------------------------------------------------
GETMOUSE
; GETS THE MOUSE STATUS.
; INPUT    - A0 POINTER TO THE MEMORY AREA TO STORE THE STATUS:
; OUTPUT   - STATUS STORED IN THE FOLLOWING FORMAT:
;            (A0).W : Y COORDINATE
;            2(A0).W: X COORDINATE
;            4(A0).B: STATE:
;            +---+---+---+---+---+---+---+---+
;            | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
;            +---+---+---+---+---+---+---+---+
;              |   |   |   |   |   |   |   |
;              |   |   |   |   |   |   |   +----- LEFT BUTTON
;              |   |   |   |   |   |   +--------- RIGHT BUTTON
;              |   |   |   |   |   +------------- X
;              |   |   |   |   +----------------- X
;              |   |   |   +--------------------- X
;              |   |   +------------------------- X
;              |   +----------------------------- X
;              +--------------------------------- X
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            MOVE.B  #61,D0
            CLR.B   D1
            TRAP    #15                     ; GET DATA USING TRAP #15
            MOVE.L  D1,(A0)+                ; STORE IT
            MOVE.B  D0,(A0)
            MOVEM.L (A7)+,D0-D1/A0
            RTS
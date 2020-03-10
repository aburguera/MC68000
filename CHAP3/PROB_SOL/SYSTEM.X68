; =============================================================================
; SYSTEM ROUTINES
; =============================================================================

; -----------------------------------------------------------------------------
; INSTALLER AND DISPATCHER
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
INSTALL
; INSTALLS THE SYSTEM ROUTINES. STANDARD SUBROUTINE.
; INPUT    -
; OUTPUT   -
; MODIFIES -
; -----------------------------------------------------------------------------
            MOVE.L  #SYSDISP,($80)
            RTS

; -----------------------------------------------------------------------------
SYSDISP
; SYSTEM DISPATCHER. DEPENDING ON THE SELECTED FUNCTIONALITY, IT CALLS THE
; APPROPPRIATE ROUTINE AND PREPARES INPUT REGISTERS. MUST BE CALLED BY THE
; DESIRED TRAP. THAT IS, MUST BE INSTALLED IN THE APPROPPRIATE INTERRUPT
; VECTOR ADDRESS.
; INPUT    - NONE
; OUTPUT   - DEPENDS ON THE FUNCTIONALITY CALLED.
; MODIFIES - ONLY THOSE FUNCTIONALITIES OUTPUTTING REGISTERS.
; -----------------------------------------------------------------------------
            MOVEM.L A0-A6/D0-D7,-(A7)
            LEA     SYSDATA,A1
            MOVE.L  62(A7),A0
            MOVE.W  (A0)+,D0                ; GET TASK ID, POINT A0 TO 1ST PARM
            ROL.W   #3,D0                   ; TIMES EIGHT
            AND.L   #$0000FFF8,D0           ; CONVERT IT PROPERLY TO LONG
            MOVEM.L (A1,D0),A1/D1           ; A1 ROUTINE POINTER, D1 PARAM SIZE
            ADD.L   D1,62(A7)               ; PREPARE RETURN ADDRESS
            ;---
            ; AT THIS POINT:
            ; - A1: ADDRESS TO BRANCH
            ; - A0: FIRST PARAMETER ADDRESS
            ;---
            JSR     (A1)

.END        MOVEM.L (A7)+,A0-A6/D0-D7
            RTE


            ; DISPATCHER DATA. FIRST, NUMBER OF BYTES TO SKIP TO CORRECT THE
            ; RETURN ADDRESS. SECOND, THE FUNCTION TO EXECUTE, IN THE ORDER
            ; OF THE DESIRED FUNCTIONALITY NUMBER.
SYSDATA     DC.L    6,INIT,6,PRINT,4,LOCATE,10,DRAWPOLY,6,SETPAL,4,SETPEN
            DC.L    4,SETFILL

; -----------------------------------------------------------------------------
; DISPATCHED SUBROUTINES
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
INIT
; INITIALIZES THE DISPLAY TO WINDOWED MODE AND THE SPECIFIED RESOLUTION
; INPUT    - A0  : POINTER TO THE LONG WITH THE DESIRED RESOLUTION
;                  HIGH 16 BITS: WIDTH
;                  LOW 16 BIT: HEIGHT
; OUTPUT   - SCREEN INITIALIZED
; MODIFIES - D0.B,D1.L,A0
; -----------------------------------------------------------------------------
            MOVE.L  #1,D1                   ; SET WINDOWED MODE
            MOVE.B  #33,D0
            TRAP    #15
            MOVE.L  (A0),D1                 ; GET THE RESOLUTION
            TRAP    #15                     ; SET IT
            RTS

; -----------------------------------------------------------------------------
PRINT
; PRINTS A ZERO-TERMINATED STRING.
; INPUT    - A0  : POINTER TO THE POINTER TO THE STRING TO PRINT
; OUTPUT   - STRING PRINTED
; MODIFIES - A0.L,D0.B,D1.B
; -----------------------------------------------------------------------------
            MOVE.L  (A0),A0                 ; GET THE STRING POINTER
            MOVE.B  #6,D0                   ; PREPARE EASY68K TRAP #15
.LOOP       MOVE.B  (A0)+,D1                ; GET THE CHAR
            BEQ     .END                    ; IF TERMINATOR, END
            TRAP    #15                     ; OTHERWISE, PRINT IT
            BRA     .LOOP
.END        RTS

; -----------------------------------------------------------------------------
LOCATE
; PUTS THE TEXT CURSOR TO THE SPECIFIED COORDINATES
; INPUT    - A0  :POINTER TO THE COORDINATES (CCRR, 16 BIT)
; OUTPUT   - CURSOR POSITIONNED
; MODIFIES - D0.B,D1.W
; -----------------------------------------------------------------------------
            MOVE.W  (A0),D1                 ; GET THE POSITION
            MOVE.B  #11,D0                  ; DO THE JOB!
            TRAP    #15
            RTS

; -----------------------------------------------------------------------------
DRAWPOLY
; DRAWS A POLYGON TRANSLATED AS SPECIFIED WITH THE CURRENT PEN COLOR
; INPUT    - A0  : POINTER TO A DATABLOCK CONTAINING
;              * POINTER TO THE FFFF TERMINATED POLYGON DEFINITION (LONG)
;              * X MOTION. (WORD)
;              * Y MOTION. (WORD)
; OUTPUT   - POLYGON DRAWN
; MODIFIES - A0,A1,D0.B,D1.W,D2.W,D3.W,D4.W
; -----------------------------------------------------------------------------
            MOVE.L  (A0)+,A1                ; POINTER TO THE POLYGON
            MOVEM.W (A0),D3-D4              ; X AND Y

            MOVE.B  #86,D0                  ; PREP. TO MOVE GRAPHIC CURSOR (GC)
.LOOP       MOVE.W  (A1)+,D1                ; CURRENT POLYGON X
            CMP.W   #$FFFF,D1               ; IF LAST ITEM, EXIT
            BEQ     .END
            MOVE.W  (A1)+,D2                ; CURRENT POLYGON Y
            ADD.W   D3,D1                   ; TRANSLATE X
            ADD.W   D4,D2                   ; TRANSLATE Y
            TRAP    #15                     ; DRAW OR MOVE
            MOVE.B  #85,D0                  ; ONLY MOVE GC FOR FIRST POINT
            BRA     .LOOP                   ; DONE
.END        RTS

; -----------------------------------------------------------------------------
SETPAL
; COPIES THE 16 00BBGGRR PALETTE VECTOR FROM THE SPECIFIED SOURCE INTO THE
; SYSTEM PALETTE.
; INPUT    - A0  : POINTER TO THE POINTER TO THE PALETTE
; OUTPUT   - PALETTE STORED IN SYSTEM AREA
; MODIFIES - A0,A1,D0.W
; -----------------------------------------------------------------------------
            MOVE.L  (A0),A0                 ; GET THE PALETTE POINTER
            MOVE.W  #15,D0
            LEA     SYSPAL,A1
.LOOP       MOVE.L  (A0)+,(A1)+             ; COPY THE PALETTE TO THE SYS PAL.
            DBRA.W  D0,.LOOP
            RTS

; -----------------------------------------------------------------------------
SETPEN
; SETS THE PEN COLOR TO THE SPECIFIED PALETTE NUMBER. NOTE THAT THE SYSTEM
; PALETTE MUST BE DEFINED PRIOR TO USING THIS ROUTINE.
; INPUT    - POINTER TO THE COLOR INDEX (FROM 0 TO 15), WHICH IS A WORD.
; OUTPUT   - PEN COLOR DEFINED
; MODIFIES - D0.B,D1.L,A0
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
SETPENCM    MOVE.W  (A0),D1                 ; GET THE COLOR INDEX
            AND.L   #$F,D1                  ; CLEAR THE REMAINING BITS
            ROL     #2,D1                   ; TIMES 4 (EACH PAL ITEM IS LONG)
            LEA     SYSPAL,A0               ; GET THE SYSTEM PALETTE INDEX
            MOVE.L  (A0,D1),D1              ; COMPUTE THE PALETTE COLOR
            TRAP    #15                     ; SET IT
            RTS

; -----------------------------------------------------------------------------
SETFILL
; SETS THE PEN COLOR TO THE SPECIFIED PALETTE NUMBER. NOTE THAT THE SYSTEM
; PALETTE MUST BE DEFINED PRIOR TO USING THIS ROUTINE.
; INPUT    - IN RAM AFTER THE TRAP INSTRUCTION:
;              * COLOR INDEX (FROM 0 TO 15) INTO A WORD.
; OUTPUT   - FILL COLOR DEFINED
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            BRA     SETPENCM
; -----------------------------------------------------------------------------
INSTALL
; INSTALLS THE MOUSE ISR INTO INTERRUPT LEVEL 1 AND THE TIMER ISR INTO
; LEVEL 2. MOUSE IS CONFIGURED TO RESPOND TO ALL EVENTS (MOVE, BUTTON UP
; AND BUTTON DOWN). TIMER IS SET TO 20MS. IT ALSO SETS GRAPHICS TO WINDOWED,
; 640X480, ENABLES DOUBLE BUFFER AND SWITCHES TO USER MODE.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NOTHING
; -----------------------------------------------------------------------------
            ; INIT MOUSE COORDINATES
            LEA     SMOUSEY,A0
            BSR     GETMOUSE

            ; SET TO WINDOWED, 640X480
            MOVE.B  #33,D0
            MOVE.L  #640<<16+480,D1         ; SET SCREEN TO 640 X 480
            TRAP    #15
            MOVE.L  #1,D1                   ; SET WINDOWED
            TRAP    #15

            ; ENABLE DOUBLE BUFFER
            INIDBUF

            ; INSTALL MOUSE
            ORI.W   #$0700,SR               ; DISABLE INTERRUPTS
            MOVE.L  #ISRMOUSE,(INTL1)       ; DEFINE MOUSE MOTION ISR
            MOVE.W  #(1<<8)|(CMMOVE|CMUP|CMDOWN),D1 ; ENABLE MOUSE IRQ
            MOVE.B  #60,D0
            TRAP    #15

            ; INSTALL TIMED INTERRUPT
            MOVE.L  #ISRTIMER,(INTL2)       ; DEFINE TIMER ISR
            MOVE.B  #%10000010,D2           ; SET IRQ LEVEL 2 FOR TIMER
            MOVE.L  #20,D3                  ; SET INTERVAL TO 20MS
            MOVE.B  #6,D1
            MOVE.B  #32,D0
            TRAP    #15
            ANDI.W  #$F8FF,SR               ; ENABLE INTERRUPTS

            ; SWITCH TO USER
            MOVE.L  (A7)+,A0                ; GET RETURN ADDRESS FROM SSP
            ANDI.W  #$DFFF,SR               ; SWITCH TO USER
            MOVE.L  A0,-(A7)                ; PUT THE RETURN ADDR. INTO USP
            RTS

; -----------------------------------------------------------------------------
PLOTMOUSE
; PRINTS THE MOUSE COORDINATES BELOW THE MOUSE ARROW. THE TEXT IS PRINTED
; IN WHITE OVER BLACK IF NO MOUSE BUTTON IS PRESSED, IN WHITE OVER GREEN
; IF LEFT BUTTON IS PRESSED AND IN WHITE OVER RED IF RIGHT BUTTON IS PRESSED.
; INPUT    - MOUSE DATA COMES FROM SYSTEM VARIABLES (SMOUSEY, SMOUSEX AND
;            SMOUSES), WHOSE FORMAT IS THE SAME PROVIDED BY GETMOUSE.
; OUTPUT   - DATA PRINTED
; MODIFIES - NOTHING
; NOTE     - FOR THE SAKE OF SIMPLICITY, LET'S ASSUME THAT ONE CHARACTER
;            IS 8X15 PIXELS
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)             ; SAVE REGISTERS
            CLR.L   D1                      ; BLACK COLOR
            MOVE.B  (SMOUSES),D0
            BEQ     .SETFILL                ; IF NO BUTTON, USE BLACK
            MOVE.L  #CRED,D1
            AND.B   #MSBLEFT,D0
            BEQ     .SETFILL                ; IF NO LEFT BUTTON, USE RED
            MOVE.L  #CGREEN,D1              ; OTHERWISE USE GREEN
.SETFILL    MOVE.B  #81,D0                  ; SET THE COLOR
            TRAP    #15
            MOVE.W  (SMOUSEX),D0            ; GET THE X
            LSL.W   #5,D0                   ; PUT IT INTO THE MSB DIVIDED BY 8
            AND.W   #$FF00,D0               ; MASK IT
            CLR.L   D1
            MOVE.W  (SMOUSEY),D1
            DIVU    #15,D1                  ; DIVIDE BY 15
            OR.W    D0,D1                   ; JOIN (OR) THE X AND THE Y
            MOVE.B  #11,D0
            TRAP    #15                     ; USE THE LOCATE SYSTEM CALL
            MOVE.L  (SMOUSEY),-(A7)
            BSR     PRNPNT                  ; PRINT THE DATA
            ADDQ.L  #4,A7                   ; RESTORE STACK
            MOVEM.L (A7)+,D0-D1             ; RESTORE REGISTERS
            RTS

; -----------------------------------------------------------------------------
ISRMOUSE
; INTERRUPT SERVICE ROUTINE FOR ALL MOUSE EVENTS. GETS MOUSE STATUS AND STORES
; IT FROM SMOUSEY SYSTEM VAR ONWARD IN THE FORMAT SPECIFIED BY GETMOUSE
; INPUT    - NONE
; OUTPUT   - DATA STORED
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            LEA     SMOUSEY,A0              ; PREPARE PARAMETER
            BSR     GETMOUSE                ; USE GETMOUSE
            MOVEM.L (A7)+,D0-D1/A0
            RTE

; -----------------------------------------------------------------------------
ISRTIMER
; INTERRUPT SERVICE ROUTINE FOR TIMER EVENTS. IT PLOTS THE MOUSE COORDINATES
; AT (APPROXIMATELY) THE MOUSE COORDINATES USING RED OR GREEN DEPENDING
; ON THE PRESSED BUTTON (SEE PLOTMOUSE FOR MORE INFO).
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            CLRSCR
            BSR     PLOTMOUSE
            UPDTDBUF
            MOVEM.L (A7)+,D0-D1
            RTE
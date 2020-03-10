            ORG     $1000

; ==============================================================================
; SIMPLE EXAMPLE OF TRAP USAGE.
; 1.- INSTALL TRAP #2 (I.E. SET ISR ADDRESS FOR TRAP #2). NOTE THAT ISRTRAP2
;     SHOULD BE IN PROTECTED MEMORY AND INSTALLING THE TRAP MUST BE DONE IN
;     SUPERVISOR MODE.
; 2.- SWITCH TO USER MODE.
; 3.- USE THE TRAP.
; PLEASE, SIMULATE THIS CODE USING EASY68K AND FOLLOW THE EXECUTION STEP BY
; STEP, PAYING SPECIAL ATTENTION TO THE SUPERVISOR BIT (S) IN SR.
; ==============================================================================

START       MOVE.L  #ISRTRAP2,($88)         ; SET ISR ADDRESS FOR TRAP #2
            ANDI.W  #$DFFF,SR               ; SWITCH TO USER MODE
            MOVE.L  #3,D1                   ; PREPARE TRAP INPUT DATA
            TRAP    #2                      ; AFTER THAT, D1 SHOULD BE 30

            SIMHALT

; ------------------------------------------------------------------------------
ISRTRAP2
; SERVICE ROUTINE FOR TRAP #2. MULTIPLIES D1 TIMES 10. TO DO SO, IT EXPLOITS
; THE LEFT SHIFT AND THE FACT THAT D1*10=D1*8+D1+D1.
; NOTE THAT THIS IS JUST AN EXAMPLE. MULTIPLYING TIMES 10 IS NOT USUALLY A
; SERVICE ROUTINE.
; INPUT    - D1.L : INPUT VALUE
; OUTPUT   - D1.L : INPUT VALUE TIMES 10
; MODIFIES - NOTHING ASIDE OF D1.L
; ------------------------------------------------------------------------------
            MOVE.L  D2,-(A7)                ; STORE TEMPORARY REGISTER
            MOVE.L  D1,D2                   ; COPY INPUT DATA
            LSL.L   #3,D2                   ; MULTIPLY BY 8
            ADD.L   D1,D2                   ; ADD ORIGINAL DATA
            ADD.L   D2,D1                   ; ADD IT AGAIN: D1=D1*8+D1+D1=D1*10
            MOVE.L  (A7)+,D2                ; RESTORE TEMPORARY REGISTER
            RTE                             ; RETURN FROM EXCEPTION

            END     START
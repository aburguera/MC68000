            ORG     $1000
START       MOVE.B  #32,D0                  ; TRAP #15 TASK 32
            CLR.B   D1                      ; PARAMETER D1.B=0
            TRAP    #15                     ; DISPLAY HARDWARE WINDOW
            MOVE.B  #2,D1                   ; TRAP #15 TASK 32 PARAMETER D1.B=2
            TRAP    #15                     ; D1=LED MAPPING ADDRESS
            MOVE.L  D1,A0                   ; COPY ADDRESS TO ADDRESS REGISTER
            MOVE.B  #1,D2                   ; D2=INITIAL VALUE TO SHOW
.LOOP       MOVE.B  D2,(A0)                 ; TRANSFER DATA TO MAPPING ADDRESS
            ROL.B   #1,D2                   ; ROTATE LEFT DATA BYTE
            MOVE.B  #23,D0                  ; TRAP #15 TASK 23
            MOVE.L  #100,D1                 ; PARAMETER D1.L=100
            TRAP    #15                     ; WAIT 1 SECOND
            BRA     .LOOP                   ; INFINITE LOOP
            SIMHALT
            END     START
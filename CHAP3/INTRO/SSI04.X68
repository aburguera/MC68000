            ORG     $1000

; ==============================================================================
; DRAW A GREEN SQUARE OF 100X100 OUTLINED IN WHITE AND CENTERED INTO A WINDOW
; OF 800X600 PIXELS.
; ==============================================================================

START       MOVE.L  #1,D1                   ; SELECT WINDOWED MODE
            MOVE.B  #33,D0                  ; SELECT TASK 33
            TRAP    #15                     ; SET WINDOWED MODE
            MOVE.L  #800<<16|600,D1         ; DEFINE 800X600PIXELS
            TRAP    #15                     ; SET RES. (D0.B WAS ALREADY SET)
            MOVE.L  #$00FFFFFF,D1           ; DEFINE COLOR WHITE
            MOVE.B  #80,D0                  ; SELECT TASK 80
            TRAP    #15                     ; DEFINE PEN COLOR
            MOVE.L  #$0000FF00,D1           ; DEFINE COLOR GREEN
            MOVE.B  #81,D0                  ; SELECT TASK 81
            TRAP    #15                     ; DEFINE FILL COLOR
            MOVE.W  #(800-100)/2,D1         ; LEFT X TO CENTER THE SQUARE
            MOVE.W  #(600-100)/2,D2         ; TOP Y TO CENTER THE SQUARE
            MOVE.W  #(800+100)/2,D3         ; RIGHT X TO CENTER THE SQUARE
            MOVE.W  #(600+100)/2,D4         ; BOTTOM Y TO CENTER THE SQUARE
            MOVE.B  #87,D0                  ; SELECT TASK 87
            TRAP    #15                     ; DRAW THE SQUARE

            SIMHALT

            END     START
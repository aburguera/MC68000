; =============================================================================
; CONSTANTS
; =============================================================================
; MOUSE IRQ CONFIG BITS
CMMOVE      EQU     4
CMUP        EQU     2
CMDOWN      EQU     1

; MOUSE BUTTONS STATUS
MSBLEFT     EQU     1
MSBRIGHT    EQU     2

; EXCEPTION VECTOR ADDRESSES
INTL1       EQU     $64
INTL2       EQU     $68

; COLORS
CBLACK      EQU     $00000000
CRED        EQU     $000000FF
CGREEN      EQU     $0000FF00
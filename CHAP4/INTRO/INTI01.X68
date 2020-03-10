            ORG     $1000

ENAINT      MACRO
            ANDI.W  #$F8FF,SR
            ENDM

DISINT      MACRO
            ORI.W   #$0700,SR
            ENDM

START       SIMHALT

            END     START
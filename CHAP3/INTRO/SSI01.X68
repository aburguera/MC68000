            ORG     $1000
START       ANDI.W  #$DFFF,SR
            ORI.W   #$2000,SR
            SIMHALT
            END     START